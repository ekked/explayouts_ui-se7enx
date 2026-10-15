{ezcss_require(array('netgen/layouts-admin.css','netgen/layouts-exponential.css','explayouts-ui.css'))}
{literal}<style>
#rules { visibility: visible !important; }
#rules .message-feedback,
#rules .message-error { margin: 14px 18px; }
#rules .rule-layout .icon-rule,
#rules .rule-layout .icon-rule-disabled { font-family: 'Material Icons' !important; }
#rules .nl-rule-body .nl-rule-setting h4 { margin: 0 0 6px; font-size: 15px; }
#rules .nl-rule-body .nl-rule-setting .note { font-size: 12px; color: #777; margin: 0 0 10px; }

#rules .nl-rule-body-overlay { position: fixed; top: 0; right: 0; bottom: 0; left: 0; width: 100%; background: rgba(0,0,0,.5); z-index: 100000; }
#rules .nl-rule-body { position: absolute; top: 0; right: 0; left: auto; width: 100%; max-width: 560px; height: 100%; background: #fff; box-shadow: -2px 0 8px rgba(0,0,0,.2); display: flex; flex-direction: column; overflow: hidden; padding: 0 18px; box-sizing: border-box; }
#rules .nl-rule-body form { display: flex; flex-direction: column; flex: 1 1 auto; min-height: 0; width: 100%; background: #fff; margin: 0; padding: 0; }
#rules .nl-rule-body form > .nl-grid { display: flex; flex-direction: column; flex-wrap: nowrap; flex: 1 1 auto; min-height: 0; }
#rules .nl-rule-body form > .nl-grid > .col-xs12 { flex: 0 0 auto; min-height: 0; }
#rules .nl-rule-body form > .nl-grid > .nl-rule-body-rules { flex: 1 1 auto; overflow-y: auto; min-height: 0; }
#rules .nl-rule-body .sidebar-title { flex: 0 0 auto; background: #fff; z-index: 10; padding: 16px 0; margin: 0; border-bottom: 1px solid #e8e8e8; }
#rules .nl-rule-body .sidebar-title h1 { margin: 0; font-size: 24px; }
#rules .nl-rule-body .sidebar-title .nl-rule-actions { display: flex; align-items: center; gap: 8px; }
#rules .nl-rule-body .sidebar-title .js-toggle-body { margin-left: auto; }

#rules .rule-layout-info { display: flex; align-items: center; gap: 12px; margin: 8px 0 12px; }
#rules .rule-layout-info-icon { flex: 0 0 48px; width: 48px; height: 48px; background: #f5f5f5; border-radius: 4px; display: flex; align-items: center; justify-content: center; overflow: hidden; }
#rules .rule-layout-info-icon .layout-icon { display: inline-block; width: 40px; height: 40px; background-size: contain; background-repeat: no-repeat; background-position: center; }
#rules .rule-layout-info-text p { margin: 0; font-size: 14px; }
#rules .rule-layout-info-text p strong { font-weight: 500; }
#rules .nl-layout-options a { font-size: 14px; color: #2196F3; text-decoration: none; }
#rules .nl-layout-options a:hover { text-decoration: underline; }

#rules .nl-rule-body .settings-list { list-style: none; margin: 0; padding: 0; }
#rules .nl-rule-body .settings-list li { display: flex; align-items: center; gap: 12px; padding: 8px 0; border-bottom: 1px solid #e8e8e8; }
#rules .nl-rule-body .settings-list li:last-child { border-bottom: none; }
#rules .nl-rule-body .settings-list .settings-value { flex: 1 1 auto; font-size: 14px; color: #333; position: relative; padding-right: 24px; }
#rules .nl-rule-body .settings-list .settings-value strong { font-weight: 500; }
#rules .nl-rule-body .settings-list .settings-value.editable-value:after { content: 'edit'; font-family: 'Material Icons'; font-size: 18px; color: #999; position: absolute; right: 0; top: 50%; transform: translateY(-50%); }
#rules .nl-rule-body .settings-list .settings-value input[type="text"] { width: auto; min-width: 160px; padding: 4px 6px; border: none; border-bottom: 1px solid transparent; background: transparent; font-size: 14px; margin-left: 4px; }
#rules .nl-rule-body .settings-list .settings-value input[type="text"]:hover { border-bottom-color: #ddd; }
#rules .nl-rule-body .settings-list .settings-value input[type="text"]:focus { border-bottom-color: #2196F3; background: #fff; outline: none; }
#rules .nl-rule-body .settings-list select { min-width: 140px; padding: 6px; border: 1px solid #ddd; border-radius: 2px; font-size: 14px; }
#rules .nl-rule-body .settings-list .remove-setting { flex: 0 0 auto; color: #d32f2f; font-size: 13px; text-decoration: none; }
#rules .nl-rule-body .settings-list .remove-setting:hover { text-decoration: underline; }
#rules .nl-rule-body .settings-list .js-view-target { font-size: 13px; color: #2196F3; text-decoration: none; }
#rules .nl-rule-body .settings-list .js-view-target:hover { text-decoration: underline; }

