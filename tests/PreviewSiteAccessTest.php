<?php
/**
 * The layout preview renders in the public siteaccess of the administration in use (expLayoutsPreviewSiteAccess of
 * explayouts), not in site.ini [SiteSettings] DefaultAccess: in an installation serving several sites that is the
 * default of the whole installation, another site's, whose settings and design then ran on this site's database.
 * Where no siteaccess qualifies the preview says so instead of switching.
 *
 * @license GPL-2.0-or-later
 */
use PHPUnit\Framework\TestCase;

class PreviewSiteAccessTest extends TestCase
{
    protected static function view(): string
    {
        $file = dirname( __DIR__ ) . '/classes/runnable/views/explayouts_ui/preview.php';
        self::assertFileExists( $file );
        return (string)file_get_contents( $file );
    }

    public function testThePreviewDoesNotSwitchToDefaultAccess()
    {
        $this->assertStringNotContainsString( "'DefaultAccess'", self::view() );
    }

    public function testThePreviewAsksForThePublicSiteaccessOfTheAdministrationBeforeSwitching()
    {
        $view = self::view();
        $resolve = strpos( $view, '\\expLayoutsPreviewSiteAccess::resolve()' );
        $switch = strpos( $view, '\\eZSiteAccess::load( $access )' );
        $this->assertNotFalse( $resolve );
        $this->assertNotFalse( $switch );
        $this->assertLessThan( $switch, $resolve );
    }

    public function testWithoutAPublicSiteaccessThePreviewReturnsBeforeSwitching()
    {
        $view = self::view();
        $this->assertSame( 1, preg_match( '/if \( \$siteAccess === false \)\s*\{(.*?)\n        \}/s', $view, $m ) );
        $this->assertStringContainsString( 'return $this->viewResult(', $m[1] );
        $this->assertStringContainsString( 'expLayoutsPreviewSiteAccess::$lastError', $m[1] );
        $this->assertStringContainsString( 'htmlspecialchars(', $m[1] );
    }
}
