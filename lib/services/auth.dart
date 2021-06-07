import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static Future<Map<String, dynamic>> signupService(
      {surname, firstName, email, password}) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'firstName': firstName,
      'surname': surname
    };

    var url = Uri.parse(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyBFXfbiVJ28Eg6_PIRUCQbLKQyHd_5v2c8');
    http.Response response = await http.post(url,
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'});
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    bool hasError = true;
    String message = 'Something went wrong!';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      hasError = true;
      message = 'This email not found';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      hasError = true;
      message = 'This email already exists';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      hasError = true;
      message = 'Password invalid';
    }

    return {'success': !hasError, 'message': message};
  }

  static Future<Map<String, dynamic>> signInService({email, password}) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBFXfbiVJ28Eg6_PIRUCQbLKQyHd_5v2c8');
    http.Response response = await http.post(url,
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'});
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    bool hasError = true;
    String message = 'Something went wrong!';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);

      prefs.setString('userId', responseData['localId']);
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      hasError = true;
      message = 'This email not found';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      hasError = true;
      message = 'This email already exists';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      hasError = true;
      message = 'Password invalid';
    }

    return {'success': !hasError, 'message': message};
  }
}
