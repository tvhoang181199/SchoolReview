import React, { useState, useEffect } from "react";
import { Typography, Breadcrumbs, Link, makeStyles, Grid } from "@material-ui/core";
import HomeIcon from "@material-ui/icons/Home";
import PeopleAltIcon from "@material-ui/icons/PeopleAlt";
import GamesIcon from "@material-ui/icons/Games";
import { Link as RouterLink } from "react-router-dom";

import "./style.css";
import { userApi, postApi } from "../../services";
import Loading from "../../components/Loading";
import { useDispatch, useSelector } from "react-redux";
import actions from "../../redux/app/actions";

const useStyles = makeStyles((theme) => ({
  link: {
    display: "flex",
  },
  icon: {
    marginRight: theme.spacing(0.5),
    width: 22,
    height: 22,
  },
  label: {
    minWidth: 220,
  },
  box: {
    margin: "10px 0",
    background: "#ddd",
    boxShadow: "0 2px 8px grey",
    borderRadius: 8,
    width: "100%",
  },
}));

const Dashboard = (props) => {
  const classes = useStyles();
  const dispatch = useDispatch();
  const usersList = useSelector((state) => state.app.usersList);
  const postsList = useSelector((state) => state.app.postsList);
  const verifyUsers = useSelector((state) => state.app.verifyUsers);
  const approvePosts = useSelector((state) => state.app.approvePosts);
  const [loading, setLoading] = useState(true);

  const getAllData = async () => {
    const usersList = await userApi.getUsersList();
    const postsList = await postApi.getPostsList();
    const verifyUsers = usersList.filter((user) => user.verify !== 2);
    const approvePosts = postsList.filter((post) => !post.verify);
    dispatch(actions.initData({ usersList, postsList, verifyUsers, approvePosts }));
    setLoading(false);
  };

  useEffect(() => {
    getAllData();
  }, []);

  return (
    <div className={classes.root}>
      {loading ? (
        <Loading />
      ) : (
        <>
          <Breadcrumbs aria-label="breadcrumb">
            <Typography variant="body1" color="textPrimary" className={classes.link}>
              <HomeIcon className={classes.icon} />
              Dashboard
            </Typography>
          </Breadcrumbs>

          <Grid container spacing={2} direction="row" className={classes.box}>
            <Grid item lg={3} xs={6}>
              <div className="small-box bg-info">
                <div className="inner">
                  <h3>{usersList ? usersList.length : 0}</h3>
                  <p>Users</p>
                </div>
                <div className="icon">
                  <PeopleAltIcon />
                </div>
                <Link to="/users" className="small-box-footer" component={RouterLink}>
                  More info
                </Link>
              </div>
            </Grid>

            <Grid item lg={3} xs={6}>
              <div className="small-box bg-success">
                <div className="inner">
                  <h3>{verifyUsers ? verifyUsers.length : 0}</h3>
                  <p>Verify Users</p>
                </div>
                <div className="icon">
                  <PeopleAltIcon />
                </div>
                <Link to="/users" className="small-box-footer" component={RouterLink}>
                  More info
                </Link>
              </div>
            </Grid>

            <Grid item lg={3} xs={6}>
              <div className="small-box bg-warning">
                <div className="inner">
                  <h3>{postsList ? postsList.length : 0}</h3>
                  <p>Posts</p>
                </div>
                <div className="icon">
                  <GamesIcon />
                </div>
                <Link to="/posts" className="small-box-footer" component={RouterLink}>
                  More info
                </Link>
              </div>
            </Grid>

            <Grid item lg={3} xs={6}>
              <div className="small-box bg-error">
                <div className="inner">
                  <h3>{approvePosts ? approvePosts.length : 0}</h3>
                  <p>Approve Posts</p>
                </div>
                <div className="icon">
                  <PeopleAltIcon />
                </div>
                <Link to="/users" className="small-box-footer" component={RouterLink}>
                  More info
                </Link>
              </div>
            </Grid>
          </Grid>
        </>
      )}
    </div>
  );
};

export default Dashboard;
