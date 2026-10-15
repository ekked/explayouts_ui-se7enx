{* admin4: the shared layouts (explayouts_ui/shared_layouts_list), the layouts other layouts link zones to. *}
{ezcss_require( 'explayouts_ui_admin4.css' )}
<div class="context-block a4-page explayouts-a4">

<div class="box-header"><div class="box-ml">
<h1 class="context-title">{'Shared layouts'|i18n( 'design/admin/explayouts_ui/shared_layouts_list' )}</h1>
</div></div>

<div class="box-bc"><div class="box-ml"><div class="box-content">

<div class="a4-toolbar">
    <p class="a4-meta">{'Layouts whose zones other layouts link to.'|i18n( 'design/admin/explayouts_ui/shared_layouts_list' )}</p>
    <div class="a4-actions">
        <a class="a4-btn a4-btn-primary" href={'explayouts_ui_api/app#layout'|ezurl}>{'New shared layout'|i18n( 'design/admin/explayouts_ui/shared_layouts_list' )}</a>
    </div>
</div>

{if count( $layouts )}
<ul class="a4-cards explayouts-a4-layouts">
{foreach $layouts as $layout}
    <li class="a4-card explayouts-a4-layout">
        <span class="explayouts-a4-type-icon" aria-hidden="true">{$layout_type_icons[$layout.layout_type]}</span>
        <div class="a4-card-body">
            <div class="a4-card-title">
                <h2 class="a4-h3"><a href={concat( 'explayouts_ui_api/app#layout/', $layout.id )|ezurl}>{$layout.name|wash}</a></h2>
                {if ne( $layout.status, 2 )}<span class="a4-badge is-warn">{'Draft'|i18n( 'design/admin/explayouts_ui/shared_layouts_list' )}</span>{/if}
            </div>
            <p class="a4-meta"><code class="a4-code">{$layout.identifier|wash}</code> &middot; <span class="a4-tag">{$layout.layout_type|wash}</span> &middot; {$layout.modified|datetime( 'custom', '%Y-%m-%d %H:%i' )} &middot; {'%count references'|i18n( 'design/admin/explayouts_ui/shared_layouts_list',, hash( '%count', first_set( $shared_counts[$layout.id], 0 ) ) )}</p>
        </div>
        <div class="a4-actions">
            <a class="a4-btn a4-btn-small a4-btn-ghost" href={concat( 'explayouts_ui/layout_preview/', $layout.id, '/', $layout.status )|ezurl} target="_blank">{'Preview'|i18n( 'design/admin/explayouts_ui/shared_layouts_list' )}</a>
        </div>
    </li>
{/foreach}
</ul>
{else}
<p class="a4-empty">{'There are no shared layouts referenced by other layouts yet.'|i18n( 'design/admin/explayouts_ui/shared_layouts_list' )}</p>
{/if}

{if $page_count|gt( $limit )}
<div class="a4-listfoot">
{include name=SharedNavigator
         uri='design:navigator/google.tpl'
         page_uri='/explayouts_ui/shared_layouts_list'
         item_count=$page_count
         view_parameters=$view_parameters
         item_limit=$limit}
</div>
{/if}

</div></div></div>
</div>
