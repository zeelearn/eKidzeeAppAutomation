importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

/*Update with yours config*/
const firebaseConfig = {
  apiKey: "AIzaSyB-dMRlwZLc_0EnBr7JqRA1XxnJPMHvRQ8",
  authDomain: "kidzeeandroidapp-91faf.firebaseapp.com",
  databaseURL: "https://kidzeeandroidapp-91faf.firebaseio.com",
  projectId: "kidzeeandroidapp-91faf",
  storageBucket: "kidzeeandroidapp-91faf.appspot.com",
  messagingSenderId: "66383917412",
  appId: "1:66383917412:web:f6c3022cc3debad69eca71",
  measurementId: "G-DD0T4TMV7F"
};
firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

self.addEventListener("notificationclick", function (event) {
  event.notification.close();

  const targetUrl = event.notification.data?.url || '/';
  event.waitUntil(
    clients.matchAll({ type: "window", includeUncontrolled: true }).then(windowClients => {
      for (const client of windowClients) {
        // Focus existing tab if same origin
        if (client.url.includes(self.location.origin) && "focus" in client) {
          return client.focus();
        }
      }
      // Always try openWindow — Chrome only blocks cross-origin in insecure mode
      return clients.openWindow(targetUrl).catch(err => {
        console.warn("openWindow blocked:", err);
      });
    })
  );
});

messaging.onBackgroundMessage(function (payload) {
  console.log('Received background message ', payload);

  const notificationTitle = payload.data.title;

  let dbUserRequest = indexedDB.open('auth');

  dbUserRequest.onerror = function (event) {
    console.error("logindetails Failed to open database:", event.target.errorCode);
  };

  dbUserRequest.onupgradeneeded = function (event) {
    var db = event.target.result;
  };

  console.log('Notification title is - ', notificationTitle);


  dbUserRequest.onsuccess = function (dbvent) {

    let db = dbvent.target.result;

    let transaction = db.transaction(['box'], 'readwrite');
    let objectStore = transaction.objectStore('box');

    let getRequest = objectStore.get('login_details');
    getRequest.onsuccess = function (successevent) {
      let userData = successevent.target.result;

      let exists = Object.values(userData).includes("success");
      if (exists != null) {
        let parsedOfflineUserData = JSON.parse(userData);
        console.log('Kidzww data after parsed  is - ', parsedOfflineUserData);
        console.log('Notification data after parsed  is - ', payload.data);
        const notificationOptions = {
          body: payload.data.body,
          icon: payload.data.logo || '/icons/Icon-192.png',
          data: {
            url: payload.data.url || '/'
          },
          image: payload.data.bigimage || undefined
        };
        if (payload.data.type != null && (payload.data.type === 'chat' || payload.data.type === 'td')) {
          if (parsedOfflineUserData.data.User_ID.toString() === payload.data.business_user_id || parsedOfflineUserData.data.User_ID.toString() === payload.data.user_id) {
            self.registration.showNotification(notificationTitle,
              notificationOptions);
          }
        } else if (payload.data.topic) {

          let userIDList = ["0", parsedOfflineUserData.data.User_ID.toString()];
          let userTypeList = ["0", parsedOfflineUserData.data.User_Type];
          let franchiseeList = ["0", ...parsedOfflineUserData.data.Program.map(program => program.Franchisee_id.toString())];
          let classIDList = ["0", ...parsedOfflineUserData.data.Program.map(program => program.Class_Id.toString())];
          let parts = payload.data.topic.split("_").map(String);


          let result =
            franchiseeList.includes(parts[0]) &&
            userIDList.includes(parts[1]) &&
            userTypeList.includes(parts[2]) &&
            classIDList.includes(parts[3]);

          if (result) {
            console.log("All parts match. Executing...");
            self.registration.showNotification(notificationTitle, notificationOptions);

          } else {
            console.log("Not all parts match.");
          }
        } else {
          console.log("Not all Match");
        }
      }
    };
    getRequest.onerror = function (event) {
      console.log("Error retrieving notifications:", event.target.error);

    };
  };
});