import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageUpload {

  Future<String?> uploadImageToCloudinary(File imageFile) async {

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dwdhkwu0r/upload');

    final request = http.MultipartRequest('POST', url)..fields['upload_preset'];
    request.fields['upload_preset'] = "ecommerce";
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      return jsonResponse['secure_url']; 
    } else {
      print("Upload failed: ${response.reasonPhrase}");
      return null;
    }
  }

}
