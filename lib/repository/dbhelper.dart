import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../model/item.dart';

class DbHelper {

  // Atributos: o nome da tabela e os nomes das colunas:
  String tblItem = "item";
  String colId = "id";
  String colName = "name";
  String colDescription = "description";
  String colCondition = "condition";
  String colLocation = "location";


  DbHelper._internal();

  static final DbHelper _dbHelper = DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}items.db";
    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblItem($colId INTEGER PRIMARY KEY, $colName TEXT, " +
            "$colDescription TEXT, $colCondition TEXT, $colLocation TEXT)");

  }

  static Database? _db;

  Future<Database> get db async {
    _db ??= await initializeDb();
    return _db!;
  }

// Método para inserir dados no banco.
  Future<int> createItem(Item item) async {

    Database db = await this.db;

    var result = await db.insert(tblItem, item.toMap());
    return result;
  }

// Recuperar todos os registros.
  Future<List> getItems() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblItem");
    return result;
  }

// Recuperar o número de registros da tabela.
  Future<int> getCount() async {
    Database db = await this.db;

    var result = Sqflite.firstIntValue(
        await db.rawQuery("select count (*) from $tblItem")
    );
    return result!;
  }

// Método para atualizar registro.
  Future<int> updateItem(Item item) async {
    var db = await this.db;
    var result = await db.update(tblItem,
        item.toMap(),
        where: "$colId = ?",
        whereArgs: [item.id]);
    return result;
  }

// Método para apagar registro.
  Future<int> deleteItem(int id) async {
    int result;
    var db = await this.db;
    result = await db.rawDelete('DELETE FROM $tblItem WHERE $colId = $id');
    return result;
  }

}