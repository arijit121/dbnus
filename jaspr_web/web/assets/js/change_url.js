function changeUrl(path) {
    history.pushState('', '', path);
}