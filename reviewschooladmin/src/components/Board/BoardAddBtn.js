import React, { useState } from "react";
import { makeStyles } from "@material-ui/core/styles";
import Button from "@material-ui/core/Button";
import TextField from "@material-ui/core/TextField";
import Dialog from "@material-ui/core/Dialog";
import DialogActions from "@material-ui/core/DialogActions";
import DialogContent from "@material-ui/core/DialogContent";
import DialogTitle from "@material-ui/core/DialogTitle";
import { Grid, Fab, Card, Typography } from "@material-ui/core";
import { Add as AddIcon } from "@material-ui/icons";
import { boardApi } from "../../services";
import moment from "moment";
import { useDispatch } from "react-redux";
import { actions } from "../../redux";
import { makeRandomId } from "../../utils/common";

export default function BoardAddBtn(props) {
  const classes = useStyles();
  const [open, setOpen] = useState(false);
  const [name, setName] = useState("");
  const dispatch = useDispatch();

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const submitAddBoard = async (data) => {
    try {
      const token = JSON.parse(localStorage.getItem("token"));
      await boardApi.addBoard(data, token);
    } catch (error) {
      console.log(error);
    }
  };

  const handleAddBoard = () => {
    const date = moment();
    const board_id = makeRandomId();
    const board = { board_id, name, date, permission: "private", owner: props.owner };
    submitAddBoard(board);
    dispatch(actions.addBoard({ board }));
    setOpen(false);
  };

  return (
    <Grid key="add-board-button" item>
      <Card className={classes.AddBoardBtn} onClick={handleClickOpen}>
        <Fab color="secondary">
          <AddIcon />
        </Fab>
        <Typography variant="subtitle2" color="secondary" style={{ marginTop: 10 }}>
          Add board
        </Typography>
      </Card>
      <Dialog open={open} onClose={handleClose} maxWidth="xl">
        <DialogTitle id="form-dialog-title">Add new board</DialogTitle>
        <DialogContent>
          <TextField
            autoFocus
            id="name"
            label="Name"
            type="text"
            fullWidth
            variant="outlined"
            onChange={(e) => setName(e.target.value)}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={handleAddBoard} color="primary" variant="contained">
            Add
          </Button>
        </DialogActions>
      </Dialog>
    </Grid>
  );
}

const useStyles = makeStyles({
  AddBoardBtn: {
    cursor: "pointer",
    padding: "20px 40px",
    background: "transparent",
    border: "2px #ccc dashed",
    boxShadow: "none",
    textAlign: "center",
    "&:hover": {
      border: "2px #C51162 dashed",
    },
  },
});
