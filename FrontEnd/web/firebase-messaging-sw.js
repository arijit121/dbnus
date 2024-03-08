importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");


const firebaseConfig = {
  apiKey: "AIzaSyB1d_V13Jk8qflgd52GKkqOEf_4prUqV-k",
  authDomain: "genupathlabs-28005.firebaseapp.com",
  databaseURL: "https://genupathlabs-28005.firebaseio.com",
  projectId: "genupathlabs-28005",
  storageBucket: "genupathlabs-28005.appspot.com",
  messagingSenderId: "1010994691811",
  appId: "1:1010994691811:web:5131c65b45f57e1aaf8fd6",
  measurementId: "G-6R0RHRH1Y3"
};
firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});