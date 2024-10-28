import 'package:http/http.dart' as http;

abstract class BaseApiServices {
  // get APi
  Future<dynamic> getApi(String url, Map<String, String> headers,
      {String? query});

  // get APi stream
  Stream<http.Response> getStreemApi(String url, Map<String, String> headers);

// Post
  Future<dynamic> postApi(
      Map<String,dynamic> data, String url, Map<String, String> headers);

  // Update
  Future<dynamic> updateApi(
      dynamic data, String url, Map<String, String> headers);

  // Delete
  Future<dynamic> deleteApi(String url, Map<String, String> headers);

//Form data abstract Class................................................>>
// Form data PostAPI
  Future<dynamic> formDataPostServices(url, Map<String, String> data,
      Map<String, String> headers, String filekey, String images,{String? filekey2, String? filePath2});

// Form data UpdateAPIServices
  Future<dynamic> formDataUpdateServices(url, Map<String, String> data,
      Map<String, String> headers, String filekey, String images);
}
