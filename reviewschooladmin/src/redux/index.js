const importAll = (r, hasDefault) => {
  return r.keys().map((e) => {
    const path = e.split("/");
    return {
      name: path.slice(-1)[0].split(".")[0].toUpperCase(),
      key: path.reverse()[1],
      data: hasDefault ? r(e).default : r(e),
    };
  });
};

const rawActions = importAll(require.context("./", true, /actions.js$/i), true);
const rawTypes = importAll(require.context("./", true, /types.js$/i));
const rawReducers = importAll(require.context("./", true, /reducer.js$/i), true);

export const actions = rawActions.reduce((p, e) => ({ ...p, ...e.data }), {});
export const types = rawTypes.reduce((p, e) => ({ ...p, ...e.data }), {});
export const reducers = rawReducers.reduce((p, e) => ({ ...p, [e.key]: e.data }), {});
