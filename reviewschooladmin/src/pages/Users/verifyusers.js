import React, { useEffect } from "react";

import Table from "../../components/Table";
import { Typography, Breadcrumbs, Link, Button, Grid } from "@material-ui/core";
import { makeStyles } from "@material-ui/core/styles";
import { Home, PeopleAlt } from "@material-ui/icons";
import { Link as RouteLink } from "react-router-dom";
import queryString from "query-string";
import { useDispatch, useSelector } from "react-redux";
import actions from "../../redux/app/actions";
import { userApi } from "../../services";

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

function VerifyUsers(props) {
  const classes = useStyles();
  const dispatch = useDispatch();
  const verifyUsers = useSelector((state) => state.app.verifyUsers);

  const searchOptions = props.location.search ? queryString.parse(props.location.search) : null;
  const generateData = (verifyUsers) => {
    return (verifyUsers || []).map((user, i) => {
      const stt = i + 1;
      const email = user.email;
      const name = user.name;
      const verified = user.isVerified === 0 ? "Not Verify" : user.isVerified === 1 ? "Pending" : "Verified";
      const blocked = user.isBlocked ? "True" : "False";
      const actions = user.userID;
      const tableType = "verifyuser";
      return { stt, email, name, verified, blocked, actions, tableType };
    });
  };

  const columns = React.useMemo(
    () => [
      {
        Header: "STT",
        accessor: "stt",
      },
      {
        Header: "Email",
        accessor: "email",
      },
      {
        Header: "Name",
        accessor: "name",
      },
      {
        Header: "Verified",
        accessor: "verified",
        disableSortBy: true,
      },
      {
        Header: "Blocked",
        accessor: "blocked",
        disableSortBy: true,
      },
      {
        Header: "Actions",
        accessor: "actions",
        disableSortBy: true,
      },
    ],
    []
  );
  // let users = usersList;
  // if (searchOptions) {
  //   const key = Object.keys(searchOptions)[0];
  //   users = users.filter((item) => item[key].toLowerCase().includes(searchOptions[key].toLowerCase()));
  // }

  const submitVerifyUser = async (email) => {
    try {
      await userApi.verifyUserByEmail(email);
      dispatch(actions.verifyUserByEmail(email));
    } catch (error) {
      console.log(error);
    }
  };

  const handleVerifyUser = (userID) => {
    const user = verifyUsers.find((user) => user.userID === userID);
    submitVerifyUser(user.email);
  };

  const data = React.useMemo(() => generateData(verifyUsers), [verifyUsers]);

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
          <PeopleAlt className={classes.icon} />
          Users
        </Typography>
      </Breadcrumbs>
      <div className={classes.container}>
        <Table columns={columns} data={data} verifyUser={handleVerifyUser} />
      </div>
    </div>
  );
}

export default VerifyUsers;
