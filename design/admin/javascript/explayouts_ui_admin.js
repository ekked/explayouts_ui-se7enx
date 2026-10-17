/* The explayouts_ui pages of the classic admin designs (layout list, shared layouts, layout edit, mappings, setup),
   where inline scripts and handler attributes stood until 1.3.19. Printed with ezscript at the end of each page's
   template, so the page's markup is there when it runs; it sets itself up once even when it is printed twice.
   - the layout cards' sorting (#layout-sorting-sort, #layout-sorting-direction, data-<key> on the cards of .nl-layouts);
   - the .nl-dropdown menus (a click on .nl-dropdown-toggle opens its menu, any other click closes them), except on
     the mappings page, whose explayouts_ui_rule_list.js does that;
   - data-explui-confirm="<text>": on a form, its submit asks confirm(<text>); on a button or link, its click does;
     declined, nothing is sent. */
(function () {
    if (window.explayoutsUiAdminReady) return;
    window.explayoutsUiAdminReady = true;

    var sortSelect = document.getElementById('layout-sorting-sort');
    var dirSelect = document.getElementById('layout-sorting-direction');
    function sortLayouts() {
        var sort = sortSelect.value;
        var dir = dirSelect.value;
        var container = document.querySelector('.nl-layouts');
        if (!container) return;
        var cards = Array.prototype.slice.call(container.children);
        cards.sort(function(a, b) {
            var av = a.getAttribute('data-' + sort) || '';
            var bv = b.getAttribute('data-' + sort) || '';
            if (sort === 'modified' || sort === 'mappings') {
                av = parseInt(av) || 0;
                bv = parseInt(bv) || 0;
            } else {
                av = av.toLowerCase();
                bv = bv.toLowerCase();
            }
            if (av < bv) return -1;
            if (av > bv) return 1;
            return 0;
        });
        if (dir === 'desc') cards.reverse();
        for (var k = 0; k < cards.length; k++) {
            container.appendChild(cards[k]);
        }
    }
    if (sortSelect && dirSelect) {
        sortSelect.addEventListener('change', sortLayouts);
        dirSelect.addEventListener('change', sortLayouts);
    }

    // the mappings page binds its menus itself (explayouts_ui_rule_list.js): not twice
    var toggles = document.getElementById('explayouts-ui-rule-list-data') ? [] : document.querySelectorAll('.nl-dropdown-toggle');
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
    if (toggles.length) {
        document.addEventListener('click', function(){
            var all = document.querySelectorAll('.nl-dropdown.nl-dropdown-active');
            for (var j = 0; j < all.length; j++) {
                all[j].className = all[j].className.replace(/\bnl-dropdown-active\b/g, '').trim();
            }
        });
    }

    document.addEventListener('submit', function (e) {
        var form = e.target;
        var text = form && form.getAttribute && form.getAttribute('data-explui-confirm');
        if (text && !window.confirm(text)) e.preventDefault();
    }, true);
    document.addEventListener('click', function (e) {
        var el = e.target && e.target.closest ? e.target.closest('[data-explui-confirm]') : null;
        if (!el || el.tagName === 'FORM') return;
        if (!window.confirm(el.getAttribute('data-explui-confirm'))) {
            e.preventDefault();
            e.stopImmediatePropagation();
        }
    }, true);
})();
