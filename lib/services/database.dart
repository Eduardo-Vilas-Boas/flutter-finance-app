import 'dart:ffi';

import 'package:flutter_finance_app/models/UserTransaction.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const DATABASE_NAME = "my_db.db";

const TABLENAME = "UserTransaction";

const ID = "ID";
const CATEGORY = "CATEGORY";
const DESCRIPTION = "DESCRIPTION";
const AMOUNT = "AMOUNT";
const DATE = "DATE";

const SUM = "SUM";

Future<void> startDatabase() async {
  // Get a location using getDatabasesPath
  var databasesPath = await getDatabasesPath();

  String path = join(databasesPath, DATABASE_NAME);

  // open the database
  await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table

    String sqlCommand = "CREATE TABLE IF NOT EXISTS " +
        TABLENAME +
        " (" +
        ID +
        " INTEGER PRIMARY KEY AUTOINCREMENT, " +
        CATEGORY +
        " TEXT, " +
        DESCRIPTION +
        " TEXT, " +
        AMOUNT +
        " NUMERIC, " +
        DATE +
        " INTEGER)";

    await db.execute(sqlCommand);
  });
}

Future<void> saveTransaction(
    String category, String description, double amount, int date) async {
  var database = await openDatabase(DATABASE_NAME);

  String sqlScript = "INSERT INTO " +
      TABLENAME +
      "(" +
      CATEGORY +
      ", " +
      DESCRIPTION +
      ", " +
      AMOUNT +
      ", " +
      DATE +
      ") VALUES(?, ?, ?, ?)";

  print("sqlScript: " + sqlScript);

  // Update some record
  await database.rawInsert(sqlScript, [category, description, amount, date]);
}

Future<List> getCategorySpending() async {
  var database = await openDatabase(DATABASE_NAME);

  String sqlScript = "SELECT " +
      CATEGORY +
      ", SUM(" +
      AMOUNT +
      ") AS " +
      SUM +
      " FROM " +
      TABLENAME +
      " GROUP BY " +
      CATEGORY +
      " ORDER BY " +
      CATEGORY;

  List<Map> transactionList = await database.rawQuery(sqlScript);
  List categorySpending = [];

  for (var i = 0; i < transactionList.length; i = i + 1) {
    categorySpending
        .add([transactionList[i][CATEGORY], transactionList[i][SUM]]);
  }

  return categorySpending;
}

Future<List<UserTransaction>> getRecentTransactions() async {
  var database = await openDatabase(DATABASE_NAME);

  int oneWeekBefore =
      DateTime.now().subtract(Duration(days: 7)).millisecondsSinceEpoch;

  String sqlScript = 'SELECT * FROM ' +
      TABLENAME +
      " WHERE " +
      DATE +
      " >= " +
      oneWeekBefore.toString();

  List<Map> transactionList = await database.rawQuery(sqlScript);

  List<UserTransaction> userTransactionList = [];

  for (var i = 0; i < transactionList.length; i = i + 1) {
    UserTransaction userTransaction = new UserTransaction(
        id: transactionList[i][ID],
        category: transactionList[i][CATEGORY],
        description: transactionList[i][DESCRIPTION],
        amount: double.parse(transactionList[i][AMOUNT].toString()),
        date: DateTime.fromMillisecondsSinceEpoch(transactionList[i][DATE]));

    userTransactionList.add(userTransaction);
  }

  return userTransactionList;
}

Future<List<UserTransaction>> getTransactions() async {
  var database = await openDatabase(DATABASE_NAME);

  List<Map> transactionList =
      await database.rawQuery('SELECT * FROM ' + TABLENAME);

  List<UserTransaction> userTransactionList = [];

  for (var i = 0; i < transactionList.length; i = i + 1) {
    UserTransaction userTransaction = new UserTransaction(
        id: transactionList[i][ID],
        category: transactionList[i][CATEGORY],
        description: transactionList[i][DESCRIPTION],
        amount: double.parse(transactionList[i][AMOUNT].toString()),
        date: DateTime.fromMillisecondsSinceEpoch(transactionList[i][DATE]));

    userTransactionList.add(userTransaction);
  }

  return userTransactionList;
}
