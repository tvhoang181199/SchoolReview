import React, { useEffect, useState } from "react";

import { useTable, useSortBy, usePagination } from "react-table";
import { TablePagination, Button } from "@material-ui/core";
import { makeStyles } from "@material-ui/core/styles";
import { useHistory } from "react-router-dom";
import ConfirmModal from "./ConfirmModal";

function Table({ columns, data, blockUser, verifyUser }) {
  const classes = useStyles();
  const history = useHistory();
  const [open, setOpen] = useState(false);
  const [userId, setUserId] = useState("");
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
    setOpen(true);
  };

  const handleBlockUser = () => {
    // blockUser(userId, secret, token);
    console.log("BLOCK: ", userId);
    blockUser(userId);
    setOpen(false);
  };

  const onVerifyUser = (userID) => {
    console.log("VERIFY: ", userID);
    verifyUser(userID);
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
              disabled={status.blocked == "True"}
            >
              {status.blocked == "False" ? "Block" : "Blocked"}
            </Button>
          </div>
        );
    }
  };

  return (
    <>
      <ConfirmModal
        title="Do you want to block this user ?"
        open={open}
        onAgree={handleBlockUser}
        onDisagree={() => setOpen(false)}
      />
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
