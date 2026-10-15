{* admin4: the Layouts dashboard (explayouts_ui/dashboard), in admin4's page structure and components. The same
   data as design/admin's template: counts and the recently changed layouts. *}
{ezcss_require( 'explayouts_ui_admin4.css' )}
<div class="context-block a4-page explayouts-a4">

<div class="box-header"><div class="box-ml">
<h1 class="context-title">{'Layouts Dashboard'|i18n( 'design/admin/explayouts_ui/dashboard' )}</h1>
</div></div>

<div class="box-bc"><div class="box-ml"><div class="box-content">

<div class="a4-toolbar">
    <p class="a4-meta">{'Layouts arrange zones and blocks on a page; mappings decide on which pages a layout is used.'|i18n( 'design/admin/explayouts_ui/dashboard' )}</p>
    <div class="a4-actions">
        <a class="a4-btn a4-btn-primary" href={'explayouts_ui_api/app#layout'|ezurl}>{'New layout'|i18n( 'design/admin/explayouts_ui/dashboard' )}</a>
        <a class="a4-btn" href={'explayouts_ui/layout_list'|ezurl}>{'Layouts'|i18n( 'design/admin/explayouts_ui/dashboard' )}</a>
        <a class="a4-btn" href={'explayouts_ui/rule_list'|ezurl}>{'Rules'|i18n( 'design/admin/explayouts_ui/dashboard' )}</a>
        <a class="a4-btn" href={'explayouts_ui/template_editor/'|ezurl}>{'Template editor'|i18n( 'design/admin/explayouts_ui/dashboard' )}</a>
        <a class="a4-btn" href={'explayouts_ui/setup'|ezurl}>{'Setup DB'|i18n( 'design/admin/explayouts_ui/dashboard' )}</a>
    </div>
</div>

<section aria-labelledby="explayouts-overview-title">
<h2 class="a4-sr-only" id="explayouts-overview-title">{'Overview'|i18n( 'design/admin/explayouts_ui/dashboard' )}</h2>
<ul class="a4-figures">
    <li class="a4-figure"><strong>{$counts.layouts|wash}</strong><span>{'Layouts'|i18n( 'design/admin/explayouts_ui/dashboard' )}</span></li>
    <li class="a4-figure"><strong>{$counts.zones|wash}</strong><span>{'Zones'|i18n( 'design/admin/explayouts_ui/dashboard' )}</span></li>
    <li class="a4-figure"><strong>{$counts.blocks|wash}</strong><span>{'Blocks'|i18n( 'design/admin/explayouts_ui/dashboard' )}</span></li>
    <li class="a4-figure"><strong>{$counts.rules|wash}</strong><span>{'Rules'|i18n( 'design/admin/explayouts_ui/dashboard' )}</span></li>
    <li class="a4-figure"><strong>{$counts.collections|wash}</strong><span>{'Collections'|i18n( 'design/admin/explayouts_ui/dashboard' )}</span></li>
</ul>
</section>

<section class="a4-section" aria-labelledby="explayouts-recent-title">
<div class="a4-section-head"><h2 class="a4-h2" id="explayouts-recent-title">{'Recent layouts'|i18n( 'design/admin/explayouts_ui/dashboard' )}</h2></div>
{if count( $recent_layouts )}
<div class="a4-table-wrap">
<table class="a4-table">
    <thead>
        <tr>
            <th scope="col">{'Name'|i18n( 'design/admin/explayouts_ui/dashboard' )}</th>
            <th scope="col">{'Identifier'|i18n( 'design/admin/explayouts_ui/dashboard' )}</th>
            <th scope="col">{'Status'|i18n( 'design/admin/explayouts_ui/dashboard' )}</th>
            <th scope="col">{'Modified'|i18n( 'design/admin/explayouts_ui/dashboard' )}</th>
            <th scope="col"><span class="a4-sr-only">{'Action'|i18n( 'design/admin/explayouts_ui/dashboard' )}</span></th>
        </tr>
    </thead>
    <tbody>
    {foreach $recent_layouts as $layout}
        <tr>
            <td><a href={concat( 'explayouts_ui_api/app#layout/', $layout.id )|ezurl}>{$layout.name|wash}</a></td>
            <td><code class="a4-code">{$layout.identifier|wash}</code></td>
            <td>{if eq( $layout.status, 2 )}<span class="a4-badge is-ok">{'Published'|i18n( 'design/admin/explayouts_ui/dashboard' )}</span>{else}<span class="a4-badge">{'Draft'|i18n( 'design/admin/explayouts_ui/dashboard' )}</span>{/if}</td>
            <td class="a4-nowrap">{$layout.modified|datetime( 'custom', '%Y-%m-%d %H:%i' )}</td>
            <td class="a4-end"><a class="a4-btn a4-btn-small" href={concat( 'explayouts_ui_api/app#layout/', $layout.id )|ezurl}>{'Open'|i18n( 'design/admin/explayouts_ui/dashboard' )}</a></td>
        </tr>
    {/foreach}
    </tbody>
</table>
</div>
{else}
<p class="a4-empty">{'There are no layouts yet'|i18n( 'design/admin/explayouts_ui/dashboard' )}</p>
{/if}
</section>

</div></div></div>
</div>
