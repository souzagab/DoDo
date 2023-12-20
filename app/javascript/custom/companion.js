async function registerServiceWorker() {
  if (!navigator.serviceWorker) {
    console.error("Service workers are not supported by this browser");
    return
  }

  try {
    console.info("#registerServiceWorker: Registering service worker")
    await navigator.serviceWorker.register("/service-worker.js", { scope: "/" });
  } catch (e) {
    console.warn("Service worker registration failed", e);
    throw e;
  }
}

async function requestNotificationPermission() {
  if (!("Notification" in window)) {
    console.warn("#requestNotificationPermission: Notifications are not supported by this browser");
    return false
  }

  try {
    const result = await Notification.requestPermission()
    console.log("#requestPermission: Notification permission request result", result);
    if (result === "granted") {
      allowAlert.style.display = "none"
      return true
    }
  } catch (e) {
    console.warn("#requestPermission: Notification permission request failed", e);
    throw e
  }
}

async function startServiceWorker() {
  try {
    await registerServiceWorker()

    if (await requestNotificationPermission()) {
      const subscription = await getPushSubscription();
      if (!subscription) {
        console.warn("#requestNotificationPermission: No subscription active");
        return
      }
      console.info("#requestNotificationPermission: Subscription", subscription)
      await sendSubscriptionToServer(subscription);
    }
  } catch (e) {
    console.warn("#requestNotificationPermission: Service Worker initialization failed", e)
  }
}

async function getPushSubscription() {
  const registration = await navigator.serviceWorker.getRegistration();
  if (!registration) {
    console.warn("#getPushSubscription: No service worker registration found");
    return
  }

  const publicKey = document.head.querySelector('meta[name="vapid_public_key"]').getAttribute("content");
  const subscription = await registration.pushManager.subscribe({
    userVisibleOnly: true,
    applicationServerKey: publicKey,
  }).catch((e) => {
    console.warn("#getPushSubscription: Subscription failed", e);
    throw e
  })

  return subscription
}

async function sendSubscriptionToServer(subscription) {
  try {
    console.info("#sendSubscriptionToServer: Sending subscription to server", subscription);
    return fetch("/devices", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.head.querySelector('meta[name="csrf-token"]').getAttribute("content"),
      },
      body: JSON.stringify({ device: subscription.toJSON() }),
    })
  } catch (e) {
    console.warn("#sendSubscriptionToServer: Failed to send subscription to server", e);
    throw e
  }
}


const allowButton = document.querySelector("#allow_notifications")
const allowAlert = document.querySelector("#allow_notifications_alert")

if (typeof Notification !== "undefined") {
  if (Notification.permission === "denied") {
    allowAlert.style.display = "none"
  } else if (Notification.permission === "granted") {
    startServiceWorker().then(() => {
      allowAlert.style.display = "none"
    })
  } else {
    allowAlert.style.display = "flex"
  }

  allowButton.addEventListener("click", async () => {
    if (await requestNotificationPermission()) {
      startServiceWorker().then(() => {
        console.info("#allowButton: Service Worker initialized");
        allowAlert.style.display = "none"
    })
    }
  })
}