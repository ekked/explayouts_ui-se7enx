<?php
/**
 * The layouts transfer pages: their own policies, the menu links that ask for them, the shared bodies without inline
 * CSS or script, every string translatable, and the console command's alias.
 *
 * @license GPL-2.0-or-later
 */
use PHPUnit\Framework\TestCase;

class TransferPagesTest extends TestCase
{
    protected static function root(): string
    {
        return dirname( __DIR__ );
    }

    protected static function module(): array
    {
        $Module = $ViewList = $FunctionList = null;
        include self::root() . '/modules/explayouts_ui/module.php';
        return array( $ViewList, $FunctionList );
    }

    public function testExportAndImportHaveTheirOwnPolicies()
    {
        list( $views, $functions ) = self::module();
        $this->assertSame( array( 'transfer_export' ), $views['transfer_export']['functions'] );
        $this->assertSame( array( 'transfer_import' ), $views['transfer_import']['functions'] );
        $this->assertArrayHasKey( 'transfer_export', $functions );
        $this->assertArrayHasKey( 'transfer_import', $functions );
    }

    public function testTheMenuLinksAskForThePolicies()
    {
        $menu = file_get_contents( self::root() . '/settings/menu.ini.append.php' );
        $this->assertStringContainsString( "Links[Export]=explayouts_ui/transfer_export\n", $menu );
        $this->assertStringContainsString( "PolicyList_Export[]=explayouts_ui/transfer_export\n", $menu );
        $this->assertStringContainsString( "PolicyList_Import[]=explayouts_ui/transfer_import\n", $menu );
        $classic = file_get_contents( self::root() . '/design/admin/templates/parts/explayouts_ui/menu.tpl' );
        $this->assertStringContainsString( "'function', 'transfer_export'", $classic );
        $this->assertStringContainsString( "'function', 'transfer_import'", $classic );
    }

    public function testTheBodiesCarryNoInlineCssOrScriptAndTranslateEveryString()
    {
        $files = glob( self::root() . '/design/standard/templates/explayouts_ui/parts/transfer_*.tpl' );
        $this->assertCount( 3, $files );
        $catalogue = file_get_contents( self::root() . '/translations/ger-DE/translation.ts' );
        foreach ( $files as $file )
        {
            $body = file_get_contents( $file );
            $this->assertDoesNotMatchRegularExpression( '/<style|\sstyle=|<script|\son[a-z]+=/i', $body, $file );
            preg_match_all( "/'((?:[^'\\\\]|\\\\.)+)'\|i18n\( 'design\/admin\/explayouts_ui\/transfer'/", $body, $m );
            $this->assertNotEmpty( $m[1], $file );
            foreach ( $m[1] as $source )
                $this->assertStringContainsString( '<source>' . htmlspecialchars( $source, ENT_NOQUOTES ) . '</source>', $catalogue, $source );
        }
        foreach ( array( 'admin', 'admin4' ) as $design )
            foreach ( array( 'export', 'import' ) as $page )
                $this->assertStringContainsString( "design:explayouts_ui/parts/transfer_{$page}_body.tpl",
                    file_get_contents( self::root() . "/design/$design/templates/explayouts_ui/transfer_$page.tpl" ) );
    }

    public function testTheConsoleCommandIsExpLayouts()
    {
        $stub = file_get_contents( self::root() . '/bin/php/layouts.php' );
        $this->assertStringContainsString( '@alias exp:layouts', $stub );
        $this->assertStringContainsString( 'The code is in extension/explayouts_ui/classes/runnable/commands/php_layouts.php (#207)', $stub );
        $this->assertTrue( is_executable( self::root() . '/bin/php/layouts.php' ) );
        $command = file_get_contents( self::root() . '/classes/runnable/commands/php_layouts.php' );
        foreach ( array( 'dry-run', 'json', 'strategy:', 'only:', 'all', 'publish', 'unmapped:' ) as $option )
            $this->assertStringContainsString( "[$option]", $command );
    }
}
