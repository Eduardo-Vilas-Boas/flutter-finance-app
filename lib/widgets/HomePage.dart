import 'package:flutter/material.dart';
import 'package:flutter_finance_app/models/UserTransaction.dart';
import 'package:flutter_finance_app/services/database.dart' as db;
import 'package:flutter_finance_app/widgets/transaction_list.dart';

import 'chart.dart';
import 'new_transaction.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UserTransaction> userTransactionList = [];

  Future<void> getTransactionList() async {
    List<UserTransaction> userTransactionListTemp = await db.getTransactions();

    setState(() {
      userTransactionList = userTransactionListTemp;
    });
  }

  @override
  void initState() {
    super.initState();
    getTransactionList();
  }

  List<UserTransaction> get _recentTransactions {
    return userTransactionList.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bContext) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(db.saveTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("userTransactionList: " + userTransactionList.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Finance App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Chart(_recentTransactions),
            TransactionList(userTransactionList),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}