import { createStore, applyMiddleware } from "redux";
import { createLogger } from "redux-logger";
import createReducer from "./reducers";

const configureStore = (initialState = {}) => {
  const rootReducer = createReducer();
  const loggerMiddleware = createLogger({ collapsed: true });

  const store = createStore(rootReducer, initialState, applyMiddleware(loggerMiddleware));

  return store;
};

export default configureStore;
