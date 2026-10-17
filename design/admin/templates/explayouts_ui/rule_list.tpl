{ezcss_require(array('netgen/layouts-admin.css','netgen/layouts-exponential.css','explayouts-ui.css','explayouts_ui_admin.css'))}

<div class="ng-layouts-app explui-page-rules">
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
                <div class="nl-rule-cell"><div class="nl-export-checkbox"><input type="checkbox" id="toggleSelectAll"><label for="toggleSelectAll"><span class="a4-sr-only">{'Select all mappings for export'|i18n( 'design/admin/explayouts_ui/rule_list' )}</span></label></div></div>
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
                                        <label for="export{$rule.id|wash}"><span class="a4-sr-only">{'Select mapping %id for export'|i18n( 'design/admin/explayouts_ui/rule_list', , hash( '%id', $rule.id ) )|wash}</span></label>
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
                                                    <form method="post" action={'explayouts_ui/rule_list'|ezurl} data-explui-confirm="{'Delete this mapping?'|i18n( 'design/admin/explayouts_ui/rule_list' )|wash}">
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


{include uri='design:explayouts_ui/parts/rule_list_script.tpl' targetTypes=$targetTypes conditionTypes=$conditionTypes contentClassesJson=$contentClassesJson siteAccessListJson=$siteAccessListJson autoOpenNewRule=$autoOpenNewRule autoOpenRuleId=$autoOpenRuleId}
{ezscript( array( 'explayouts_ui_admin.js' ) )}
