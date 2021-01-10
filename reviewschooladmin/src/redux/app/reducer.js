import * as types from "./types";

const INITIAL_STATE = {
  isAuthenticated: false,
  token: "",
  user: {},
  boards: [],
  cards: [],
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
    default:
      return state;
  }
};
