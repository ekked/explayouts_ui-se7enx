{* The script of the mappings page (explayouts_ui/rule_list): its settings and texts as a JSON data block, then the
   behaviour of the rule list and of the rule panels (rule_detail.tpl) from javascript/explayouts_ui_rule_list.js
   (until 1.3.19 inline scripts). One file for every admin design: design/admin's and design/admin4's rule_list.tpl
   include it. The data block is printed from one set-block with < and > as JSON escapes. *}
{set-block variable=$explayouts_ui_rule_list_data}{ldelim}"target_types": {json_encode( $targetTypes )},
"condition_types": {json_encode( $conditionTypes )},
"content_classes": {$contentClassesJson},
"siteaccess_list": {$siteAccessListJson},
"content_browser_url": {json_encode( '/explayouts_content_browser_ui/browser/'|ezurl( 'no' ) )},
"cms_view_base": {json_encode( '/content/view/full/'|ezurl( 'no' ) )},
"auto_open_new_rule": {if $autoOpenNewRule}true{else}false{/if},
"auto_open_rule_id": {json_encode( concat( '', $autoOpenRuleId ) )},
"i18n": {json_encode( hash(
    'location', 'Location'|i18n( 'design/admin/explayouts_ui/rule_list' ),
    'subtree', 'Subtree'|i18n( 'design/admin/explayouts_ui/rule_list' ),
    'path', 'Path'|i18n( 'design/admin/explayouts_ui/rule_list' ),
    'path_prefix', 'Path prefix'|i18n( 'design/admin/explayouts_ui/rule_list' ),
    'path_regex', 'Path regex'|i18n( 'design/admin/explayouts_ui/rule_list' ),
    'route', 'Route'|i18n( 'design/admin/explayouts_ui/rule_list' ),
    'klass', 'Class'|i18n( 'design/admin/explayouts_ui/rule_list' ),
    'siteaccess', 'Siteaccess'|i18n( 'design/admin/explayouts_ui/rule_list' ),
    'query_parameter', 'Query parameter'|i18n( 'design/admin/explayouts_ui/rule_list' ),
    'route_parameter', 'Route parameter'|i18n( 'design/admin/explayouts_ui/rule_list' ),
    'time', 'Time'|i18n( 'design/admin/explayouts_ui/rule_list' ),
    'view_in_cms', 'View in CMS'|i18n( 'design/admin/explayouts_ui/rule_list' ),
    'select_classes', 'Select content classes'|i18n( 'design/admin/explayouts_ui/rule_list' ),
    'select_siteaccesses', 'Select siteaccesses'|i18n( 'design/admin/explayouts_ui/rule_list' ),
    'content_browser', 'Choose a location'|i18n( 'design/admin/explayouts_ui/rule_list' ),
    'close', 'Close'|i18n( 'design/admin/explayouts_ui/rule_list' ),
    'remove', 'Delete'|i18n( 'design/admin/explayouts_ui/rule_detail' ),
    'target_type', 'Target type'|i18n( 'design/admin/explayouts_ui/rule_detail' ),
    'condition_type', 'Condition type'|i18n( 'design/admin/explayouts_ui/rule_detail' )
) )}{rdelim}{/set-block}
<script type="application/json" id="explayouts-ui-rule-list-data">{$explayouts_ui_rule_list_data|explode( '<' )|implode( '\u003c' )|explode( '>' )|implode( '\u003e' )}</script>
{undef $explayouts_ui_rule_list_data}
{ezscript( array( 'explayouts_ui_rule_list.js' ) )}
