import React from "react";
import { useSelector } from "react-redux";
import { Link as RouteLink, useParams } from "react-router-dom";
import { Breadcrumbs, Grid, Link, makeStyles, Typography } from "@material-ui/core";
import { Home, PeopleAlt } from "@material-ui/icons";
import PersonIcon from "@material-ui/icons/Person";
import PostDetail from "../Posts/PostDetail";

const avatarImage = "https://www.winhelponline.com/blog/wp-content/uploads/2017/12/user.png";

function ViewUser(props) {
  const classes = useStyles();
  const userID = useParams().id;
  const usersList = useSelector((state) => state.app.usersList);
  const postsList = useSelector((state) => state.app.postsList);
  const user = usersList.find((user) => user.userID === userID);
  const posts = postsList.filter((post) => post.userID === userID);
  console.log({ userID, user, posts });

  return (
    <div>
      <Breadcrumbs aria-label="breadcrumb">
        <Link color="inherit" to="/" component={RouteLink} className={classes.link}>
          <Home className={classes.icon} />
          <Typography variant="body1" style={{ color: "inherit" }}>
            Dashboard
          </Typography>
        </Link>
        <Link color="inherit" to="/users" component={RouteLink} className={classes.link}>
          <PeopleAlt className={classes.icon} />
          <Typography variant="body1" style={{ color: "inherit" }}>
            Users
          </Typography>
        </Link>
        <Typography variant="body1" color="textPrimary" className={classes.link}>
          <PersonIcon className={classes.icon} />
          View User
        </Typography>
      </Breadcrumbs>
      <div className={classes.container}>
        <Grid container direction="row">
          <Grid container direction="column" item xs={3} style={{ height: "fit-content" }}>
            <Grid item xs={12} className={classes.profile}>
              <img src={avatarImage} width={100} height={100} />
              <Typography className={classes.name} variant="body1" color="initial">
                {user.name}
              </Typography>
              <Typography className={classes.email} variant="body2" color="initial">
                {user.email}
              </Typography>
            </Grid>
          </Grid>
          <Grid container direction="column" item xs={9}>
            <Grid item xs={12} className={classes.posts}>
              {posts.map((post, i) => (
                <PostDetail key={i} post={post} />
              ))}
            </Grid>
          </Grid>
        </Grid>
      </div>
    </div>
  );
}

export default ViewUser;

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
    marginLeft: 25,
    padding: 15,
  },
}));
