{* admin4: the layouts (explayouts_ui/layout_list), one card per layout, in admin4's page structure and
   components. The same data and form fields as design/admin's template; the sorting runs in
   javascript/explayouts_ui_admin4.js (data-* on each card). *}
{ezcss_require( 'explayouts_ui_admin4.css' )}
{ezscript_require( 'explayouts_ui_admin4.js' )}
<div class="context-block a4-page explayouts-a4">

<div class="box-header"><div class="box-ml">
<h1 class="context-title">{'Layouts'|i18n( 'design/admin/explayouts_ui/layout_list' )}</h1>
</div></div>

<div class="box-bc"><div class="box-ml"><div class="box-content">

{if $message}<div class="a4-notice is-ok" role="status">{$message|wash}</div>{/if}
{if $error}<div class="a4-notice is-bad" role="alert">{$error|wash}</div>{/if}

<div class="a4-toolbar">
    <div class="a4-row explayouts-a4-sort" data-explayouts-sort-target="explayouts-layout-cards">
        <label class="a4-label" for="layout-sorting-sort">{'Sort by'|i18n( 'design/admin/explayouts_ui/layout_list' )}</label>
        <select id="layout-sorting-sort" class="a4-input is-auto">
            <option value="name">{'Name'|i18n( 'design/admin/explayouts_ui/layout_list' )}</option>
            <option value="description">{'Description'|i18n( 'design/admin/explayouts_ui/layout_list' )}</option>
            <option value="modified">{'Last modified'|i18n( 'design/admin/explayouts_ui/layout_list' )}</option>
            <option value="type">{'Layout type'|i18n( 'design/admin/explayouts_ui/layout_list' )}</option>
            <option value="mappings">{'Mappings'|i18n( 'design/admin/explayouts_ui/layout_list' )}</option>
        </select>
        <label class="a4-sr-only" for="layout-sorting-direction">{'Order'|i18n( 'design/admin/explayouts_ui/layout_list' )}</label>
        <select id="layout-sorting-direction" class="a4-input is-auto">
            <option value="asc">{'Ascending'|i18n( 'design/admin/explayouts_ui/layout_list' )}</option>
            <option value="desc">{'Descending'|i18n( 'design/admin/explayouts_ui/layout_list' )}</option>
        </select>
    </div>
    <div class="a4-actions">
        <a class="a4-btn a4-btn-primary" href={'explayouts_ui_api/app#layout'|ezurl}>{'New layout'|i18n( 'design/admin/explayouts_ui/layout_list' )}</a>
    </div>
</div>

{if count( $layouts )}
<ul class="a4-cards explayouts-a4-layouts" id="explayouts-layout-cards">
{foreach $layouts as $layout}
    {def $mappings = first_set( $mappings_count[$layout.id], 0 )}
    <li class="a4-card explayouts-a4-layout" data-name="{$layout.name|wash}" data-description="{$layout.identifier|wash}" data-modified="{$layout.modified}" data-type="{$layout.layout_type|wash}" data-mappings="{$mappings}">
        <span class="explayouts-a4-type-icon" aria-hidden="true">{$layout_type_icons[$layout.layout_type]}</span>
        <div class="a4-card-body">
            <div class="a4-card-title">
                <h2 class="a4-h3"><a href={concat( 'explayouts_ui_api/app#layout/', $layout.id )|ezurl}>{$layout.name|wash}</a></h2>
                {if ne( $layout.status, 2 )}<span class="a4-badge is-warn">{'Draft'|i18n( 'design/admin/explayouts_ui/layout_list' )}</span>{/if}
            </div>
            <p class="a4-meta"><code class="a4-code">{$layout.identifier|wash}</code> &middot; <span class="a4-tag">{$layout.layout_type|wash}</span> &middot; {$layout.modified|datetime( 'custom', '%Y-%m-%d %H:%i' )} &middot; {'%count mappings'|i18n( 'design/admin/explayouts_ui/layout_list',, hash( '%count', $mappings ) )}</p>
        </div>
        <div class="a4-actions">
            <a class="a4-btn a4-btn-small" href={concat( 'explayouts_ui_api/app#layout/', $layout.id )|ezurl}>{'Open'|i18n( 'design/admin/explayouts_ui/dashboard' )}</a>
            <a class="a4-btn a4-btn-small a4-btn-ghost" href={concat( 'explayouts_ui/layout_preview/', $layout.id, '/', $layout.status )|ezurl} target="_blank">{'Preview'|i18n( 'design/admin/explayouts_ui/layout_list' )}</a>
            <form method="post" action={'explayouts_ui/layout_list'|ezurl} class="explayouts-a4-inline-form" data-explayouts-confirm="{'Delete this layout and all its zones/blocks?'|i18n( 'design/admin/explayouts_ui/layout_list' )|wash}">
                <input type="hidden" name="DeleteLayoutID" value="{$layout.id|wash}" />
                <button type="submit" name="DeleteLayout" class="a4-btn a4-btn-small a4-btn-outline-danger">{'Delete'|i18n( 'design/admin/explayouts_ui/layout_list' )}</button>
            </form>
        </div>
    </li>
    {undef $mappings}
{/foreach}
</ul>
{else}
<p class="a4-empty">{'There are no layouts defined'|i18n( 'design/admin/explayouts_ui/layout_list' )}</p>
{/if}

{if $page_count|gt( $limit )}
<div class="a4-listfoot">
{include name=LayoutNavigator
         uri='design:navigator/google.tpl'
         page_uri='/explayouts_ui/layout_list'
         item_count=$page_count
         view_parameters=$view_parameters
         item_limit=$limit}
</div>
{/if}

</div></div></div>
</div>
