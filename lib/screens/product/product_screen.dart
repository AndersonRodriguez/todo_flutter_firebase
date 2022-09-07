import 'package:flutter/material.dart';
import 'package:todo_flutter_firebase/models/product.dart';
import 'package:todo_flutter_firebase/screens/product/product_form_screen.dart';
import 'package:todo_flutter_firebase/services/api_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ApiService? _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: FutureBuilder(
        future: _apiService?.getProducts(),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error ${snapshot.error.toString()}'),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Product> products = snapshot.data!;
            return _buildListView(products);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _buildListView(List<Product> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        Product product = products[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // _confirmDeleteProduct(context, product);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductFormScreen(product: product),
                          ),
                        );
                      },
                      child: const Text('Editar'),
                    ),
                    TextButton(
                      onPressed: () {
                        _confirmDeleteProduct(context, product);
                      },
                      child: const Text(
                        'Eliminar',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _confirmDeleteProduct(BuildContext context, Product product) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Alerta!!!'),
            content:
                Text('Esta seguro de eliminar este producto ${product.name}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('NO'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _apiService!.deleteProduct(product.name).then((isSucces) {
                    if (isSucces) {
                      _apiService!.getProducts();
                    } else {
                      print('Error al eliminar');
                    }
                  });
                },
                child: const Text('SI'),
              ),
            ],
          );
        });
  }
}
