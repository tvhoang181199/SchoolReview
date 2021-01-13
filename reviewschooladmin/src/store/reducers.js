import { combineReducers } from "redux";
import { reducers } from "./../redux";

export default function createReducer() {
  return combineReducers(reducers);
}
