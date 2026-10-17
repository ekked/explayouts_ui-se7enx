{ezcss_require(array('netgen/layouts-admin.css','netgen/layouts-exponential.css','explayouts-ui.css','explayouts_ui_admin.css'))}
{* layouts-admin.js is not loaded: its content browser stops at once without Netgen's page tags, so none of it ever ran here, and these pages have their own scripts. *}
{ezscript_load(array('netgen/layouts-exponential.js'))}
<div class="ng-layouts-app row explui-page-layouts">
    <div class="layouts-content">
        <div id="layouts" class="nl-layouts-view-grid explui-show">
            <div class="layouts-header">
                <h2 class="layouts-title">{'Layouts'|i18n( 'design/admin/explayouts_ui/layout_list' )}</h2>
                <div class="layouts-controls">
                    <a href="#" class="nl-btn js-export explui-hidden">{'Export'|i18n( 'design/admin/explayouts_ui/layout_list' )}</a>
                    <a href="#" class="nl-btn js-change-layouts-view explui-hidden"></a>
                    <div class="layout-sorting-controls">
                        <label for="layout-sorting-sort"><i class="material-icons" aria-hidden="true">sort_by_alpha</i><span class="a4-sr-only">{'Sort by'|i18n( 'design/admin/explayouts_ui/layout_list' )}</span></label>
                        <select id="layout-sorting-sort" class="nl-select">
                            <option value="name">{'Name'|i18n( 'design/admin/explayouts_ui/layout_list' )}</option>
                            <option value="description">{'Description'|i18n( 'design/admin/explayouts_ui/layout_list' )}</option>
                            <option value="modified">{'Last modified'|i18n( 'design/admin/explayouts_ui/layout_list' )}</option>
                            <option value="type">{'Layout type'|i18n( 'design/admin/explayouts_ui/layout_list' )}</option>
                            <option value="mappings">{'Mappings'|i18n( 'design/admin/explayouts_ui/layout_list' )}</option>
                        </select>
                        <label for="layout-sorting-direction" class="a4-sr-only">{'Sort direction'|i18n( 'design/admin/explayouts_ui/layout_list' )}</label>
                        <select id="layout-sorting-direction" class="nl-select">
                            <option value="asc">{'Ascending'|i18n( 'design/admin/explayouts_ui/layout_list' )}</option>
                            <option value="desc">{'Descending'|i18n( 'design/admin/explayouts_ui/layout_list' )}</option>
                        </select>
                    </div>
                    <a href={concat('explayouts_ui_api/app#layout')|ezurl} id="add-new-button" class="nl-btn nl-btn-primary js-open-ngl">
                        <i class="material-icons">add</i> {'New layout'|i18n( 'design/admin/explayouts_ui/layout_list' )}
                    </a>
                </div>
            </div>

            <div class="nl-layouts-head explui-hidden">
                <div class="nl-layout-info">
                    <div class="nl-layout-type"><a class="js-reorder-layouts" data-sorting="type">{'Layout type'|i18n( 'design/admin/explayouts_ui/layout_list' )}<i class="sort-icon"></i></a></div>
                    <div class="nl-layout-text">
                        <div class="nl-layout-name"><div class="nl-export-checkbox"><input type="checkbox" id="toggleSelectAll"><label for="toggleSelectAll"><span class="a4-sr-only">{'Select all layouts for export'|i18n( 'design/admin/explayouts_ui/layout_list' )}</span></label></div><a class="js-reorder-layouts active sorting-asc" data-sorting="name">{'Name'|i18n( 'design/admin/explayouts_ui/layout_list' )}<i class="sort-icon"></i></a></div>
                        <div class="nl-layout-description"><a class="js-reorder-layouts" data-sorting="description">{'Description'|i18n( 'design/admin/explayouts_ui/layout_list' )}<i class="sort-icon"></i></a></div>
                        <div class="nl-layout-modified"><a class="js-reorder-layouts" data-sorting="modified">{'Last modified'|i18n( 'design/admin/explayouts_ui/layout_list' )}<i class="sort-icon"></i></a></div>
                    </div>
                </div>
                <div class="nl-layout-actions">
                    <div class="nl-layout-data"><a class="js-reorder-layouts" data-sorting="mappings">{'Mappings'|i18n( 'design/admin/explayouts_ui/layout_list' )}<i class="sort-icon"></i></a></div>
                </div>
            </div>

            {if $message}<div class="message-feedback">{$message|wash}</div>{/if}
            {if $error}<div class="message-error">{$error|wash}</div>{/if}

            <div class="nl-layouts">
                {foreach $layouts as $layout}
                    <div class="nl-layout" data-name="{$layout.name|wash}" data-identifier="{$layout.identifier|wash}" data-description="{$layout.identifier|wash}" data-modified="{$layout.modified}" data-type="{$layout.layout_type|wash}" data-mappings="{if is_set($mappings_count[$layout.id])}{$mappings_count[$layout.id]}{else}0{/if}">
                        <div class="nl-layout-content">
                            <div class="nl-layout-info">
                                <div class="nl-layout-type">
                                    <p>{$layout.layout_type|wash}</p>
                                    <span class="nl-layout-icon">{$layout_type_icons[$layout.layout_type]}</span>
                                </div>
                                <div class="nl-layout-text">
                                    <div class="nl-layout-name"><a href={concat('explayouts_ui_api/app#layout/',$layout.id)|ezurl}>{$layout.name|wash}</a></div>
                                    <div class="nl-layout-description">{$layout.identifier|wash}</div>
                                    <div class="nl-layout-modified"><p>{$layout.modified|datetime( 'custom', '%Y-%m-%d %H:%i' )}</p></div>
                                    {if ne($layout.status,2)}<span class="unpublished-label">{'Draft'|i18n( 'design/admin/explayouts_ui/layout_list' )}</span>{/if}
                                </div>
                            </div>
                            <div class="nl-layout-actions">
                                <div class="nl-layout-data">
                                    <div class="meta-info">
                                        <i class="material-icons">link</i>
                                        <span>{'%count mappings'|i18n( 'design/admin/explayouts_ui/layout_list',, hash( '%count', first_set( $mappings_count[$layout.id], 0 ) ) )}</span>
                                    </div>
                                </div>
                                <div class="nl-dropdown" data-position="right">
                                    <button class="nl-btn nl-dropdown-toggle" type="button"><i class="material-icons">more_horiz</i></button>
                                    <ul class="nl-dropdown-menu main-dropdown">
                                        <li><a href={concat('explayouts_ui/layout_preview/',$layout.id,'/',$layout.status)|ezurl} target="_blank"><i class="material-icons explui-icon-inline">visibility</i> {'Preview'|i18n( 'design/admin/explayouts_ui/layout_list' )}</a></li>
                                        <li>
                                            <form method="post" action={'explayouts_ui/layout_list'|ezurl} class="explui-inline-form" data-explui-confirm="{'Delete this layout and all its zones/blocks?'|i18n( 'design/admin/explayouts_ui/layout_list' )|wash}">
                                                <input type="hidden" name="DeleteLayoutID" value="{$layout.id|wash}" />
                                                <button type="submit" name="DeleteLayout" class="explui-menu-button">{'Delete'|i18n( 'design/admin/explayouts_ui/layout_list' )}</button>
                                            </form>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                {/foreach}
            </div>

{* Paged. The size is admininterface.ini [PaginationSettings], keyed by this
   view, and the extension ships its own defaults for these four. *}
{if $page_count|gt( $limit )}
<div class="context-toolbar">
{include name=LayoutNavigator
         uri='design:navigator/google.tpl'
         page_uri='/explayouts_ui/layout_list'
         item_count=$page_count
         view_parameters=$view_parameters
         item_limit=$limit}
</div>
{/if}


            {if count($layouts)|eq(0)}
                <p class="nl-no-items explui-show">{'There are no layouts defined'|i18n( 'design/admin/explayouts_ui/layout_list' )}</p>
            {/if}
        </div>
    </div>
</div>
{ezscript( array( 'explayouts_ui_admin.js' ) )}
