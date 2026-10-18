<?php
/**
 * explayouts_ui/template_editor: the template editor of the layout templates, inside the administration's page (top
 * menu, breadcrumb, the Layouts left menu).
 *
 * GET                           the page: the template list (search and filters) and the editor
 * GET  ?file=<path>, XHR        a template's text and facts (original kept, used by, overridden by)
 * POST Action=check, XHR        the syntax check and the diff of the editor's text against the saved file (or the
 *                               original, Compare=original); writes nothing
 * POST Action=save, XHR         checks, then saves (the original is kept the first time); refused on a syntax error
 * POST Action=revert, XHR       puts the original back
 *
 * Every POST needs explayouts_ui/edit (the view itself also opens with explayouts_ui/read) and the form token, and
 * every save and revert is written to the audit log (system.template.change, never the text). Which folders may be
 * read and written: explayouts.ini [TemplateEditorSettings] (expLayoutsTemplateEditor).
 *
 * The code of extension/explayouts_ui/modules/explayouts_ui/template_editor.php (#207); guide:
 * doc/bc/6.0/cli_cronjob_view_abstractions.md
 */

namespace
{
if ( !function_exists( 'expModuleViewExplayoutsUiTemplateEditorJsonResponse' ) ) {
function expModuleViewExplayoutsUiTemplateEditorJsonResponse( $data, $status = 200 )
{
    if ( $status !== 200 )
        header( 'HTTP/1.1 ' . (int)$status . ' ' . ( $status === 403 ? 'Forbidden' : ( $status === 405 ? 'Method Not Allowed' : 'Unprocessable Entity' ) ) );
    header( 'Content-Type: application/json; charset=utf-8' );
    header( 'Cache-Control: no-store' );
    header( 'X-Content-Type-Options: nosniff' );
    echo json_encode( $data );
    eZExecution::cleanExit();
}
}
}

namespace Exponential\View\Extension\ExplayoutsUi\ExplayoutsUi
{

class TemplateEditor extends \Exponential\Runnable\ModuleView
{
    const CONTEXT = 'design/admin/explayouts_ui/template_editor';

    public function run( array $scope )
    {
        // the including function's variables ($Params, $Module, $cli, ...)
        foreach ( array_keys( $scope ) as $__name )
            if ( $__name !== 'this' && $__name !== 'scope' )
                ${$__name} = &$scope[$__name];
        unset( $__name );

        $isXhr = isset( $_SERVER['HTTP_X_REQUESTED_WITH'] ) && $_SERVER['HTTP_X_REQUESTED_WITH'] === 'XMLHttpRequest';
        $method = isset( $_SERVER['REQUEST_METHOD'] ) ? $_SERVER['REQUEST_METHOD'] : 'GET';

        if ( $isXhr )
        {
            \eZDebug::updateSettings( array( 'debug-enabled' => false ) );
            if ( $method === 'POST' )
                $this->handlePost();
            if ( isset( $_GET['file'] ) && is_string( $_GET['file'] ) && $_GET['file'] !== '' )
                $this->handleRead( $_GET['file'] );
            expModuleViewExplayoutsUiTemplateEditorJsonResponse( array( 'success' => false, 'error' => \ezpI18n::tr( self::CONTEXT, 'Unknown request' ) ), 422 );
        }
        if ( $method === 'POST' )
        {
            // writes go through the page's script only: a plain form post is not a way in
            expModuleViewExplayoutsUiTemplateEditorJsonResponse( array( 'success' => false, 'error' => \ezpI18n::tr( self::CONTEXT, 'Unknown request' ) ), 422 );
        }

        $paths = \expLayoutsTemplateEditor::listTemplates();
        $rows = \expLayoutsUiTemplateEditor::describe( $paths );
        $designs = array();
        $groups = array();
        foreach ( $rows as $row )
        {
            if ( $row['design'] !== '' )
                $designs[$row['design']] = true;
            if ( $row['group'] !== '' )
                $groups[$row['group']] = true;
        }
        ksort( $designs );
        ksort( $groups );

        $selected = isset( $_GET['file'] ) && is_string( $_GET['file'] ) && in_array( $_GET['file'], $paths, true ) ? $_GET['file'] : '';

        $baseUrl = 'explayouts_ui/template_editor';
        \eZURI::transformURI( $baseUrl );

        $jsonFlags = JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT;
        $data = array(
            'rows' => $rows,
            'base_url' => $baseUrl,
            'selected' => $selected,
            'selected_meta' => $selected !== '' ? self::meta( $selected ) : null,
            'csrf_token' => class_exists( 'ezxFormToken' ) ? \ezxFormToken::getToken() : '',
            'can_edit' => \expLayoutsUiTemplateEditor::currentUserCanEdit(),
            // an older explayouts without the setting offers no New
            'allow_new' => method_exists( 'expLayoutsTemplateEditor', 'newTemplatesAllowed' ) && \expLayoutsTemplateEditor::newTemplatesAllowed(),
        );
        $dataJson = json_encode( $data, $jsonFlags );

        $tpl = \eZTemplate::factory();
        $tpl->setVariable( 'editor_json', $dataJson === false ? '{}' : $dataJson );
        $tpl->setVariable( 'template_count', count( $rows ) );
        // an open template (?file=) is drawn open from the start, so the page does not move when the script opens it
        $tpl->setVariable( 'selected_path', $selected );
        $tpl->setVariable( 'designs', array_keys( $designs ) );
        $tpl->setVariable( 'groups', array_keys( $groups ) );
        $tpl->setVariable( 'can_edit', $data['can_edit'] );
        $tpl->setVariable( 'allow_new_templates', $data['can_edit'] && $data['allow_new'] );

        header( 'Cache-Control: no-store, no-cache, must-revalidate, max-age=0' );

        $Result = array();
        $Result['content'] = $tpl->fetch( 'design:explayouts_ui/template_editor.tpl' );
        $Result['left_menu'] = 'design:parts/explayouts_ui/menu.tpl';
        $Result['path'] = array( array( 'url' => 'explayouts_ui/dashboard', 'text' => \ezpI18n::tr( 'explayouts_ui/layout', 'Layouts' ) ),
                                 array( 'url' => false, 'text' => \ezpI18n::tr( self::CONTEXT, 'Template editor' ) ) );
        return $this->viewResult( $Result, $Result );
    }

