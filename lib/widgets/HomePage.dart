import 'package:flutter/material.dart';
import 'package:flutter_finance_app/components/CategorySpendingChart.dart';
import 'package:flutter_finance_app/components/CummulativeSpendingChart.dart';
import 'package:flutter_finance_app/models/Category.dart';
import 'package:flutter_finance_app/models/UserTransaction.dart';
import 'package:flutter_finance_app/services/database.dart' as db;
import 'package:flutter_finance_app/components/TransactionList.dart';
import 'package:flutter_finance_app/components/NewTransaction.dart';
import 'package:select_form_field/select_form_field.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<UserTransaction>> userTransactionByCategoryList = [];
  List<dynamic> categorySpending = [];
  List<UserTransaction> recentTransactions = [];

  Future<void> getTransactionList() async {
    List<String> categories = [];

    Category.categoryDictionary.forEach((key, value) => {categories.add(key)});
    categories.sort();

    List<List<UserTransaction>> timeSeries = [];

    Category.categoryOrder.forEach((value) async => {
          timeSeries.add(await db.getTransactionListByCategory(value)
              as List<UserTransaction>)
        });

    setState(() {
      userTransactionByCategoryList = timeSeries;
    });
  }

  Future<void> getCategorySpending() async {
    List<dynamic> categorySpendingTemp = await db.getCategorySpending();

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

  String _itemSelected = 'Cummulative';
  final List<Map<String, dynamic>> _items = [
    {
      'value': 'Cummulative',
      'label': 'Cummulative',
    },
    {
      'value': 'Total',
      'label': 'Total',
    },
    {
      'value': 'Recent',
      'label': 'Recent',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SelectFormField(
              type: SelectFormFieldType.dropdown, // or can be dialog
              labelText: 'View',
              items: _items,
              onChanged: (val) => setState(() {
                _itemSelected = val;
              }),
              onSaved: (val) => print(val),
            ),
            CategorySpendingChart(categorySpending: categorySpending),
            CummulativeSpendingChart(timeSeries: userTransactionByCategoryList),
            TransactionList(recentTransactions),
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
