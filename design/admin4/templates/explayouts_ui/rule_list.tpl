{* admin4: the layout mappings (explayouts_ui/rule_list) in admin4's page structure and components. One card per
   rule; a disabled rule is muted and says so. The rule panel (rule_detail.tpl) and the page script
   (parts/rule_list_script.tpl, shared with design/admin) keep their class hooks (nl-rule, js-*), so the behaviour
   is the same. Form fields and button names are those the view reads. *}
{ezcss_require( 'explayouts_ui_admin4.css' )}
<div class="context-block a4-page explayouts-a4">

<div class="box-header"><div class="box-ml">
<h1 class="context-title">{'Layout mappings'|i18n( 'design/admin/explayouts_ui/rule_list' )}</h1>
</div></div>

<div class="box-bc"><div class="box-ml"><div class="box-content" id="rules">

<div class="a4-toolbar">
    <p class="a4-meta">{'A mapping links a layout to pages: the first enabled mapping by priority whose targets and conditions match the page wins.'|i18n( 'design/admin/explayouts_ui/rule_list' )}</p>
    {if $canEdit}
    <div class="a4-actions">
        <button type="button" class="a4-btn a4-btn-primary js-add-rule">{'New mapping'|i18n( 'design/admin/explayouts_ui/rule_list' )}</button>
    </div>
    {/if}
</div>

{if $message}<div class="a4-notice is-ok" role="status">{$message|wash}</div>{/if}
{if $error}<div class="a4-notice is-bad" role="alert">{$error|wash}</div>{/if}

