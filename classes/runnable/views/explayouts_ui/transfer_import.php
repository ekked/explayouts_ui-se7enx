<?php
/**
 * explayouts_ui/transfer_import: imports a layouts transfer file (expLayoutsCoreTransferService).
 *
 * Three steps, each a POST of the same form:
 *   1. upload: the file and the global choices (strategy, publish, unmapped references);
 *   2. preview (a dry run): what each layout and rule is (new, identical, changed, conflicting) and what the import
 *      will do with it; a strategy can be chosen per item and the preview run again;
 *   3. import: one transaction; the report says what was written, or that nothing was.
 * Between the steps the file waits in the transfer work directory under a random name that only this session knows.
 *
 * Policy: explayouts_ui/transfer_import. Guide: doc/TRANSFER.md of explayouts_core.
 */

namespace Exponential\View\Extension\ExplayoutsUi\ExplayoutsUi
{

class TransferImport extends \Exponential\Runnable\ModuleView
{
    const SESSION_KEY = 'ExpLayoutsTransferUploads';

    /** Largest file accepted, in bytes. */
    const MAX_UPLOAD_BYTES = 67108864;

    public function run( array $scope )
    {
        // the including function's variables ($Params, $Module, $cli, ...)
        foreach ( array_keys( $scope ) as $__name )
            if ( $__name !== 'this' && $__name !== 'scope' )
                ${$__name} = &$scope[$__name];
        unset( $__name );

        $http = \eZHTTPTool::instance();
        $tpl = \eZTemplate::factory();
        $service = new \expLayoutsCoreTransferService();
        $service->removeStaleFiles();

        $options = self::options( $http );
        $step = 'upload';
        $errors = array();
        $result = null;
        $token = '';

        if ( $http->hasPostVariable( 'PreviewButton' ) || $http->hasPostVariable( 'ImportButton' ) )
        {
            $token = $http->hasPostVariable( 'TransferToken' ) ? (string)$http->postVariable( 'TransferToken' ) : '';
            $path = $token !== '' ? self::uploadPath( $http, $service, $token ) : null;

            if ( isset( $_FILES['TransferFile'] ) && is_array( $_FILES['TransferFile'] ) && (int)$_FILES['TransferFile']['error'] !== UPLOAD_ERR_NO_FILE )
            {
                $stored = self::storeUpload( $http, $service, $_FILES['TransferFile'] );
                if ( is_string( $stored['error'] ) )
                    $errors[] = $stored['error'];
                else
                {
                    $token = $stored['token'];
                    $path = $stored['path'];
                }
            }
            elseif ( $path === null )
                $errors[] = \ezpI18n::tr( 'design/admin/explayouts_ui/transfer', 'Please choose a layouts transfer file (.zip).' );

            if ( !$errors )
            {
                $import = $http->hasPostVariable( 'ImportButton' );
                $options['dry_run'] = !$import;
                $result = $service->import( $path, $options );
                $step = $result['ok'] ? ( $import ? 'done' : 'preview' ) : ( $result['plan'] ? 'preview' : 'upload' );
                if ( $import && $result['ok'] )
                    self::forget( $http, $token, $path );
            }
        }

        $tpl->setVariable( 'step', $step );
        $tpl->setVariable( 'errors', $errors );
        $tpl->setVariable( 'result', $result ? self::forTemplate( $result ) : false );
        $tpl->setVariable( 'options', $options );
        $tpl->setVariable( 'token', $token );
        $tpl->setVariable( 'strategies', \expLayoutsCoreTransferFormat::strategies() );

        $Result = array();
        $Result['content'] = $tpl->fetch( 'design:explayouts_ui/transfer_import.tpl' );
        $Result['left_menu'] = 'design:parts/explayouts_ui/menu.tpl';
        $Result['path'] = array( array( 'url' => 'explayouts_ui/dashboard', 'text' => \ezpI18n::tr( 'explayouts_ui/layout', 'Layouts' ) ),
                                 array( 'url' => false, 'text' => \ezpI18n::tr( 'design/admin/parts/explayouts_ui/menu', 'Import' ) ) );
        return $this->viewResult( $Result, $Result );
    }

