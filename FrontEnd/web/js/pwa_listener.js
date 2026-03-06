// This file must be loaded in the <head> of index.html before Flutter boots up.
// It catches early window events that might otherwise be missed.

window.__pwa_deferred_prompt = null;

// Catch the native installation prompt as soon as the browser fires it on page load
window.addEventListener('beforeinstallprompt', function (e) {
    e.preventDefault();
    window.__pwa_deferred_prompt = e;
    console.log('[Early PWA] beforeinstallprompt captured!');
});

// Update the cache instantly the moment the user successfully installs the app via any method
window.addEventListener('appinstalled', function () {
    console.log('[Early PWA] appinstalled event fired!');
    localStorage.setItem('__pwa_installed_cached', 'true');
});
