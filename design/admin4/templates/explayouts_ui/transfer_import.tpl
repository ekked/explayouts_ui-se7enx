{* admin4: Import (explayouts_ui/transfer_import). Same form fields as design/admin's template. *}
{ezcss_require( 'explayouts_ui_admin4.css' )}
<div class="context-block a4-page explayouts-a4">

<div class="box-header"><div class="box-ml">
<h1 class="context-title">{'Import'|i18n( 'design/admin/explayouts_ui/transfer_import' )}</h1>
</div></div>

<div class="box-bc"><div class="box-ml"><div class="box-content">

<p class="a4-intro">{'Please choose a JSON file containing entities to import'|i18n( 'design/admin/explayouts_ui/transfer_import' )}</p>
{if $message}<div class="a4-notice is-ok" role="status">{$message|wash}</div>{/if}
{if $error}<div class="a4-notice is-bad" role="alert">{$error|wash}</div>{/if}

<form class="a4-form" name="import" method="post" action={'explayouts_ui/transfer_import'|ezurl} enctype="multipart/form-data">
    <div class="a4-field">
        <label class="a4-label" for="import_file">{'Select file'|i18n( 'design/admin/explayouts_ui/transfer_import' )}</label>
        <input class="a4-input" type="file" id="import_file" name="import[file]" accept="application/json,.json" required="required" />
    </div>
    <fieldset class="a4-field">
        <legend class="a4-label">{'Import mode'|i18n( 'design/admin/explayouts_ui/transfer_import' )}</legend>
        <div class="a4-radios">
            <label class="a4-check"><input type="radio" name="import[import_mode]" value="copy" checked="checked" /> {'Copy existing entities'|i18n( 'design/admin/explayouts_ui/transfer_import' )}</label>
            <label class="a4-check"><input type="radio" name="import[import_mode]" value="overwrite" /> {'Overwrite existing entities'|i18n( 'design/admin/explayouts_ui/transfer_import' )}</label>
            <label class="a4-check"><input type="radio" name="import[import_mode]" value="skip" /> {'Skip existing entities'|i18n( 'design/admin/explayouts_ui/transfer_import' )}</label>
        </div>
    </fieldset>
    <div class="a4-actions">
        <button type="submit" class="a4-btn a4-btn-primary">{'Import'|i18n( 'design/admin/explayouts_ui/transfer_import' )}</button>
    </div>
</form>

</div></div></div>
</div>
