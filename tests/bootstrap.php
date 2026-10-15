<?php
/**
 * Bootstrap of the explayouts_ui tests: no kernel. ezpI18n is a stand-in that fills in the arguments, unless the
 * kernel's class is already loaded (checked without autoloading, so the stand-in is not skipped for the real one).
 *
 * @license GPL-2.0-or-later
 */
if ( !class_exists( 'ezpI18n', false ) )
{
    class ezpI18n
    {
        public static function tr( $context, $source, $comment = null, $arguments = null )
        {
            return strtr( $source, (array) $arguments );
        }
    }
}
require_once dirname( __DIR__ ) . '/classes/explayoutsuiruleinput.php';
