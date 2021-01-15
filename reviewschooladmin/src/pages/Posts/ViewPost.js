import React from "react";
import { useSelector } from "react-redux";
import { Link as RouteLink, useParams } from "react-router-dom";
import { Breadcrumbs, Grid, Link, makeStyles, Typography } from "@material-ui/core";
import { Home, PeopleAlt } from "@material-ui/icons";
import AssignmentIcon from "@material-ui/icons/Assignment";
import PersonIcon from "@material-ui/icons/Person";
import PostDetail from "./PostDetail";
import AssignmentTurnedInIcon from "@material-ui/icons/AssignmentTurnedIn";

function ViewPost(props) {
  const classes = useStyles();
  const postID = useParams().id;
  const postsList = useSelector((state) => state.app.postsList);
  const post = postsList.find((post) => post.postID === postID);
  console.log({ post });

  return (
    <div>
      <Breadcrumbs aria-label="breadcrumb">
        <Link color="inherit" to="/" component={RouteLink} className={classes.link}>
          <Home className={classes.icon} />
          <Typography variant="body1" style={{ color: "inherit" }}>
            Dashboard
          </Typography>
        </Link>
        <Link color="inherit" to="/posts" component={RouteLink} className={classes.link}>
          <AssignmentTurnedInIcon className={classes.icon} />
          <Typography variant="body1" style={{ color: "inherit" }}>
            Posts
          </Typography>
        </Link>
        <Typography variant="body1" color="textPrimary" className={classes.link}>
          <AssignmentIcon className={classes.icon} />
          View Post
        </Typography>
      </Breadcrumbs>
      <div className={classes.container}>
        <Grid container direction="row">
          <Grid item xs={12} className={classes.posts}>
            <PostDetail post={post} />
          </Grid>
        </Grid>
      </div>
    </div>
  );
}

export default ViewPost;

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
  },
  profile: {
    background: "#ddd",
    boxShadow: "0 2px 8px grey",
    borderRadius: 8,
    padding: 15,
    textAlign: "center",
  },
  name: {
    color: "black",
    fontSize: 18,
    fontWeight: "bold",
    overflowWrap: "anywhere",
  },
  email: {
    color: "#929292",
    fontSize: 16,
    fontWeight: "300",
    overflowWrap: "anywhere",
  },
  posts: {
    background: "#ddd",
    boxShadow: "0 2px 8px grey",
    borderRadius: 8,
    padding: 15,
  },
}));
