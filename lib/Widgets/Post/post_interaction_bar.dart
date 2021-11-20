import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:like_button/like_button.dart";

///Class for interaction bar exists the bottom of each post in home page
///
///holds:
///1-Notes number
///2-buttons to Favorite and reblog and reply
class PostInteractionBar extends StatefulWidget {
  ///Constructor takes total number of notes
  const PostInteractionBar({required final this.notesNum, final Key? key})
      : super(key: key);

  /// Number of Notes of the Blog
  final int notesNum;

  @override
  _PostInteractionBarState createState() => _PostInteractionBarState();
}

class _PostInteractionBarState extends State<PostInteractionBar> {
  bool isLoved = false;
  NumberFormat numFormatter = NumberFormat.decimalPattern("en_us");

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 80,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              onPressed: () {},
              child: Image.asset(
                "assets/images/interactions.jpeg",
              ),
            ),
          ),
          Expanded(
            child: Text(
              "${numFormatter.format(widget.notesNum)} notes",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black45,
              ),
            ),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.reply,
              color: Colors.black,
            ),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.repeat,
              color: Colors.black,
            ),
          ),
          LikeButton(
            isLiked: isLoved,
            likeBuilder: (final bool isLoved) {
              final Color color = isLoved ? Colors.red : Colors.black;
              return Icon(
                isLoved ? Icons.favorite : Icons.favorite_border_outlined,
                color: color,
              );
            },
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.add_comment_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}