{* The body of explayouts_ui/transfer_import, for every admin design: upload, preview (a dry run with the state and
   the action of each layout and rule), import. Shared admin components (.a4-*) only; no inline style or script.
   Variables: $step (upload, preview, done), $errors, $result, $options, $token, $strategies. *}
{def $state_tags = hash( 'new', 'is-info', 'identical', 'is-ok', 'changed', 'is-warn', 'conflicting', 'is-bad' )}

<p class="a4-intro">{'Import layouts, shared layouts and their mappings from a layouts transfer file (.zip). Nothing is written before you have seen the preview.'|i18n( 'design/admin/explayouts_ui/transfer' )}</p>

{if $errors}
<div class="a4-notice is-bad" role="alert">
    <ul>{foreach $errors as $message}<li>{$message|wash}</li>{/foreach}</ul>
</div>
{/if}

{if $result}
    {if $result.errors}
    <div class="a4-notice is-bad" role="alert">
        {if $result.import}<p class="a4-notice-title">{'Nothing was written: the import was rolled back.'|i18n( 'design/admin/explayouts_ui/transfer' )}</p>{/if}
        <ul>{foreach $result.errors as $message}<li>{$message|wash}</li>{/foreach}</ul>
    </div>
    {/if}
    {if $result.warnings}
    <details class="a4-fold is-warn">
        <summary>{'%count warnings'|i18n( 'design/admin/explayouts_ui/transfer', , hash( '%count', $result.warnings|count ) )}</summary>
        <div class="a4-fold-body"><ul>{foreach $result.warnings as $message}<li>{$message|wash}</li>{/foreach}</ul></div>
    </details>
    {/if}
{/if}

{if eq( $step, 'done' )}
<div class="a4-notice is-ok" role="status">
    <p class="a4-notice-title">{'The import was written.'|i18n( 'design/admin/explayouts_ui/transfer' )}</p>
    <p>{'%written items written, %entries resolver cache entries of the affected layouts removed.'|i18n( 'design/admin/explayouts_ui/transfer', , hash( '%written', $result.import.written|count, '%entries', $result.import.cache_entries_removed ) )}</p>
