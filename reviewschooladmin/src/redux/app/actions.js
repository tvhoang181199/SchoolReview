import * as types from "./types";

export default {
  signin: () => ({ type: types.SIGNIN }),
  signout: () => ({ type: types.SIGNOUT }),
  initData: (payload) => ({ type: types.INIT_DATA, payload }),
  blockUserByEmail: (payload) => ({ type: types.BLOCK_USER_BY_EMAIL, payload }),
  verifyUserByEmail: (payload) => ({ type: types.VERIFY_USER_BY_EMAIL, payload }),
  approvePost: (payload) => ({ type: types.APPROVE_POST, payload }),
  blockPost: (payload) => ({ type: types.BLOCK_POST, payload }),
};
