<!DOCTYPE html>
{* admin4: the template editor (explayouts_ui/template_editor). It stays a page of its own (a full-height editor does
   not fit the admin columns), with admin4's tokens and light or dark mode, and a header that leads back to the
   Layouts pages. The editor itself is design/admin's parts/template_editor_body.tpl. *}
<html lang="{fetch( 'content', 'locale' ).http_locale_code|wash}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{'7x Template Editor'|i18n( 'design/admin/explayouts_ui/template_editor' )}</title>
    {* The color mode, before anything is drawn: a blocking script (until 1.3.19 inline). *}
    <script src={'javascript/explayouts_ui_template_editor_theme.js'|ezdesign}></script>
    <link rel="stylesheet" href={'stylesheets/components.css'|ezdesign}>
    <link rel="stylesheet" href={'stylesheets/explayouts_ui_template_editor.css'|ezdesign}>
</head>
<body>
<header class="explayouts-te-header">
    <a href={'explayouts_ui/dashboard'|ezurl}>&larr; {'Layouts'|i18n( 'design/admin/explayouts_ui/dashboard' )}</a>
    <span class="explayouts-te-title">{'Template editor'|i18n( 'design/admin/explayouts_ui/dashboard' )}</span>
</header>
{include uri='design:explayouts_ui/parts/template_editor_body.tpl' files_json=$files_json selected_json=$selected_json initial_content_json=$initial_content_json base_url=$base_url csrf_token=$csrf_token allow_new_templates=$allow_new_templates}
</body>
</html>
