<?php
/**
 * The template editor of explayouts_ui (explayouts_ui/template_editor), on top of explayouts' expLayoutsTemplateEditor
 * (which decides which folders may be read and written, keeps the backup and writes the file):
 *
 * - describe(): the list rows (name, folder, extension, design, group, changed by the editor, overridden elsewhere);
 * - the original: the first time the editor changes a template, the file as it was is kept in
 *   <var>/explayouts/template_original/<path>, so "Revert to original" can put it back (and removes the copy);
 * - diff(): a line diff (Myers) in hunks with context, for the review before saving;
 * - validate(): the template engine's own syntax check of the text (eZTemplate::validateTemplateFile on a scratch
 *   copy), with the line of each problem;
 * - writeRefusal() / tokenMatches(): a write is a POST, by a user with explayouts_ui/edit, carrying the form token;
 * - usedBy(): how many published blocks or layouts are of the type a block or layout template draws.
 *
 * @license GPL-2.0-or-later
 */
class expLayoutsUiTemplateEditor extends expLayoutsTemplateEditor
{
    /** Lines of context around each change in a diff */
    const CONTEXT = 3;

    /** Edit distance beyond which the diff is given up and the change is shown as a whole replacement */
    const MAX_EDIT_DISTANCE = 1000;

    /** The folder under the var directory that holds the originals */
    const ORIGINAL_DIR = 'explayouts/template_original';

    // ---------------------------------------------------------------- the list

    /**
     * Where a template path lives: extension, design, group (the folder inside templates/) and the path inside
     * templates/. Paths outside a design folder give empty strings.
     *
     * @return array( 'extension' => string, 'design' => string, 'relative' => string, 'group' => string )
     */
    public static function locate( $path )
    {
        $path = ltrim( str_replace( '\\', '/', (string)$path ), '/' );
        $result = array( 'extension' => '', 'design' => '', 'relative' => '', 'group' => '' );
        if ( preg_match( '~^extension/([^/]+)/design/([^/]+)/(?:override/)?templates/(.+)$~', $path, $m ) )
            $result = array( 'extension' => $m[1], 'design' => $m[2], 'relative' => $m[3], 'group' => '' );
        else if ( preg_match( '~^design/([^/]+)/(?:override/)?templates/(.+)$~', $path, $m ) )
            $result = array( 'extension' => '', 'design' => $m[1], 'relative' => $m[2], 'group' => '' );
        if ( $result['relative'] !== '' )
        {
            $folder = dirname( $result['relative'] );
            $result['group'] = $folder === '.' ? '' : $folder;
        }
        return $result;
    }

    /**
     * The rows of the template list.
     *
     * @param string[] $paths as listTemplates() gives them
     * @return array[] path, name, folder, extension, design, group, changed (bool), overridden_by (string[])
     */
    public static function describe( array $paths )
    {
        $rows = array();
        foreach ( $paths as $path )
        {
            $where = self::locate( $path );
            $rows[] = array(
                'path' => $path,
                'name' => basename( $path ),
                'folder' => dirname( $path ),
                'extension' => $where['extension'],
                'design' => $where['design'],
                'group' => $where['group'],
                'changed' => self::hasOriginal( $path ),
                'overridden_by' => self::overriddenBy( $path ),
            );
        }
        return $rows;
    }

    /**
     * The other design folders (of the installation and its extensions) that hold a template with the same path
     * inside templates/: one of them is used instead of this one wherever its design comes first.
     *
     * @return string[] paths relative to the installation
     */
    public static function overriddenBy( $path, $root = null )
    {
        $where = self::locate( $path );
        if ( $where['relative'] === '' || strpos( $where['relative'], '..' ) !== false )
            return array();
        $root = $root === null ? eZSys::rootDir() : $root;
        $found = array();
        $patterns = array( 'design/*/templates/', 'design/*/override/templates/',
                           'extension/*/design/*/templates/', 'extension/*/design/*/override/templates/' );
        foreach ( $patterns as $pattern )
        {
            foreach ( (array)glob( $root . '/' . $pattern . $where['relative'], GLOB_NOSORT ) as $file )
            {
                if ( !is_string( $file ) || is_link( $file ) )
                    continue;
                $relative = substr( $file, strlen( $root ) + 1 );
                if ( $relative !== ltrim( $path, '/' ) )
                    $found[] = $relative;
            }
        }
        sort( $found );
        return array_values( array_unique( $found ) );
    }

    // ---------------------------------------------------------------- the original

