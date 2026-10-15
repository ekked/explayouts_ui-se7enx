<?php
/**
 * Template operators of explayouts_ui.
 *
 *   explayouts_ui_has_template( 'parts/left_width_control.tpl' )
 *
 * true when a template of that path exists in one of the current designs (site design, additional designs,
 * design extensions), without loading it. The admin4 left menu uses it to take admin4's shared parts (width switch)
 * where the installation has them and to draw its own fallback where it does not.
 */
class expLayoutsUiTemplateOperators
{
    function operatorList()
    {
        return array( 'explayouts_ui_has_template' );
    }

    function namedParameterPerOperator()
    {
        return true;
    }

    function namedParameterList()
    {
        return array( 'explayouts_ui_has_template' => array( 'path' => array( 'type' => 'string', 'required' => true, 'default' => '' ) ) );
    }

    function modify( $tpl, $operatorName, $operatorParameters, $rootNamespace, $currentNamespace, &$operatorValue, $namedParameters )
    {
        if ( $operatorName === 'explayouts_ui_has_template' )
            $operatorValue = self::hasTemplate( (string)$namedParameters['path'] );
    }

    /**
     * @param string $path relative to a design's templates/ directory
     * @return bool
     */
    static function hasTemplate( $path )
    {
        $path = ltrim( $path, '/' );
        if ( $path === '' || strpos( $path, '..' ) !== false )
            return false;
        $triedFiles = array();
        $match = eZTemplateDesignResource::fileMatch( eZTemplateDesignResource::allDesignBases(), 'templates', $path, $triedFiles );
        return is_array( $match ) && isset( $match['path'] ) && is_file( $match['path'] );
    }
}
