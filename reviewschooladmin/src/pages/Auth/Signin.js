import React, { useState } from "react";
import { Grid, makeStyles, TextField, Typography, Button, Dialog, DialogContent } from "@material-ui/core";
// import { startLoginAdmin } from "../../action/auth/action";
// import { connect } from "react-redux";
import CustomizedSnackbars from "../../components/CustomizedSnackbars";
import SupervisorAccountIcon from "@material-ui/icons/SupervisorAccount";
import Avatar from "@material-ui/core/Avatar";
import Link from "@material-ui/core/Link";
import { withRouter } from "react-router-dom";
import { auth } from "../../services/firebase";
import actions from "../../redux/app/actions";
import { useDispatch } from "react-redux";

const Signin = (props) => {
  const classes = useStyles();
  const [message, setMessage] = useState(null);
  const dispatch = useDispatch();

  const handleSubmitLogin = (e) => {
    e.preventDefault();
    const username = e.target.elements.username.value;
    const password = e.target.elements.password.value;

    auth()
      .signInWithEmailAndPassword(username, password)
      .then((user) => {
        console.log({ user });
        dispatch(actions.signin());
      })
      .catch((error) => {
        var errorCode = error.code;
        var errorMessage = error.message;
        setMessage({ type: "error", content: `${errorMessage}`, open: true });
      });
  };

  return (
    <div>
      <Grid container style={{ minHeight: "100vh" }}>
        <Dialog open={true} onClose={() => false} maxWidth="lg">
          <DialogContent>
            <Grid container direction="column" alignItems="center" className={classes.dialog}>
              <Avatar className={classes.avatar}>
                <SupervisorAccountIcon />
              </Avatar>
              <Typography variant="h5" color="initial">
                WELCOME
              </Typography>
              <Typography variant="body2" color="initial">
                PLEASE LOGIN TO ADMIN DASHBOARD
              </Typography>
              <form className={classes.form} noValidate onSubmit={handleSubmitLogin}>
                <TextField
                  id="username"
                  autoComplete="username"
                  fullWidth
                  margin="normal"
                  required
                  label="Username"
                  variant="outlined"
                  className={classes.textFiled}
                />
                <TextField
                  id="password"
                  autoComplete="password"
                  fullWidth
                  margin="normal"
                  required
                  label="Password"
                  variant="outlined"
                  type="password"
                  className={classes.textFiled}
                />
                <Button type="submit" variant="contained" color="primary" className={classes.button}>
                  Log In
                </Button>
              </form>
            </Grid>
          </DialogContent>
        </Dialog>
      </Grid>
      <CustomizedSnackbars message={message} />
    </div>
  );
};

const useStyles = makeStyles((theme) => ({
  root: {
    width: 600,
    height: "auto",
  },
  dialog: {
    "& > *": {
      margin: "10px 0",
    },
  },
  form: {
    display: "flex",
    flexDirection: "column",
  },
  textFiled: {
    width: 320,
    margin: "10px auto",
  },
  button: {
    width: "50%",
    margin: "10px auto",
  },
  avatar: {
    margin: theme.spacing(1),
    backgroundColor: theme.palette.secondary.main,
  },
}));
// const mapStateToProps = (state) => {
//   return {
//     token: state.auth.token
//   }
// }
// const mapDispatchToProps = { login: startLoginAdmin };
// export default connect(mapStateToProps, mapDispatchToProps)(withRouter(Signin));

export default Signin;
