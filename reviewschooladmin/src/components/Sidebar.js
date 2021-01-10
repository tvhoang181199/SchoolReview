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
import InboxIcon from "@material-ui/icons/MoveToInbox";
import MailIcon from "@material-ui/icons/Mail";
import IconButton from "@material-ui/core/IconButton";
import MenuIcon from "@material-ui/icons/Menu";
import ChevronLeftIcon from "@material-ui/icons/ChevronLeft";
import ChevronRightIcon from "@material-ui/icons/ChevronRight";
import VpnKeyIcon from "@material-ui/icons/VpnKey";
import PersonIcon from "@material-ui/icons/Person";
import ExitToAppIcon from "@material-ui/icons/ExitToApp";
import SupervisorAccountIcon from "@material-ui/icons/SupervisorAccount";
import SportsEsportsIcon from "@material-ui/icons/SportsEsports";
import clsx from "clsx";

import { Link } from "@material-ui/core";
import { Link as RouterLink, useHistory } from "react-router-dom";

// import IcAdmin from "../../assets/images/icon-admin.png";
// import { startLogout } from "../../action/auth/action";
// import { connect } from "react-redux";

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
      redirect: () => history.push("/admin/manageuser"),
    },
    {
      icon: <SportsEsportsIcon />,
      text: "Reviews",
      redirect: () => history.push("/admin/managegame"),
    },
    {
      icon: <SupervisorAccountIcon />,
      text: "Verify User",
      redirect: () => history.push("/admin/managegame"),
    },
    {
      icon: <SportsEsportsIcon />,
      text: "Approve Post",
      redirect: () => history.push("/admin/managegame"),
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
        {/* <img src={""} height={40} weight={40} style={{ margin: "auto" }} /> */}
        <RouterLink to="/admin" style={{ margin: "auto" }}>
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
// const mapDispatchToProps = { logout: startLogout };
// export default connect(null, mapDispatchToProps)(Sidebar);

export default Sidebar;