    /**
     * The import's choices from the form: strategy, publish, unmapped and a strategy per item ("default" = the global one).
     */
    public static function options( \eZHTTPTool $http )
    {
        $strategy = $http->hasPostVariable( 'TransferStrategy' ) ? (string)$http->postVariable( 'TransferStrategy' ) : 'skip';
        $unmapped = $http->hasPostVariable( 'TransferUnmapped' ) ? (string)$http->postVariable( 'TransferUnmapped' ) : 'drop';
        $items = array();
        if ( $http->hasPostVariable( 'TransferItem' ) && is_array( $http->postVariable( 'TransferItem' ) ) )
            foreach ( $http->postVariable( 'TransferItem' ) as $key => $value )
                if ( is_string( $key ) && preg_match( '/^(layout|rule):[A-Za-z0-9_.:\-]{1,300}$/', $key ) && in_array( $value, \expLayoutsCoreTransferFormat::strategies(), true ) )
                    $items[$key] = $value;
        return array(
            'strategy' => in_array( $strategy, \expLayoutsCoreTransferFormat::strategies(), true ) ? $strategy : 'skip',
            'publish' => $http->hasPostVariable( 'TransferPublish' ),
            'unmapped' => in_array( $unmapped, array( 'drop', 'keep', 'fail' ), true ) ? $unmapped : 'drop',
            'items' => $items,
        );
    }

    /**
     * Keeps an uploaded file for the next step, under a random name this session remembers.
     */
    protected static function storeUpload( \eZHTTPTool $http, \expLayoutsCoreTransferService $service, array $file )
    {
        if ( (int)$file['error'] !== UPLOAD_ERR_OK || !is_uploaded_file( $file['tmp_name'] ) )
            return array( 'error' => \ezpI18n::tr( 'design/admin/explayouts_ui/transfer', 'The file could not be uploaded.' ) );
        if ( (int)$file['size'] > self::MAX_UPLOAD_BYTES )
            return array( 'error' => \ezpI18n::tr( 'design/admin/explayouts_ui/transfer', 'The file is larger than 64 MB.' ) );

        $token = bin2hex( random_bytes( 16 ) );
        $path = $service->workDir() . '/upload-' . $token . '.zip';
        if ( !move_uploaded_file( $file['tmp_name'], $path ) )
            return array( 'error' => \ezpI18n::tr( 'design/admin/explayouts_ui/transfer', 'The file could not be uploaded.' ) );

        $known = $http->hasSessionVariable( self::SESSION_KEY ) ? (array)$http->sessionVariable( self::SESSION_KEY ) : array();
        $known[$token] = time();
        $http->setSessionVariable( self::SESSION_KEY, array_slice( $known, -10, null, true ) );
        return array( 'error' => null, 'token' => $token, 'path' => $path );
    }

    /**
     * The path of a file uploaded in this session, or null.
     */
    protected static function uploadPath( \eZHTTPTool $http, \expLayoutsCoreTransferService $service, $token )
    {
        if ( !preg_match( '/^[a-f0-9]{32}$/', $token ) )
            return null;
        $known = $http->hasSessionVariable( self::SESSION_KEY ) ? (array)$http->sessionVariable( self::SESSION_KEY ) : array();
        if ( !isset( $known[$token] ) )
            return null;
        $path = $service->workDir() . '/upload-' . $token . '.zip';
        return is_file( $path ) ? $path : null;
    }

    protected static function forget( \eZHTTPTool $http, $token, $path )
    {
        $known = $http->hasSessionVariable( self::SESSION_KEY ) ? (array)$http->sessionVariable( self::SESSION_KEY ) : array();
        unset( $known[$token] );
        $http->setSessionVariable( self::SESSION_KEY, $known );
        if ( $path && is_file( $path ) )
            @unlink( $path );
    }