{if count( $ruleData )|eq( 0 )}
<p class="a4-empty">{'There are no rules defined'|i18n( 'design/admin/explayouts_ui/rule_list' )}</p>
{else}
<ul class="a4-cards explayouts-a4-rules">
{foreach $ruleData as $item}
    {def $rule = $item.rule
         $layout = $item.layout
         $layoutType = $item.layout_type
         $targets = $item.targets
         $conditions = $item.conditions
         $targetType = cond( count( $item.targets )|gt( 0 ), $item.targets[0].target_type, 'null' )
         $conditionType = cond( count( $item.conditions )|gt( 0 ), $item.conditions[0].condition_type, '' )}
    {if eq( $targetType, '' )}{set $targetType = 'null'}{/if}
    {def $targetLabel = cond( eq( $targetType, 'node' ), 'Location'|i18n( 'design/admin/explayouts_ui/rule_list' ),
                              eq( $targetType, 'subtree' ), 'Subtree'|i18n( 'design/admin/explayouts_ui/rule_list' ),
                              eq( $targetType, 'path' ), 'Path'|i18n( 'design/admin/explayouts_ui/rule_list' ),
                              eq( $targetType, 'path_prefix' ), 'Path prefix'|i18n( 'design/admin/explayouts_ui/rule_list' ),
                              eq( $targetType, 'path_regex' ), 'Path regex'|i18n( 'design/admin/explayouts_ui/rule_list' ),
                              eq( $targetType, 'route' ), 'Route'|i18n( 'design/admin/explayouts_ui/rule_list' ),
                              eq( $targetType, 'null' ), 'All'|i18n( 'design/admin/explayouts_ui/rule_list' ),
                              $targetType )}
    <li class="nl-rule a4-card explayouts-a4-rule{if not( $rule.enabled )} is-disabled{/if}" id="rule-{$rule.id|wash}" data-rule-id="{$rule.id|wash}">
        <div class="nl-rule-content{if not( $rule.enabled )} disabled{/if}" data-id="{$rule.id|wash}" data-target-type="{$targetType|wash}" data-layout-id="{$rule.layout_id|wash}" data-enabled="{$rule.enabled|wash}">
            <div class="a4-card-head">
                <div class="a4-card-title">
                    <span class="a4-badge is-mono" title="{'Priority'|i18n( 'design/admin/explayouts_ui/rule_detail' )}">{$rule.priority|sum( 1 )}</span>
                    <h2 class="a4-h3">{if $layout}{$layout.name|wash}{else}<span class="a4-muted">{'No mapped layout'|i18n( 'design/admin/explayouts_ui/rule_list' )}</span>{/if}</h2>
                    {if $rule.enabled}
                    <span class="a4-badge is-ok">{'Enabled'|i18n( 'design/admin/explayouts_ui/rule_detail' )}</span>
                    {else}
                    <span class="a4-badge is-warn">{'Disabled'|i18n( 'design/admin/explayouts_ui/rule_detail' )}</span>
                    <span class="a4-meta">{'This mapping is not used until it is enabled again.'|i18n( 'design/admin/explayouts_ui/rule_list' )}</span>
                    {/if}
                </div>
            </div>
            <dl class="a4-facts">
                <dt>{'Targets'|i18n( 'design/admin/explayouts_ui/rule_list' )}</dt>
                <dd>
                {if eq( $targetType, 'null' )}{'All'|i18n( 'design/admin/explayouts_ui/rule_list' )}
                {elseif count( $targets )|eq( 1 )}{$targetLabel}: <code class="a4-code">{$targets[0].displayValue|wash}</code>
                {else}{$targetLabel} ({count( $targets )}){/if}
                </dd>
                <dt>{'Conditions'|i18n( 'design/admin/explayouts_ui/rule_list' )}</dt>
                <dd>
                {if count( $conditions )|gt( 0 )}
                    {foreach $conditions as $c}{$c.condition_type|wash}: {$c.displayValue|wash}{delimiter}; {/delimiter}{/foreach}
                {else}<span class="a4-muted">{'None'|i18n( 'design/admin/explayouts_ui/rule_list' )}</span>{/if}
                </dd>
            </dl>
            <div class="a4-actions">
                <a href="#" class="a4-btn a4-btn-small js-toggle-body">{'Details'|i18n( 'design/admin/explayouts_ui/rule_list' )}</a>
                {if $layout}<a class="a4-btn a4-btn-small" href={concat( 'explayouts_ui_api/app#layout/', $rule.layout_id )|ezurl}>{'Edit layout'|i18n( 'design/admin/explayouts_ui/rule_list' )}</a>{/if}
                {if $canEdit}
                <a href="#" class="a4-btn a4-btn-small a4-btn-ghost js-link-layout">{if $layout}{'Link other layout'|i18n( 'design/admin/explayouts_ui/rule_list' )}{else}{'Link layout'|i18n( 'design/admin/explayouts_ui/rule_list' )}{/if}</a>
                <details class="a4-fold explayouts-a4-more">
                    <summary>{'More actions'|i18n( 'design/admin/explayouts_ui/rule_list' )}</summary>
                    <div class="a4-fold-body a4-actions">
                        <form method="post" action={'explayouts_ui/rule_list'|ezurl}>
                            <input type="hidden" name="CopyRuleID" value="{$rule.id|wash}" />
                            <button type="submit" name="CopyRule" class="a4-btn a4-btn-small">{'Duplicate mapping'|i18n( 'design/admin/explayouts_ui/rule_list' )}</button>
                        </form>
                        <form method="post" action={'explayouts_ui/rule_list'|ezurl}>
                            <input type="hidden" name="RuleID" value="{$rule.id|wash}" />
                            {if $rule.enabled}
                            <button type="submit" name="DisableRule" class="a4-btn a4-btn-small">{'Deactivate mapping'|i18n( 'design/admin/explayouts_ui/rule_list' )}</button>
                            {else}
                            <button type="submit" name="EnableRule" class="a4-btn a4-btn-small">{'Enable mapping'|i18n( 'design/admin/explayouts_ui/rule_list' )}</button>
                            {/if}
                        </form>
                        {if $layout}
                        <form method="post" action={'explayouts_ui/rule_list'|ezurl}>
                            <input type="hidden" name="RuleID" value="{$rule.id|wash}" />
                            <button type="submit" name="UnlinkRule" class="a4-btn a4-btn-small">{'Unlink layout'|i18n( 'design/admin/explayouts_ui/rule_list' )}</button>
                        </form>
                        <form method="post" action={'explayouts_ui/rule_list'|ezurl}>
                            <input type="hidden" name="RuleID" value="{$rule.id|wash}" />
                            <button type="submit" name="ClearLayoutCache" class="a4-btn a4-btn-small">{'Clear layout cache'|i18n( 'design/admin/explayouts_ui/rule_list' )}</button>
                        </form>
                        {/if}
                        <form method="post" action={'explayouts_ui/rule_list'|ezurl} data-explayouts-confirm="{'Delete this mapping?'|i18n( 'design/admin/explayouts_ui/rule_list' )|wash}">
                            <input type="hidden" name="DeleteRuleID" value="{$rule.id|wash}" />
                            <button type="submit" name="DeleteRule" class="a4-btn a4-btn-small a4-btn-outline-danger">{'Delete mapping'|i18n( 'design/admin/explayouts_ui/rule_list' )}</button>
                        </form>
                    </div>
                </details>
                {/if}
            </div>
        </div>
        {include uri='design:explayouts_ui/rule_detail.tpl'
                 rule=$rule ruleId=$rule.id layout=$layout layoutType=$layoutType targetType=$targetType
                 conditionType=$conditionType targets=$targets conditions=$conditions canEdit=$canEdit
                 layouts=$layouts targetTypes=$targetTypes conditionTypes=$conditionTypes}
    </li>
    {undef $rule $layout $layoutType $targets $conditions $targetType $conditionType $targetLabel}
{/foreach}
</ul>

{if $page_count|gt( $limit )}
<div class="a4-listfoot">
{include name=RuleNavigator
         uri='design:navigator/google.tpl'
         page_uri='/explayouts_ui/rule_list'
         item_count=$page_count
         view_parameters=$view_parameters
         item_limit=$limit}
</div>
{/if}
{/if}

{* The panel of a new mapping, also when there is no mapping yet (design/admin drew it only next to a list). *}
<div class="nl-rule explayouts-a4-new-rule" id="rule-new" data-rule-id="new">
    {include uri='design:explayouts_ui/rule_detail.tpl'
             rule=$newRule ruleId='new' targetType=$newRuleTargetType targets=$newRuleTargets conditions=array()
             canEdit=$canEdit layouts=$layouts targetTypes=$targetTypes conditionTypes=$conditionTypes}
</div>

</div></div></div>
</div>
{ezscript_require( 'explayouts_ui_admin4.js' )}
{include uri='design:explayouts_ui/parts/rule_list_script.tpl' targetTypes=$targetTypes conditionTypes=$conditionTypes contentClassesJson=$contentClassesJson siteAccessListJson=$siteAccessListJson autoOpenNewRule=$autoOpenNewRule autoOpenRuleId=$autoOpenRuleId}
