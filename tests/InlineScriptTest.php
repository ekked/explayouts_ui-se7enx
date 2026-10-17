<?php
/**
 * 1.3.20: no template of the extension carries an inline script, an on...= handler attribute or a javascript: URL,
 * so the pages run under a Content Security Policy with script-src 'self'. A <script> is either a file (src, empty)
 * or a JSON data block (type="application/json"). Their code is in design/admin/javascript (explayouts_ui_admin.js,
 * explayouts_ui_rule_list.js, explayouts_ui_template_editor.js) and design/admin4/javascript.
 *
 * @license GPL-2.0-or-later
 */
use PHPUnit\Framework\TestCase;

class InlineScriptTest extends TestCase
{
    public function testNoTemplateHasInlineCode()
    {
        $root = dirname( __DIR__ );
        $files = new RegexIterator( new RecursiveIteratorIterator( new RecursiveDirectoryIterator( $root . '/design' ) ), '~\.tpl$~' );
        $count = 0;
        foreach ( $files as $file )
        {
            $path = substr( (string)$file, strlen( $root ) + 1 );
            $tpl = file_get_contents( (string)$file );
            preg_match_all( '~<script\b([^>]*)>(.*?)</script>~is', $tpl, $m, PREG_SET_ORDER );
            foreach ( $m as $script )
            {
                $isData = stripos( $script[1], 'type="application/json"' ) !== false;
                $isFile = preg_match( '~\bsrc=~', $script[1] ) && trim( $script[2] ) === '';
                $this->assertTrue( $isData || $isFile, $path . ': inline script ' . substr( $script[0], 0, 100 ) );
            }
            $this->assertDoesNotMatchRegularExpression( '~<[a-z][^>]*\son[a-z]+\s*=\s*["\']~i', $tpl, $path . ': handler attribute' );
            $this->assertStringNotContainsString( 'javascript:', $tpl, $path );
            $count++;
        }
        $this->assertGreaterThan( 20, $count );
    }

    public function testTheDataBlocksAreEscaped()
    {
        $chain = "|explode( '<' )|implode( '\\u003c' )|explode( '>' )|implode( '\\u003e' )}</script>";
        $dir = dirname( __DIR__ ) . '/design/admin/templates/explayouts_ui/parts/';
        $this->assertStringContainsString( 'id="explayouts-ui-rule-list-data">{$explayouts_ui_rule_list_data' . $chain, file_get_contents( $dir . 'rule_list_script.tpl' ) );
        $this->assertStringContainsString( 'id="explayouts-ui-te-data">{$explayouts_ui_te_data' . $chain, file_get_contents( $dir . 'template_editor_body.tpl' ) );
    }
}
