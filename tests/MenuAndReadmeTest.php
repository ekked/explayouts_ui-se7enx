<?php
/**
 * The admin tab asks for the policy of the view it opens; the README names every view of the module; the template
 * editor offers New only where the server would create the file.
 *
 * @license GPL-2.0-or-later
 */
use PHPUnit\Framework\TestCase;

class MenuAndReadmeTest extends TestCase
{
    protected static function moduleViews(): array
    {
        $Module = $ViewList = $FunctionList = null;
        include dirname( __DIR__ ) . '/modules/explayouts_ui/module.php';
        return $ViewList;
    }

    /** One menu.ini group as key => value(s), the way eZINI reads Key[]/Key[name]=value lines. */
    protected static function menuGroup( string $group ): array
    {
        $text = file_get_contents( dirname( __DIR__ ) . '/settings/menu.ini.append.php' );
        $values = array();
        $current = null;
        foreach ( preg_split( '/\r?\n/', $text ) as $line )
        {
            $line = trim( $line );
            if ( preg_match( '/^\[(.+)\]$/', $line, $m ) )
                $current = $m[1];
            else if ( $current === $group && preg_match( '/^([A-Za-z]+)\[([^\]]*)\](?:=(.*))?$/', $line, $m ) && isset( $m[3] ) )
            {
                if ( $m[2] === '' )
                    $values[$m[1]][] = $m[3];
                else
                    $values[$m[1]][$m[2]] = $m[3];
            }
        }
        return $values;
    }

    public function testTheTabAsksForThePolicyOfTheViewItOpens()
    {
        $group = self::menuGroup( 'Topmenu_explayouts_ui_dashboard' );
        $this->assertSame( 'explayouts_ui/dashboard', $group['URL']['default'] );
        $views = self::moduleViews();
        $expected = array_map( function ( $function ) { return 'explayouts_ui/' . $function; }, $views['dashboard']['functions'] );
        $this->assertSame( $expected, $group['PolicyList'] );
    }

    public function testEveryLeftMenuLinkOpensAViewOfTheModule()
    {
        $views = self::moduleViews();
        foreach ( self::menuGroup( 'Leftmenu_explayouts_ui_dashboard' )['Links'] as $name => $url )
        {
            $this->assertMatchesRegularExpression( '#^explayouts_ui/([a-z_]+)$#', $url, $name );
            $this->assertArrayHasKey( substr( $url, strlen( 'explayouts_ui/' ) ), $views, $name );
        }
    }

    public function testTheReadmeNamesEveryViewAndNoOther()
    {
        $readme = file_get_contents( dirname( __DIR__ ) . '/README.md' );
        $views = array_keys( self::moduleViews() );
        $this->assertCount( 13, $views );
        $this->assertStringContainsString( 'Thirteen module views', $readme );
        preg_match( '/\| View \| Purpose \|\n\|[-|]+\|\n((?:\|.*\|\n)+)/', $readme, $m );
        $this->assertNotEmpty( $m, 'the view table of the README' );
        preg_match_all( '/`([a-z_]+)`/', implode( "\n", array_map( function ( $row ) { return explode( '|', $row )[1]; }, explode( "\n", trim( $m[1] ) ) ) ), $named );
        sort( $views );
        $listed = $named[1];
        sort( $listed );
        $this->assertSame( $views, $listed );
        $this->assertStringNotContainsString( 'no PHP classes', $readme );
        $this->assertStringNotContainsString( 'explayouts/read', $readme );
    }

    public function testTheTemplateEditorOffersNewOnlyWhenAllowed()
    {
        $body = file_get_contents( dirname( __DIR__ ) . '/design/admin/templates/explayouts_ui/parts/template_editor_body.tpl' );
        $this->assertMatchesRegularExpression( '#\{if \$allow_new_templates\}<button[^>]*id="new-file"[^>]*>.*?</button>\{/if\}#', $body );
        $this->assertStringContainsString( 'if (newBtn) newBtn.addEventListener', $body );
        // The path is taken from the installation root (expLayoutsTemplateEditor::resolve()), not from design/ or extension/.
        $this->assertStringNotContainsString( 'relative to design/ or extension/', $body );
        $this->assertStringContainsString( 'New template path (from the installation root, inside an allowed folder, must end in .tpl):', $body );
        foreach ( array( 'admin', 'admin4' ) as $design )
        {
            $page = file_get_contents( dirname( __DIR__ ) . '/design/' . $design . '/templates/explayouts_ui/template_editor.tpl' );
            $this->assertStringContainsString( 'allow_new_templates=$allow_new_templates', $page, $design );
        }
        $view = file_get_contents( dirname( __DIR__ ) . '/classes/runnable/views/explayouts_ui/template_editor.php' );
        $this->assertStringContainsString( "setVariable( 'allow_new_templates'", $view );
    }
}
