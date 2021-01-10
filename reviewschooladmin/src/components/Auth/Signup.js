import React, { useState } from "react";
import { Grid, makeStyles, TextField, Typography, Button, Dialog, DialogContent } from "@material-ui/core";
import FacebookIcon from "@material-ui/icons/Facebook";
import { Link, useHistory } from "react-router-dom";
import { authApi } from "../../services";
import { validateEmail } from "../../utils/common";
import CustomizedSnackbars from "../common/CustomizedSnackbars";
import FacebookLogin from "react-facebook-login/dist/facebook-login-render-props";
import GoogleLogin from "react-google-login";
import { useDispatch } from "react-redux";
import { actions } from "../../redux";

function Signup() {
  const classes = useStyles();
  const history = useHistory();
  const [fname, setFname] = useState("");
  const [lname, setLname] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [message, setMessage] = useState(null);
  const dispatch = useDispatch();

  const submitSignup = async (data) => {
    try {
      await authApi.signup(data);
      setMessage({ type: "success", content: "Sign up successfully !!!", open: true });
      history.push("/signin");
    } catch (error) {
      console.log(error);
      setMessage({ type: "error", content: "Email is invalid !!!", open: true });
      history.push("/signup");
    }
  };

  const handleSignup = () => {
    if (!validateEmail(email)) {
      setMessage({ type: "error", content: "Email is invalid !!!", open: true });
      return;
    }
    submitSignup({ first_name: fname.trim(), last_name: lname.trim(), email, password });
  };

  const signinWithThirdParty = async (data) => {
    const response = await authApi.signinWithThirdParty(data);
    const { user, token } = response;
    localStorage.setItem("user", JSON.stringify(user));
    localStorage.setItem("token", JSON.stringify(token));
    dispatch(actions.signin({ user, token }));
    setMessage({ type: "success", content: "Sign in successfully !!!", open: true });
    history.push("/");
  };

  const responseFacebook = (response) => {
    const { id, email, name } = response;
    if (response.status !== "unknown") {
      const data = { id, email, first_name: name, last_name: "" };
      signinWithThirdParty(data);
    }
  };

  const responseGoogle = (response) => {
    const { googleId, email, givenName, familyName } = response.profileObj;
    signinWithThirdParty({ id: googleId, email, first_name: givenName, last_name: familyName });
  };

  return (
    <div>
      <Grid container style={{ minHeight: "100vh" }}>
        <Grid item xs={12}>
          <img
            src="https://source.unsplash.com/random"
            alt="background"
            style={{ width: "100%", height: "100%", objectFit: "cover" }}
          />
        </Grid>
        <Dialog open={true} onClose={() => false} maxWidth="lg">
          <DialogContent>
            <Grid container direction="column" alignItems="center" className={classes.form}>
              <Typography variant="h3" color="initial">
                Sign up
              </Typography>
              <Grid container className={classes.textFiled}>
                <Grid item xs={12} sm={6}>
                  <TextField
                    autoComplete="fname"
                    name="fname"
                    variant="outlined"
                    required
                    fullWidth
                    id="fName"
                    label="First Name"
                    onChange={(e) => setFname(e.target.value)}
                    autoFocus
                    style={{ width: 170 }}
                  />
                </Grid>
                <Grid item xs={12} sm={6}>
                  <TextField
                    variant="outlined"
                    required
                    fullWidth
                    id="lname"
                    label="Last Name"
                    name="lname"
                    autoComplete="lname"
                    onChange={(e) => setLname(e.target.value)}
                    style={{ width: 170, marginLeft: 10 }}
                  />
                </Grid>
              </Grid>
              <TextField
                id="email"
                autoComplete="email"
                fullWidth
                margin="normal"
                required
                label="Email"
                variant="outlined"
                onChange={(e) => setEmail(e.target.value)}
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
                onChange={(e) => setPassword(e.target.value)}
                className={classes.textFiled}
              />
              <Button onClick={handleSignup} variant="contained" color="primary" style={{ width: "50%" }}>
                Sign up
              </Button>
              <FacebookLogin
                appId="695868198030092"
                autoLoad={false}
                callback={responseFacebook}
                fields="name,email"
                render={(renderProps) => (
                  <Button
                    onClick={renderProps.onClick}
                    variant="outlined"
                    startIcon={<FacebookIcon color="primary" style={{ fontSize: 28 }} />}
                    color="default"
                    className={classes.button}
                  >
                    Sign in with Facebook
                  </Button>
                )}
              />
              <GoogleLogin
                clientId="921119486812-2vc92c8q6m8j0a61ba9oh3rk7t2birhr.apps.googleusercontent.com"
                render={(renderProps) => (
                  <Button
                    onClick={renderProps.onClick}
                    disabled={renderProps.disabled}
                    variant="outlined"
                    startIcon={
                      <img
                        width="20px"
                        style={{ marginBottom: 3, marginRight: 5 }}
                        alt="Google sign-in"
                        src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/512px-Google_%22G%22_Logo.svg.png"
                      />
                    }
                    color="default"
                    className={classes.button}
                  >
                    Sign in with Google
                  </Button>
                )}
                buttonText="Login"
                onSuccess={responseGoogle}
                cookiePolicy={"single_host_origin"}
              />
              <Grid container justify="flex-end">
                <Grid item>
                  <Link to="/signin" variant="body2">
                    Already have an account? Sign in
                  </Link>
                </Grid>
              </Grid>
            </Grid>
          </DialogContent>
        </Dialog>
      </Grid>
      <CustomizedSnackbars message={message} />
    </div>
  );
}

export default Signup;

const useStyles = makeStyles({
  dialogForm: {
    width: 600,
    height: "auto",
  },
  form: {
    "&> *": {
      margin: "10px auto",
    },
  },
  textFiled: {
    width: 360,
    margin: "10px auto",
  },
  button: {
    width: "100%",
  },
});