#rules .nl-rule-body .condition-items { list-style: none; margin: 0; padding: 0; display: flex; flex-wrap: wrap; gap: 6px; }
#rules .nl-rule-body .condition-items li { display: inline-flex; align-items: center; padding: 4px 10px; background: #f0f0f0; border-radius: 12px; font-size: 13px; color: #333; border: 1px solid #e0e0e0; }

#rules .nl-rule-body .settings-list .settings-value.editable-value { cursor: pointer; }
#rules .nl-rule-body .settings-list li.editing .condition-items { display: none; }
#rules .nl-rule-body .settings-list .condition-edit-controls { display: none; }
#rules .nl-rule-body .settings-list li.editing .condition-edit-controls { display: inline; }
#rules .nl-rule-body .settings-list .condition-edit-select { min-width: 240px; padding: 4px; border: 1px solid #ddd; border-radius: 2px; min-height: 80px; }

#rules .nl-rule-body .settings-action { margin-top: 8px; }
#rules .nl-rule-body .settings-action-add { display: flex; align-items: center; gap: 8px; }
#rules .nl-rule-body .settings-action-add .nl-select { min-width: 160px; padding: 6px; border: 1px solid #ddd; border-radius: 2px; }
#rules .nl-rule-body .settings-action-add .nl-btn-link { display: inline-flex; align-items: center; gap: 4px; color: #2196F3; text-decoration: none; font-size: 14px; }
#rules .nl-rule-body .settings-action-add .nl-btn-link:hover { text-decoration: underline; }

#rules .nl-dropdown-menu form { margin: 0; }
#rules .nl-dropdown-menu button { background: none; border: none; width: 100%; text-align: left; padding: 8px 16px; cursor: pointer; font: inherit; color: inherit; }
#rules .nl-dropdown-menu button:disabled { opacity: .5; cursor: not-allowed; }
#rules .nl-dropdown-menu a, #rules .nl-dropdown-menu button { display: block; width: 100%; box-sizing: border-box; }
</style>{/literal}

