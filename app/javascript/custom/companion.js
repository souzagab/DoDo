async function registerServiceWorker() {
  if (!navigator.serviceWorker) return

  try {
    await navigator.serviceWorker.register("/service-worker.js", { scope: "/" })
  } catch (e) {
    console.error("Service worker registration failed", e)
  }
}

async function requestNotificationPermission() {
  if (!("Notification" in window)) return false

  const result = await Notification.requestPermission()

  return result === "granted"
}
async function startServiceWorker(){
  await registerServiceWorker()

  if (await requestNotificationPermission()) {
    const subscription = await getPushSubscription()

    return sendSubscriptionToServer(subscription)
  }
}

async function getPushSubscription() {
  const registration = await navigator.serviceWorker.getRegistration()
  if (!registration) return

  const publicKey = document.head.querySelector('meta[name="vapid_public_key"]').getAttribute("content")
  const subscription = await registration.pushManager.subscribe({
    userVisibleOnly: true,
    applicationServerKey: publicKey
  })

  return subscription
}

async function sendSubscriptionToServer(subscription) {
  // TODO: post request to save subscription
  console.table(subscription)
}

startServiceWorker()
  .then(() => { console.log("Service Worker Started")})
