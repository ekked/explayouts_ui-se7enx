/* explayouts_ui in admin4: sorting of the layout cards and confirmations of delete forms. No markup with inline
   styles is written here (doc/bc/6.0/admin4-styling.md). */
(function () {
    'use strict';

    function sortCards() {
        var bar = document.querySelector('[data-explayouts-sort-target]');
        if (!bar) return;
        var list = document.getElementById(bar.getAttribute('data-explayouts-sort-target'));
        var sortSelect = document.getElementById('layout-sorting-sort');
        var dirSelect = document.getElementById('layout-sorting-direction');
        if (!list || !sortSelect || !dirSelect) return;
        function run() {
            var key = sortSelect.value, desc = dirSelect.value === 'desc';
            var cards = Array.prototype.slice.call(list.children);
            cards.sort(function (a, b) {
                var av = a.getAttribute('data-' + key) || '', bv = b.getAttribute('data-' + key) || '';
                if (key === 'modified' || key === 'mappings') { av = parseInt(av, 10) || 0; bv = parseInt(bv, 10) || 0; }
                else { av = av.toLowerCase(); bv = bv.toLowerCase(); }
                return av < bv ? -1 : (av > bv ? 1 : 0);
            });
            if (desc) cards.reverse();
            cards.forEach(function (card) { list.appendChild(card); });
        }
        sortSelect.addEventListener('change', run);
        dirSelect.addEventListener('change', run);
    }

    function confirmForms() {
        document.addEventListener('submit', function (e) {
            var form = e.target;
            var text = form && form.getAttribute && form.getAttribute('data-explayouts-confirm');
            if (text && !window.confirm(text)) e.preventDefault();
        }, true);
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', function () { sortCards(); confirmForms(); });
    else { sortCards(); confirmForms(); }
})();
