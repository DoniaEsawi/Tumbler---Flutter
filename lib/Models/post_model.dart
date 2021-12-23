// ignore_for_file: public_member_api_docs
///Post Model
class PostModel {
  PostModel({
    required final this.postId,
    required final this.postBody,
    required final this.postStatus,
    required final this.postType,
    required final this.blogId,
    required final this.blogUsername,
    required final this.blogAvatar,
    required final this.blogAvatarShape,
    required final this.blogTitle,
    required final this.postTime,
    required final this.notes,
  });

  final int postId;
  final String postBody;
  final String postStatus;
  final String postType;
  final int blogId;
  final String blogUsername;
  final String blogAvatar;
  final String blogAvatarShape;
  final String blogTitle;
  final String postTime;
  final int notes;

  /// Converts JSON["response"]["posts"] to List of Posts
  static List<PostModel> fromJSON(final List<dynamic> json) {
    final List<PostModel> temp = <PostModel>[];
    for (int i = 0; i < json.length; i++) {
      temp.add(
        PostModel(
          postId: json[i]["post_id"] as int,
          postBody: json[i]["post_body"] ?? "",
          postStatus: json[i]["post_status"] ?? "",
          postType: json[i]["post_type"] ?? "",
          blogId: json[i]["blog_id"] as int,
          blogUsername: json[i]["blog_username"] ?? "",
          blogAvatar: json[i]["blog_avatar"] ?? "",
          blogAvatarShape: json[i]["blog_avatar_shape"] ?? "",
          blogTitle: json[i]["blog_title"] ?? "",
          postTime: json[i]["post_time"] ?? "",
          notes: (json[i]["notes"] ?? 0) as int,
        ),
      );
    }
    return temp;
  }
}