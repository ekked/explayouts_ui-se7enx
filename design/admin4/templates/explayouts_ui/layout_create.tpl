{* admin4: New layout (explayouts_ui/layout_create), admin4's page structure and form components. Same fields as
   design/admin's template. *}
{ezcss_require( 'explayouts_ui_admin4.css' )}
<div class="context-block a4-page explayouts-a4">

<div class="box-header"><div class="box-ml">
<h1 class="context-title">{'New layout'|i18n( 'design/admin/explayouts_ui/layout_create' )}</h1>
</div></div>

<div class="box-bc"><div class="box-ml"><div class="box-content">

<form class="a4-form is-wide" method="post" action={'explayouts_ui/layout_create'|ezurl}>
    <fieldset class="a4-field a4-field-wide">
        <legend class="a4-label">{'Layout type'|i18n( 'design/admin/explayouts_ui/layout_create' )}</legend>
        <div class="a4-chips">
        {foreach $available_types as $type}
            <label class="a4-chip"><input type="radio" name="LayoutType" value="{$type.identifier|wash}"{if eq( $type.identifier, $available_types.0.identifier )} checked="checked"{/if} /><span>{$type.name|wash}</span></label>
        {/foreach}
        </div>
    </fieldset>
    <div class="a4-field">
        <label class="a4-label" for="layout-name">{'Name'|i18n( 'design/admin/explayouts_ui/layout_create' )}</label>
        <input class="a4-input" id="layout-name" type="text" name="Name" value="" required="required" />
    </div>
    <div class="a4-field">
        <label class="a4-label" for="layout-identifier">{'Identifier (optional)'|i18n( 'design/admin/explayouts_ui/layout_create' )}</label>
        <input class="a4-input" id="layout-identifier" type="text" name="Identifier" value="" />
    </div>
    <div class="a4-field a4-field-wide">
        <label class="a4-label" for="layout-description">{'Description'|i18n( 'design/admin/explayouts_ui/layout_create' )}</label>
        <textarea class="a4-input" id="layout-description" name="Description" rows="4"></textarea>
    </div>
    <div class="a4-actions">
        <button class="a4-btn a4-btn-primary" type="submit" name="CreateLayout">{'Create layout'|i18n( 'design/admin/explayouts_ui/layout_create' )}</button>
        <a class="a4-btn" href={'explayouts_ui/layout_list'|ezurl}>{'Cancel'|i18n( 'design/admin/explayouts_ui/layout_create' )}</a>
    </div>
</form>

</div></div></div>
</div>
