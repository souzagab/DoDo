async function registerServiceWorker() {
  if (!navigator.serviceWorker) return;

  try {
    await navigator.serviceWorker.register("/service-worker.js", { scope: "/" });
  } catch (e) {
    console.warn("Service worker registration failed", e);
    throw e;
  }
}

async function requestNotificationPermission() {
  if (!("Notification" in window)) return false

  try {
    const result = await Notification.requestPermission();
    return result === "granted"
  } catch (e) {
    console.warn("Notification permission request failed", e);
    throw e
  }
}

async function startServiceWorker() {
  try {
    await registerServiceWorker()

    if (await requestNotificationPermission()) {
      const subscription = await getPushSubscription();
      if (!subscription) {
        console.warn("No subscription active");
        return
      }

      await sendSubscriptionToServer(subscription);
    }
  } catch (e) {
    console.warn("Service Worker initialization failed", e)
  }
}

async function getPushSubscription() {
  const registration = await navigator.serviceWorker.getRegistration();
  if (!registration) return

  const publicKey = document.head.querySelector('meta[name="vapid_public_key"]').getAttribute("content");
  const subscription = await registration.pushManager.subscribe({
    userVisibleOnly: true,
    applicationServerKey: publicKey,
  })

  return subscription
}

async function sendSubscriptionToServer(subscription) {
  try {
    return fetch("/devices", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.head.querySelector('meta[name="csrf-token"]').getAttribute("content"),
      },
      body: JSON.stringify({ device: subscription.toJSON() }),
    })
  } catch (e) {
    console.warn("Failed to send subscription to server", e);
    throw e
  }
}

(async () => {
  try {
    await startServiceWorker();
    console.log("Service Worker Started");
  } catch (e) {
    console.warn("Service Worker initialization failed", e);
  }
})()
