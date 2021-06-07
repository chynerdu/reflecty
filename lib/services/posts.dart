import 'package:abccompany/models/postModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class PostService {
  //  add note
  static Future<bool> publishPost({title, description, image}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    final Map<String, dynamic> postFormData = {
      'title': title,
      'description': description,
      'image': image,
      'userId': userId
    };
    try {
      var url = Uri.parse(
          'https://reflecty-2a4da-default-rtdb.firebaseio.com//posts/$userId.json');
      final http.Response response =
          await http.post(url, body: json.encode(postFormData));
      if (response.statusCode != 200 && response.statusCode != 201) {
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      // print(newNote);
      return true;
    } catch (error) {
      print(error);

      return false;
    }
  }

  // fetch posts

  static Future<Map<String, dynamic>> fetchPosts() async {
    print('fetching online');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    var url = Uri.parse(
        'https://reflecty-2a4da-default-rtdb.firebaseio.com/posts/$userId.json');
    return http.get(url).then<Map<String, dynamic>>((http.Response response) {
      final List<PostModel> fetchedPosteList = [];
      print('response body ${response.body}');
      final Map<String, dynamic> postListData = json.decode(response.body);
      // if (postListData == null) {
      //   return {'success': true, 'data': []};
      // }
      print('decoded $postListData');
      postListData.forEach((String postId, dynamic post) {
        print('posts ${post['description']}');
        final PostModel postItem = PostModel(
          id: postId,
          title: post['title'],
          description: post['description'],
          image: post['image'],
        );
        fetchedPosteList.add(postItem);
      });

      return {'success': true, 'data': fetchedPosteList};
    }).catchError((error) {
      print('error occured here $error');
      return {'success': false, 'data': []};
      // return false;
    });
  }

  // delete post
  static Future<dynamic> deletePost(deletedPostId) async {
    // _isLoading = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    var url = Uri.parse(
        'https://reflecty-2a4da-default-rtdb.firebaseio.com/posts/$userId/$deletedPostId.json');
    return http.delete(url).then((http.Response response) {
      return true;
    }).catchError((error) {
      return false;
    });
  }
}
