import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_flutter_firebase/models/product.dart';
import 'package:todo_flutter_firebase/services/api_service.dart';

class ProductFormScreen extends StatefulWidget {
  Product? product;

  ProductFormScreen({Key? key, this.product}) : super(key: key);

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final TextEditingController _controllerName = TextEditingController();

  final ApiService _apiService = ApiService();

  bool _isEditing = false;

  File? _image;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _isEditing = true;
      _controllerName.text = widget.product!.name;
    }
  }

  _showSnackBar(String value) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Text(value),
        ],
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _save() {
    if (_controllerName.text.isEmpty && _image != null) {
      return;
    }

    Product product = Product(_controllerName.text);

    _apiService.saveImage(_image!).then((imageString) {
      product.image = imageString;

      // if (imageString!.isNotEmpty) {
      //   return;
      // }

      if (_isEditing) {
        product.id = widget.product!.id;
        _apiService.updateProduct(product).then((value) {
          if (value) {
            _apiService.getProducts();
            Navigator.pop(context);
          } else {
            _showSnackBar('Error en editar');
          }
        });
      } else {
        _apiService.createProduct(product).then((value) {
          if (value) {
            _apiService.getProducts();
            Navigator.pop(context);
          } else {
            _showSnackBar('Error en creación');
          }
        });
      }
    });
  }

  _selectImage() {
    _proccessImage(ImageSource.gallery);
  }

  _takeImage() {
    _proccessImage(ImageSource.camera);
  }

  _proccessImage(ImageSource source) async {
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      print(pickedImage.path);
      _image = File(pickedImage.path);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _isEditing ? 'Formulario de edición' : 'Formulario de creación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildName(),
            _buildImage(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: _selectImage,
                  icon: const Icon(Icons.photo_size_select_actual),
                ),
                IconButton(
                  onPressed: _takeImage,
                  icon: const Icon(Icons.camera_alt),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _save,
              child: Text(_isEditing ? 'Editar' : 'Guardar'),
            )
          ],
        ),
      ),
    );
  }

  _buildName() {
    return TextField(
      controller: _controllerName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Nombre',
        errorText: _controllerName.text.isNotEmpty ? null : 'Requerido',
      ),
    );
  }

  _buildImage() {
    if (widget.product?.image != null) {
      return Center(
        child: Image.network(widget.product!.image!),
      );
    }
    return Center(
      child: _image == null
          ? const Text('Seccione una image')
          : Image.file(_image!),
    );
  }
}
