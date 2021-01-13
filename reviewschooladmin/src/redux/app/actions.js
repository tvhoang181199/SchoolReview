import * as types from "./types";

export default {
  signin: () => ({ type: types.SIGNIN }),
  signout: () => ({ type: types.SIGNOUT }),
  initData: (payload) => ({ type: types.INIT_DATA, payload }),
};
