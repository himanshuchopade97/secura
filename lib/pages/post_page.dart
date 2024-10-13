import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secura/components/my_post_tile.dart';
import 'package:secura/helper/navigate_pages.dart';
import 'package:secura/models/post.dart';
import 'package:secura/services/database/database_provider.dart';

/*
  this page displays :
    - individual post
    - comment on post
 */

class PostPage extends StatefulWidget {
  final Post post;
  const PostPage({
    super.key,
    required this.post,
  });

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  //providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    //listen to all comments
    final allComments = listeningProvider.getComments(widget.post.id);

    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.post.message),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          //post
          MyPostTile(
            post: widget.post,
            onUserTap: () => goUserPage(context, widget.post.uid),
            onPostTap: () {},
          ),

          //comments
          allComments.isEmpty
              ?
              //no comments
              Center(
                  child: Text("No Comments yet..."),
                )
              :
              //comments exist
              ListView.builder(
                  itemCount: allComments.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    //get each comment
                    final comment = allComments[index];

                    //return as comment tle UI
                    return Container(
                      child: Text(comment.message),
                    );
                  },
                )
        ],
      ),
    );
  }
}
