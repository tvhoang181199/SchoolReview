import React, { useEffect, useState } from "react";
import { Grid, makeStyles, Container, Typography } from "@material-ui/core";
import AddIcon from "@material-ui/icons/Add";
import StopIcon from "@material-ui/icons/Stop";
import CardBoard from "../CardBoard";
import { useSelector } from "react-redux";
import { Link } from "react-router-dom";
import CustomizedSnackbars from "../common/CustomizedSnackbars";

function BoardView(props) {
  const classes = useStyles();
  const boards = useSelector((state) => state.app.boards);
  const cards = useSelector((state) => state.app.cards);
  const user = useSelector((state) => state.app.user);
  const [allCards, setAllCards] = useState([]);
  const [board, setBoard] = useState({});
  const [isAdd, setIsAdd] = useState(-1);
  const [message, setMessage] = useState(null);
  const board_id = props.match.params.id;

  const resetIsAdd = () => {
    setIsAdd(-1);
  };

  useEffect(() => {
    const board = boards.find((board) => board.board_id === board_id);
    const user = JSON.parse(localStorage.getItem("user"));
    if (board && user.email !== board.owner && board.permission === "private") {
      setMessage({ open: true, type: "error", content: "You have not permission to access this page !!!" });
    } else {
      setAllCards(cards.filter((card) => card.board_id === board_id));
      setBoard(board);
    }
  }, [boards, cards, user]);

  return (
    <>
      {message ? (
        <div>
          <Typography variant="h6" color="initial">
            Please return to home page !!!
            <Link to="/"> Home Page </Link>
          </Typography>
          <CustomizedSnackbars message={message} />
        </div>
      ) : (
        <Container>
          <Grid container spacing={5} className={classes.root}>
            <Grid item className={classes.title} xs={12}>
              BOARD: {board ? board.name : "loading..."}
            </Grid>
            <Grid container item className={classes.header} xs={12}>
              <Grid item xs={4} className={classes.titleColumn}>
                <div className={classes.wentWellHeader}>
                  <StopIcon style={{ color: "blue" }} />
                  <div>Went well</div>
                </div>
                <div className={classes.addBtn} onClick={() => setIsAdd(0)}>
                  <AddIcon />
                </div>
              </Grid>
              <Grid item xs={4} className={classes.titleColumn}>
                <div className={classes.toImproveHeader}>
                  <StopIcon style={{ color: "green" }} />
                  <div>To improve</div>
                </div>
                <div className={classes.addBtn} onClick={() => setIsAdd(1)}>
                  <AddIcon />
                </div>
              </Grid>
              <Grid item xs={4} className={classes.titleColumn}>
                <div className={classes.actionItemsHeader}>
                  <StopIcon style={{ color: "red" }} />
                  <div>Action items</div>
                </div>
                <div className={classes.addBtn} onClick={() => setIsAdd(2)}>
                  <AddIcon />
                </div>
              </Grid>
              <Grid item xs={12}>
                <CardBoard board_id={board_id} allCards={allCards} isAdd={isAdd} onResetIsAdd={resetIsAdd} />
              </Grid>
            </Grid>
          </Grid>
        </Container>
      )}
    </>
  );
}

export default BoardView;

const useStyles = makeStyles((theme) => ({
  root: {
    display: "flex",
    flexWrap: "wrap",
    "& > *": {
      margin: theme.spacing(1),
      width: theme.spacing(16),
      height: theme.spacing(16),
    },
  },
  title: {
    fontSize: 38,
    textAlign: "center",
    marginTop: 20,
    marginBottom: -60,
    padding: 0,
  },
  header: {
    display: "flex",
    flexDirection: "row",
    minHeight: 80,
  },
  titleColumn: {
    flex: 1,
    margin: "auto 7.5px",
    textAlign: "center",
    padding: 0,
    "& > div:first-child": {
      textAlign: "left",
      height: 30,
      display: "flex",
      flexDirection: "row",
      fontWeight: 600,
    },
    "& > div:nth-child(2)": {},
  },
  addBtn: {
    background: "#ddd",
    cursor: "pointer",
    "&:hover": {
      background: "#ccc",
    },
  },
}));
