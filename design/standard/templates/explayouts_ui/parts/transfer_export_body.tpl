{* The body of explayouts_ui/transfer_export, for every admin design: choose layouts, shared layouts, mappings and
   drafts, then download the layouts transfer file. Shared admin components (.a4-*) only; no inline style or script.
   Variables: $layouts, $shared_layouts (one row per identifier), $chosen_layouts, $chosen_shared, $chosen_rules,
   $chosen_drafts, $errors, $warnings, $can_import. *}

<p class="a4-intro">{'Export layouts, shared layouts and their mappings into a layouts transfer file (.zip) that another installation can import. The shared layouts the chosen layouts link to are always included.'|i18n( 'design/admin/explayouts_ui/transfer' )}</p>

{if $errors}
<div class="a4-notice is-bad" role="alert"><ul>{foreach $errors as $message}<li>{$message|wash}</li>{/foreach}</ul></div>
{/if}
{if $warnings}
<div class="a4-notice is-warn" role="status"><ul>{foreach $warnings as $message}<li>{$message|wash}</li>{/foreach}</ul></div>
{/if}

<form class="a4-form is-wide" name="transfer_export" method="post" action={'explayouts_ui/transfer_export'|ezurl}>

{foreach array( hash( 'rows', $layouts, 'name', 'ExportLayout', 'chosen', $chosen_layouts, 'id', 'layouts', 'title', 'Layouts'|i18n( 'design/admin/explayouts_ui/transfer' ) ),
                hash( 'rows', $shared_layouts, 'name', 'ExportShared', 'chosen', $chosen_shared, 'id', 'shared', 'title', 'Shared layouts'|i18n( 'design/admin/explayouts_ui/transfer' ) ) ) as $group}
<fieldset class="a4-section">
    <legend class="a4-h2">{$group.title|wash}</legend>
    {if $group.rows}
    <div class="a4-table-wrap">
    <table class="a4-table is-compact">
        <thead><tr>
            <th scope="col"><span class="a4-sr-only">{'Export'|i18n( 'design/admin/explayouts_ui/transfer' )}</span></th>
            <th scope="col">{'Name'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
            <th scope="col">{'Type'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
            <th scope="col">{'Status'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
            <th scope="col">{'Mappings'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
            <th scope="col">{'Links to'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
        </tr></thead>
        <tbody>
        {foreach $group.rows as $index => $row}
            <tr>
                <td><input type="checkbox" id="export-{$group.id}-{$index}" name="{$group.name}[]" value="{$row.identifier|wash}"{if $group.chosen|contains( $row.identifier )} checked="checked"{/if} /></td>
                <td><label for="export-{$group.id}-{$index}">{$row.name|wash}</label><br /><code class="a4-code a4-muted">{$row.identifier|wash}</code></td>
                <td>{$row.layout_type|wash}</td>
                <td>
                    {if $row.published}<span class="a4-tag is-ok">{'published'|i18n( 'design/admin/explayouts_ui/transfer' )}</span>{else}<span class="a4-tag is-warn">{'draft only'|i18n( 'design/admin/explayouts_ui/transfer' )}</span>{/if}
                    {if and( $row.published, $row.has_draft )} <span class="a4-tag">{'open draft'|i18n( 'design/admin/explayouts_ui/transfer' )}</span>{/if}
                </td>
                <td class="a4-num">{$row.rules|wash}</td>
                <td>{foreach $row.link_names as $link_name}<span class="a4-tag">{$link_name|wash}</span> {/foreach}</td>
            </tr>
        {/foreach}
        </tbody>
    </table>
    </div>
    {else}
    <p class="a4-empty">{'There are none.'|i18n( 'design/admin/explayouts_ui/transfer' )}</p>
    {/if}
</fieldset>
{/foreach}

<fieldset class="a4-field">
    <legend class="a4-label">{'Layout mappings'|i18n( 'design/admin/explayouts_ui/transfer' )}</legend>
    <div class="a4-radios">
        <label class="a4-check"><input type="radio" name="ExportRules" value="none"{if eq( $chosen_rules, 'none' )} checked="checked"{/if} /> {'None'|i18n( 'design/admin/explayouts_ui/transfer' )}</label>
        <label class="a4-check"><input type="radio" name="ExportRules" value="selected"{if eq( $chosen_rules, 'selected' )} checked="checked"{/if} /> {'The mappings of the chosen layouts, with their targets and conditions'|i18n( 'design/admin/explayouts_ui/transfer' )}</label>
        <label class="a4-check"><input type="radio" name="ExportRules" value="all"{if eq( $chosen_rules, 'all' )} checked="checked"{/if} /> {'All mappings (their layouts are included)'|i18n( 'design/admin/explayouts_ui/transfer' )}</label>
    </div>
</fieldset>

<div class="a4-field">
    <label class="a4-check"><input type="checkbox" name="ExportDrafts" value="1"{if $chosen_drafts} checked="checked"{/if} /> {'Include open drafts (only published layouts otherwise)'|i18n( 'design/admin/explayouts_ui/transfer' )}</label>
</div>

<div class="a4-actions">
    <button type="submit" class="a4-btn a4-btn-primary" name="ExportButton" value="1">{'Export the selection'|i18n( 'design/admin/explayouts_ui/transfer' )}</button>
    <button type="submit" class="a4-btn" name="ExportAllButton" value="1">{'Export everything'|i18n( 'design/admin/explayouts_ui/transfer' )}</button>
    {if $can_import}<a class="a4-btn a4-btn-ghost" href={'explayouts_ui/transfer_import'|ezurl}>{'Import'|i18n( 'design/admin/explayouts_ui/transfer' )}</a>{/if}
</div>
</form>
