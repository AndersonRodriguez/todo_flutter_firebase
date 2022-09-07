import 'package:flutter/material.dart';
import 'package:todo_flutter_firebase/models/data_model.dart';
import 'package:todo_flutter_firebase/providers/db_provider.dart';

class OffileneScreen extends StatefulWidget {
  const OffileneScreen({Key? key}) : super(key: key);

  @override
  State<OffileneScreen> createState() => _OffileneScreenState();
}

class _OffileneScreenState extends State<OffileneScreen> {
  _addData() {
    DataModel data = DataModel('Valor 2');

    DBProvider.db.createDataSQL(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addData,
        child: const Icon(Icons.add),
      ),
    );
  }
}
