import axios from "axios";
// import { getToken } from "./../services/appAPI";

const createAxios = () =>
  axios.create({
    baseURL: "",
    timeout: 20000,
    headers: {
      Accept: "application/json",
    },
  });

const axiosInstance = createAxios();

axiosInstance.interceptors.request.use(
  async (config) => {
    // const token = await getToken();
    // config.headers.Authorization = "JWT " + token;
    return config;
  },
  (error) => Promise.reject(error)
);

axiosInstance.interceptors.response.use(
  (response) => {
    return response.data;
  },
  (error) => Promise.reject(error)
);

export default axiosInstance;
