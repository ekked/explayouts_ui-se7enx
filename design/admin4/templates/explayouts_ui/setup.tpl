{* admin4: Setup (explayouts_ui/setup). Installs the explayouts_* tables only; a table that is there already is
   left as it is. *}
{ezcss_require( 'explayouts_ui_admin4.css' )}
<div class="context-block a4-page explayouts-a4">

<div class="box-header"><div class="box-ml">
<h1 class="context-title">{'Exponential Layouts Setup'|i18n( 'design/admin/explayouts_ui/setup' )}</h1>
</div></div>

<div class="box-bc"><div class="box-ml"><div class="box-content">

{if $message}<div class="a4-notice is-ok" role="status">{$message|wash}</div>{/if}
{if $error}<div class="a4-notice is-bad" role="alert">{$error|wash}</div>{/if}

<dl class="a4-facts is-rows">
    <dt>{'Detected database type:'|i18n( 'design/admin/explayouts_ui/setup' )}</dt>
    <dd><code class="a4-code">{$db_type|wash}</code></dd>
    {if $schema_file}
    <dt>{'Schema file:'|i18n( 'design/admin/explayouts_ui/setup' )}</dt>
    <dd><code class="a4-code">{$schema_file|wash}</code></dd>
    {/if}
</dl>

{if $schema_file}
<p class="a4-help">{'Creates the missing explayouts_* tables. Tables that exist already and every other table of the database are left as they are.'|i18n( 'design/admin/explayouts_ui/setup' )}</p>
<form method="post" action={'explayouts_ui/setup'|ezurl}>
    <div class="a4-actions">
        <button class="a4-btn a4-btn-primary" type="submit" name="InstallSchema" value="1">{'Install / update schema'|i18n( 'design/admin/explayouts_ui/setup' )}</button>
        <a class="a4-btn" href={'explayouts_ui/layout_list'|ezurl}>{'Back to layouts'|i18n( 'design/admin/explayouts_ui/setup' )}</a>
    </div>
</form>
{else}
<div class="a4-notice is-warn">{'Could not determine a supported schema file for this database.'|i18n( 'design/admin/explayouts_ui/setup' )}</div>
<p><a class="a4-btn" href={'explayouts_ui/layout_list'|ezurl}>{'Back to layouts'|i18n( 'design/admin/explayouts_ui/setup' )}</a></p>
{/if}

</div></div></div>
</div>
