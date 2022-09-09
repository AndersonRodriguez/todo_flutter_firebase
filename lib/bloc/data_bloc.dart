import 'dart:async';

import 'package:todo_flutter_firebase/models/data_model.dart';
import 'package:todo_flutter_firebase/providers/db_provider.dart';

class DataBloc {
  static final DataBloc _singleton = DataBloc._internal();

  final _dataController = StreamController<List<DataModel>>.broadcast();

  Stream<List<DataModel>> get dataStream => _dataController.stream;

  factory DataBloc() => _singleton;

  DataBloc._internal() {
    getAllData();
  }

  dispose() {
    _dataController.close();
  }

  getAllData() async {
    _dataController.sink.add(await DBProvider.db.getAllData());
  }

  addData(DataModel data) async {
    await DBProvider.db.createDataSQL(data);
    getAllData();
  }

  deleteDataId(int id) async {
    await DBProvider.db.deleteData(id);
    getAllData();
  }
}
