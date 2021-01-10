import { backEndApi } from "../utils";

export default {
  getBoards: (token) =>
    backEndApi.get(`/api/boards`, {
      headers: {
        Authorization: "Bearer " + token,
      },
    }),
  addBoard: (data, token) =>
    backEndApi.post(`/api/boards/create`, data, {
      headers: {
        Authorization: "Bearer " + token,
      },
    }),
  updateBoard: (data, token) =>
    backEndApi.put(`api/boards/update`, data, {
      headers: {
        Authorization: "Bearer " + token,
      },
    }),
  deleteBoard: (data, token) =>
    backEndApi.delete(`api/boards/delete?board_id=${data.board_id}`, {
      headers: {
        Authorization: "Bearer " + token,
      },
    }),
  shareBoard: (data, token) =>
    backEndApi.put(`api/boards/share`, data, {
      headers: {
        Authorization: "Bearer " + token,
      },
    }),
};
