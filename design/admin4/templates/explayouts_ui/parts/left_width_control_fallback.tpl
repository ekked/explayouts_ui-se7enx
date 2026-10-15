{* The left menu width switch of admin4 installations without parts/left_width_control.tpl: the links the core
   left menus drew before it (parts/setup/menu.tpl), same markup and texts. *}
<div id="widthcontrol-links" class="widthcontrol">
<p>
{def $explayouts_ui_left_size = ezpreference( 'admin_left_menu_size' )}
{foreach array( 'small', 'medium', 'large' ) as $explayouts_ui_size}
    {def $explayouts_ui_size_name = cond( eq( $explayouts_ui_size, 'small' ), 'Small'|i18n( 'design/admin/parts/user/menu' ), eq( $explayouts_ui_size, 'medium' ), 'Medium'|i18n( 'design/admin/parts/user/menu' ), 'Large'|i18n( 'design/admin/parts/user/menu' ) )}
    {if or( eq( $explayouts_ui_left_size, $explayouts_ui_size ), and( eq( $explayouts_ui_size, 'small' ), eq( $explayouts_ui_left_size, '' ) ) )}
    <span class="current">{$explayouts_ui_size_name}</span>
    {else}
    <a href={concat( '/user/preferences/set/admin_left_menu_size/', $explayouts_ui_size )|ezurl}>{$explayouts_ui_size_name}</a>
    {/if}
    {undef $explayouts_ui_size_name}
{/foreach}
{undef $explayouts_ui_left_size}
</p>
</div>
