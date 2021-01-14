import { db } from "./firebase";

export default {
  getPostsList: async () => {
    const response = await db.collection("posts").get();
    const postsList = response.docs.map((item) => item.data());
    return postsList;
  },
  getPostByID: async (postID) => {
    const response = await db.collection("posts").doc(postID).get();
    console.log({ response });
    return response;
  },
  approvePost: async (postID) => {
    const response = await db.collection("posts").doc(postID).update({ isVerified: true });
    return response;
  },
};
