import { backEndApi } from "../utils";

export default {
  signin: (data) => backEndApi.post(`/api/auth/signin`, data),
  signinWithThirdParty: (data) => backEndApi.post(`/api/auth/signinthirdparty`, data),
  signup: (data) => backEndApi.post(`/api/auth/signup`, data),
  updateProfile: (data, token) =>
    backEndApi.put(`api/auth/update`, data, {
      headers: {
        Authorization: "Bearer " + token,
      },
    }),
};
