import React, { useEffect, useRef, useState } from "react";
import { makeStyles } from "@material-ui/core/styles";
import Paper from "@material-ui/core/Paper";
import InputBase from "@material-ui/core/InputBase";
import Divider from "@material-ui/core/Divider";
import IconButton from "@material-ui/core/IconButton";
import ExpandMoreIcon from "@material-ui/icons/ExpandMore";
import SearchIcon from "@material-ui/icons/Search";
import { Typography } from "@material-ui/core";
import Popper from "@material-ui/core/Popper";
import Grow from "@material-ui/core/Grow";
import MenuItem from "@material-ui/core/MenuItem";
import MenuList from "@material-ui/core/MenuList";
import ClickAwayListener from "@material-ui/core/ClickAwayListener";
import CheckIcon from "@material-ui/icons/Check";
import qs from "query-string";
import { withRouter } from "react-router-dom";

const useStyles = makeStyles((theme) => ({
  root: {
    padding: "2px 4px",
    display: "flex",
    alignItems: "center",
    width: 400,
  },
  input: {
    marginLeft: theme.spacing(1),
    flex: 1,
  },
  iconButton: {
    padding: 5,
    borderRadius: 0,
    marginRight: 5,
  },
  iconButtonMenu: {
    background: "#ececec",
    padding: "5px 20px",
    borderRadius: 0,
    marginRight: 5,
  },
  divider: {
    height: 28,
    margin: 4,
  },
  popper: {
    zIndex: 9999,
    border: "1px solid #c1c1c1",
    borderRadius: 3,
  },
}));

const SearchUser = (props) => {
  const classes = useStyles();
  const anchorRef = useRef(null);
  const [open, setOpen] = useState(false);
  const [option, setOption] = useState("email");
  const searchRef = useRef();

  const handleToggle = () => {
    setOpen((prevOpen) => !prevOpen);
  };

  const handleClose = (event) => {
    if (anchorRef.current && anchorRef.current.contains(event.target)) {
      return;
    }

    setOpen(false);
  };

  // return focus to the button when we transitioned from !open -> open
  const prevOpen = useRef(open);
  useEffect(() => {
    if (prevOpen.current === true && open === false) {
      anchorRef.current.focus();
    }

    prevOpen.current = open;
  }, [open]);

  const handleChangeOption = (option) => {
    setOption(option);
    setOpen(false);
  };

  const handleSearch = () => {
    const searchContent = searchRef.current.value;
    if (searchContent) {
      const query = { [option]: searchContent };
      props.history.replace({
        pathname: "/admin/manageuser",
        search: qs.stringify(query),
      });
      searchRef.current.value = "";
      setOption("email");
    }
  };

  return (
    <Paper component="form" className={classes.root}>
      <InputBase className={classes.input} placeholder="Search Users" inputRef={searchRef} />
      <Divider className={classes.divider} orientation="vertical" />
      <IconButton className={classes.iconButton} aria-label="menu" ref={anchorRef} onClick={handleToggle}>
        <Typography variant="body1" color="initial">
          {option}
        </Typography>
        <ExpandMoreIcon />
      </IconButton>
      <Popper className={classes.popper} open={open} anchorEl={anchorRef.current} placement="bottom-end" transition>
        {({ TransitionProps }) => (
          <Grow {...TransitionProps}>
            <Paper>
              <ClickAwayListener onClickAway={handleClose}>
                <MenuList autoFocusItem={open} id="menu-list-grow">
                  <MenuItem onClick={() => handleChangeOption("email")}>Email</MenuItem>
                  <MenuItem onClick={() => handleChangeOption("name")}>Name</MenuItem>
                </MenuList>
              </ClickAwayListener>
            </Paper>
          </Grow>
        )}
      </Popper>
      <IconButton className={classes.iconButtonMenu} aria-label="search" onClick={handleSearch}>
        <SearchIcon />
      </IconButton>
    </Paper>
  );
};
export default SearchUser;
