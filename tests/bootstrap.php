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
require_once dirname( __DIR__ ) . '/classes/explayoutsuischemastatement.php';
// The template editor's class builds on explayouts' expLayoutsTemplateEditor: the real one beside this extension,
// else an empty stand-in (the tests use only what needs no kernel: the diff, the tag check, the write rules).
if ( !class_exists( 'expLayoutsTemplateEditor', false ) )
{
    $editor = dirname( __DIR__, 2 ) . '/explayouts/classes/explayoutstemplateeditor.php';
    if ( is_file( $editor ) )
        require_once $editor;
    else
    {
        class expLayoutsTemplateEditor
        {
        }
    }
}
require_once dirname( __DIR__ ) . '/classes/explayoutsuitemplateeditor.php';