    /**
     * The file that keeps the original of a template (whether it exists or not), or false for a path the editor
     * does not handle.
     */
    public static function originalFile( $path )
    {
        $file = self::resolve( $path );
        if ( $file === false )
            return false;
        $base = realpath( eZSys::rootDir() );
        if ( $base === false || strpos( $file, $base . '/' ) !== 0 )
            return false;
        $varDir = eZSys::varDirectory();
        if ( $varDir === '' || $varDir[0] !== '/' )
            $varDir = $base . '/' . $varDir;
        return rtrim( $varDir, '/' ) . '/' . self::ORIGINAL_DIR . '/' . substr( $file, strlen( $base ) + 1 );
    }

    public static function hasOriginal( $path )
    {
        $original = self::originalFile( $path );
        return $original !== false && is_file( $original );
    }

    public static function readOriginal( $path )
    {
        $original = self::originalFile( $path );
        return $original !== false && is_file( $original ) ? file_get_contents( $original ) : false;
    }

    /**
     * Saves a template and, the first time the editor changes an existing one, keeps the file as it was as its
     * original. Nothing is written when the original could not be kept.
     */
    public static function saveKeepingOriginal( $path, $content )
    {
        $file = self::resolve( $path );
        $original = self::originalFile( $path );
        if ( $file === false || $original === false )
            return false;
        if ( is_file( $file ) && !is_file( $original ) )
        {
            $dir = dirname( $original );
            if ( !is_dir( $dir ) && !eZDir::mkdir( $dir, false, true ) )
                return false;
            if ( !copy( $file, $original ) )
                return false;
        }
        return self::save( $path, $content );
    }

    /**
     * Puts the original back and removes the copy. False when there is none or the write failed.
     */
    public static function revertToOriginal( $path )
    {
        $original = self::originalFile( $path );
        if ( $original === false || !is_file( $original ) )
            return false;
        $content = file_get_contents( $original );
        if ( $content === false || !self::save( $path, $content ) )
            return false;
        @unlink( $original );
        return true;
    }

    // ---------------------------------------------------------------- the diff

    /**
     * A line diff of two texts in hunks with self::CONTEXT lines of context.
     *
     * @return array( 'added' => int, 'removed' => int, 'hunks' => array( array( 'old' => first old line,
     *         'new' => first new line, 'lines' => array( array( 't' => ' '|'-'|'+', 'o' => old line no or null,
     *         'n' => new line no or null, 's' => text ) ) ) ) )
     */
    public static function diff( $old, $new, $context = self::CONTEXT )
    {
        $a = self::lines( $old );
        $b = self::lines( $new );
        $ops = self::lineOps( $a, $b );

        $added = 0;
        $removed = 0;
        $rows = array();
        $o = 1;
        $n = 1;
        foreach ( $ops as $op )
        {
            if ( $op[0] === '=' )
                $rows[] = array( 't' => ' ', 'o' => $o++, 'n' => $n++, 's' => $op[1] );
            else if ( $op[0] === '-' )
            {
                $rows[] = array( 't' => '-', 'o' => $o++, 'n' => null, 's' => $op[1] );
                $removed++;
            }
            else
            {
                $rows[] = array( 't' => '+', 'o' => null, 'n' => $n++, 's' => $op[1] );
                $added++;
            }
        }

        // the hunks: every changed row with its context, neighbors merged
        $keep = array();
        foreach ( $rows as $i => $row )
        {
            if ( $row['t'] === ' ' )
                continue;
            for ( $j = max( 0, $i - $context ); $j <= min( count( $rows ) - 1, $i + $context ); $j++ )
                $keep[$j] = true;
        }
        $hunks = array();
        $current = null;
        $last = -2;
        foreach ( $rows as $i => $row )
        {
            if ( !isset( $keep[$i] ) )
                continue;
            if ( $i !== $last + 1 || $current === null )
            {
                if ( $current !== null )
                    $hunks[] = $current;
                $current = array( 'old' => $row['o'] !== null ? $row['o'] : self::nextNumber( $rows, $i, 'o' ),
                                  'new' => $row['n'] !== null ? $row['n'] : self::nextNumber( $rows, $i, 'n' ),
                                  'lines' => array() );
            }
            $current['lines'][] = $row;
            $last = $i;
        }
        if ( $current !== null )
            $hunks[] = $current;

        return array( 'added' => $added, 'removed' => $removed, 'hunks' => $hunks );
    }

