{* design/admin: Export (explayouts_ui/transfer_export). The body is shared by every admin design and uses the shared
   admin components (components.css, which design/admin loads as well). *}
<div class="context-block a4-page">

<div class="box-header"><div class="box-ml">
<h1 class="context-title">{'Export layouts'|i18n( 'design/admin/explayouts_ui/transfer' )}</h1>
</div></div>

<div class="box-bc"><div class="box-ml"><div class="box-content">
{include uri='design:explayouts_ui/parts/transfer_export_body.tpl'}
</div></div></div>
</div>
