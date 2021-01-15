import React, { useEffect } from "react";

import Table from "../../components/Table";
import { Typography, Breadcrumbs, Link, Button, Grid } from "@material-ui/core";
import { makeStyles } from "@material-ui/core/styles";
import { Home } from "@material-ui/icons";
import { Link as RouteLink } from "react-router-dom";
import { useDispatch, useSelector } from "react-redux";
import { postApi } from "../../services";
import actions from "../../redux/app/actions";
import PostAddIcon from "@material-ui/icons/PostAdd";
import moment from "moment";

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
  container: {
    margin: "10px 0",
    background: "#ddd",
    boxShadow: "0 2px 8px grey",
    borderRadius: 8,
    padding: 15,
  },
}));

function ApprovePosts(props) {
  const classes = useStyles();
  const dispatch = useDispatch();
  const approvePosts = useSelector((state) => state.app.approvePosts);

  const generateData = (postsList) => {
    return (postsList || []).map((post, i) => {
      const stt = i + 1;
      const title = post.title;
      const author = post.userName;
      const likes = post.likedUsers ? `${post.likedUsers.length} likes` : "0 like";
      const comments = post.comments ? `${post.comments.length} comments` : "0 comment";
      const verified = post.isVerified ? "Approved" : "Approve Pending";
      const blocked = post.isBlocked ? "True" : "False";
      const actions = post.postID;
      const tableType = "approvepost";
      const date = moment(post.createdDate.seconds).format("DD-MM-YYYY hh:mm:ss");
      return { stt, title, author, comments, likes, verified, date, blocked, actions, tableType };
    });
  };

  const columns = React.useMemo(
    () => [
      {
        Header: "STT",
        accessor: "stt",
      },
      {
        Header: "Title",
        accessor: "title",
      },
      {
        Header: "Author",
        accessor: "author",
      },
      {
        Header: "Date",
        accessor: "date",
      },
      {
        Header: "Likes",
        accessor: "likes",
      },
      {
        Header: "Comments",
        accessor: "comments",
      },
      {
        Header: "Verified",
        accessor: "verified",
      },
      {
        Header: "Actions",
        accessor: "actions",
        disableSortBy: true,
      },
    ],
    []
  );

  const data = React.useMemo(() => generateData(approvePosts), [approvePosts]);

  const submitApprovePost = async (postID) => {
    try {
      await postApi.approvePost(postID);
      dispatch(actions.approvePost(postID));
    } catch (error) {}
  };

  const handleApprovePost = (postID) => {
    submitApprovePost(postID);
  };

  return (
    <div>
      <Breadcrumbs aria-label="breadcrumb">
        <Link color="inherit" to="/" component={RouteLink} className={classes.link}>
          <Home className={classes.icon} />
          <Typography variant="body1" style={{ color: "inherit" }}>
            Dashboard
          </Typography>
        </Link>
        <Typography variant="body1" color="textPrimary" className={classes.link}>
          <PostAddIcon className={classes.icon} />
          Approve Posts
        </Typography>
      </Breadcrumbs>
      <div className={classes.container}>
        <Table columns={columns} data={data} approvePosts={handleApprovePost} />
      </div>
    </div>
  );
}

export default ApprovePosts;