    /** The lines of a text; one line break at the end does not make an empty last line. */
    protected static function lines( $text )
    {
        $text = str_replace( array( "\r\n", "\r" ), "\n", (string)$text );
        if ( $text === '' )
            return array();
        if ( substr( $text, -1 ) === "\n" )
            $text = substr( $text, 0, -1 );
        return explode( "\n", $text );
    }

    protected static function nextNumber( array $rows, $from, $key )
    {
        for ( $i = $from; $i < count( $rows ); $i++ )
            if ( $rows[$i][$key] !== null )
                return $rows[$i][$key];
        // after the last line: one past the last number
        for ( $i = $from; $i >= 0; $i-- )
            if ( $rows[$i][$key] !== null )
                return $rows[$i][$key] + 1;
        return 1;
    }

    /**
     * The edit script from $a to $b: array( array( '='|'-'|'+', line ) ). The common start and end are taken off
     * first; the middle is diffed with Myers' algorithm, or replaced as a whole beyond MAX_EDIT_DISTANCE.
     */
    protected static function lineOps( array $a, array $b )
    {
        $start = 0;
        $na = count( $a );
        $nb = count( $b );
        while ( $start < $na && $start < $nb && $a[$start] === $b[$start] )
            $start++;
        $end = 0;
        while ( $end < $na - $start && $end < $nb - $start && $a[$na - 1 - $end] === $b[$nb - 1 - $end] )
            $end++;

        $ops = array();
        for ( $i = 0; $i < $start; $i++ )
            $ops[] = array( '=', $a[$i] );
        $midA = array_slice( $a, $start, $na - $start - $end );
        $midB = array_slice( $b, $start, $nb - $start - $end );
        foreach ( self::myers( $midA, $midB ) as $op )
            $ops[] = $op;
        for ( $i = $na - $end; $i < $na; $i++ )
            $ops[] = array( '=', $a[$i] );
        return $ops;
    }

    protected static function myers( array $a, array $b )
    {
        $n = count( $a );
        $m = count( $b );
        if ( $n === 0 || $m === 0 )
            return self::replaceAll( $a, $b );

        $max = min( $n + $m, self::MAX_EDIT_DISTANCE );
        $v = array( 1 => 0 );
        $trace = array();
        $found = false;
        for ( $d = 0; $d <= $max && !$found; $d++ )
        {
            $trace[] = $v;
            for ( $k = -$d; $k <= $d; $k += 2 )
            {
                if ( $k === -$d || ( $k !== $d && $v[$k - 1] < $v[$k + 1] ) )
                    $x = $v[$k + 1];
                else
                    $x = $v[$k - 1] + 1;
                $y = $x - $k;
                while ( $x < $n && $y < $m && $a[$x] === $b[$y] )
                {
                    $x++;
                    $y++;
                }
                $v[$k] = $x;
                if ( $x >= $n && $y >= $m )
                {
                    $found = true;
                    break;
                }
            }
        }
        if ( !$found )
            return self::replaceAll( $a, $b );

        // back from the end, round by round
        $ops = array();
        $x = $n;
        $y = $m;
        for ( $d = count( $trace ) - 1; $d > 0; $d-- )
        {
            $v = $trace[$d];
            $k = $x - $y;
            if ( $k === -$d || ( $k !== $d && $v[$k - 1] < $v[$k + 1] ) )
                $prevK = $k + 1;
            else
                $prevK = $k - 1;
            $prevX = $v[$prevK];
            $prevY = $prevX - $prevK;
            while ( $x > $prevX && $y > $prevY )
            {
                $ops[] = array( '=', $a[$x - 1] );
                $x--;
                $y--;
            }
            if ( $x === $prevX )
                $ops[] = array( '+', $b[$y - 1] );
            else
                $ops[] = array( '-', $a[$x - 1] );
            $x = $prevX;
            $y = $prevY;
        }
        while ( $x > 0 && $y > 0 )
        {
            $ops[] = array( '=', $a[$x - 1] );
            $x--;
            $y--;
        }
        return array_reverse( $ops );
    }

    protected static function replaceAll( array $a, array $b )
    {
        $ops = array();
        foreach ( $a as $line )
            $ops[] = array( '-', $line );
        foreach ( $b as $line )
            $ops[] = array( '+', $line );
        return $ops;
    }

    // ---------------------------------------------------------------- the syntax check

