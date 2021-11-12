import 'package:flutter/material.dart';
import 'package:flutter_finance_app/components/CategorySpendingChart.dart';
import 'package:flutter_finance_app/models/UserTransaction.dart';
import 'package:flutter_finance_app/services/database.dart' as db;
import 'package:flutter_finance_app/components/TransactionList.dart';
import 'package:flutter_finance_app/components/NewTransaction.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UserTransaction> userTransactionList = [];
  List<dynamic> categorySpending = [];
  List<UserTransaction> recentTransactions = [];

  Future<void> getTransactionList() async {
    List<UserTransaction> userTransactionListTemp = await db.getTransactions();

    setState(() {
      userTransactionList = userTransactionListTemp;
    });
  }

  Future<void> getCategorySpending() async {
    List<dynamic> categorySpendingTemp = await db.getCategorySpending();

    print("categorySpendingTemp: " + categorySpendingTemp.toString());

    setState(() {
      categorySpending = categorySpendingTemp;
    });
  }

  Future<void> getRecentTransactions() async {
    List<UserTransaction> recentTransactionsTemp =
        await db.getRecentTransactions();

    setState(() {
      recentTransactions = recentTransactionsTemp;
    });
  }

  void executeUpdate() {
    getTransactionList();
    getCategorySpending();
    getRecentTransactions();
  }

  @override
  void initState() {
    super.initState();
    executeUpdate();
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bContext) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(db.saveTransaction, executeUpdate),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance App'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.only(top: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            BarChartSample3(categorySpending: this.categorySpending),
            TransactionList(recentTransactions),
          ],
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
