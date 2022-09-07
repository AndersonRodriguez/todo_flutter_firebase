import 'dart:io';
import 'dart:convert';

import 'package:mime_type/mime_type.dart';
import 'package:todo_flutter_firebase/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  final String _baseUrl = 'http://192.168.20.22:3000/';

  final String _baseUrlImage =
      'https://api.cloudinary.com/v1_1/daqkw9a0u/image/upload?upload_preset=s06nzenj';

  Future<List<Product>> getProducts() async {
    try {
      var response = await http.get(
        Uri.parse('${_baseUrl}product'),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return productsFromJson(response.body);
      } else {
        throw 'Error en petición';
        // return [];
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Product?> getProduct(String id) async {
    var response = await http.get(
      Uri.parse('${_baseUrl}product/$id'),
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Product.fromJson(response.body);
    }
  }

  Future<bool> createProduct(Product product) async {
    var response = await http.post(
      Uri.parse('${_baseUrl}product'),
      headers: {'content-type': 'application/json'},
      body: product.toJson(),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    print(product.toJson());

    var response = await http.put(
      Uri.parse('${_baseUrl}product/${product.name}'),
      headers: {'content-type': 'application/json'},
      body: product.toJson(),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    var response = await http.delete(
      Uri.parse('${_baseUrl}product/$id'),
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<String?> saveImage(File image) async {
    final mimeType = mime(image.path)!.split('/'); // image/jpeg

    final request = http.MultipartRequest('POST', Uri.parse(_baseUrlImage));

    final file = await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType(
        mimeType[0],
        mimeType[1],
      ),
      filename: 'image',
    );

    request.files.add(file);

    final streamResponse = await request.send();

    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200) {
      return null;
    }

    final responseData = json.decode(response.body);

    return responseData['secure_url'];
  }
}