    /**
     * Checks the syntax of a template text with the template engine (the parser the site uses, nothing is run).
     * The text is written to a scratch file under the var directory for the check and removed afterwards.
     *
     * @return array( 'ok' => bool, 'errors' => array( array( 'line' => int|null, 'text' => string ) ),
     *                'warnings' => same )
     */
    public static function validate( $content )
    {
        $result = array( 'ok' => true, 'errors' => array(), 'warnings' => array() );
        $varDir = eZSys::varDirectory();
        if ( $varDir === '' || $varDir[0] !== '/' )
            $varDir = eZSys::rootDir() . '/' . $varDir;
        $dir = rtrim( $varDir, '/' ) . '/explayouts/template_check';
        if ( !is_dir( $dir ) && !eZDir::mkdir( $dir, false, true ) )
            return $result;
        $file = $dir . '/check-' . bin2hex( random_bytes( 8 ) ) . '.tpl';
        if ( file_put_contents( $file, (string)$content ) === false )
            return $result;

        $tpl = eZTemplate::factory();
        try
        {
            $data = $tpl->validateTemplateFile( $file, true );
        }
        catch ( Exception $e )
        {
            $data = array( 'result' => false, 'errors' => array( array( 'text' => $e->getMessage(), 'placement' => false ) ), 'warnings' => array() );
        }
        @unlink( $file );
        $tpl->resetErrorLog();

        if ( !is_array( $data ) )
            return $result;
        foreach ( array( 'errors', 'warnings' ) as $kind )
        {
            foreach ( isset( $data[$kind] ) ? (array)$data[$kind] : array() as $entry )
            {
                $text = isset( $entry['text'] ) ? (string)$entry['text'] : '';
                $placement = isset( $entry['placement'] ) ? $entry['placement'] : false;
                $line = self::placementLine( $placement );
                if ( $line === null )
                    $line = self::placementLine( is_string( $placement ) ? $placement . ' ' . $text : $text );
                $result[$kind][] = array( 'line' => $line, 'text' => self::cleanMessage( $text, $file ) );
            }
        }
        // What the parser lets through: a block tag that is never closed, or closed by the wrong end tag. A warning,
        // not an error: the engine draws such a template (some shipped ones end with an open {let}), so the save is
        // only confirmed, not refused.
        $reported = array();
        foreach ( array_merge( $result['errors'], $result['warnings'] ) as $entry )
            $reported[(int)$entry['line']] = true;
        foreach ( self::unbalancedTags( $content ) as $problem )
            if ( !isset( $reported[$problem['line']] ) )
                $result['warnings'][] = $problem;
        foreach ( array( 'errors', 'warnings' ) as $kind )
            usort( $result[$kind], function ( $x, $y ) { return (int)$x['line'] - (int)$y['line']; } );
        $result['ok'] = !$result['errors'];
        return $result;
    }

    /** The template functions that have an end tag ({if} ... {/if}). */
    const BLOCK_TAGS = 'if|foreach|section|while|do|for|switch|let|set-block|append-block|cache-block|run-once|literal';

    /**
     * Block tags without their end tag, and end tags that close another block, outside {* comments *} and
     * {literal} parts.
     *
     * @return array( array( 'line' => int, 'text' => string ) )
     */
    public static function unbalancedTags( $content )
    {
        $content = str_replace( array( "\r\n", "\r" ), "\n", (string)$content );
        $problems = array();
        $stack = array();
        if ( !preg_match_all( '~\{\*.*?\*\}|\{(/?)(' . self::BLOCK_TAGS . ')(?=[\s}])~s', $content, $m, PREG_OFFSET_CAPTURE | PREG_SET_ORDER ) )
            return $problems;
        $inLiteral = false;
        foreach ( $m as $match )
        {
            if ( !isset( $match[2] ) || $match[2][1] < 0 )
                continue; // a comment
            $closing = $match[1][0] === '/';
            $name = $match[2][0];
            $line = substr_count( $content, "\n", 0, $match[0][1] ) + 1;
            if ( $inLiteral && !( $closing && $name === 'literal' ) )
                continue;
            if ( !$closing )
            {
                $stack[]= array( $name, $line );
                $inLiteral = $name === 'literal';
                continue;
            }
            $inLiteral = false;
            if ( $stack && end( $stack )[0] === $name )
            {
                array_pop( $stack );
                continue;
            }
            $open = $stack ? end( $stack ) : null;
            $problems[] = array( 'line' => $line, 'text' => $open
                ? sprintf( '{/%s} closes {%s} opened on line %d', $name, $open[0], $open[1] )
                : sprintf( '{/%s} without a start tag', $name ) );
            // a matching tag further down the stack: the ones above it were left open
            for ( $i = count( $stack ) - 1; $i >= 0; $i-- )
            {
                if ( $stack[$i][0] === $name )
                {
                    foreach ( array_splice( $stack, $i ) as $index => $left )
                        if ( $index > 0 )
                            $problems[] = array( 'line' => $left[1], 'text' => sprintf( '{%s} is not closed', $left[0] ) );
                    break;
                }
            }
        }
        foreach ( $stack as $left )
            $problems[] = array( 'line' => $left[1], 'text' => sprintf( '{%s} is not closed', $left[0] ) );
        return $problems;
    }

