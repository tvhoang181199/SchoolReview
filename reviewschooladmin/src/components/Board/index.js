import React, { useEffect, useState } from "react";
import { Divider, Grid, Typography } from "@material-ui/core";
import { makeStyles } from "@material-ui/core/styles";
import BoardCell from "./BoardCell";
import { boardApi, cardApi } from "../../services";
import BoardAddBtn from "./BoardAddBtn";
import { useDispatch, useSelector } from "react-redux";
import { actions } from "../../redux";

function Board() {
  const classes = useStyles();
  const boards = useSelector((state) => state.app.boards);
  const user = useSelector((state) => state.app.user);
  const token = useSelector((state) => state.app.token);
  const [privateBoards, setPrivateBoards] = useState([]);
  const [publicBoards, setPublicBoards] = useState([]);
  const [myBoards, setMyBoards] = useState([]);
  const dispatch = useDispatch();

  const fetchData = async (user, token) => {
    if (token === "") return;
    const boards = await boardApi.getBoards(token);
    const cards = await cardApi.getCards(token);
    const data = { boards, cards };
    dispatch(actions.getAllNecessaryData(data));
  };

  useEffect(() => {
    setMyBoards(boards.filter((b) => b.owner === user.email));
  }, [boards, user]);

  useEffect(() => {
    setPrivateBoards(myBoards.filter((b) => b.permission === "private"));
    setPublicBoards(myBoards.filter((b) => b.permission === "public"));
  }, [myBoards]);

  useEffect(() => {
    fetchData(user, token);
  }, [token]);

  return (
    <Grid container direction="column" className={classes.root}>
      <Grid item>
        <Typography variant="h5" className={classes.header}>
          Private board
        </Typography>
        <Grid container spacing={5}>
          <BoardAddBtn owner={user.email} />
          {privateBoards.map((value, i) => (
            <BoardCell key={i} value={value} />
          ))}
        </Grid>
      </Grid>
      <Divider style={{ margin: "40px 0px" }} />
      <Grid item>
        <Typography variant="h5" className={classes.header}>
          Public board
        </Typography>
        <Grid container spacing={5}>
          {publicBoards.map((value, i) => (
            <BoardCell key={i} value={value} />
          ))}
        </Grid>
      </Grid>
    </Grid>
  );
}

export default Board;

const useStyles = makeStyles({
  root: {
    flexGrow: 1,
    marginTop: 20,
    margin: "auto",
    width: "90%",
  },
  header: {
    marginBottom: 20,
    color: "#283593",
  },
  bullet: {
    display: "inline-block",
    margin: "0 2px",
    transform: "scale(0.8)",
  },
  title: {
    fontSize: 14,
  },
  pos: {
    marginBottom: 12,
  },
});
