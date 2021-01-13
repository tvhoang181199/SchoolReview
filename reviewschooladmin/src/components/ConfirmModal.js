import React from "react";
import { Button, Dialog, DialogActions, DialogContent, DialogContentText, DialogTitle } from "@material-ui/core";

export default function ConfirmModal(props) {
  const { open, title, body, onAgree, onDisagree } = props;

  return (
    <Dialog open={open} onClose={onDisagree}>
      <DialogTitle>{title}</DialogTitle>
      {body && (
        <DialogContent>
          <DialogContentText>{body}</DialogContentText>
        </DialogContent>
      )}
      <DialogActions>
        <Button onClick={onDisagree} color="primary">
          Disagree
        </Button>
        <Button onClick={onAgree} variant="contained" color="primary" autoFocus>
          Agree
        </Button>
      </DialogActions>
    </Dialog>
  );
}
