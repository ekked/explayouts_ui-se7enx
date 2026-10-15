{* admin4: the left menu of the Layouts pages, built like every admin4 left menu: the links of menu.ini
   [Leftmenu_explayouts_ui_dashboard] through parts/ini_menu.tpl (policies, current page), then the width switch.
   The width switch is admin4's shared part (parts/left_width_control.tpl) where the installation has it, and the
   older links otherwise. *}
{include uri='design:parts/ini_menu.tpl' ini_section='Leftmenu_explayouts_ui_dashboard'}

{if explayouts_ui_has_template( 'parts/left_width_control.tpl' )}
    {include uri=concat( 'design:parts/', 'left_width_control.tpl' )}
{else}
    {include uri='design:explayouts_ui/parts/left_width_control_fallback.tpl'}
{/if}
