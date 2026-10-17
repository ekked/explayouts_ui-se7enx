{* The template editor itself (explayouts_ui/template_editor): the file list, the toolbar, the editing area and the
   script. One file for every admin design; design/admin's and design/admin4's template_editor.tpl draw the page
   around it. *}
<div class="app">
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <h1>{'7x Template Editor'|i18n( 'design/admin/explayouts_ui/template_editor' )} <small id="tpl-count"></small></h1>
            <input type="text" id="filter" placeholder="{'Filter templates...'|i18n( 'design/admin/explayouts_ui/template_editor' )}" autocomplete="off">
        </div>
        <nav class="flat-list" id="tree"></nav>
        <div class="resizer" id="resizer"></div>
    </aside>
    <main class="main">
        <div class="toolbar">
            {* New only with explayouts.ini [TemplateEditorSettings] AllowNewTemplates=enabled; the server refuses to create a file otherwise. *}
            {if $allow_new_templates}<button class="btn secondary" id="new-file">{'New'|i18n( 'design/admin/explayouts_ui/template_editor' )}</button>{/if}
            <button class="btn" id="save-file">{'Save'|i18n( 'design/admin/explayouts_ui/template_editor' )}</button>
            <button class="btn secondary exit-btn" id="exit-editor" title="{'Return to admin'|i18n( 'design/admin/explayouts_ui/template_editor' )}">×</button>
            <span class="path" id="path">{'No file selected'|i18n( 'design/admin/explayouts_ui/template_editor' )}</span>
            <span class="status" id="status"></span>
        </div>
        <div class="editor-wrap" id="editor-wrap">
            <div class="empty">{'Select a template from the list to start editing.'|i18n( 'design/admin/explayouts_ui/template_editor' )}</div>
        </div>
    </main>
</div>

{* The values of the editor, one JSON data block (the view's values are JSON with the HEX flags; < and > of the whole
   block as JSON escapes), read by javascript/explayouts_ui_template_editor.js (until 1.3.19 inline scripts). *}
{set-block variable=$explayouts_ui_te_data}{ldelim}"i18n": {json_encode( hash(
    'not_array', 'TPL_FILES is not an array. Check the server response.'|i18n( 'design/admin/explayouts_ui/template_editor' ),
    'no_match', 'No templates match.'|i18n( 'design/admin/explayouts_ui/template_editor' ),
    'render_error', 'Render error: %message'|i18n( 'design/admin/explayouts_ui/template_editor' ),
    'load_error', 'Load error: %message'|i18n( 'design/admin/explayouts_ui/template_editor' ),
    'no_file', 'No file selected'|i18n( 'design/admin/explayouts_ui/template_editor' ),
    'saved', 'Saved'|i18n( 'design/admin/explayouts_ui/template_editor' ),
    'save_failed', 'Save failed: %message'|i18n( 'design/admin/explayouts_ui/template_editor' ),
    'save_error', 'Save error: %message'|i18n( 'design/admin/explayouts_ui/template_editor' ),
    'new_path', 'New template path (from the installation root, inside an allowed folder, must end in .tpl):'|i18n( 'design/admin/explayouts_ui/template_editor' ),
    'must_end_tpl', 'Path must end in .tpl'|i18n( 'design/admin/explayouts_ui/template_editor' ),
    'count', '(%count templates)'|i18n( 'design/admin/explayouts_ui/template_editor' ),
    'new_file_error', 'New file error: %message'|i18n( 'design/admin/explayouts_ui/template_editor' )
) )},
"files": {$files_json}, "base_url": {$base_url}, "selected": {$selected_json}, "initial": {$initial_content_json}, "csrf_token": {$csrf_token}{rdelim}{/set-block}
<script type="application/json" id="explayouts-ui-te-data">{$explayouts_ui_te_data|explode( '<' )|implode( '\u003c' )|explode( '>' )|implode( '\u003e' )}</script>
{undef $explayouts_ui_te_data}
<script src={'javascript/explayouts_ui_template_editor.js'|ezdesign}></script>
