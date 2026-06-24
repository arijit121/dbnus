function replaceState(path) {
    history.replaceState('', '', path);
}

function pushState(path) {
    history.pushState('', '', path);
}