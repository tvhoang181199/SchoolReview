import React, { useEffect, useState } from "react";
import { makeStyles } from "@material-ui/core";
import RGL, { WidthProvider } from "react-grid-layout";
import Card from "./Card";
import { makeRandomId } from "../../utils/common";
import { useSelector, useDispatch } from "react-redux";
import "./style.css";
import { cardApi } from "../../services";
import { actions } from "../../redux";

const ReactGridLayout = WidthProvider(RGL);

const CardBoard = (props) => {
  const { board_id, allCards, isAdd, onResetIsAdd, onLayoutChange = () => {} } = props;
  const classes = useStyles();
  const user = useSelector((state) => state.app.user);
  const [layout, setLayout] = useState([]);
  const [cardList, setCardList] = useState(allCards);
  const dispatch = useDispatch();

  const getCategory = (i) => {
    switch (i) {
      case 0:
        return "Went well";
      case 1:
        return "To improve";
      case 2:
        return "Action items";
      default:
        break;
    }
  };

  const getX = (category) => {
    switch (category) {
      case "Went well":
        return 0;
      case "To improve":
        return 1;
      case "Action items":
        return 2;
      default:
        break;
    }
  };

  const getAllLayout = () => {
    return cardList.map((card, i) => ({
      ...card.matrix,
      y: card.shouldSave ? 0 : Math.max(card.matrix.y, 1),
    }));
  };

  const handleLayoutChange = (newLayout) => {
    console.log({ cardList, newLayout });
    onLayoutChange(newLayout);
    setLayout(newLayout);
  };

  const addNewCard = (i) => {
    const card_id = makeRandomId();
    const newCard = {
      content: "",
      board_id,
      card_id,
      category: getCategory(i),
      owner: user.email,
      matrix: { i: card_id, x: i, y: 0, w: 1, h: 1 },
      shouldSave: true,
    };
    const newCardList = [...cardList, newCard];
    setCardList(newCardList);
  };

  useEffect(() => {
    const _allCards = allCards.filter((card) => card.board_id === board_id);
    const _unSaveCards = cardList.filter(
      (card) => card.shouldSave && !allCards.find((c) => c.card_id === card.card_id)
    );
    console.log({ _allCards, _unSaveCards });
    setCardList(_allCards.concat(_unSaveCards));
  }, [allCards]);

  useEffect(() => {
    if (isAdd !== -1) {
      addNewCard(isAdd);
      onResetIsAdd();
    }
  }, [isAdd]);

  useEffect(() => {
    setLayout(getAllLayout());
  }, [cardList]);

  const submitUpdateCard = async (data) => {
    try {
      const token = JSON.parse(localStorage.getItem("token"));
      await cardApi.updateCard(data, token);
      dispatch(actions.updateCard(data));
    } catch (error) {
      console.log(error);
    }
  };

  const handleDragStop = (newLayout, oldItem, newItem) => {
    const newCardList = cardList.map((card) =>
      card.card_id === newItem.i ? { ...card, category: getCategory(newItem.x), matrix: newItem } : card
    );
    const newCard = {
      ...cardList.find((card) => card.card_id === newItem.i),
      category: getCategory(newItem.x),
      matrix: newItem,
    };
    console.log({ newCard });
    submitUpdateCard(newCard);
    setCardList(newCardList);
  };

  const submitDeleteCard = async (data) => {
    try {
      const token = JSON.parse(localStorage.getItem("token"));
      await cardApi.deleteCard(data, token);
      dispatch(actions.deleteCard(data));
    } catch (error) {
      console.log(error);
    }
  };

  const handleDeleteCard = (data) => {
    if (data.shouldSave) {
      const newCardList = cardList.filter((card) => card.card_id !== data.card_id);
      setCardList(newCardList);
    } else {
      submitDeleteCard(data);
    }
  };

  return (
    <div className={classes.cardBoard}>
      <ReactGridLayout
        className="layout"
        layout={layout}
        onLayoutChange={handleLayoutChange}
        cols={3}
        margin={[0, 0]}
        rowHeight={120}
        resizeHandle={["s"]}
        isResizable={false}
        onDragStop={handleDragStop}
      >
        {cardList.map((card, i) => (
          <div key={card.card_id}>
            <Card card={card} onDeleteCard={handleDeleteCard} />
          </div>
        ))}
      </ReactGridLayout>
    </div>
  );
};

export default CardBoard;

const useStyles = makeStyles({
  cardBoard: {
    // position: "relative",
    width: "100%",
  },
});
