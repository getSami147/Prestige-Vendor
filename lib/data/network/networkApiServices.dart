import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:prestige_vender/data/appException.dart';
import 'package:prestige_vender/data/network/baseApiServices.dart';

class NetworkApiServices extends BaseApiServices {
  // Get API Method......
  @override
  Future<dynamic> getApi(String url, Map<String, String> headers,{String? query}) async {
    dynamic jsonResponse;
    try {
      final response = await http.get(Uri.parse(url).replace(query: query),
          headers: headers);
      jsonResponse = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    }
    return jsonResponse;
  }

  // getStreemApiMethod......
  @override
  getStreemApi(String url, Map<String, String> headers) async {
    dynamic jsonResponse;
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      jsonResponse = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    }
    return jsonResponse;
  }

  // Post API Method......
  @override
  Future<dynamic> postApi(Map<String,dynamic> data, String url,
      Map<String, String> headers) async {
    dynamic jsonResponse;
    try {
      final response = await http
          .post(Uri.parse(url), body: jsonEncode(data), headers: headers)
          .timeout(const Duration(seconds: 15));
      jsonResponse = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    }
    return jsonResponse;
  }

  // update Api Method......
  @override
  Future<dynamic> updateApi(
      dynamic data, String url, Map<String, String> headers) async {
    dynamic jsonResponse;
    try {
      final response = await http
          .patch(Uri.parse(url), body: jsonEncode(data), headers: headers)
          .timeout(const Duration(seconds: 15));
      jsonResponse = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    }
    return jsonResponse;
  }

  // delete Api Method......
  @override
  Future<dynamic> deleteApi(String url, Map<String, String> headers) async {
    dynamic jsonResponse;
    try {
      final response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 15)
          );
      jsonResponse = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    }
    return jsonResponse;
  }

  //formDataPostServices.......
  @override
  Future formDataPostServices(dynamic url, Map<String,String> data,
      Map<String, String> headers, String? filekey, String? filePath ,{String? filekey2, String? filePath2}) async {
    dynamic responseJson;
    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));

       if (filePath != null && filePath.isNotEmpty) {
         request.files.add(await http.MultipartFile.fromPath(filekey.toString(), filePath));
      }
       if (filePath2 != null && filePath2.isNotEmpty) {
         request.files.add(await http.MultipartFile.fromPath(filekey2.toString(),filePath2.toString()));
      }
      
      request.fields.addAll(data);
      request.headers.addAll(headers);
      var response = await request.send();

      responseJson = returnFormResponse(response);
    } on SocketException {
      throw FatchDataExceptions('no internet connection');
    }
    return responseJson;
  }

  //formDataUpdateServices.......
  @override
  Future formDataUpdateServices(dynamic url, Map<String, String> data,
      Map<String, String> headers, String? filekey, String? filePath,{String? filekey2, String? filePath2}) async {
    dynamic responseJson;
    try {
      var request = http.MultipartRequest("PATCH", Uri.parse(url));

       if (filePath != null && filePath.isNotEmpty) {
         request.files.add(await http.MultipartFile.fromPath(filekey.toString(), filePath));
      }
       if (filePath2 != null && filePath2.isNotEmpty) {
         request.files.add(await http.MultipartFile.fromPath(filekey2.toString(),filePath2.toString()));
      }
      request.fields.addAll(data);
      request.headers.addAll(headers);
      var response = await request.send();
      responseJson = returnFormResponse(response);
    } on SocketException {
      throw FatchDataExceptions('no internet connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
      // debugPrint("status code: ${response.statusCode}");
      // debugPrint("body: ${response.body}");

    switch (response.statusCode) {
      
    
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 204:
        return "";
      case 302:
        throw UnAuthorizedExceptions("you have no mobile data ");
      case 400:
        throw BadRequestExceptions(
            jsonDecode(response.body)["message"].toString());
      case 401:
        throw UnAuthorizedExceptions(
            jsonDecode(response.body)["message"].toString());
       case 403:
        throw UnAuthorizedExceptions(
            jsonDecode(response.body)["message"].toString());
      case 404:
        throw NotFoundExceptions(
            jsonDecode(response.body)["message"].toString());
            
      case 409:
        throw ConflictingExceptions(
            jsonDecode(response.body)["message"].toString());
      case 429 :
        throw TooManyRequestsExceptions(
            response.body);
      case 500:
        throw ServerExceptions(jsonDecode(response.body)["message"].toString());
      case 503:
        throw ServiceUnavaibleExceptions(
            jsonDecode(response.body)["message"].toString());
      case 504:
        throw TimeoutExceptions(
            jsonDecode(response.body)["message"].toString());
      default:
        throw FatchDataExceptions(
            "Please check your internet connection : ${response.statusCode}");
    }
  }

  // form data response
  dynamic returnFormResponse(http.StreamedResponse response) async {

      // debugPrint("status code: ${response.statusCode}");
      // debugPrint("body: ${response.stream.bytesToString()}");

    switch (response.statusCode) {
      case 200:
        dynamic responseJson =
            jsonDecode(await response.stream.bytesToString());
        return responseJson;

      case 201:
        dynamic responseJson =
            jsonDecode(await response.stream.bytesToString());
        return responseJson;

      case 204:
        return "";
      case 302:
        throw UnAuthorizedExceptions("you have no mobile data ");

      case 400:
        var data = jsonDecode(await response.stream.bytesToString());
        throw BadRequestExceptions(data['message']);

      case 401:
        var data = jsonDecode(await response.stream.bytesToString());
        throw UnAuthorizedExceptions(data['message']);

      case 403:
        var data = jsonDecode(await response.stream.bytesToString());
        throw UnAuthorizedExceptions(data['message']);

      case 404:
        var data = jsonDecode(await response.stream.bytesToString());
        throw NotFoundExceptions(data['message']);

      case 409:
        var data = jsonDecode(await response.stream.bytesToString());
        throw ConflictingExceptions(data['message']);
      case 429:
        var data = jsonDecode(await response.stream.bytesToString());
        throw TooManyRequestsExceptions(data['message']);

      case 500:
        var data = jsonDecode(await response.stream.bytesToString());
        throw ServerExceptions(data['message']);

      case 503:
        var data = jsonDecode(await response.stream.bytesToString());
        throw ServiceUnavaibleExceptions(data['message']);

      case 504:
        var data = jsonDecode(await response.stream.bytesToString());
        throw TimeoutExceptions(data['message']);

      default:
        throw FatchDataExceptions(
            "Error Occurred While Communication With Server with Status Code ${response.statusCode}");
    }
  }
}
