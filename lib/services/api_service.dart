import 'package:todo_flutter_firebase/models/product.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'http://192.168.20.22:3000/';

  Future<List<Product>> getProducts() async {
    try {
      var response = await http.get(
        Uri.parse('${_baseUrl}product'),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return productsFromJson(response.body);
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
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

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    var response = await http.put(
      Uri.parse('${_baseUrl}product/${product.id}'),
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
}
