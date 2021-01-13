import { db } from "./firebase";

export default {
  getPostsList: async () => {
    const response = await db.collection("posts").get();
    const postsList = response.docs.map((item) => item.data());
    return postsList;
  },
};
