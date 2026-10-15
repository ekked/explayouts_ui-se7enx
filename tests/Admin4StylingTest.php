<?php
/**
 * The admin4 templates and stylesheets of explayouts_ui follow the administration's styling rules
 * (doc/bc/6.0/admin4-styling.md in Exponential): no inline CSS in a template, no version query on an asset link,
 * and stylesheets that take their colours from admin4's --a4-* tokens, without local aliases or hard-coded colours.
 *
 * @license GPL-2.0-or-later
 */
use PHPUnit\Framework\TestCase;

class Admin4StylingTest extends TestCase
{
    protected static function files( $dir, $suffix )
    {
        $files = array();
        $it = new RecursiveIteratorIterator( new RecursiveDirectoryIterator( dirname( __DIR__ ) . '/design/admin4/' . $dir, FilesystemIterator::SKIP_DOTS ) );
        foreach ( $it as $file )
            if ( substr( $file->getFilename(), -strlen( $suffix ) ) === $suffix )
                $files[] = $file->getPathname();
        sort( $files );
        return $files;
    }

    public function testTemplatesCarryNoInlineCss()
    {
        $templates = self::files( 'templates', '.tpl' );
        $this->assertNotEmpty( $templates );
        foreach ( $templates as $file )
        {
            $tpl = file_get_contents( $file );
            $this->assertDoesNotMatchRegularExpression( '/<style[\s>]/i', $tpl, basename( $file ) . ' has a <style> block' );
            $this->assertDoesNotMatchRegularExpression( '/\sstyle\s*=\s*["\'{]/i', $tpl, basename( $file ) . ' has a style attribute' );
            $this->assertDoesNotMatchRegularExpression( '/\.(css|js)\?v=/i', $tpl, basename( $file ) . ' adds a version query to an asset' );
        }
    }

    public function testStylesheetsUseTheTokensOnly()
    {
        $sheets = self::files( 'stylesheets', '.css' );
        $this->assertNotEmpty( $sheets );
        foreach ( $sheets as $file )
        {
            $css = preg_replace( '#/\*.*?\*/#s', '', file_get_contents( $file ) );
            $this->assertDoesNotMatchRegularExpression( '/^\s*--(?!a4-)[\w-]+\s*:/m', $css, basename( $file ) . ' defines a local custom property' );
            // colours only through var(): what is left once every var(...) is removed must hold none
            $bare = preg_replace( '/var\([^()]*(\([^()]*\))?[^()]*\)/', '', $css );
            $this->assertDoesNotMatchRegularExpression( '/#[0-9a-f]{3,8}\b|rgba?\(/i', $bare, basename( $file ) . ' hard-codes a colour' );
        }
    }
}
