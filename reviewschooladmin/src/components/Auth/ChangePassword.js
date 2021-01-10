import React, { useState } from "react";
import { Grid, Typography, TextField, Button, Breadcrumbs, Link, makeStyles } from "@material-ui/core";
import Divider from "@material-ui/core/Divider";
import HomeIcon from "@material-ui/icons/Home";
import VpnKeyIcon from "@material-ui/icons/VpnKey";
import { Link as RouteLink } from "react-router-dom";

const useStyles = makeStyles((theme) => ({
  link: {
    display: "flex",
  },
  icon: {
    marginRight: theme.spacing(0.5),
    width: 20,
    height: 20,
  },
  label: {
    minWidth: 220,
  },
}));

function handleClick(event) {
  event.preventDefault();
  console.info("You clicked a breadcrumb.");
}

function ChangePassword() {
  const classes = useStyles();
  const [newPassword, setNewPassword] = useState("");

  return (
    <div>
      <Grid
        container
        spacing={1}
        direction="column"
        justify="center"
        alignItems="flex-start"
        alignContent="center"
        wrap="nowrap"
        style={{ padding: 40 }}
      >
        <Grid item xs={12}>
          <Breadcrumbs aria-label="breadcrumb">
            <Link color="inherit" to="/" component={RouteLink} className={classes.link}>
              <HomeIcon className={classes.icon} />
              Home
            </Link>
            <Typography color="textPrimary" className={classes.link}>
              <VpnKeyIcon className={classes.icon} />
              Change password
            </Typography>
          </Breadcrumbs>
        </Grid>
        <Grid item xs={12} style={{ width: "100%", padding: "10px 0" }}>
          <Divider />
        </Grid>
        <Grid item container xs={12} spacing={1}>
          <Grid item container spacing={1} xs={12}>
            <Grid item>
              <Typography variant="h6" color="initial" className={classes.label}>
                Current password:
              </Typography>
            </Grid>
            <Grid item>
              <TextField
                id="currentPassword"
                size="small"
                onChange={(e) => setNewPassword(e.target.value)}
                variant="outlined"
              />
            </Grid>
          </Grid>
          <Grid item container spacing={1} xs={12}>
            <Grid item>
              <Typography variant="h6" color="initial" className={classes.label}>
                New password:
              </Typography>
            </Grid>
            <Grid item>
              <TextField
                id="newPassword"
                size="small"
                onChange={(e) => setNewPassword(e.target.value)}
                variant="outlined"
              />
            </Grid>
          </Grid>
          <Grid item container spacing={1} xs={12}>
            <Grid item>
              <Typography variant="h6" color="initial" className={classes.label}>
                Re-type new password:
              </Typography>
            </Grid>
            <Grid item>
              <TextField
                id="renewPassword"
                size="small"
                onChange={(e) => setNewPassword(e.target.value)}
                variant="outlined"
              />
            </Grid>
          </Grid>
        </Grid>
        <Grid item xs={12}>
          <Button variant="contained" color="primary">
            Save
          </Button>
        </Grid>
      </Grid>
    </div>
  );
}

export default ChangePassword;
