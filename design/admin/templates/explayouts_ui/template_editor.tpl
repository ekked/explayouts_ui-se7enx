<!DOCTYPE html>
<html lang="en" data-a4-theme="dark">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{'7x Template Editor'|i18n( 'design/admin/explayouts_ui/template_editor' )}</title>
    {* The editor keeps the dark look it always had in this design: admin4's tokens in their dark values (components.css), *}
    {* the layout in explayouts_ui_template_editor.css, the same file design/admin4 uses. No inline CSS. *}
    <link rel="stylesheet" href={'stylesheets/components.css'|ezdesign}>
    <link rel="stylesheet" href={'stylesheets/explayouts_ui_template_editor.css'|ezdesign}>
</head>
<body>
{include uri='design:explayouts_ui/parts/template_editor_body.tpl' files_json=$files_json selected_json=$selected_json initial_content_json=$initial_content_json base_url=$base_url csrf_token=$csrf_token allow_new_templates=$allow_new_templates}
</body>
</html>