    /**
     * The reasons of the diff (expLayoutsCoreTransferDiff, in English for the console) in the user's language.
     */
    protected static function translateReasons( array $items )
    {
        $context = 'design/admin/explayouts_ui/transfer';
        foreach ( $items as $index => $item )
        {
            foreach ( $item['reasons'] as $r => $reason )
            {
                if ( preg_match( '/^The same targets map to the layout "(.*)" on this installation\.$/', $reason, $m ) )
                    $reason = \ezpI18n::tr( $context, 'The same targets map to the layout "%layout" on this installation.', null, array( '%layout' => $m[1] ) );
                elseif ( $reason === 'The layout type differs.' )
                    $reason = \ezpI18n::tr( $context, 'The layout type differs.' );
                elseif ( $reason === 'The shared flag differs.' )
                    $reason = \ezpI18n::tr( $context, 'The shared flag differs.' );
                elseif ( $reason === 'A draft of this layout is open on this installation.' )
                    $reason = \ezpI18n::tr( $context, 'A draft of this layout is open on this installation.' );
                $items[$index]['reasons'][$r] = $reason;
            }
        }
        return $items;
    }

    /**
     * The service's answer in the shape the template reads (no nested objects, counts as rows).
     */
    public static function forTemplate( array $result )
    {
        $manifest = is_array( $result['manifest'] ) ? $result['manifest'] : array();
        $counts = array();
        $context = 'design/admin/explayouts_ui/transfer';
        $labels = array(
            'layouts' => \ezpI18n::tr( $context, 'Layouts' ), 'shared_layouts' => \ezpI18n::tr( $context, 'Shared layouts' ),
            'drafts' => \ezpI18n::tr( $context, 'Drafts' ), 'zones' => \ezpI18n::tr( $context, 'Zones' ),
            'linked_zones' => \ezpI18n::tr( $context, 'Linked zones' ), 'blocks' => \ezpI18n::tr( $context, 'Blocks' ),
            'parameters' => \ezpI18n::tr( $context, 'Parameters' ), 'collections' => \ezpI18n::tr( $context, 'Collections' ),
            'items' => \ezpI18n::tr( $context, 'Collection items' ), 'queries' => \ezpI18n::tr( $context, 'Queries' ),
            'rules' => \ezpI18n::tr( $context, 'Layout mappings' ), 'targets' => \ezpI18n::tr( $context, 'Targets' ),
            'conditions' => \ezpI18n::tr( $context, 'Conditions' ), 'node_references' => \ezpI18n::tr( $context, 'Node references' ),
            'object_references' => \ezpI18n::tr( $context, 'Object references' ),
        );
        foreach ( isset( $manifest['counts'] ) ? (array)$manifest['counts'] : array() as $name => $value )
            $counts[] = array( 'name' => isset( $labels[$name] ) ? $labels[$name] : (string)$name, 'value' => (int)$value );
        return array(
            'ok' => (bool)$result['ok'],
            'errors' => array_values( (array)$result['errors'] ),
            'warnings' => array_values( (array)$result['warnings'] ),
            'format_version' => isset( $manifest['format_version'] ) ? (int)$manifest['format_version'] : 0,
            'created' => isset( $manifest['created'] ) ? (string)$manifest['created'] : '',
            'source_url' => isset( $manifest['source']['site_url'] ) ? (string)$manifest['source']['site_url'] : '',
            'source_name' => isset( $manifest['source']['site_name'] ) ? (string)$manifest['source']['site_name'] : '',
            'counts' => $counts,
            'layouts' => $result['plan'] ? self::translateReasons( $result['plan']['layouts'] ) : array(),
            'rules' => $result['plan'] ? self::translateReasons( $result['plan']['rules'] ) : array(),
            'totals' => $result['plan'] ? $result['plan']['totals'] : array(),
            'unmapped' => $result['unmapped'],
            'import' => isset( $result['import'] ) ? $result['import'] : false,
        );
    }
}

}
