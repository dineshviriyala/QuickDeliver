import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:your_project_name/Models/AppConstants.dart';
import 'package:your_project_name/Models/BadRequestModel.dart';

// ignore: non_constant_identifier_names
class HttpOperations {
  HttpOperations();
  Future<http.Response> ourgetAsync(String endPoint,
      {requireToken = false}) async {
    try {
      String finalUrl;
      if (!endPoint.contains('http')) {
        finalUrl = 'https://$endPoint';
      } else {
        finalUrl = endPoint;
      }
      Map<String, String> headers;
      headers = {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        HttpHeaders.cacheControlHeader: 'no-cache',
      };
      if (requireToken) {
        var header = {"Authorization": "Bearer ${appUser.token}"};
        // var header = {"Authorization": "Bearer "};
        headers.addAll(header);
      }
      Uri uri = Uri.parse(finalUrl);
      final response = await http.get(uri, headers: headers);
      return response;
    } catch (e) {
      if (e is SocketException) {
        throw 'No internet available';
      } else {
        throw (e.toString());
      }
    }
  }

  Future<http.Response> ourpostAsync(String endPoint, Map data,
      {requireToken = false}) async {
    try {
      String finalUrl;
      if (!endPoint.contains('http')) {
        finalUrl = 'https://$endPoint';
      } else {
        finalUrl = endPoint;
      }
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        HttpHeaders.cacheControlHeader: 'no-cache',
      };
      if (requireToken) {
        var header = {"Authorization": "Bearer ${appUser.token}"};
        headers.addAll(header);
      }
      // String s = jsonEncode(data);
      // s = s;
      var client = http.Client();
      var response = await client.post(Uri.parse(finalUrl),
          body: jsonEncode(data), headers: headers);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}
