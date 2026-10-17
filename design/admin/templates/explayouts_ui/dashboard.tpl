{ezcss_require(array('netgen/layouts-admin.css','netgen/layouts-exponential.css','explayouts-ui.css','explayouts_ui_admin.css'))}
{* layouts-admin.js is not loaded: its content browser stops at once without Netgen's page tags, so none of it ever ran here, and these pages have their own scripts. *}
{ezscript_load(array('netgen/layouts-exponential.js'))}


<div class="ng-layouts-app explui-page-dashboard">
    <div class="layouts-content">
        <div class="layouts-header">
            <h2 class="layouts-title">{'Layouts Dashboard'|i18n( 'design/admin/explayouts_ui/dashboard' )}</h2>
            <div class="layouts-controls">
                <a href={concat('explayouts_ui_api/app#layout')|ezurl} class="nl-btn nl-btn-primary">
                    <i class="material-icons">add</i> {'New layout'|i18n( 'design/admin/explayouts_ui/dashboard' )}
                </a>
                <a href={concat('explayouts_ui/layout_list')|ezurl} class="nl-btn">
                    <i class="material-icons">view_list</i> {'Layouts'|i18n( 'design/admin/explayouts_ui/dashboard' )}
                </a>
                <a href={concat('explayouts_ui/rule_list')|ezurl} class="nl-btn">
                    <i class="material-icons">link</i> {'Rules'|i18n( 'design/admin/explayouts_ui/dashboard' )}
                </a>
                <a href={concat('explayouts_ui/template_editor/')|ezurl} class="nl-btn">
                    <i class="material-icons">code</i> {'Template editor'|i18n( 'design/admin/explayouts_ui/dashboard' )}
                </a>
                <a href={concat('explayouts_ui/setup')|ezurl} class="nl-btn">
                    <i class="material-icons">build</i> {'Setup DB'|i18n( 'design/admin/explayouts_ui/dashboard' )}
                </a>
            </div>
        </div>

        <div class="nl-dashboard-stats">
            <div class="nl-stat-card">
                <div class="nl-stat-value">{$counts.layouts|wash}</div>
                <div class="nl-stat-label">{'Layouts'|i18n( 'design/admin/explayouts_ui/dashboard' )}</div>
            </div>
            <div class="nl-stat-card">
                <div class="nl-stat-value">{$counts.zones|wash}</div>
                <div class="nl-stat-label">{'Zones'|i18n( 'design/admin/explayouts_ui/dashboard' )}</div>
            </div>
            <div class="nl-stat-card">
                <div class="nl-stat-value">{$counts.blocks|wash}</div>
                <div class="nl-stat-label">{'Blocks'|i18n( 'design/admin/explayouts_ui/dashboard' )}</div>
            </div>
            <div class="nl-stat-card">
                <div class="nl-stat-value">{$counts.rules|wash}</div>
                <div class="nl-stat-label">{'Rules'|i18n( 'design/admin/explayouts_ui/dashboard' )}</div>
            </div>
            <div class="nl-stat-card">
                <div class="nl-stat-value">{$counts.collections|wash}</div>
                <div class="nl-stat-label">{'Collections'|i18n( 'design/admin/explayouts_ui/dashboard' )}</div>
            </div>
        </div>

        <h3 class="layouts-title explui-recent-title">{'Recent layouts'|i18n( 'design/admin/explayouts_ui/dashboard' )}</h3>

        {if count($recent_layouts)}
            <table class="nl-recent-table" cellspacing="0">
                <thead>
                    <tr>
                        <th>{'Name'|i18n( 'design/admin/explayouts_ui/dashboard' )}</th>
                        <th>{'Identifier'|i18n( 'design/admin/explayouts_ui/dashboard' )}</th>
                        <th>{'Status'|i18n( 'design/admin/explayouts_ui/dashboard' )}</th>
                        <th>{'Modified'|i18n( 'design/admin/explayouts_ui/dashboard' )}</th>
                        <th class="explui-col-action">{'Action'|i18n( 'design/admin/explayouts_ui/dashboard' )}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $recent_layouts as $layout}
                        <tr>
                            <td>{$layout.name|wash}</td>
                            <td>{$layout.identifier|wash}</td>
                            <td>
                                {if eq($layout.status,2)}
                                    <span class="nl-status-label published">{'Published'|i18n( 'design/admin/explayouts_ui/dashboard' )}</span>
                                {else}
                                    <span class="nl-status-label">{'Draft'|i18n( 'design/admin/explayouts_ui/dashboard' )}</span>
                                {/if}
                            </td>
                            <td>{$layout.modified|datetime( 'custom', '%Y-%m-%d %H:%i' )}</td>
                            <td>
                                <a href={concat('explayouts_ui_api/app#layout/',$layout.id)|ezurl} class="nl-btn nl-btn-small">
                                    <i class="material-icons explui-icon-18">open_in_new</i> {'Open'|i18n( 'design/admin/explayouts_ui/dashboard' )}
                                </a>
                            </td>
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        {else}
            <p class="nl-no-items">{'There are no layouts yet'|i18n( 'design/admin/explayouts_ui/dashboard' )}</p>
        {/if}
    </div>
</div>
