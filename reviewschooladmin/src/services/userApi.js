import { db } from "./firebase";

export default {
  getUsersList: async () => {
    const response = await db.collection("users").get();
    const usersList = response.docs.map((item) => item.data());
    return usersList;
  },
  getUserByID: async (userID) => {
    // const response = await db.collection("users").doc("ro@test.com").set({ isBlocked: true });
    // return usersList;
  },
  adduser: async (userID) => {
    const response = await db.collection("schools").doc("admin@test.com").set({
      name: "Tokyo",
      country: "Japan",
    });
    return response;
  },
  blockUserByEmail: async (email) => {
    const response = await db.collection("users").doc(email).update({ isBlocked: true });
    return response;
  },
  verifyUserByEmail: async (email) => {
    const response = await db.collection("users").doc(email).update({ isVerified: 2 });
    return response;
  },
};
