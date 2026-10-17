{ezcss_require(array('netgen/layouts-admin.css','netgen/layouts-exponential.css','explayouts-ui.css','explayouts_ui_admin.css'))}
{* layouts-admin.js is not loaded: its content browser stops at once without Netgen's page tags, so none of it ever ran here, and these pages have their own scripts. *}
{ezscript_load(array('netgen/layouts-exponential.js'))}
<div class="ng-layouts-app row explui-page-shared-layouts">
    <div class="layouts-content">
        <div class="nl-layouts-view-grid explui-show">
            <div class="layouts-header">
                <h2 class="layouts-title">{'Shared layouts'|i18n( 'design/admin/explayouts_ui/shared_layouts_list' )}</h2>
                <div class="layouts-controls">
                    <a href={concat('explayouts_ui_api/app#layout')|ezurl} id="add-new-button" class="nl-btn nl-btn-primary js-open-ngl">
                        <i class="material-icons">add</i> {'New shared layout'|i18n( 'design/admin/explayouts_ui/shared_layouts_list' )}
                    </a>
                </div>
            </div>

            <div class="nl-layouts">
                {foreach $layouts as $layout}
                    <div class="nl-layout" data-name="{$layout.name|wash}" data-identifier="{$layout.identifier|wash}" data-modified="{$layout.modified}" data-type="{$layout.layout_type|wash}">
                        <div class="nl-layout-content">
                            <div class="nl-layout-info">
                                <div class="nl-layout-type">
                                    <p>{$layout.layout_type|wash}</p>
                                    <span class="nl-layout-icon">{$layout_type_icons[$layout.layout_type]}</span>
                                </div>
                                <div class="nl-layout-text">
                                    <div class="nl-layout-name"><a href={concat('explayouts_ui_api/app#layout/',$layout.id)|ezurl}>{$layout.name|wash}</a></div>
                                    <div class="nl-layout-description">{$layout.identifier|wash}</div>
                                    <div class="nl-layout-modified"><p>{$layout.modified|datetime( 'custom', '%Y-%m-%d %H:%i' )}</p></div>
                                    {if ne($layout.status,2)}<span class="unpublished-label">{'Draft'|i18n( 'design/admin/explayouts_ui/shared_layouts_list' )}</span>{/if}
                                </div>
                            </div>
                            <div class="nl-layout-actions">
                                <div class="nl-layout-data">
                                    <div class="meta-info">
                                        <i class="material-icons">share</i>
                                        <span>{'%count references'|i18n( 'design/admin/explayouts_ui/shared_layouts_list',, hash( '%count', first_set( $shared_counts[$layout.id], 0 ) ) )}</span>
                                    </div>
                                </div>
                                <div class="nl-dropdown" data-position="right">
                                    <button class="nl-btn nl-dropdown-toggle" type="button"><i class="material-icons">more_horiz</i></button>
                                    <ul class="nl-dropdown-menu main-dropdown">
                                        <li><a href={concat('explayouts_ui/layout_preview/',$layout.id,'/',$layout.status)|ezurl} target="_blank"><i class="material-icons explui-icon-inline">visibility</i> {'Preview'|i18n( 'design/admin/explayouts_ui/shared_layouts_list' )}</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                {/foreach}
            </div>

{* Paged. The size is admininterface.ini [PaginationSettings], keyed by this
   view, and the extension ships its own defaults for these four. *}
{if $page_count|gt( $limit )}
<div class="context-toolbar">
{include name=SharedNavigator
         uri='design:navigator/google.tpl'
         page_uri='/explayouts_ui/shared_layouts_list'
         item_count=$page_count
         view_parameters=$view_parameters
         item_limit=$limit}
</div>
{/if}


            {if count($layouts)|eq(0)}
                <p class="nl-no-items explui-show">{'There are no shared layouts referenced by other layouts yet.'|i18n( 'design/admin/explayouts_ui/shared_layouts_list' )}</p>
            {/if}
        </div>
    </div>
</div>
{literal}
<script>
(function(){
    var toggles = document.querySelectorAll('.nl-dropdown-toggle');
    for (var i = 0; i < toggles.length; i++) {
        toggles[i].addEventListener('click', function(e){
            e.preventDefault();
            e.stopPropagation();
            var dd = this.parentNode;
            var active = /\bnl-dropdown-active\b/.test(dd.className);
            var all = document.querySelectorAll('.nl-dropdown.nl-dropdown-active');
            for (var j = 0; j < all.length; j++) {
                if (all[j] !== dd) all[j].className = all[j].className.replace(/\bnl-dropdown-active\b/g, '').trim();
            }
            if (!active) {
                dd.className += ' nl-dropdown-active';
            } else {
                dd.className = dd.className.replace(/\bnl-dropdown-active\b/g, '').trim();
            }
        });
    }
    document.addEventListener('click', function(){
        var all = document.querySelectorAll('.nl-dropdown.nl-dropdown-active');
        for (var j = 0; j < all.length; j++) {
            all[j].className = all[j].className.replace(/\bnl-dropdown-active\b/g, '').trim();
        }
    });
})();
</script>
{/literal}
