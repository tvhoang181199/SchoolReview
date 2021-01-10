import React, { useEffect } from "react";
import "./App.css";
import { BrowserRouter as Router, Switch, Route, useHistory } from "react-router-dom";
import { actions } from "./redux";
import { useDispatch, useSelector } from "react-redux";
import { auth, db } from "./services/firebase";
import Header from "./components/Header";
import Profile from "./pages/Auth/Profile";
import Signin from "./pages/Auth/Signin";

const Routing = () => {
  // const history = useHistory();
  // const dispatch = useDispatch();

  // const fetchData = async (user, token) => {
  //   const boards = await boardApi.getBoards(token);
  //   const cards = await cardApi.getCards(token);
  //   const data = { boards, cards };
  //   dispatch(actions.getAllNecessaryData(data));
  //   dispatch(actions.signin({ user, token }));
  // };

  // useEffect(() => {
  //   const user = JSON.parse(localStorage.getItem("user"));
  //   const token = JSON.parse(localStorage.getItem("token"));
  //   if (!user && !token) {
  //     history.push("/signin");
  //   } else {
  //     fetchData(user, token);
  //   }
  // }, []);

  const fetchBlogs = async () => {
    const response = db.collection("users");
    const data = await response.get();
    data.docs.forEach((item) => {
      console.log({ item });
    });
  };

  useEffect(() => {
    fetchBlogs();
  }, []);

  return (
    <Switch>
      <Route path="/" exact component={Signin} />
      <Route path="/profile" exact component={Profile} />
      {/* <Route path="/" exact component={Board} /> */}
      {/* <Route path="/:id" component={BoardView} /> */}
      <Route redirect="/signin" />
    </Switch>
  );
};

function App() {
  return (
    <Router>
      <Header />
      <Routing />
    </Router>
  );
}

export default App;
