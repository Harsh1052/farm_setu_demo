import 'package:http/http.dart' as http;

Future<String> downloadFile(String url) async {
  final response = await http.get(Uri.parse(url),headers: { "Access-Control-Allow-Origin": "*",
    'Content-Type': 'application/json',
    'Accept': '*/*'} );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to download file');
  }
}