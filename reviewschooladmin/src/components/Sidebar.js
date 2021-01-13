/*eslint-disable*/
import React from "react";
// @material-ui/core components
import { makeStyles, useTheme } from "@material-ui/core/styles";
import Drawer from "@material-ui/core/Drawer";
import List from "@material-ui/core/List";
import Typography from "@material-ui/core/Typography";
import Divider from "@material-ui/core/Divider";
import ListItem from "@material-ui/core/ListItem";
import ListItemIcon from "@material-ui/core/ListItemIcon";
import ListItemText from "@material-ui/core/ListItemText";
import IconButton from "@material-ui/core/IconButton";
import ChevronLeftIcon from "@material-ui/icons/ChevronLeft";
import ChevronRightIcon from "@material-ui/icons/ChevronRight";
import ExitToAppIcon from "@material-ui/icons/ExitToApp";
import SupervisorAccountIcon from "@material-ui/icons/SupervisorAccount";
import AssignmentTurnedInIcon from "@material-ui/icons/AssignmentTurnedIn";
import clsx from "clsx";
import PostAddIcon from "@material-ui/icons/PostAdd";
import PersonAddIcon from "@material-ui/icons/PersonAdd";

import { Link } from "@material-ui/core";
import { Link as RouterLink, useHistory } from "react-router-dom";

const drawerWidth = 240;

const useStyles = makeStyles((theme) => ({
  root: {
    display: "flex",
  },
  appBar: {
    zIndex: theme.zIndex.drawer + 1,
    transition: theme.transitions.create(["width", "margin"], {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.leavingScreen,
    }),
  },
  appBarShift: {
    marginLeft: drawerWidth,
    width: `calc(100% - ${drawerWidth}px)`,
    transition: theme.transitions.create(["width", "margin"], {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.enteringScreen,
    }),
  },
  menuButton: {
    marginRight: 36,
  },
  hide: {
    display: "none",
  },
  drawer: {
    width: drawerWidth,
    flexShrink: 0,
    whiteSpace: "nowrap",
  },
  drawerOpen: {
    width: drawerWidth,
    color: "white",
    background: "#3e435f",
    transition: theme.transitions.create("width", {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.enteringScreen,
    }),
  },
  drawerClose: {
    color: "white",
    background: "#3e435f",
    transition: theme.transitions.create("width", {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.leavingScreen,
    }),
    overflowX: "hidden",
    width: theme.spacing(7) + 1,
    [theme.breakpoints.up("sm")]: {
      width: theme.spacing(9) + 1,
    },
  },
  toolbar: {
    display: "flex",
    alignItems: "center",
    justifyContent: "flex-end",
    padding: theme.spacing(0, 1),
    // necessary for content to be below app bar
    ...theme.mixins.toolbar,
  },
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
}));

const Sidebar = ({ onDrawerClose, open, logout }) => {
  const classes = useStyles();
  const history = useHistory();
  const theme = useTheme();

  const dataList = [
    {
      icon: <SupervisorAccountIcon />,
      text: "Users",
      redirect: () => history.push("/users"),
    },
    {
      icon: <PersonAddIcon />,
      text: "Verify User",
      redirect: () => history.push("/verifyusers"),
    },
    {
      icon: <AssignmentTurnedInIcon />,
      text: "Post",
      redirect: () => history.push("/posts"),
    },
    {
      icon: <PostAddIcon />,
      text: "Approve Post",
      redirect: () => history.push("/approveposts"),
    },
  ];

  const actionsList = [
    // {
    //   icon: <VpnKeyIcon />,
    //   text: "Change password",
    //   redirect: () => history.push("/admin/changepassword"),
    // },
    // {
    //   icon: <PersonIcon />,
    //   text: "Edit profile",
    //   redirect: () => history.push("/admin/profile"),
    // },
    {
      icon: <ExitToAppIcon />,
      text: "Log out",
      redirect: () => {
        logout();
        history.push("/");
      },
    },
  ];

  return (
    <Drawer
      variant="permanent"
      className={clsx(classes.drawer, {
        [classes.drawerOpen]: open,
        [classes.drawerClose]: !open,
      })}
      classes={{
        paper: clsx({
          [classes.drawerOpen]: open,
          [classes.drawerClose]: !open,
        }),
      }}
    >
      <div className={classes.toolbar} style={{ display: "flex", justifyContent: "space-around" }}>
        <RouterLink to="/" style={{ margin: "auto" }}>
          <Typography variant="h6" style={{ color: "white" }}>
            Admin Desktop
          </Typography>
        </RouterLink>
        <IconButton onClick={onDrawerClose}>
          {theme.direction === "rtl" ? (
            <ChevronRightIcon style={{ color: "white" }} />
          ) : (
            <ChevronLeftIcon style={{ color: "white" }} />
          )}
        </IconButton>
      </div>
      <Divider />
      <List>
        {dataList.map((data, index) => (
          <ListItem button key={data.text} onClick={data.redirect}>
            <ListItemIcon style={{ color: "white" }}>{data.icon}</ListItemIcon>
            <ListItemText primary={data.text} />
          </ListItem>
        ))}
      </List>
      <Divider />
      <List>
        {actionsList.map((data, index) => (
          <ListItem button key={data.text} onClick={data.redirect}>
            <ListItemIcon style={{ color: "white" }}>{data.icon}</ListItemIcon>
            <ListItemText primary={data.text} />
          </ListItem>
        ))}
      </List>
    </Drawer>
  );
};

export default Sidebar;
