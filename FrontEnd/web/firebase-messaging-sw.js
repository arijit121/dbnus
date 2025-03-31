importScripts("https://www.gstatic.com/firebasejs/10.11.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.11.1/firebase-messaging-compat.js");


const firebaseConfig = {
  apiKey: "AIzaSyDdGpKs-t8Ee4tr4GsaEavhureueb2O4zM",
  authDomain: "dbnus-df986.firebaseapp.com",
  databaseURL: "https://dbnus-df986.firebaseio.com",
  projectId: "dbnus-df986",
  storageBucket: "dbnus-df986.appspot.com",
  messagingSenderId: "783534429855",
  appId: "1:783534429855:web:cc78ab29a1b67306e6f4aa",
  measurementId: "G-8YSKF8B4G1"
};
firebase.initializeApp(firebaseConfig);

let messaging;
try {
  messaging = firebase.messaging.isSupported() ? firebase.messaging() : null
} catch (err) {
  console.error('Failed to initialize Firebase Messaging', err);
}

if (messaging) {
  // To dispaly background notifications
  try {
    messaging.onBackgroundMessage((message) => {
      console.log('Received background message: ', message.data);
      var data = message.data;
      var title = data['title'];
      var body = data['body'];
      var bigText = data['message'];
      var image = data['image'];
      var actionURL = data['ActionURL'];
      var notificationOptions = {
        tag: body,
        body: bigText,
        icon: image,
        data: {
          url: actionURL,// This should contain the URL you want to open
        },
      }
      self.registration.showNotification(title, notificationOptions);
    });
  } catch (err) {
    console.log(err);
  }
}

// File: firebase-messaging-sw.js
// Handling Notification click
self.addEventListener('notificationclick', (event) => {
  event.notification.close(); // Closing the notification when clicked

  console.log('Notification click:', event.notification.data);

  const urlToOpen = event.notification.data?.url || '/';

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((windowClients) => {
      for (const client of windowClients) {
        if (client.url.includes(urlToOpen) && 'focus' in client) {
          return client.focus();
        }
      }
      if (clients.openWindow) {
        return clients.openWindow(urlToOpen);
      }
    })
  );
});