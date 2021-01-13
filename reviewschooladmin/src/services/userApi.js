import { db } from "./firebase";

export default {
  getUsersList: async () => {
    const response = await db.collection("users").get();
    const usersList = response.docs.map((item) => item.data());
    return usersList;
  },
};
