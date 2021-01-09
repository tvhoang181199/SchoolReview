import * as types from "./types";

const INITIAL_STATE = {
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
        token: action.payload.token,
        user: action.payload.user,
      };
    case types.SIGNOUT:
      return {
        ...INITIAL_STATE,
      };
    case types.UPDATE_PROFILE:
      return {
        ...state,
        user: {
          ...state.user,
          first_name: action.payload.first_name,
          last_name: action.payload.last_name,
        },
      };
    case types.GET_ALL_NECESSARY_DATA:
      return {
        ...state,
        boards: action.payload.boards,
        cards: action.payload.cards,
      };
    case types.ADD_BOARD:
      return {
        ...state,
        boards: [...state.boards, action.payload.board],
      };
    case types.UPDATE_BOARD:
      return {
        ...state,
        boards: state.boards.map((board) =>
          board.board_id === action.payload.board_id ? { ...board, name: action.payload.name } : board
        ),
      };
    case types.SHARE_BOARD:
      return {
        ...state,
        boards: state.boards.map((board) =>
          board.board_id === action.payload.board_id ? { ...board, permission: "public" } : board
        ),
      };
    case types.DELETE_BOARD:
      return {
        ...state,
        boards: state.boards.filter((board) => board.board_id !== action.payload.board_id),
      };
    case types.ADD_CARD:
      return {
        ...state,
        cards: [...state.cards, action.payload],
      };
    case types.UPDATE_CARD:
      return {
        ...state,
        cards: state.cards.map((card) => (card.card_id === action.payload.card_id ? { ...action.payload } : card)),
      };
    case types.DELETE_CARD:
      return {
        ...state,
        cards: state.cards.filter((card) => card.card_id !== action.payload.card_id),
      };
    default:
      return state;
  }
};
