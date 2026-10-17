{ezcss_require(array('netgen/layouts-admin.css','netgen/layouts-exponential.css','explayouts-ui.css','explayouts_ui_admin.css'))}
<div class="ng-layouts-app row explui-page-components">
    <div class="layouts-content components-content">
        <div class="layouts-header">
            <h2 class="layouts-title">{'Components'|i18n( 'design/admin/explayouts_ui/components' )}</h2>
        </div>

        <form method="get" class="layouts-form nl-components-filter-form">
            <div class="filter">
                <h3 class="row-title">{'Filter'|i18n( 'design/admin/explayouts_ui/components' )}</h3>
                <div class="row-input">
                    <div>
                        <label for="component_filter_contentType">{'Content type'|i18n( 'design/admin/explayouts_ui/components' )}</label>
                        <select id="component_filter_contentType" name="component_filter[contentType]">
                            <option value="" {if eq($filter_content_type, '')}selected="selected"{/if}>{'All content types'|i18n( 'design/admin/explayouts_ui/components' )}</option>
                            {foreach $component_classes as $identifier => $class}
                                <option value="{$identifier|wash}" {if eq($filter_content_type, $identifier)}selected="selected"{/if}>{$class.name|wash}</option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="checkbox">
                        <input type="checkbox" id="component_filter_showOnlyUnused" name="component_filter[showOnlyUnused]" value="1" {if $filter_show_only_unused}checked="checked"{/if} />
                        <label for="component_filter_showOnlyUnused">{'Show only unused'|i18n( 'design/admin/explayouts_ui/components' )}</label>
                    </div>
                </div>
            </div>

            <div class="sort">
                <h3 class="row-title">{'Sort'|i18n( 'design/admin/explayouts_ui/components' )}</h3>
                <div class="row-input">
                    <div>
                        <label for="component_filter_sortType">{'Sort type'|i18n( 'design/admin/explayouts_ui/components' )}</label>
                        <select id="component_filter_sortType" name="component_filter[sortType]">
                            <option value="name" {if eq($sort_type, 'name')}selected="selected"{/if}>{'Name'|i18n( 'design/admin/explayouts_ui/components' )}</option>
                            <option value="last_modified" {if eq($sort_type, 'last_modified')}selected="selected"{/if}>{'Last modified'|i18n( 'design/admin/explayouts_ui/components' )}</option>
                        </select>
                    </div>
                    <div>
                        <label for="component_filter_sortDirection">{'Sort direction'|i18n( 'design/admin/explayouts_ui/components' )}</label>
                        <select id="component_filter_sortDirection" name="component_filter[sortDirection]">
                            <option value="ascending" {if eq($sort_direction, 'ascending')}selected="selected"{/if}>{'Ascending'|i18n( 'design/admin/explayouts_ui/components' )}</option>
                            <option value="descending" {if eq($sort_direction, 'descending')}selected="selected"{/if}>{'Descending'|i18n( 'design/admin/explayouts_ui/components' )}</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="nl-btn nl-btn-primary">{'Submit'|i18n( 'design/admin/explayouts_ui/components' )}</button>
            </div>
        </form>

        <div class="nl-components">
            {if $components|count}
                <ul class="nl-components-list">
                    <li class="nl-component nl-component-header">
                        <div class="nl-component__name">{'Name'|i18n( 'design/admin/explayouts_ui/components' )}</div>
                        <div class="nl-component__content-type">{'Content type'|i18n( 'design/admin/explayouts_ui/components' )}</div>
                        <div class="nl-component__last-modified">{'Last modified'|i18n( 'design/admin/explayouts_ui/components' )}</div>
                        <div class="nl-component__usage-count">{'Count'|i18n( 'design/admin/explayouts_ui/components' )}</div>
                        <div class="nl-component__used-in">{'Used in'|i18n( 'design/admin/explayouts_ui/components' )}</div>
                        <div class="nl-component__actions">{'Edit'|i18n( 'design/admin/explayouts_ui/components' )}</div>
                    </li>
                    {foreach $components as $component}
                        <li class="nl-component">
                            <div class="nl-component__name" data-cell-title="{'Name'|i18n( 'design/admin/explayouts_ui/components' )}">
                                <a href={concat( $component.view_url )|ezurl}>{$component.name|wash}</a>
                            </div>
                            <div class="nl-component__content-type" data-cell-title="{'Content type'|i18n( 'design/admin/explayouts_ui/components' )}">{$component.class_name|wash}</div>
                            <div class="nl-component__last-modified" data-cell-title="{'Last modified'|i18n( 'design/admin/explayouts_ui/components' )}">{$component.modified|datetime( 'custom', '%M %d, %Y, %h:%i:%s %A' )}</div>
                            <div class="nl-component__usage-count" data-cell-title="{'Count'|i18n( 'design/admin/explayouts_ui/components' )}">{$component.count}</div>
                            <div class="nl-component__used-in" data-cell-title="{'Used in'|i18n( 'design/admin/explayouts_ui/components' )}">
                                {if $component.usages|count}
                                    {foreach $component.usages as $usage}
                                        <div class="used-in-item">
                                            <span class="used-in-item-name"><a href={concat('explayouts_ui_api/app#layout/', $usage.layout_id)|ezurl} target="_blank">{$usage.layout_name|wash}</a></span>
                                            <span class="used-in-item-style">{$usage.style_name|wash}</span>
                                        </div>
                                    {/foreach}
                                {else}
                                    <span class="used-in-item-style">{'Not used'|i18n( 'design/admin/explayouts_ui/components' )}</span>
                                {/if}
                            </div>
                            <div class="nl-component__actions" data-cell-title="{'Edit'|i18n( 'design/admin/explayouts_ui/components' )}">
                                <a href={concat( $component.edit_url )|ezurl} title="{'Edit \'%name\''|i18n( 'design/admin/explayouts_ui/components',, hash( '%name', $component.name|wash ) )}"><img src={'edit.gif'|ezimage} width="16" height="16" alt="{'Edit'|i18n( 'design/admin/explayouts_ui/components' )}" /></a>
                            </div>
                        </li>
                    {/foreach}
                </ul>

{* Paged. The size is admininterface.ini [PaginationSettings], keyed by this
   view, and the extension ships its own defaults for these four. *}
{if $page_count|gt( $limit )}
<div class="context-toolbar">
{include name=ComponentNavigator
         uri='design:navigator/google.tpl'
         page_uri='/explayouts_ui/components'
         item_count=$page_count
         view_parameters=$view_parameters
         item_limit=$limit}
</div>
{/if}

            {else}
                <p class="nl-no-items">{'There are no components matching the selected filters.'|i18n( 'design/admin/explayouts_ui/components' )}</p>
            {/if}
        </div>
    </div>
</div>
