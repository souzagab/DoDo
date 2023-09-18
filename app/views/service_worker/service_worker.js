
importScripts(
    "https://storage.googleapis.com/workbox-cdn/releases/7.0.0/workbox-sw.js"
)

const { CacheFirst, NetworkFirst } = workbox.strategies
const { registerRoute } = workbox.routing

registerRoute(
    ({ request }) => request.destination === 'image',
    new CacheFirst({ cacheName: 'images' })
)

registerRoute(
    ({ request }) => request.destination === 'script' || request.destination === 'style',
    new CacheFirst({ cacheName: 'assets' })
)

registerRoute(
    ({ request }) => request.destination === 'document',
    new NetworkFirst({ cacheName: 'pages' })
)

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
