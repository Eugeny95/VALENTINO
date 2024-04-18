import 'package:data_layer/models/db_models/history_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import "package:collection/collection.dart";

class StorageDBProvider {
  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  late Database database;
  Future<void> init() async {
    String _databasesPath = await getDatabasesPath();
    String _path = _databasesPath + '/test_db3.db';

    database = await openDatabase(_path, version: 3, onConfigure: _onConfigure,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE history_order (id INTEGER PRIMARY KEY, status TEXT, totalcost REAL, date_time INTEGER);');

      await db.execute(
          'CREATE TABLE positions (id INTEGER PRIMARY KEY, name TEXT, amount INTEGER, cost REAL, order_id INTEGER, FOREIGN KEY (order_id)  REFERENCES history_order (id) ON DELETE CASCADE);');
    });
  }

  Future<void> insertOrder({required HistoryDbModel historyDbModel}) async {
    print('insert order');
    final db = await database;
    int orderId = await db.insert(
      'history_order',
      historyDbModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    for (PositionDbModel positionDbModel in historyDbModel.positions!) {
      positionDbModel.order_id = orderId;
      print('insert position with id $orderId');
      await db.insert(
        'positions',
        positionDbModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    }
  }

  Future<List<HistoryDbModel>> getHistoryOrders() async {
    final db = await database;
    List<HistoryDbModel> listHistoryDbModel = [];
    String query =
        '''SELECT history_order.id,  history_order.date_time, history_order.status,
       history_order.totalcost, positions.name, positions.amount, positions.cost
      FROM history_order LEFT JOIN positions ON history_order.id = positions.order_id ''';

    List<Map> result = await db.rawQuery(query);

    var newMap = groupBy(result, (obj) => obj['id']);

    for (var key in newMap.keys) {
      HistoryDbModel historyDbModel = HistoryDbModel(
        id: newMap[key]![0]['id'] ?? 0,
        totalcost: newMap[key]![0]['totalcost'] ?? 0,
        date_time: newMap[key]![0]['date_time'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                newMap[key]![0]['date_time'] as int)
            : null,
        status: newMap[key]![0]['status'] != null
            ? OrderStatus.values
                .firstWhere((e) => (e.toString() == newMap[key]![0]['status']))
            : null,
      );
      historyDbModel.positions = [];

      //

      for (var position in newMap[key]!) {
        print('get position');
        PositionDbModel positionDbModel = PositionDbModel(
          name: position['name'] ?? '',
          amount: position['amount'] ?? 0,
          cost: position['cost'] ?? 0,
        );

        historyDbModel.positions!.add(positionDbModel);
      }
      listHistoryDbModel.add(historyDbModel);
    }
    return listHistoryDbModel;
  }
}
