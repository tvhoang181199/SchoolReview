import React, { useState } from "react";
import {
  IconButton,
  Grid,
  CardActions,
  CardContent,
  Typography,
  Tooltip,
  Card,
  TextField,
  Button,
} from "@material-ui/core";
import { makeStyles } from "@material-ui/core/styles";
import AccessAlarmsIcon from "@material-ui/icons/AccessAlarms";
import DeleteIcon from "@material-ui/icons/Delete";
import EditIcon from "@material-ui/icons/Edit";
import ShareIcon from "@material-ui/icons/Share";
import moment from "moment";
import { Link } from "react-router-dom";
import { useDispatch, useSelector } from "react-redux";
import { boardApi } from "../../services";
import { actions } from "../../redux";
import AlertDialog from "../common/AlertDialog";

function BoardCell(props) {
  const { value } = props;
  const classes = useStyles();
  const cards = useSelector((state) => state.app.cards);
  const _cards = cards.filter((card) => card.board_id === value.board_id);
  const [isEditing, setIsEditing] = useState(false);
  const [isShare, setIsShare] = useState(false);
  const [isDelete, setIsDelete] = useState(false);
  const [newName, setNewName] = useState(value.name);
  const dispatch = useDispatch();

  const changeNameBoard = async (e) => {
    try {
      e.preventDefault();
      const token = JSON.parse(localStorage.getItem("token"));
      const data = { name: newName, board_id: value.board_id };
      await boardApi.updateBoard(data, token);
      dispatch(actions.updateBoard(data));
      setIsEditing(false);
    } catch (error) {
      console.log(error);
    }
  };

  const submitShareBoard = async (id) => {
    try {
      const token = JSON.parse(localStorage.getItem("token"));
      await boardApi.shareBoard({ board_id: id }, token);
      dispatch(actions.shareBoard({ board_id: id }));
    } catch (error) {
      console.log(error);
    }
  };

  const submitDeleteBoard = async (id) => {
    try {
      const token = JSON.parse(localStorage.getItem("token"));
      await boardApi.deleteBoard({ board_id: id }, token);
      dispatch(actions.deleteBoard({ board_id: id }));
    } catch (error) {
      console.log(error);
    }
  };

  const handleShareBoard = () => {
    console.log("SHARE BOARD");
    setIsShare(false);
    submitShareBoard(value.board_id);
  };

  const handleDeleteBoard = () => {
    console.log("DELETE BOARD");
    setIsDelete(false);
    submitDeleteBoard(value.board_id);
  };

  const getHeight = (cards, category) => {
    const cardList = cards.filter((c) => c.category === category);
    return cardList.length * 5;
  };

  return (
    <Grid item>
      <Card className={classes.boardCell}>
        <Link to={`/${value.board_id}`} style={{ textDecoration: "none" }}>
          <CardContent>
            {isEditing ? (
              <Grid container direction="row">
                <Grid item>
                  <TextField
                    id="newName"
                    value={newName}
                    onChange={(e) => setNewName(e.target.value)}
                    autoFocus
                    style={{ width: 120 }}
                  />
                </Grid>
                <Grid item>
                  <Button variant="text" color="default" onClick={(e) => changeNameBoard(e)}>
                    Save
                  </Button>
                </Grid>
              </Grid>
            ) : (
              <Typography variant="h5" component="h2" style={{ color: "black" }}>
                {value.name}
              </Typography>
            )}
          </CardContent>
          <CardContent style={{ paddingTop: 0 }}>
            <Typography variant="body2" color="textSecondary" component="span">
              <AccessAlarmsIcon style={{ fontSize: ".9rem" }} />
              <span>{moment(value.date).format("MMM-DD")}</span>
            </Typography>
            <Typography variant="body2" color="textSecondary" component="span" style={{ float: "right" }}>
              {_cards.length > 0 ? `${_cards.length} cards` : ""}
            </Typography>
          </CardContent>
          {_cards.length > 0 && (
            <CardContent className={classes.boardSmall}>
              <ul>
                <Tooltip title="Went well">
                  <li className={classes.cardWentWell} style={{ height: `${getHeight(_cards, "Went well")}px` }}></li>
                </Tooltip>
                <Tooltip title="To improve">
                  <li className={classes.cardToImprove} style={{ height: `${getHeight(_cards, "To improve")}px` }}></li>
                </Tooltip>
                <Tooltip title="Action items">
                  <li
                    className={classes.cardActionItems}
                    style={{ height: `${getHeight(_cards, "Action items")}px` }}
                  ></li>
                </Tooltip>
              </ul>
            </CardContent>
          )}
        </Link>
        <CardActions className={classes.boardAction}>
          <Tooltip title="Edit name of board">
            <IconButton size="small" className={classes.editIcon} onClick={() => setIsEditing(true)}>
              <EditIcon />
            </IconButton>
          </Tooltip>
          <Tooltip title="Share board">
            <IconButton size="small" className={classes.shareIcon} onClick={() => setIsShare(true)}>
              <ShareIcon />
            </IconButton>
          </Tooltip>
          <Tooltip title="Delete board">
            <IconButton size="small" className={classes.deleteIcon} onClick={() => setIsDelete(true)}>
              <DeleteIcon />
            </IconButton>
          </Tooltip>
        </CardActions>
      </Card>
      <AlertDialog
        open={isShare}
        title="Share board"
        content={`${window.location.href}+${value.board_id}`}
        handleAgree={handleShareBoard}
        handleDisagree={() => setIsShare(false)}
      />
      <AlertDialog
        open={isDelete}
        title="Are you sure delete this board ?"
        content={`This is will delete all cards of this board !!!`}
        handleAgree={handleDeleteBoard}
        handleDisagree={() => setIsDelete(false)}
      />
    </Grid>
  );
}

export default BoardCell;

const useStyles = makeStyles({
  boardCell: {
    cursor: "pointer",
    padding: 0,
    minWidth: 220,
    background: "white",
    boxShadow: "0 4px 8px 0 rgba(192,208,230,0.5)",
    "&:hover": {
      boxShadow: "0 6px 10px rgba(0, 0, 0, 0.19) ",
    },
  },
  boardSmall: {
    borderTop: "1px solid #f1f1f1",
    "& > ul": {
      listStyle: "none",
      padding: 0,
      margin: 0,
      display: "flex",
      flexDirection: "row",
      "& > li": {
        width: 50,
        margin: "0 6px",
      },
    },
    "&:last-child": {
      padding: 14,
    },
  },
  boardAction: {
    borderTop: "1px solid #f1f1f1",
    justifyContent: "space-around",
    padding: 5,
    "& > button": {
      padding: "5px 0",
    },
  },
  body: {
    marginTop: 10,
  },
  cardWentWell: {
    background: "blue",
  },
  cardToImprove: {
    background: "green",
  },
  cardActionItems: {
    background: "red",
  },
});