<div class="ng-layouts-app">
    <div class="layouts-content">
        <div id="rules" class="nl-element">
        <div class="layouts-header">
            <h2 class="layouts-title">{'Layout mappings'|i18n( 'design/admin/explayouts_ui/rule_list' )}</h2>
            <div class="layouts-controls">
                {if $canEdit}
                    <button type="button" class="nl-btn nl-btn-primary js-add-rule">
                        <i class="material-icons">add</i> {'New mapping'|i18n( 'design/admin/explayouts_ui/rule_list' )}
                    </button>
                {/if}
            </div>
        </div>

        {if $message}<div class="message-feedback">{$message|wash}</div>{/if}
        {if $error}<div class="message-error">{$error|wash}</div>{/if}

        <div class="nl-rules-head">
            <div class="nl-rules-head-wrapper">
                <div class="nl-rule-cell"><div class="nl-export-checkbox"><input type="checkbox" id="toggleSelectAll"><label for="toggleSelectAll"></label></div></div>
                <div class="nl-rule-cell rule-priority"></div>
                <div class="nl-rule-cell rule-layout">{'Mapped layout'|i18n( 'design/admin/explayouts_ui/rule_list' )}</div>
                <div class="nl-rule-cell rule-targets">{'Targets'|i18n( 'design/admin/explayouts_ui/rule_list' )}</div>
                <div class="nl-rule-cell rule-conditions">{'Conditions'|i18n( 'design/admin/explayouts_ui/rule_list' )}</div>
            </div>
        </div>

        <div class="nl-rules">
            {if count($ruleData)|eq(0)}
                <p class="nl-no-items">{'There are no rules defined'|i18n( 'design/admin/explayouts_ui/rule_list' )}</p>
            {else}
                {foreach $ruleData as $item}
                    {def $rule = $item.rule}
                    {def $layout = $item.layout}
                    {def $layoutType = $item.layout_type}
                    {def $targets = $item.targets}
                    {def $conditions = $item.conditions}

                    {def $targetType = ''}
                    {if count($targets)|gt(0)}
                        {set $targetType = $targets[0].target_type}
                    {/if}
                    {if eq($targetType,'')}{set $targetType = 'null'}{/if}

                    {def $conditionType = ''}
                    {if count($conditions)|gt(0)}
                        {set $conditionType = $conditions[0].condition_type}
                    {/if}

                    <div class="nl-rule nl-element" id="rule-{$rule.id|wash}" tabindex="0" data-rule-id="{$rule.id|wash}">
                        <div class="nl-rule-content {if not($rule.enabled)}disabled{/if}"
                             data-id="{$rule.id|wash}"
                             data-target-type="{$targetType|wash}"
                             data-layout-id="{$rule.layout_id|wash}"
                             data-enabled="{$rule.enabled|wash}">

                            <div class="nl-rule-head">
                                <div class="nl-rule-cell">
                                    <div class="nl-export-checkbox">
                                        <input type="checkbox" id="export{$rule.id|wash}" {if not($rule.enabled)}disabled="disabled"{/if}>
                                        <label for="export{$rule.id|wash}"></label>
                                    </div>
                                </div>

                                <div class="nl-rule-cell rule-layout">
                                    <div class="rule-priority"><span class="rule-priority-nr">{$rule.priority|sum(1)}</span></div>
                                    <i class="material-icons icon-rule">widgets</i>
                                    <i class="material-icons icon-rule-disabled">error</i>

                                    {if $layout}
                                        <p>{$layout.name|wash}</p>
                                    {else}
                                        <div class="no-layout" title="{'No mapped layout'|i18n( 'design/admin/explayouts_ui/rule_list' )}"><span>{'No mapped layout'|i18n( 'design/admin/explayouts_ui/rule_list' )}</span></div>
                                    {/if}
                                </div>

                                {def $ruleTargetTypeLabel = cond(eq($targetType,'node'),'Location'|i18n( 'design/admin/explayouts_ui/rule_list' ),cond(eq($targetType,'subtree'),'Subtree'|i18n( 'design/admin/explayouts_ui/rule_list' ),cond(eq($targetType,'path'),'Path'|i18n( 'design/admin/explayouts_ui/rule_list' ),cond(eq($targetType,'path_prefix'),'Path prefix'|i18n( 'design/admin/explayouts_ui/rule_list' ),cond(eq($targetType,'path_regex'),'Path regex'|i18n( 'design/admin/explayouts_ui/rule_list' ),cond(eq($targetType,'route'),'Route'|i18n( 'design/admin/explayouts_ui/rule_list' ),cond(eq($targetType,'null'),'All'|i18n( 'design/admin/explayouts_ui/rule_list' ),$targetType)))))))}
                                <div class="nl-rule-cell rule-targets">
                                    {if count($targets)|gt(0)}
                                        {if eq($targetType,'null')}
                                            <p>{'All'|i18n( 'design/admin/explayouts_ui/rule_list' )}</p>
                                        {elseif count($targets)|eq(1)}
                                            {def $ruleTargetValue = $targets[0].displayValue}
                                            <p>{$ruleTargetTypeLabel|wash}:</p>
                                            <ul><li>{$ruleTargetValue|wash}</li></ul>
                                            {undef $ruleTargetValue}
                                        {else}
                                            <p>{$ruleTargetTypeLabel|wash} ({count($targets)|wash})</p>
                                        {/if}
                                    {/if}
                                </div>

                                <div class="nl-rule-cell rule-conditions">
                                    {if count($conditions)|gt(0)}
                                        <ul class="{if count($conditions)|eq(2)}nl-ellipsis{elseif count($conditions)|gt(2)}nl-inline{/if}">
                                            {foreach $conditions as $c}
                                                {def $rowConditionDisplayType = cond(eq($c.condition_type,'content_type'),'class',cond(eq($c.condition_type,'siteaccess'),'siteaccess',$c.condition_type))}
                                                {def $rowConditionLabel = cond(eq($rowConditionDisplayType,'class'),'Class'|i18n( 'design/admin/explayouts_ui/rule_list' ),cond(eq($rowConditionDisplayType,'siteaccess'),'Siteaccess'|i18n( 'design/admin/explayouts_ui/rule_list' ),cond(eq($rowConditionDisplayType,'query_parameter'),'Query parameter'|i18n( 'design/admin/explayouts_ui/rule_list' ),cond(eq($rowConditionDisplayType,'route_parameter'),'Route parameter'|i18n( 'design/admin/explayouts_ui/rule_list' ),cond(eq($rowConditionDisplayType,'time'),'Time'|i18n( 'design/admin/explayouts_ui/rule_list' ),$rowConditionDisplayType)))))}
                                                {def $rowConditionValue = $c.displayValue}
                                                <li>{if count($conditions)|lt(3)}{$rowConditionLabel|wash}: {/if}{$rowConditionValue|wash}</li>
                                                {undef $rowConditionDisplayType}
                                                {undef $rowConditionLabel}
                                                {undef $rowConditionValue}
                                            {/foreach}
                                        </ul>
                                    {/if}
                                </div>

                                <div class="hover-actions">
                                    {if $layout}
                                        <div class="nl-rule-cell rule-edit-layout rule-padded-left">
                                            <a href={concat('explayouts_ui_api/app#layout/',$rule.layout_id)|ezurl} class="js-open-ngl">{'Edit layout'|i18n( 'design/admin/explayouts_ui/rule_list' )}</a>
                                        </div>
                                    {/if}

                                    {if $canEdit}
                                        <div class="nl-rule-cell rule-link-layout {if not($layout)}rule-padded-left{/if}">
                                            <a class="js-link-layout" href="#">{if $layout}{'Link other layout'|i18n( 'design/admin/explayouts_ui/rule_list' )}{else}{'Link layout'|i18n( 'design/admin/explayouts_ui/rule_list' )}{/if}</a>
                                        </div>
                                    {/if}

                                    <div class="nl-rule-cell rule-details">
                                        <a href="#" class="js-toggle-body">{'Details'|i18n( 'design/admin/explayouts_ui/rule_list' )}</a>
                                    </div>

                                    <div class="nl-dropdown" data-position="right">
                                        <button class="nl-btn nl-dropdown-toggle"><i class="material-icons">more_horiz</i></button>
                                        <ul class="nl-dropdown-menu">
                                                    {if $canEdit}
                                                <li><a href="#" class="js-toggle-body">{'Edit description'|i18n( 'design/admin/explayouts_ui/rule_list' )}</a></li>
                                                <li>
                                                    <form method="post" action={'explayouts_ui/rule_list'|ezurl}>
                                                        <input type="hidden" name="CopyRuleID" value="{$rule.id|wash}" />
                                                        <button type="submit" name="CopyRule" class="js-rule-copy-rule">{'Duplicate mapping'|i18n( 'design/admin/explayouts_ui/rule_list' )}</button>
                                                    </form>
                                                </li>
                                            {/if}

                                            {if $canEdit}
                                                <li>
                                                    <form method="post" action={'explayouts_ui/rule_list'|ezurl}>
                                                        <input type="hidden" name="RuleID" value="{$rule.id|wash}" />
                                                        <button type="submit" name="EnableRule" class="js-rule-edit" data-action="enable" {if $rule.enabled}disabled="disabled"{/if}>{'Enable mapping'|i18n( 'design/admin/explayouts_ui/rule_list' )}</button>
                                                    </form>
                                                </li>
                                                <li>
                                                    <form method="post" action={'explayouts_ui/rule_list'|ezurl}>
                                                        <input type="hidden" name="RuleID" value="{$rule.id|wash}" />
                                                        <button type="submit" name="DisableRule" class="js-rule-edit" data-action="disable" {if not($rule.enabled)}disabled="disabled"{/if}>{'Deactivate mapping'|i18n( 'design/admin/explayouts_ui/rule_list' )}</button>
                                                    </form>
                                                </li>
                                            {/if}

                                            {if $canEdit}
                                                <li>
                                                    <form method="post" action={'explayouts_ui/rule_list'|ezurl} onsubmit="return confirm('{'Delete this mapping?'|i18n( 'design/admin/explayouts_ui/rule_list' )|wash( javascript )}');">
                                                        <input type="hidden" name="DeleteRuleID" value="{$rule.id|wash}" />
                                                        <button type="submit" name="DeleteRule" class="js-rule-delete">{'Delete mapping'|i18n( 'design/admin/explayouts_ui/rule_list' )}</button>
                                                    </form>
                                                </li>
                                            {/if}

                                            {if and( $canEdit, $layout )}
                                                <li>
                                                    <form method="post" action={'explayouts_ui/rule_list'|ezurl}>
                                                        <input type="hidden" name="RuleID" value="{$rule.id|wash}" />
                                                        <button type="submit" name="UnlinkRule" class="js-rule-unlink">{'Unlink layout'|i18n( 'design/admin/explayouts_ui/rule_list' )}</button>
                                                    </form>
                                                </li>
                                                <li>
                                                    <form method="post" action={'explayouts_ui/rule_list'|ezurl}>
                                                        <input type="hidden" name="RuleID" value="{$rule.id|wash}" />
                                                        <button type="submit" name="ClearLayoutCache" class="js-layout-clear-cache">{'Clear layout cache'|i18n( 'design/admin/explayouts_ui/rule_list' )}</button>
                                                    </form>
                                                </li>
                                            {/if}
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>

                        {include uri='design:explayouts_ui/rule_detail.tpl'
                            rule=$rule
                            ruleId=$rule.id
                            layout=$layout
                            layoutType=$layoutType
                            targetType=$targetType
                            conditionType=$conditionType
                            targets=$targets
                            conditions=$conditions
                            canEdit=$canEdit
                            layouts=$layouts
                            targetTypes=$targetTypes
                            conditionTypes=$conditionTypes}
                    </div>

                    {undef $rule}
                    {undef $layout}
                    {undef $layoutType}
                    {undef $targets}
                    {undef $conditions}
                    {undef $targetType}
                    {undef $conditionType}
                {/foreach}

