importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");


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

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});