import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_finance_app/components/CategorySpendingChart.dart';
import 'package:flutter_finance_app/components/CummulativeSpendingChart.dart';
import 'package:flutter_finance_app/models/Category.dart';
import 'package:flutter_finance_app/models/UserTransaction.dart';
import 'package:flutter_finance_app/services/database.dart' as db;
import 'package:flutter_finance_app/components/TransactionList.dart';
import 'package:flutter_finance_app/components/NewTransaction.dart';
import 'package:select_form_field/select_form_field.dart';

import 'package:csv/csv.dart';
import 'package:url_launcher/url_launcher.dart';

void _generateCsvFile(List<UserTransaction> userTransactionList) async {
  List<dynamic> row = [];
  row.add("ID");
  row.add("CATEGORY");
  row.add("DESCRIPTION");
  row.add("AMOUNT");
  row.add("DATE");

  List<List<dynamic>> rows = [];
  rows.add(row);
  for (int i = 0; i < userTransactionList.length; i++) {
    List<dynamic> row = [];
    row.add(userTransactionList[i].id);
    row.add(userTransactionList[i].category);
    row.add(userTransactionList[i].description);
    row.add(userTransactionList[i].amount);
    row.add(userTransactionList[i].id);
    rows.add(row);
  }

  String csv = const ListToCsvConverter().convert(rows);

  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURL("eduardo.vilasboas.guerra@protonmail.com", "Data", csv);
  print("Finished.");
}

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

  final categoryController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  List<Map<String, dynamic>> _itemCategoryList = [];

  static final all = "All";

  @override
  void initState() {
    super.initState();
    List<Map<String, dynamic>> _itemsTemp = [];

    Category.categoryDictionary.forEach((key, value) => _itemsTemp
        .add({'value': key, 'label': key, 'icon': value[Category.icon]}));

    _itemsTemp
        .add({'value': all, 'label': all, 'icon': Icon(Icons.all_inclusive)});

    setState(() {
      _itemCategoryList = _itemsTemp;
    });
    executeUpdate();
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bContext) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(
              addTransaction: db.saveTransaction, executeUpdate: executeUpdate),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  static final cummulative = "Cummulative";
  static final total = "Total";
  static final transactions = "Transactions";

  String _itemViewSelected = 'Cummulative';
  final List<Map<String, dynamic>> _itemViewList = [
    {
      'value': cummulative,
      'label': cummulative,
    },
    {
      'value': total,
      'label': total,
    },
    {
      'value': transactions,
      'label': transactions,
    },
  ];

  @override
  Widget build(BuildContext context) {
    var currentTransactionList = recentTransactions;

    if (this.categoryController.text.isNotEmpty &&
        this.categoryController.text != all) {
      currentTransactionList = currentTransactionList
          .where((element) => element.category == this.categoryController.text)
          .toList();
    }

    if (this.startDateController.text.isNotEmpty) {
      currentTransactionList = currentTransactionList
          .where((element) =>
              element.date.millisecondsSinceEpoch >=
              DateTime.parse(this.startDateController.text)
                  .millisecondsSinceEpoch)
          .toList();
    }

    if (this.endDateController.text.isNotEmpty) {
      currentTransactionList = currentTransactionList
          .where((element) =>
              element.date.millisecondsSinceEpoch <=
              DateTime.parse(this.endDateController.text)
                  .millisecondsSinceEpoch)
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SelectFormField(
              type: SelectFormFieldType.dropdown, // or can be dialog
              labelText: 'View',
              items: _itemViewList,
              onChanged: (val) => setState(() {
                _itemViewSelected = val;
              }),
              onSaved: (val) => print(val),
            ),
            SelectFormField(
              type: SelectFormFieldType.dropdown, // or can be dialog
              initialValue: null,
              labelText: 'Spending category',
              items: _itemCategoryList,
              onChanged: (val) => setState(() {
                this.categoryController.text = val;
              }),
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: TextField(
                      readOnly: true,
                      controller: this.startDateController,
                      decoration: InputDecoration(hintText: 'Start Date'),
                      onTap: () async {
                        var date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100));
                        setState(() {
                          this.startDateController.text =
                              date.toString().substring(0, 10);
                        });
                      },
                    )),
                Expanded(
                    flex: 1,
                    child: TextField(
                      readOnly: true,
                      controller: this.endDateController,
                      decoration: InputDecoration(hintText: 'End Date'),
                      onTap: () async {
                        var date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100));
                        setState(() {
                          this.endDateController.text =
                              date.toString().substring(0, 10);
                        });
                      },
                    )),
              ],
            ),
            _itemViewSelected == total
                ? CategorySpendingChart(categorySpending: categorySpending)
                : (_itemViewSelected == cummulative
                    ? CummulativeSpendingChart(
                        timeSeries: userTransactionByCategoryList)
                    : TransactionList(currentTransactionList, executeUpdate)),
            TextButton(
              child: Text("Export to CSV"),
              onPressed: () => _generateCsvFile(recentTransactions),
            ),
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
