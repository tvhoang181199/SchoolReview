import * as types from "./types";

export default {
  signin: (payload) => ({ type: types.SIGNIN, payload }),
  signout: () => ({ type: types.SIGNOUT }),
  updateProfile: (payload) => ({ type: types.UPDATE_PROFILE, payload }),
  getAllNecessaryData: (payload) => ({ type: types.GET_ALL_NECESSARY_DATA, payload }),
  addBoard: (payload) => ({ type: types.ADD_BOARD, payload }),
  updateBoard: (payload) => ({ type: types.UPDATE_BOARD, payload }),
  shareBoard: (payload) => ({ type: types.SHARE_BOARD, payload }),
  deleteBoard: (payload) => ({ type: types.DELETE_BOARD, payload }),
  addCard: (payload) => ({ type: types.ADD_CARD, payload }),
  updateCard: (payload) => ({ type: types.UPDATE_CARD, payload }),
  deleteCard: (payload) => ({ type: types.DELETE_CARD, payload }),
};
