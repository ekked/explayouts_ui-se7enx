{* admin4: the components (explayouts_ui/components): filter bar and a table, admin4's components. Same GET
   parameters as design/admin's template. *}
{ezcss_require( 'explayouts_ui_admin4.css' )}
<div class="context-block a4-page explayouts-a4">

<div class="box-header"><div class="box-ml">
<h1 class="context-title">{'Components'|i18n( 'design/admin/explayouts_ui/components' )}</h1>
</div></div>

<div class="box-bc"><div class="box-ml"><div class="box-content">

<form method="get" class="a4-filterbar">
    <div class="a4-field">
        <label class="a4-label" for="component_filter_contentType">{'Content type'|i18n( 'design/admin/explayouts_ui/components' )}</label>
        <select class="a4-input" id="component_filter_contentType" name="component_filter[contentType]">
            <option value=""{if eq( $filter_content_type, '' )} selected="selected"{/if}>{'All content types'|i18n( 'design/admin/explayouts_ui/components' )}</option>
            {foreach $component_classes as $identifier => $class}
            <option value="{$identifier|wash}"{if eq( $filter_content_type, $identifier )} selected="selected"{/if}>{$class.name|wash}</option>
            {/foreach}
        </select>
    </div>
    <div class="a4-field">
        <label class="a4-label" for="component_filter_sortType">{'Sort type'|i18n( 'design/admin/explayouts_ui/components' )}</label>
        <select class="a4-input" id="component_filter_sortType" name="component_filter[sortType]">
            <option value="name"{if eq( $sort_type, 'name' )} selected="selected"{/if}>{'Name'|i18n( 'design/admin/explayouts_ui/components' )}</option>
            <option value="last_modified"{if eq( $sort_type, 'last_modified' )} selected="selected"{/if}>{'Last modified'|i18n( 'design/admin/explayouts_ui/components' )}</option>
        </select>
    </div>
    <div class="a4-field">
        <label class="a4-label" for="component_filter_sortDirection">{'Sort direction'|i18n( 'design/admin/explayouts_ui/components' )}</label>
        <select class="a4-input" id="component_filter_sortDirection" name="component_filter[sortDirection]">
            <option value="ascending"{if eq( $sort_direction, 'ascending' )} selected="selected"{/if}>{'Ascending'|i18n( 'design/admin/explayouts_ui/components' )}</option>
            <option value="descending"{if eq( $sort_direction, 'descending' )} selected="selected"{/if}>{'Descending'|i18n( 'design/admin/explayouts_ui/components' )}</option>
        </select>
    </div>
    <div class="a4-field">
        <label class="a4-check"><input type="checkbox" name="component_filter[showOnlyUnused]" value="1"{if $filter_show_only_unused} checked="checked"{/if} /> {'Show only unused'|i18n( 'design/admin/explayouts_ui/components' )}</label>
        <div class="a4-actions"><button type="submit" class="a4-btn a4-btn-primary">{'Submit'|i18n( 'design/admin/explayouts_ui/components' )}</button></div>
    </div>
</form>

{if $components|count}
<div class="a4-table-wrap">
<table class="a4-table">
    <thead>
        <tr>
            <th scope="col">{'Name'|i18n( 'design/admin/explayouts_ui/components' )}</th>
            <th scope="col">{'Content type'|i18n( 'design/admin/explayouts_ui/components' )}</th>
            <th scope="col">{'Last modified'|i18n( 'design/admin/explayouts_ui/components' )}</th>
            <th scope="col" class="a4-num">{'Count'|i18n( 'design/admin/explayouts_ui/components' )}</th>
            <th scope="col">{'Used in'|i18n( 'design/admin/explayouts_ui/components' )}</th>
            <th scope="col"><span class="a4-sr-only">{'Edit'|i18n( 'design/admin/explayouts_ui/components' )}</span></th>
        </tr>
    </thead>
    <tbody>
    {foreach $components as $component}
        <tr>
            <td><a href={$component.view_url|ezurl}>{$component.name|wash}</a></td>
            <td>{$component.class_name|wash}</td>
            <td class="a4-nowrap">{$component.modified|datetime( 'custom', '%Y-%m-%d %H:%i' )}</td>
            <td class="a4-num">{$component.count}</td>
            <td>
            {if $component.usages|count}
                <ul class="a4-plain">
                {foreach $component.usages as $usage}
                    <li><a href={concat( 'explayouts_ui_api/app#layout/', $usage.layout_id )|ezurl} target="_blank">{$usage.layout_name|wash}</a> <span class="a4-meta">{$usage.style_name|wash}</span></li>
                {/foreach}
                </ul>
            {else}
                <span class="a4-muted">{'Not used'|i18n( 'design/admin/explayouts_ui/components' )}</span>
            {/if}
            </td>
            <td class="a4-end"><a class="a4-btn a4-btn-small" href={$component.edit_url|ezurl}>{'Edit'|i18n( 'design/admin/explayouts_ui/components' )}<span class="a4-sr-only"> {$component.name|wash}</span></a></td>
        </tr>
    {/foreach}
    </tbody>
</table>
</div>
{if $page_count|gt( $limit )}
<div class="a4-listfoot">
{include name=ComponentNavigator
         uri='design:navigator/google.tpl'
         page_uri='/explayouts_ui/components'
         item_count=$page_count
         view_parameters=$view_parameters
         item_limit=$limit}
</div>
{/if}
{else}
<p class="a4-empty">{'There are no components matching the selected filters.'|i18n( 'design/admin/explayouts_ui/components' )}</p>
{/if}

</div></div></div>
</div>
