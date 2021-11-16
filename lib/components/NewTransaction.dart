import 'package:flutter/material.dart';

import 'TransactionForm.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  final void Function() executeUpdate;

  NewTransaction({required this.addTransaction, required this.executeUpdate});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  void submitData() {
    FocusScope.of(context).unfocus();
    new TextEditingController().clear();

    if (amountController.text.isEmpty) {
      return;
    }

    final enteredCategory = categoryController.text;
    final enteredDescription = descriptionController.text;
    final enteredAmount = double.parse(amountController.text);
    final enteredDate = dateController.text;
    final enteredTime = timeController.text;

    if (enteredCategory.isEmpty ||
        enteredDescription.isEmpty ||
        enteredAmount <= 0 ||
        enteredDate.isEmpty ||
        enteredTime.isEmpty) {
      return;
    }

    var date = DateTime.parse(enteredDate);
    var timeArray = enteredTime.split(":");
    var hour = int.parse(timeArray[0]);
    var minute = int.parse(timeArray[1]);

    date = DateTime(date.year, date.month, date.day, hour, minute);

    this.widget.addTransaction(enteredCategory, enteredDescription,
        enteredAmount, date.millisecondsSinceEpoch);
    this.widget.executeUpdate();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TransactionForm(
                executeUpdate: this.widget.executeUpdate,
                submitData: this.submitData,
                categoryController: this.categoryController,
                descriptionController: this.descriptionController,
                amountController: this.amountController,
                dateController: this.dateController,
                timeController: this.timeController),
            TextButton(
              child: Text('Add Transaction'),
              onPressed: submitData,
            )
          ],
        ),
      ),
    );
  }
}