</div>
{if $result.import.written}
<div class="a4-table-wrap">
<table class="a4-table">
    <caption class="a4-sr-only">{'What was written'|i18n( 'design/admin/explayouts_ui/transfer' )}</caption>
    <thead><tr>
        <th scope="col">{'Item'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
        <th scope="col">{'Done'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
        <th scope="col">{'ID'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
    </tr></thead>
    <tbody>
    {foreach $result.import.written as $entry}
        <tr>
            <td><code class="a4-code">{$entry.key|wash}</code></td>
            <td>{$entry.what|wash}</td>
            <td class="a4-num">{if eq( $entry.kind, 'layout' )}<a href={concat( 'explayouts_ui/layout_preview/', $entry.id )|ezurl}>{$entry.id|wash}</a>{else}{$entry.id|wash}{/if}</td>
        </tr>
    {/foreach}
    </tbody>
</table>
</div>
{/if}
<p><a class="a4-btn" href={'explayouts_ui/transfer_import'|ezurl}>{'Import another file'|i18n( 'design/admin/explayouts_ui/transfer' )}</a></p>
{else}

<form class="a4-form is-wide" name="transfer_import" method="post" action={'explayouts_ui/transfer_import'|ezurl} enctype="multipart/form-data">

{if and( $result, eq( $step, 'preview' ) )}
    <input type="hidden" name="TransferToken" value="{$token|wash}" />

    <section class="a4-section" aria-labelledby="transfer-file-heading">
        <h2 class="a4-h2" id="transfer-file-heading">{'The file'|i18n( 'design/admin/explayouts_ui/transfer' )}</h2>
        <dl class="a4-facts">
            <dt>{'Exported from'|i18n( 'design/admin/explayouts_ui/transfer' )}</dt><dd>{$result.source_name|wash} {if $result.source_url}<code class="a4-code">{$result.source_url|wash}</code>{/if}</dd>
            <dt>{'Created'|i18n( 'design/admin/explayouts_ui/transfer' )}</dt><dd>{$result.created|wash}</dd>
            <dt>{'Format version'|i18n( 'design/admin/explayouts_ui/transfer' )}</dt><dd>{$result.format_version|wash}</dd>
            {foreach $result.counts as $count}{if $count.value}<dt>{$count.name|wash}</dt><dd class="a4-num">{$count.value|wash}</dd>{/if}{/foreach}
        </dl>
        <p class="a4-badges">
            {foreach $result.totals as $state => $total}<span class="a4-tag {$state_tags[$state]}">{$state|i18n( 'design/admin/explayouts_ui/transfer' )|wash}: {$total|wash}</span> {/foreach}
        </p>
    </section>

    {if $result.layouts}
    <section class="a4-section" aria-labelledby="transfer-layouts-heading">
        <h2 class="a4-h2" id="transfer-layouts-heading">{'Layouts'|i18n( 'design/admin/explayouts_ui/transfer' )}</h2>
        <div class="a4-table-wrap">
        <table class="a4-table">
            <thead><tr>
                <th scope="col">{'Layout'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
                <th scope="col">{'Status'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
                <th scope="col">{'Compared with this installation'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
                <th scope="col">{'Strategy'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
                <th scope="col">{'The import will'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
            </tr></thead>
            <tbody>
            {foreach $result.layouts as $item sequence array( 'a', 'b' ) as $row}
                <tr>
                    <td>{$item.name|wash}<br /><code class="a4-code">{$item.identifier|wash}</code>
                        {if $item.shared} <span class="a4-tag is-accent">{'shared'|i18n( 'design/admin/explayouts_ui/transfer' )}</span>{/if}
                        {if $item.dependency} <span class="a4-tag">{'linked to'|i18n( 'design/admin/explayouts_ui/transfer' )}</span>{/if}</td>
                    <td>{$item.status|i18n( 'design/admin/explayouts_ui/transfer' )|wash}</td>
                    <td>
                        <span class="a4-tag {$state_tags[$item.state]}">{$item.state|i18n( 'design/admin/explayouts_ui/transfer' )|wash}</span>
                        {if $item.reasons}<ul class="a4-plain">{foreach $item.reasons as $reason}<li>{$reason|wash}</li>{/foreach}</ul>{/if}
                        {if $item.differences}
                        <details class="a4-fold">
                            <summary>{'%count differences'|i18n( 'design/admin/explayouts_ui/transfer', , hash( '%count', $item.differences|count ) )}</summary>
                            <div class="a4-fold-body"><ul class="a4-plain">{foreach $item.differences as $difference}<li><code class="a4-code">{$difference|wash}</code></li>{/foreach}</ul></div>
                        </details>
                        {/if}
                    </td>
                    <td>
                        <label class="a4-sr-only" for="transfer-item-{$row}-{$item.key|md5}">{'Strategy for %item'|i18n( 'design/admin/explayouts_ui/transfer', , hash( '%item', $item.identifier ) )|wash}</label>
                        <select class="a4-input is-auto" id="transfer-item-{$row}-{$item.key|md5}" name="TransferItem[{$item.key|wash}]">
                            <option value="">{'As chosen below'|i18n( 'design/admin/explayouts_ui/transfer' )}</option>
                            {foreach $strategies as $strategy}<option value="{$strategy|wash}"{if and( is_set( $options.items[$item.key] ), eq( $options.items[$item.key], $strategy ) )} selected="selected"{/if}>{$strategy|i18n( 'design/admin/explayouts_ui/transfer' )|wash}</option>{/foreach}
                        </select>
                    </td>
                    <td>{include uri='design:explayouts_ui/parts/transfer_action.tpl' action=$item.action}</td>
                </tr>
            {/foreach}
            </tbody>
        </table>
        </div>
    </section>
    {/if}

    {if $result.rules}
    <section class="a4-section" aria-labelledby="transfer-rules-heading">
        <h2 class="a4-h2" id="transfer-rules-heading">{'Layout mappings'|i18n( 'design/admin/explayouts_ui/transfer' )}</h2>
        <div class="a4-table-wrap">
        <table class="a4-table">
            <thead><tr>
                <th scope="col">{'Layout'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
                <th scope="col">{'Targets'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
                <th scope="col">{'Compared with this installation'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
                <th scope="col">{'Strategy'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
                <th scope="col">{'The import will'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
            </tr></thead>
            <tbody>
            {foreach $result.rules as $item sequence array( 'a', 'b' ) as $row}
                <tr>
                    <td><code class="a4-code">{$item.layout|wash}</code></td>
                    <td><code class="a4-code">{$item.targets|wash|nl2br}</code></td>
                    <td>
                        <span class="a4-tag {$state_tags[$item.state]}">{$item.state|i18n( 'design/admin/explayouts_ui/transfer' )|wash}</span>
                        {if $item.reasons}<ul class="a4-plain">{foreach $item.reasons as $reason}<li>{$reason|wash}</li>{/foreach}</ul>{/if}
                        {if $item.differences}<ul class="a4-plain">{foreach $item.differences as $difference}<li><code class="a4-code">{$difference|wash}</code></li>{/foreach}</ul>{/if}
                    </td>
                    <td>
                        <label class="a4-sr-only" for="transfer-rule-{$item.key|md5}">{'Strategy for a mapping of %item'|i18n( 'design/admin/explayouts_ui/transfer', , hash( '%item', $item.layout ) )|wash}</label>
                        <select class="a4-input is-auto" id="transfer-rule-{$item.key|md5}" name="TransferItem[{$item.key|wash}]">
                            <option value="">{'As chosen below'|i18n( 'design/admin/explayouts_ui/transfer' )}</option>
                            {foreach $strategies as $strategy}<option value="{$strategy|wash}"{if and( is_set( $options.items[$item.key] ), eq( $options.items[$item.key], $strategy ) )} selected="selected"{/if}>{$strategy|i18n( 'design/admin/explayouts_ui/transfer' )|wash}</option>{/foreach}
                        </select>
                    </td>
                    <td>{include uri='design:explayouts_ui/parts/transfer_action.tpl' action=$item.action}</td>
                </tr>
            {/foreach}
            </tbody>
        </table>
        </div>
    </section>
    {/if}

    {if $result.unmapped}
    <section class="a4-section" aria-labelledby="transfer-unmapped-heading">
        <h2 class="a4-h2" id="transfer-unmapped-heading">{'References without a match here'|i18n( 'design/admin/explayouts_ui/transfer' )}</h2>
        <p class="a4-help">{'These nodes and objects have no content with the same remote ID on this installation. Choose below what happens to them.'|i18n( 'design/admin/explayouts_ui/transfer' )}</p>
        <div class="a4-table-wrap">
        <table class="a4-table is-compact">
            <thead><tr>
                <th scope="col">{'Kind'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
                <th scope="col">{'ID in the file'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
                <th scope="col">{'Remote ID'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
                <th scope="col">{'Path'|i18n( 'design/admin/explayouts_ui/transfer' )}</th>
            </tr></thead>
            <tbody>
            {foreach $result.unmapped as $reference}
                <tr><td>{$reference.kind|i18n( 'design/admin/explayouts_ui/transfer' )|wash}</td><td class="a4-num">{$reference.id|wash}</td><td><code class="a4-code">{$reference.remote_id|wash}</code></td><td>{$reference.path|wash}</td></tr>
            {/foreach}
            </tbody>
        </table>
        </div>
    </section>
    {/if}
{else}
    <div class="a4-field">
        <label class="a4-label" for="transfer-file">{'Layouts transfer file'|i18n( 'design/admin/explayouts_ui/transfer' )}</label>
        <input class="a4-input" type="file" id="transfer-file" name="TransferFile" accept="application/zip,.zip" required="required" aria-describedby="transfer-file-help" />
        <p class="a4-help" id="transfer-file-help">{'A .zip made by Export or by ./console exp:layouts export, up to 64 MB.'|i18n( 'design/admin/explayouts_ui/transfer' )}</p>
    </div>
{/if}

    <fieldset class="a4-field">
        <legend class="a4-label">{'When a layout or mapping exists here already'|i18n( 'design/admin/explayouts_ui/transfer' )}</legend>
        <div class="a4-radios">
            <label class="a4-check"><input type="radio" name="TransferStrategy" value="skip"{if eq( $options.strategy, 'skip' )} checked="checked"{/if} /> {'Skip it: keep what is here'|i18n( 'design/admin/explayouts_ui/transfer' )}</label>
            <label class="a4-check"><input type="radio" name="TransferStrategy" value="overwrite"{if eq( $options.strategy, 'overwrite' )} checked="checked"{/if} /> {'Overwrite it: a new draft with the content of the file'|i18n( 'design/admin/explayouts_ui/transfer' )}</label>
            <label class="a4-check"><input type="radio" name="TransferStrategy" value="copy"{if eq( $options.strategy, 'copy' )} checked="checked"{/if} /> {'Create a copy: a new layout with the content of the file'|i18n( 'design/admin/explayouts_ui/transfer' )}</label>
        </div>
        <p class="a4-help">{'Shared layouts that are only in the file because a layout links to them keep their version here unless you choose a strategy for them above. Mappings are not copied with their layouts.'|i18n( 'design/admin/explayouts_ui/transfer' )}</p>
    </fieldset>

    <div class="a4-field">
        <label class="a4-check"><input type="checkbox" name="TransferPublish" value="1"{if $options.publish} checked="checked"{/if} /> {'Publish overwritten layouts and copies (otherwise they stay drafts)'|i18n( 'design/admin/explayouts_ui/transfer' )}</label>
    </div>

    <div class="a4-field">
        <label class="a4-label" for="transfer-unmapped">{'References without a match here'|i18n( 'design/admin/explayouts_ui/transfer' )}</label>
        <select class="a4-input is-auto" id="transfer-unmapped" name="TransferUnmapped">
            <option value="drop"{if eq( $options.unmapped, 'drop' )} selected="selected"{/if}>{'Leave them out (and the mappings that need them)'|i18n( 'design/admin/explayouts_ui/transfer' )}</option>
            <option value="keep"{if eq( $options.unmapped, 'keep' )} selected="selected"{/if}>{'Keep the IDs of the file'|i18n( 'design/admin/explayouts_ui/transfer' )}</option>
            <option value="fail"{if eq( $options.unmapped, 'fail' )} selected="selected"{/if}>{'Stop the import'|i18n( 'design/admin/explayouts_ui/transfer' )}</option>
        </select>
    </div>

    <div class="a4-actions">
    {if and( $result, eq( $step, 'preview' ) )}
        <button type="submit" class="a4-btn a4-btn-primary" name="ImportButton" value="1">{'Import'|i18n( 'design/admin/explayouts_ui/transfer' )}</button>
        <button type="submit" class="a4-btn" name="PreviewButton" value="1">{'Update the preview'|i18n( 'design/admin/explayouts_ui/transfer' )}</button>
        <a class="a4-btn a4-btn-ghost" href={'explayouts_ui/transfer_import'|ezurl}>{'Choose another file'|i18n( 'design/admin/explayouts_ui/transfer' )}</a>
    {else}
        <button type="submit" class="a4-btn a4-btn-primary" name="PreviewButton" value="1">{'Preview'|i18n( 'design/admin/explayouts_ui/transfer' )}</button>
    {/if}
    </div>
</form>
{/if}
{undef $state_tags}