    /**
     * The facts of a template the editor shows beside it.
     */
    protected static function meta( $path )
    {
        return array(
            'path' => $path,
            'has_original' => \expLayoutsUiTemplateEditor::hasOriginal( $path ),
            'used_by' => \expLayoutsUiTemplateEditor::usedBy( $path ),
            'overridden_by' => \expLayoutsUiTemplateEditor::overriddenBy( $path ),
        );
    }

    protected function handleRead( $path )
    {
        $content = \expLayoutsTemplateEditor::read( $path );
        if ( $content === false )
            expModuleViewExplayoutsUiTemplateEditorJsonResponse( array( 'success' => false, 'error' => \ezpI18n::tr( self::CONTEXT, 'Unable to read template: %path', null, array( '%path' => $path ) ) ), 422 );
        expModuleViewExplayoutsUiTemplateEditorJsonResponse( array( 'success' => true, 'content' => $content, 'meta' => self::meta( $path ) ) );
    }

    protected function handlePost()
    {
        $posted = isset( $_POST['ezxform_token'] ) ? $_POST['ezxform_token'] : ( isset( $_SERVER['HTTP_X_CSRF_TOKEN'] ) ? $_SERVER['HTTP_X_CSRF_TOKEN'] : '' );
        $expected = class_exists( 'ezxFormToken' ) ? \ezxFormToken::getToken() : '';
        $refusal = \expLayoutsUiTemplateEditor::writeRefusal( $_SERVER['REQUEST_METHOD'], \expLayoutsUiTemplateEditor::currentUserCanEdit(),
                                                              \expLayoutsUiTemplateEditor::tokenMatches( $posted, $expected ) );
        if ( $refusal !== null )
        {
            $messages = array( 'method' => \ezpI18n::tr( self::CONTEXT, 'Changes must be sent with POST.' ),
                               'policy' => \ezpI18n::tr( self::CONTEXT, 'You are not allowed to change templates.' ),
                               'token' => \ezpI18n::tr( self::CONTEXT, 'The form has expired. Please reload the page and try again.' ) );
            expModuleViewExplayoutsUiTemplateEditorJsonResponse( array( 'success' => false, 'error' => $messages[$refusal] ), $refusal === 'method' ? 405 : 403 );
        }

        $action = isset( $_POST['Action'] ) ? (string)$_POST['Action'] : ( isset( $_POST['SaveTemplate'] ) ? 'save' : '' );
        $path = isset( $_POST['SelectedPath'] ) && is_string( $_POST['SelectedPath'] ) ? $_POST['SelectedPath'] : '';
        $content = isset( $_POST['TemplateContent'] ) && is_string( $_POST['TemplateContent'] ) ? str_replace( "\r\n", "\n", $_POST['TemplateContent'] ) : '';
        $current = $path !== '' ? \expLayoutsTemplateEditor::read( $path ) : false;

        if ( $action === 'check' )
        {
            $compare = isset( $_POST['Compare'] ) && $_POST['Compare'] === 'original' ? 'original' : 'saved';
            $base = $compare === 'original' ? \expLayoutsUiTemplateEditor::readOriginal( $path ) : $current;
            if ( $base === false )
                $base = $compare === 'original' && $current !== false ? $current : '';
            expModuleViewExplayoutsUiTemplateEditorJsonResponse( array( 'success' => true, 'compare' => $compare,
                'validation' => \expLayoutsUiTemplateEditor::validate( $content ),
                'diff' => \expLayoutsUiTemplateEditor::diff( $base, $content ) ) );
        }

        if ( $action === 'save' )
        {
            $validation = \expLayoutsUiTemplateEditor::validate( $content );
            if ( !$validation['ok'] )
                expModuleViewExplayoutsUiTemplateEditorJsonResponse( array( 'success' => false, 'validation' => $validation,
                    'error' => \ezpI18n::tr( self::CONTEXT, 'Not saved: the template has syntax errors.' ) ), 422 );
            $before = $current === false ? null : hash( 'sha256', $current );
            if ( !\expLayoutsUiTemplateEditor::saveKeepingOriginal( $path, $content ) )
                expModuleViewExplayoutsUiTemplateEditorJsonResponse( array( 'success' => false, 'error' => \ezpI18n::tr( self::CONTEXT, 'Save failed' ) ), 422 );
            self::afterWrite( $path, $current === false ? 'create' : 'change', $before, hash( 'sha256', $content ) );
            expModuleViewExplayoutsUiTemplateEditorJsonResponse( array( 'success' => true, 'message' => \ezpI18n::tr( self::CONTEXT, 'Saved' ),
                'validation' => $validation, 'meta' => self::meta( $path ) ) );
        }

        if ( $action === 'revert' )
        {
            if ( !\expLayoutsUiTemplateEditor::hasOriginal( $path ) )
                expModuleViewExplayoutsUiTemplateEditorJsonResponse( array( 'success' => false, 'error' => \ezpI18n::tr( self::CONTEXT, 'This template has no original kept by the editor.' ) ), 422 );
            $before = $current === false ? null : hash( 'sha256', $current );
            if ( !\expLayoutsUiTemplateEditor::revertToOriginal( $path ) )
                expModuleViewExplayoutsUiTemplateEditorJsonResponse( array( 'success' => false, 'error' => \ezpI18n::tr( self::CONTEXT, 'Revert failed' ) ), 422 );
            $now = \expLayoutsTemplateEditor::read( $path );
            self::afterWrite( $path, 'revert', $before, $now === false ? null : hash( 'sha256', $now ) );
            expModuleViewExplayoutsUiTemplateEditorJsonResponse( array( 'success' => true, 'message' => \ezpI18n::tr( self::CONTEXT, 'The original is back.' ),
                'content' => $now === false ? '' : $now, 'meta' => self::meta( $path ) ) );
        }

        expModuleViewExplayoutsUiTemplateEditorJsonResponse( array( 'success' => false, 'error' => \ezpI18n::tr( self::CONTEXT, 'Unknown request' ) ), 422 );
    }

    /**
     * The audit event of a save or revert (never the template's text, only its checksums) and the view caches
     * that may hold pages drawn with the old template.
     */
    protected static function afterWrite( $path, $verb, $before, $after )
    {
        if ( class_exists( 'expAuditHook' ) )
            \expAuditHook::emit( 'system.template.change', array( 'object' => array( 'type' => 'template', 'id' => (string)$path ),
                'verb' => $verb, 'before' => array( 'sha256' => $before ), 'after' => array( 'sha256' => $after ),
                'x' => array( 'editor' => 'explayouts_ui/template_editor' ) ) );
        \eZContentCacheManager::clearAllContentCache();
    }
}

}