    /**
     * The line of a template engine placement: array( array( line, column, position ), array( ... ), file ), or a
     * text with "<file>:<line>[<column>]" in it; null when there is none.
     */
    public static function placementLine( $placement )
    {
        if ( is_array( $placement ) && isset( $placement[0] ) && is_array( $placement[0] ) && isset( $placement[0][0] ) && is_numeric( $placement[0][0] ) )
            return (int)$placement[0][0];
        if ( is_string( $placement ) && preg_match( '~:(\d+)\[\d+\]~', $placement, $m ) )
            return (int)$m[1];
        return null;
    }

    /** A message without the scratch file's name, which says nothing to the editor's user. */
    protected static function cleanMessage( $text, $file )
    {
        $text = str_replace( array( $file, basename( $file ) ), 'template', (string)$text );
        // "parser error @ template:8[0] End tag ..." -> "End tag ...": the line is shown on its own
        $text = preg_replace( '~^\s*parser error\s*@\s*(?:\S+:\d+\[\d+\])?\s*~i', '', $text );
        return trim( preg_replace( '~\s+~', ' ', $text ) );
    }

    // ---------------------------------------------------------------- the write rules

    /**
     * Why a write request is refused, or null when it may go ahead: 'method' (not a POST), 'policy' (no
     * explayouts_ui/edit) or 'token' (the form token is missing or wrong).
     */
    public static function writeRefusal( $method, $canEdit, $tokenOk )
    {
        if ( strtoupper( (string)$method ) !== 'POST' )
            return 'method';
        if ( !$canEdit )
            return 'policy';
        if ( !$tokenOk )
            return 'token';
        return null;
    }

    /**
     * Whether the posted form token is the session's. Without the form token extension (an empty expected token)
     * there is nothing to compare.
     */
    public static function tokenMatches( $posted, $expected )
    {
        if ( !is_string( $expected ) || $expected === '' )
            return true;
        return is_string( $posted ) && $posted !== '' && hash_equals( $expected, $posted );
    }

    /** Whether the current user has explayouts_ui/edit. */
    public static function currentUserCanEdit()
    {
        $access = eZUser::currentUser()->hasAccessTo( 'explayouts_ui', 'edit' );
        return isset( $access['accessWord'] ) && $access['accessWord'] !== 'no';
    }

    // ---------------------------------------------------------------- used by

    /**
     * How many published blocks (and in how many layouts) or published layouts are of the type a template draws:
     * block/<name>.tpl draws the blocks <name> (and exp_component_<name>), layouts/<name>.tpl the layouts of the
     * type <name>. Null for other templates.
     *
     * @return array( 'kind' => 'block'|'layout', 'type' => string, 'count' => int, 'layouts' => int )|null
     */
    public static function usedBy( $path )
    {
        $where = self::locate( $path );
        if ( !preg_match( '~^explayouts/(block|layouts)/([A-Za-z0-9_-]+)\.tpl$~', $where['relative'], $m ) )
            return null;
        $db = eZDB::instance();
        $name = $db->escapeString( $m[2] );
        if ( $m[1] === 'block' )
        {
            $rows = $db->arrayQuery( "SELECT COUNT(*) AS c, COUNT(DISTINCT layout_id) AS l FROM explayouts_block
                                      WHERE status = 2 AND definition_identifier IN ( '$name', 'exp_component_$name' )" );
            return array( 'kind' => 'block', 'type' => $m[2], 'count' => (int)$rows[0]['c'], 'layouts' => (int)$rows[0]['l'] );
        }
        $rows = $db->arrayQuery( "SELECT COUNT(*) AS c FROM explayouts_layout WHERE status = 2 AND layout_type = '$name'" );
        return array( 'kind' => 'layout', 'type' => $m[2], 'count' => (int)$rows[0]['c'], 'layouts' => (int)$rows[0]['c'] );
    }
}
