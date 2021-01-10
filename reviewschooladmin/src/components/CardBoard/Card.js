import React, { useState } from "react";
import { makeStyles, Button } from "@material-ui/core";
import EditIcon from "@material-ui/icons/Edit";
import DeleteIcon from "@material-ui/icons/Delete";
import { cardApi } from "../../services";
import { useDispatch } from "react-redux";
import { actions } from "../../redux";
import AlertDialog from "../common/AlertDialog";

function Card(props) {
  const classes = useStyles();
  const [newContent, setNewContent] = useState(props.card.content);
  const [isEditing, setIsEditing] = useState(false);
  const [isDelete, setIsDelete] = useState(false);
  const dispatch = useDispatch();

  const getBackground = (category) => {
    switch (category) {
      case "Went well":
        return "blue";
      case "To improve":
        return "green";
      case "Action items":
        return "red";
      default:
        return;
    }
  };

  const submitAddCard = async (data) => {
    try {
      const token = JSON.parse(localStorage.getItem("token"));
      await cardApi.addCard(data, token);
      dispatch(actions.addCard(data));
    } catch (error) {
      console.log(error);
    }
  };

  const submitUpdateCard = async (data) => {
    try {
      const token = JSON.parse(localStorage.getItem("token"));
      await cardApi.updateCard(data, token);
      dispatch(actions.updateCard(data));
      setIsEditing(false);
    } catch (error) {
      console.log(error);
    }
  };

  const handleAddCard = () => {
    if (props.card.shouldSave) {
      const tempCard = { ...props.card, content: newContent };
      delete tempCard.shouldSave;
      submitAddCard(tempCard);
    }
    if (isEditing) {
      const newCard = { ...props.card, content: newContent };
      submitUpdateCard(newCard);
    }
  };

  const handleDeleteCard = () => {
    setIsDelete(false);
    props.onDeleteCard(props.card);
  };

  return (
    <>
      {isEditing || props.card.shouldSave ? (
        <div className={classes.newCard} style={{ background: `${getBackground(props.card.category)}` }}>
          <div>
            <textarea
              style={{ width: "100%", padding: 0 }}
              id="content"
              rows={3}
              value={newContent}
              onChange={(e) => setNewContent(e.target.value)}
            />
          </div>
          <div style={{ fontSize: 12, color: "white" }}>
            <Button variant="contained" fontSize="small" color="primary" onClick={handleAddCard}>
              Done
            </Button>
            <DeleteIcon className={classes.deleteIcon} color="primary" onClick={() => setIsDelete(true)} />
          </div>
        </div>
      ) : (
        <div className={classes.card} style={{ background: `${getBackground(props.card.category)}` }}>
          <div className={classes.body}>
            <div className={classes.content}>{props.card.content}</div>
            <EditIcon fontSize="small" className={classes.editIcon} onClick={() => setIsEditing(true)} />
          </div>
          <div className={classes.owner}>{props.card.owner}</div>
        </div>
      )}
      <AlertDialog
        open={isDelete}
        title="Are you sure delete this card ?"
        content=""
        handleAgree={handleDeleteCard}
        handleDisagree={() => setIsDelete(false)}
      />
    </>
  );
}

export default Card;

const useStyles = makeStyles({
  card: {
    color: "white",
    fontSize: 14,
    margin: "5px 7.5px",
    padding: 5,
    minHeight: 95,
    maxHeight: 95,
  },
  newCard: {
    color: "black",
    fontSize: 14,
    background: "white",
    border: "4px solid transparent",
    margin: "5px 7.5px",
    padding: 5,
  },
  body: {
    display: "flex",
    flexDirection: "row",
    justifyContent: "space-between",
    flexWrap: "wrap",
    minHeight: 75,
  },
  content: {
    whiteSpace: "wrap",
    maxWidth: "80%",
    width: "80%",
    maxHeight: 75,
    overflow: "hidden",
  },
  owner: {
    color: "white",
    opacity: 0.7,
  },
  deleteIcon: {
    float: "right",
    margin: "auto",
    cursor: "pointer",
  },
  editIcon: {
    cursor: "pointer",
  },
});
