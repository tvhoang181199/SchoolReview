import React, { useEffect } from "react";
import "./App.css";
import { BrowserRouter as Router, Switch, Route, useHistory } from "react-router-dom";
import { actions } from "./redux";
import { useDispatch, useSelector } from "react-redux";
import { auth, db } from "./services/firebase";
import Profile from "./pages/Auth/Profile";
import Signin from "./pages/Auth/Signin";
import AdminLayout from "./components/AdminLayout";
import Dashboard from "./pages/Dashboard";
import Users from "./pages/Users";
import Posts from "./pages/Posts";
import VerifyUsers from "./pages/Users/VerifyUsers";
import ViewUser from "./pages/Users/ViewUser";
import ViewPost from "./pages/Posts/ViewPost";
import ApprovePosts from "./pages/Posts/ApprovePosts";

const Routing = (props) => {
  if (props.isAuthenticated) {
    return (
      <AdminLayout>
        <Switch>
          <Route path="/" exact component={Dashboard} />
          <Route path="/users" exact component={Users} />
          <Route path="/users/:id" component={ViewUser} />
          <Route path="/verifyusers" exact component={VerifyUsers} />
          <Route path="/posts" exact component={Posts} />
          <Route path="/posts/:id" component={ViewPost} />
          <Route path="/approveposts" exact component={ApprovePosts} />
          <Route redirect="/" />
        </Switch>
      </AdminLayout>
    );
  } else {
    return (
      <Switch>
        <Route path="/" exact component={Signin} />
        <Route redirect="/" />
      </Switch>
    );
  }
};

function App() {
  const isAuthenticated = useSelector((state) => state.app.isAuthenticated);
  const dispatch = useDispatch();

  useEffect(() => {
    const user = JSON.parse(localStorage.getItem("user"));
    if (user) dispatch(actions.signin());
  }, []);

  return (
    <Router>
      <Routing isAuthenticated={isAuthenticated} />
    </Router>
  );
}

export default App;
