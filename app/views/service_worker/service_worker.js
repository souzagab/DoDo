
importScripts(
    "https://storage.googleapis.com/workbox-cdn/releases/7.0.0/workbox-sw.js"
)

const { CacheFirst, NetworkFirst } = workbox.strategies
const { registerRoute } = workbox.routing

// Cache
// registerRoute(
//     ({ request }) => request.destination === 'image',
//     new CacheFirst({ cacheName: 'images' })
// )
//
// registerRoute(
//     ({ request }) => request.destination === 'script' || request.destination === 'style',
//     new CacheFirst({ cacheName: 'assets' })
// )
//
// registerRoute(
//     ({ request }) => request.destination === 'document',
//     new NetworkFirst({ cacheName: 'pages' })
// )


// Lifecycle callbacks
function onInstall(event) {
    // console.log('[Service-worker]', "Installing!", event);
}

function onActivate(event) {


    // event.waitUntil(caches.keys().then((keys) => {
    //     return Promise.all(keys.map((key) => caches.delete(key)))
    // }))
}

function onFetch(event) {
    // console.log('[Service-worker]', "Fetching!", event);
}

function onPush(event) {
    const message = event.data.json()
    const title = message.title || 'Yay a message'
    const options = {
        body: message.body || 'We have received a push message.',
        icon: message.icon,
        data: { url: message.url }
    }

    event.waitUntil(self.registration.showNotification(title, options))
}
function onNotificationClick(event) {
  event.notification.close()
  event.waitUntil(clients.openWindow(event.notification.data.url))
}

self.addEventListener('activate', onActivate)
self.addEventListener('install', onInstall)
self.addEventListener('fetch', onFetch)
self.addEventListener('push', onPush)
self.addEventListener('notificationclick', onNotificationClick)
