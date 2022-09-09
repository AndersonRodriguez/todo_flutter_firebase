import 'package:flutter/material.dart';
import 'package:todo_flutter_firebase/bloc/data_bloc.dart';
import 'package:todo_flutter_firebase/models/data_model.dart';
import 'package:todo_flutter_firebase/providers/db_provider.dart';

class OfflineScreen extends StatelessWidget {
  OfflineScreen({Key? key}) : super(key: key);

  final _dataBloc = DataBloc();

  _addData() {
    DataModel data = DataModel('Valor 4');

    // DBProvider.db.createDataSQL(data);
    _dataBloc.addData(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline'),
      ),
      // body: FutureBuilder(
      //   future: DBProvider.db.getAllData(),
      body: StreamBuilder<List<DataModel>>(
        stream: _dataBloc.dataStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<DataModel>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data;

          if (data!.isEmpty) {
            return const Center(
              child: Text('Sin datos'),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) => Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.red,
              ),
              // onDismissed: (direction) =>
              //     DBProvider.db.deleteData(data[index].id!),
              onDismissed: (direction) =>
                  _dataBloc.deleteDataId(data[index].id!),
              child: ListTile(
                title: Text(data[index].value),
                subtitle: Text('${data[index].id}'),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addData,
        child: const Icon(Icons.add),
      ),
    );
  }
}
