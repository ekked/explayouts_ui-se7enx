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
        $this->assertCount( 14, $views );
        $this->assertStringContainsString( 'Fourteen module views', $readme );
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
        $body = file_get_contents( dirname( __DIR__ ) . '/design/standard/templates/explayouts_ui/parts/template_editor_body.tpl' );
        $this->assertMatchesRegularExpression( '#\{if \$allow_new_templates\}\s*<div class="a4-card-actions"><button[^>]*id="te-new"#', $body );
        $this->assertMatchesRegularExpression( '#\{if \$allow_new_templates\}\s*<dialog[^>]*id="te-new-dialog"#', $body );
        // The path is taken from the installation root (expLayoutsTemplateEditor::resolve()), not from design/ or extension/.
        $this->assertStringContainsString( 'From the installation root', $body );
        foreach ( array( 'admin', 'admin4' ) as $design )
        {
            $page = file_get_contents( dirname( __DIR__ ) . '/design/' . $design . '/templates/explayouts_ui/template_editor.tpl' );
            $this->assertStringContainsString( 'allow_new_templates=$allow_new_templates', $page, $design );
            $this->assertStringContainsString( "{ezscript_require( 'explayouts_ui_template_editor.js' )}", $page, $design );
            $this->assertStringContainsString( "{ezcss_require( 'explayouts_ui_template_editor.css' )}", $page, $design );
        }
        $view = file_get_contents( dirname( __DIR__ ) . '/classes/runnable/views/explayouts_ui/template_editor.php' );
        // New only for users who may edit, and only where the setting allows it
        $this->assertStringContainsString( "setVariable( 'allow_new_templates', \$data['can_edit'] && \$data['allow_new'] )", $view );
    }

    /** The template editor is a page of the administration: the page layout, the Layouts left menu, a breadcrumb. */
    public function testTheTemplateEditorIsAnAdminPage()
    {
        $view = file_get_contents( dirname( __DIR__ ) . '/classes/runnable/views/explayouts_ui/template_editor.php' );
        $this->assertStringNotContainsString( "'pagelayout'", $view );
        $this->assertStringContainsString( "\$Result['left_menu'] = 'design:parts/explayouts_ui/menu.tpl';", $view );
        $this->assertStringContainsString( "\$Result['path']", $view );
        $menu = file_get_contents( dirname( __DIR__ ) . '/design/admin/templates/parts/explayouts_ui/menu.tpl' );
        $this->assertStringContainsString( "'explayouts_ui/template_editor'", $menu );
        foreach ( array( 'admin', 'admin4' ) as $design )
        {
            $page = file_get_contents( dirname( __DIR__ ) . '/design/' . $design . '/templates/explayouts_ui/template_editor.tpl' );
            $this->assertStringNotContainsString( '<html', $page, $design );
            $this->assertStringContainsString( '<h1 class="context-title">', $page, $design );
        }
    }
}
