import React, { useEffect, useState } from "react";

import { useTable, useSortBy, usePagination } from "react-table";
import { TablePagination, Button } from "@material-ui/core";
import { makeStyles } from "@material-ui/core/styles";
import { useHistory } from "react-router-dom";
import ConfirmModal from "./ConfirmModal";
import ApprovePosts from "../pages/Posts/ApprovePosts";

function Table({ columns, data, blockUser, verifyUser, approvePosts }) {
  const classes = useStyles();
  const history = useHistory();
  const [open, setOpen] = useState(false);
  const [message, setMessage] = useState("");
  const [type, setType] = useState("");
  const [userId, setUserId] = useState("");
  const [postId, setPostId] = useState("");
  const {
    getTableProps,
    getTableBodyProps,
    headerGroups,
    rows,
    prepareRow,
    pageOptions,
    page,
    state: { pageIndex, pageSize },
    gotoPage,
    previousPage,
    nextPage,
    setPageSize,
    canPreviousPage,
    canNextPage,
  } = useTable(
    {
      columns,
      data,
    },
    useSortBy,
    usePagination
  );

  const handleChangePage = (event, page) => gotoPage(page);

  const handleChangeRowsPerPage = (event) => setPageSize(event.target.value);

  const onBlockUser = (userId) => {
    setUserId(userId);
    setMessage("Do you want to block this user ?");
    setType("blockuser");
    setOpen(true);
  };

  const onApprovePost = (postId) => {
    setPostId(postId);
    setMessage("Do you want to approve this post ?");
    setType("approvepost");
    setOpen(true);
  };

  const onVerifyUser = (userID) => {
    setUserId(userID);
    setMessage("Do you want to verify this user ?");
    setType("verifyuser");
    setOpen(true);
  };

  const handleBlockUser = () => {
    console.log("BLOCK: ", userId);
    blockUser(userId);
    setOpen(false);
  };

  const handleVerifyUser = () => {
    console.log("VERIFY: ", userId);
    verifyUser(userId);
    setOpen(false);
  };

  const handleApprovePost = () => {
    console.log("APRROVE: ", postId);
    approvePosts(postId);
    setOpen(false);
  };

  const getActions = (status, value) => {
    switch (status.tableType) {
      case "verifyuser":
        return (
          <div className={classes.actions}>
            <Button onClick={() => onVerifyUser(value)} variant="contained" size="small" color="primary">
              Verify
            </Button>
          </div>
        );

      case "approvepost":
        return (
          <div className={classes.actions}>
            <Button onClick={() => onApprovePost(value)} variant="contained" size="small" color="primary">
              Aprrove
            </Button>
          </div>
        );

      case "posts":
        return (
          <div className={classes.actions}>
            <Button variant="contained" size="small" color="primary">
              View
            </Button>
          </div>
        );

      default:
        return (
          <div className={classes.actions}>
            <Button onClick={() => history.push(`/users/${value}`)} variant="contained" size="small" color="primary">
              View
            </Button>
            <Button
              onClick={() => onBlockUser(value)}
              variant="contained"
              size="small"
              color="secondary"
              disabled={status.blocked === "True"}
            >
              {status.blocked === "False" ? "Block" : "Blocked"}
            </Button>
          </div>
        );
    }
  };

  const handleDisagree = () => setOpen(false);

  const handleAgree = () => {
    switch (type) {
      case "blockuser":
        handleBlockUser();
        return;
      case "verifyuser":
        handleVerifyUser();
        return;
      case "approvepost":
        handleApprovePost();
        return;
      default:
        return;
    }
  };

  return (
    <>
      <ConfirmModal title={message} open={open} onAgree={handleAgree} onDisagree={handleDisagree} />
      <table {...getTableProps()} className={classes.root}>
        <thead>
          {headerGroups.map((headerGroup) => (
            <tr {...headerGroup.getHeaderGroupProps()} className={classes.header}>
              {headerGroup.headers.map((column) => (
                <th {...column.getHeaderProps(column.getSortByToggleProps())} className={classes.th}>
                  {column.render("Header")}
                  <span>{column.isSorted ? (column.isSortedDesc ? " 🔽" : " 🔼") : ""}</span>
                </th>
              ))}
            </tr>
          ))}
        </thead>
        <tbody {...getTableBodyProps()}>
          {page.map((row, i) => {
            prepareRow(row);
            return (
              <tr {...row.getRowProps()} className={classes.row}>
                {row.cells.map((cell) => {
                  return (
                    <td {...cell.getCellProps()}>
                      {cell.column.Header === "Actions"
                        ? getActions(cell.row.original, cell.value)
                        : cell.render("Cell")}
                    </td>
                  );
                })}
              </tr>
            );
          })}
        </tbody>
      </table>
      <TablePagination
        rowsPerPageOptions={[10, 20, 30, 50]}
        component="div"
        count={rows.length}
        rowsPerPage={pageSize}
        page={pageIndex}
        onChangePage={handleChangePage}
        onChangeRowsPerPage={handleChangeRowsPerPage}
      />
    </>
  );
}

export default Table;

const useStyles = makeStyles({
  root: {
    width: "100%",
    borderSpacing: 0,
    borderCollapse: "collapse",
  },
  row: {
    borderBottom: "1px solid #f1f1f1",
    height: 35,
    "&:hover": {
      background: "#f1f1f1",
    },
    "& > td": {
      paddingLeft: 10,
      maxWidth: 200,
      overflow: "hidden",
      textOverflow: "ellipsis",
    },
  },
  header: {
    background: "#888",
    color: "white",
    textAlign: "left",
    height: 40,
    "& > th": {
      paddingLeft: 10,
    },
  },
  actions: {
    "&>button": {
      margin: "auto 5px",
    },
  },
});
