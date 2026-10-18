<?php
/**
 * explayouts_ui/transfer_export: exports layouts, shared layouts and rules into a layouts transfer file
 * (expLayoutsCoreTransferService) and sends it as a download.
 *
 * The form chooses layouts (one, several or all), shared layouts, the rules (none, those of the chosen layouts, all)
 * and whether open drafts go along; "Export everything" takes all of it. The shared layouts the chosen layouts link
 * to are always exported too.
 *
 * Policy: explayouts_ui/transfer_export. Guide: doc/TRANSFER.md of explayouts_core.
 */

namespace Exponential\View\Extension\ExplayoutsUi\ExplayoutsUi
{

class TransferExport extends \Exponential\Runnable\ModuleView
{
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

        $errors = array();
        $warnings = array();
        $chosen = array( 'layouts' => array(), 'shared' => array(), 'rules' => 'selected', 'drafts' => false );

        if ( $http->hasPostVariable( 'ExportButton' ) || $http->hasPostVariable( 'ExportAllButton' ) )
        {
            if ( $http->hasPostVariable( 'ExportAllButton' ) )
                $selection = array( 'layouts' => 'all', 'shared' => 'all', 'rules' => 'all', 'drafts' => $http->hasPostVariable( 'ExportDrafts' ) );
            else
            {
                $selection = array(
                    'layouts' => self::idList( $http, 'ExportLayout' ),
                    'shared' => self::idList( $http, 'ExportShared' ),
                    'rules' => $http->hasPostVariable( 'ExportRules' ) ? (string)$http->postVariable( 'ExportRules' ) : 'selected',
                    'drafts' => $http->hasPostVariable( 'ExportDrafts' ),
                );
                $chosen = $selection;
            }

            if ( !$selection['layouts'] && !$selection['shared'] && $selection['rules'] !== 'all' )
                $errors[] = \ezpI18n::tr( 'design/admin/explayouts_ui/transfer', 'Please choose at least one layout or shared layout.' );
            else
            {
                $export = $service->export( $selection );
                if ( $export['ok'] )
                {
                    // Sends the file and ends the request (never inside a catch: the exit is an exception under
                    // a persistent server).
                    \eZFile::download( $export['path'], true, $export['filename'] );
                    return $this->viewResult( null, null );
                }
                $errors = $export['errors'];
                $warnings = $export['warnings'];
            }
        }

        // One entry per layout identifier: its published row, else its draft, saying which states it has.
        $byIdentifier = array();
        foreach ( \expLayoutsCoreTransferService::listLayouts( true ) as $row )
        {
            $identifier = $row['identifier'];
            if ( !isset( $byIdentifier[$identifier] ) || $row['status'] === 'published' )
                $byIdentifier[$identifier] = $row + array( 'published' => false, 'has_draft' => false );
            $byIdentifier[$identifier]['published'] = $byIdentifier[$identifier]['published'] || $row['status'] === 'published';
            $byIdentifier[$identifier]['has_draft'] = $byIdentifier[$identifier]['has_draft'] || $row['status'] === 'draft';
        }
        $layouts = array();
        $shared = array();
        foreach ( $byIdentifier as $row )
        {
            $row['link_names'] = array();
            foreach ( $row['links'] as $link )
                $row['link_names'][] = isset( $byIdentifier[$link] ) && $byIdentifier[$link]['name'] !== '' ? $byIdentifier[$link]['name'] : $link;
            if ( $row['shared'] )
                $shared[] = $row;
            else
                $layouts[] = $row;
        }

        $tpl->setVariable( 'layouts', $layouts );
        $tpl->setVariable( 'shared_layouts', $shared );
        $tpl->setVariable( 'chosen_layouts', array_map( 'strval', (array)$chosen['layouts'] ) );
        $tpl->setVariable( 'chosen_shared', array_map( 'strval', (array)$chosen['shared'] ) );
        $tpl->setVariable( 'chosen_rules', $chosen['rules'] );
        $tpl->setVariable( 'chosen_drafts', (bool)$chosen['drafts'] );
        $tpl->setVariable( 'errors', $errors );
        $tpl->setVariable( 'warnings', $warnings );
        $tpl->setVariable( 'can_import', \eZUser::currentUser()->hasAccessTo( 'explayouts_ui', 'transfer_import' )['accessWord'] !== 'no' );

        $Result = array();
        $Result['content'] = $tpl->fetch( 'design:explayouts_ui/transfer_export.tpl' );
        $Result['left_menu'] = 'design:parts/explayouts_ui/menu.tpl';
        $Result['path'] = array( array( 'url' => 'explayouts_ui/dashboard', 'text' => \ezpI18n::tr( 'explayouts_ui/layout', 'Layouts' ) ),
                                 array( 'url' => false, 'text' => \ezpI18n::tr( 'design/admin/parts/explayouts_ui/menu', 'Export' ) ) );
        return $this->viewResult( $Result, $Result );
    }

    /**
     * The layout identifiers checked in a list of the form.
     */
    protected static function idList( \eZHTTPTool $http, $name )
    {
        if ( !$http->hasPostVariable( $name ) || !is_array( $http->postVariable( $name ) ) )
            return array();
        $list = array();
        foreach ( $http->postVariable( $name ) as $identifier )
            if ( is_string( $identifier ) && preg_match( \expLayoutsCoreTransferFormat::IDENTIFIER_PATTERN, $identifier ) )
                $list[] = $identifier;
        return array_values( array_unique( $list ) );
    }
}

}
