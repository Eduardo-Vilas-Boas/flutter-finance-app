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

Future<void> startDatabase() async {
  // Get a location using getDatabasesPath
  var databasesPath = await getDatabasesPath();

  String path = join(databasesPath, DATABASE_NAME);

  // open the database
  await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table

    String sqlCommand = "CREATE TABLE " + TABLENAME +  " (" +
        ID + " INTEGER PRIMARY KEY AUTOINCREMENT, " +
        CATEGORY + " TEXT, " + 
        DESCRIPTION + " TEXT, " + 
        AMOUNT + " NUMERIC, " + 
        DATE + " INTEGER)";

    await db.execute(sqlCommand);
  });
}


Future<void> saveTransaction(String category, String description, double amount, int date) async {

  var database = await openDatabase(DATABASE_NAME);

  String sqlScript = "INSERT INTO " + TABLENAME + "(" + 
    CATEGORY + ", " + 
    DESCRIPTION + ", " + 
    AMOUNT + ", " + 
    DATE + ") VALUES(?, ?, ?, ?)";

  print("sqlScript: " + sqlScript);

  // Update some record
  await database.rawInsert(sqlScript, 
  [category, description, amount, date]);
}


Future<List<UserTransaction>> getTransactions() async {

  var database = await openDatabase(DATABASE_NAME);

  List<Map> transactionList = await database.rawQuery('SELECT * FROM ' + TABLENAME);

  List<UserTransaction> userTransactionList = [];

  for (var i = 0; i < transactionList.length; i = i + 1) {
    UserTransaction userTransaction = new UserTransaction(
      id: transactionList[i][ID],
      category: transactionList[i][CATEGORY],
      description: transactionList[i][DESCRIPTION],
      amount: double.parse(transactionList[i][AMOUNT].toString()),
      date: DateTime.fromMicrosecondsSinceEpoch(transactionList[i][DATE]));

    userTransactionList.add(userTransaction);
  }

  return userTransactionList;
}