import consumer from "./consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    console.log("Connected to the notification channel!");
  },

  disconnected() {
    console.log("Disconnected from the notification channel.");
  },

  received(data) {
    console.log("Notification received: " + data.message);
  }
});

// document.addEventListener('turbo:load', () => {
//   if (Notification.permission !== 'granted') {
//     Notification.requestPermission().then(permission => { 
//     });
//   }

