/* The template editor's color mode (explayouts_ui/template_editor in admin4), set before anything is drawn: a
   blocking script in <head> (until 1.3.19 inline). html[data-a4-theme] is dark when this browser's admin4 switch
   (localStorage "exp-admin4-theme") says dark, light otherwise. */
(function () {
    var theme = null;
    try { theme = window.localStorage.getItem('exp-admin4-theme'); } catch (e) {}
    document.documentElement.setAttribute('data-a4-theme', theme === 'dark' ? 'dark' : 'light');
})();
