// import firebase from "firebase";
import firebase from "firebase/app";
import "firebase/database"; // If using Firebase database
import "firebase/storage";
import "firebase/firestore";

const firebaseConfig = {
  apiKey: "AIzaSyC8YW1Klx5oWPEI-YqcoHp9MzhLl7WF7pY",
  authDomain: "usreview-ec04a.firebaseapp.com",
  projectId: "usreview-ec04a",
  storageBucket: "usreview-ec04a.appspot.com",
  messagingSenderId: "239248749810",
  appId: "1:239248749810:web:4f6a283eadaf71533ccc6b",
};

// const config = {
//   apiKey: "AIzaSyC8YW1Klx5oWPEI-YqcoHp9MzhLl7WF7pY",
//   authDomain: "ADD-YOUR-DETAILS-HERE",
//   databaseURL: "usreview-ec04a.firebaseapp.com",
// };
firebase.initializeApp(firebaseConfig);
export const auth = firebase.auth;
export const db = firebase.firestore();
