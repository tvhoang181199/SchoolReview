import * as types from "./types";

const INITIAL_STATE = {
  isAuthenticated: false,
  token: "",
  usersList: [],
  postsList: [],
  verifyUsers: [],
  approvePosts: [],
};

export default (state = INITIAL_STATE, action) => {
  switch (action.type) {
    case types.SIGNIN:
      return {
        ...state,
        isAuthenticated: true,
      };
    case types.SIGNOUT:
      return {
        ...INITIAL_STATE,
      };
    case types.INIT_DATA:
      return {
        ...state,
        usersList: action.payload.usersList,
        postsList: action.payload.postsList,
        verifyUsers: action.payload.verifyUsers,
        approvePosts: action.payload.approvePosts,
      };
    case types.BLOCK_USER_BY_EMAIL:
      return {
        ...state,
        usersList: state.usersList.map((user) => (user.email === action.payload ? { ...user, isBlocked: true } : user)),
      };
    case types.VERIFY_USER_BY_EMAIL:
      return {
        ...state,
        usersList: state.usersList.map((user) => (user.email === action.payload ? { ...user, isVerified: 2 } : user)),
        verifyUsers: state.verifyUsers.filter((user) => user.email !== action.payload),
      };
    case types.APPROVE_POST:
      return {
        ...state,
        postsList: state.postsList.map((post) =>
          post.postID === action.payload ? { ...post, isVerified: true } : post
        ),
        approvePosts: state.approvePosts.filter((post) => post.postID !== action.payload),
      };
    case types.BLOCK_POST:
      return {
        ...state,
        postsList: state.postsList.map((post) =>
          post.postID === action.payload ? { ...post, isVerified: false } : post
        ),
        approvePosts: state.approvePosts.push({
          ...state.postsList.find((post) => post.postID === action.payload),
          isVerified: false,
        }),
      };
    default:
      return state;
  }
};
