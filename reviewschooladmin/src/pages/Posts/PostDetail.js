import React from "react";
import { makeStyles } from "@material-ui/core/styles";
import clsx from "clsx";
import Card from "@material-ui/core/Card";
import CardHeader from "@material-ui/core/CardHeader";
import CardMedia from "@material-ui/core/CardMedia";
import CardContent from "@material-ui/core/CardContent";
import CardActions from "@material-ui/core/CardActions";
import Collapse from "@material-ui/core/Collapse";
import Avatar from "@material-ui/core/Avatar";
import IconButton from "@material-ui/core/IconButton";
import Typography from "@material-ui/core/Typography";
import { red, blue } from "@material-ui/core/colors";
import FavoriteIcon from "@material-ui/icons/Favorite";
import ShareIcon from "@material-ui/icons/Share";
import ExpandMoreIcon from "@material-ui/icons/ExpandMore";
import MoreVertIcon from "@material-ui/icons/MoreVert";
import moment from "moment";

const useStyles = makeStyles((theme) => ({
  root: {
    marginBottom: 20,
  },
  media: {
    height: 0,
    paddingTop: "56.25%", // 16:9
  },
  expand: {
    transform: "rotate(0deg)",
    marginLeft: "auto",
    transition: theme.transitions.create("transform", {
      duration: theme.transitions.duration.shortest,
    }),
  },
  expandOpen: {
    transform: "rotate(180deg)",
  },
  avatar: {
    backgroundColor: blue[500],
  },
  header: {
    borderBottom: "1px solid #ddd",
    background: "#adadad",
    color: "white",
  },
  content: {
    padding: "8px 16px",
    borderBottom: "1px solid #ddd",
    maxHeight: 200,
    overflowY: "auto",
  },
  comments: {
    padding: "0 24px 10px",
  },
}));

export default function PostDetail({ post }) {
  const classes = useStyles();
  const [expanded, setExpanded] = React.useState(false);

  const handleExpandClick = () => {
    setExpanded(!expanded);
  };

  console.log({ post });

  return (
    <Card className={classes.root}>
      <CardHeader
        avatar={
          <Avatar aria-label="recipe" className={classes.avatar}>
            {post.userName[0]}
          </Avatar>
        }
        title={post.title}
        subheader={moment(post.createdDate.toDate()).format("DD-MM-YYYY hh:mm:ss")}
        className={classes.header}
      />
      <CardContent className={classes.content}>
        <Typography variant="body2" color="textSecondary" component="p">
          {post.content}
        </Typography>
      </CardContent>
      <CardActions style={{ padding: "0 8px" }} disableSpacing>
        <IconButton aria-label="add to favorites">
          <Typography variant="body1" style={{ margin: "0 3px" }} color="initial">
            {(post.likedUser || []).length}
          </Typography>
          <FavoriteIcon />
        </IconButton>
        <IconButton
          className={clsx(classes.expand, {
            [classes.expandOpen]: expanded,
          })}
          onClick={handleExpandClick}
          aria-expanded={expanded}
          aria-label="show more"
        >
          <ExpandMoreIcon />
        </IconButton>

        <Typography variant="subtitle2" color="initial">
          {(post.comments || []).length} comments
        </Typography>
      </CardActions>
      <Collapse in={expanded} timeout="auto" unmountOnExit>
        <CardContent className={classes.comments}>
          {(post.comments || []).map((comment, i) => (
            <div key={i}>
              <span style={{ fontWeight: "bold" }}>{comment.userName}: </span>
              <span>{comment.content}</span>
            </div>
          ))}
        </CardContent>
      </Collapse>
    </Card>
  );
}
