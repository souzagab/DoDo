function onInstall(event) {
    console.log('[Service-worker]', "Installing!", event);
}

function onActivate(event) {
    console.log('[Service-worker]', "Activating!", event);
}

function onFetch(event) {
    console.log('[Service-worker]', "Fetching!", event);
}

self.addEventListener('install', onInstall)
self.addEventListener('activate', onActivate)
self.addEventListener('fetch', onFetch)
