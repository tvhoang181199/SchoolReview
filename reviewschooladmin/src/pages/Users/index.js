import React, { useEffect } from "react";

import Table from "../../components/Table";
import { Typography, Breadcrumbs, Link, Button, Grid } from "@material-ui/core";
import { makeStyles } from "@material-ui/core/styles";
import { Home, PeopleAlt } from "@material-ui/icons";
import { Link as RouteLink } from "react-router-dom";
import queryString from "query-string";
import AddIcon from "@material-ui/icons/Add";
import { useSelector } from "react-redux";

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

function Users(props) {
  const classes = useStyles();
  const usersList = useSelector((state) => state.app.usersList);

  const searchOptions = props.location.search ? queryString.parse(props.location.search) : null;
  const generateData = (usersList) => {
    return (usersList || []).map((user, i) => {
      const stt = i + 1;
      const email = user.email;
      const name = user.name;
      const verified = user.isVerified ? "True" : "False";
      const blocked = user.isBlocked ? "True" : "False";
      const actions = user._id;
      return { stt, email, name, verified, blocked, actions };
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
  let users = usersList;
  if (searchOptions) {
    const key = Object.keys(searchOptions)[0];
    users = users.filter((item) => item[key].toLowerCase().includes(searchOptions[key].toLowerCase()));
  }

  const data = React.useMemo(() => generateData(users), [users]);

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
        <Grid container justify="flex-end" style={{ marginBottom: "10px" }}>
          <Grid item>
            <Button color="primary" variant="contained" startIcon={<AddIcon />}>
              Add new user
            </Button>
          </Grid>
        </Grid>
        <Table columns={columns} data={data} />
      </div>
    </div>
  );
}

export default Users;
