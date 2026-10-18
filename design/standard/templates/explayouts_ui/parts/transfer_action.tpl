{* What the layouts import does with one item ($action: create, none, skip, overwrite, copy), as words. *}
{switch match=$action}
{case match='create'}<span class="a4-tag is-info">{'Create'|i18n( 'design/admin/explayouts_ui/transfer' )}</span>{/case}
{case match='overwrite'}<span class="a4-tag is-warn">{'Overwrite'|i18n( 'design/admin/explayouts_ui/transfer' )}</span>{/case}
{case match='copy'}<span class="a4-tag is-accent">{'Create a copy'|i18n( 'design/admin/explayouts_ui/transfer' )}</span>{/case}
{case match='skip'}<span class="a4-tag">{'Skip'|i18n( 'design/admin/explayouts_ui/transfer' )}</span>{/case}
{case}<span class="a4-tag">{'No change'|i18n( 'design/admin/explayouts_ui/transfer' )}</span>{/case}
{/switch}
