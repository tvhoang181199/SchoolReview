import { backEndApi } from "../utils";

export default {
  getCards: (token) =>
    backEndApi.get(`/api/cards`, {
      headers: {
        Authorization: "Bearer " + token,
      },
    }),
  addCard: (data, token) =>
    backEndApi.post(`/api/cards/create`, data, {
      headers: {
        Authorization: "Bearer " + token,
      },
    }),
  updateCard: (data, token) =>
    backEndApi.put(`api/cards/update`, data, {
      headers: {
        Authorization: "Bearer " + token,
      },
    }),
  deleteCard: (data, token) =>
    backEndApi.delete(`api/cards/delete?card_id=${data.card_id}`, {
      headers: {
        Authorization: "Bearer " + token,
      },
    }),
};