{* Paged. The size is admininterface.ini [PaginationSettings], keyed by this
   view, and the extension ships its own defaults for these four. *}
{if $page_count|gt( $limit )}
<div class="context-toolbar">
{include name=RuleNavigator
         uri='design:navigator/google.tpl'
         page_uri='/explayouts_ui/rule_list'
         item_count=$page_count
         view_parameters=$view_parameters
         item_limit=$limit}
</div>
{/if}


                <div class="nl-rule nl-element" id="rule-new" data-rule-id="new">
                    {include uri='design:explayouts_ui/rule_detail.tpl'
                        rule=$newRule
                        ruleId='new'
                        targetType=$newRuleTargetType
                        targets=$newRuleTargets
                        conditions=array()
                        canEdit=$canEdit
                        layouts=$layouts
                        targetTypes=$targetTypes
                        conditionTypes=$conditionTypes}
                </div>
            {/if}
        </div>
    </div>
</div>
</div>

{literal}<style>
.nl-toggle-switch { position: relative; display: inline-flex; align-items: center; gap: 8px; cursor: pointer; font-weight: 500; }
.nl-toggle-input { opacity: 0; width: 0; height: 0; position: absolute; }
.nl-toggle-slider { position: relative; display: inline-block; width: 44px; height: 24px; background: #ccc; border-radius: 24px; transition: background .2s; }
.nl-toggle-slider:before { content: ""; position: absolute; height: 18px; width: 18px; left: 3px; bottom: 3px; background: white; border-radius: 50%; transition: transform .2s; }
.nl-toggle-input:checked + .nl-toggle-slider { background: #2196F3; }
.nl-toggle-input:checked + .nl-toggle-slider:before { transform: translateX(20px); }
.nl-toggle-input:focus + .nl-toggle-slider { box-shadow: 0 0 0 2px rgba(33,150,243,.4); }
</style>{/literal}

{include uri='design:explayouts_ui/parts/rule_list_script.tpl' targetTypes=$targetTypes conditionTypes=$conditionTypes contentClassesJson=$contentClassesJson siteAccessListJson=$siteAccessListJson autoOpenNewRule=$autoOpenNewRule autoOpenRuleId=$autoOpenRuleId}
