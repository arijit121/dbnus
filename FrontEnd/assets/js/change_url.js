function replaceState(path) {
    history.replaceState('', '', path);
}

function pushState(path) {
    history.pushState('', '', path);
}

function replaceCurrentUrl(path) {
    window.history.replaceState(
        { path: path },
        '',
        path
    );
}