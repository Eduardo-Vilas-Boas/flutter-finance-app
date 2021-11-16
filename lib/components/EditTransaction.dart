import 'package:flutter/material.dart';
import 'package:flutter_finance_app/models/UserTransaction.dart';
import 'package:flutter_finance_app/services/database.dart';
import 'package:flutter_finance_app/services/utils.dart';

import 'TransactionForm.dart';

class EditTransaction extends StatefulWidget {
  final UserTransaction userTransaction;

  final void Function() executeUpdate;

  EditTransaction({required this.executeUpdate, required this.userTransaction});

  @override
  _EditTransactionState createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    categoryController.text = this.widget.userTransaction.category;
    descriptionController.text = this.widget.userTransaction.description;
    amountController.text =
        this.widget.userTransaction.amount.toStringAsFixed(2);
    dateController.text =
        this.widget.userTransaction.date.toString().substring(0, 10);
    timeController.text = getTimeString(TimeOfDay(
        hour: this.widget.userTransaction.date.hour,
        minute: this.widget.userTransaction.date.minute));
  }

  void submitData(BuildContext previousContext) {
    FocusScope.of(previousContext).unfocus();
    new TextEditingController().clear();

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

    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Please Confirm'),
            content: Text('Are you sure to update the transaction?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    updateTransaction(
                        this.widget.userTransaction.id,
                        enteredCategory,
                        enteredDescription,
                        enteredAmount,
                        date.millisecondsSinceEpoch);
                    this.widget.executeUpdate();
                    Navigator.of(context).pop();
                    Navigator.of(previousContext).pop();
                  },
                  child: Text('Yes')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('No'))
            ],
          );
        });
  }

  void deleteData(BuildContext previousContext) {
    FocusScope.of(previousContext).unfocus();
    new TextEditingController().clear();

    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Please Confirm'),
            content: Text('Are you sure to remove the transaction?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    deleteTransaction(this.widget.userTransaction.id);
                    this.widget.executeUpdate();
                    Navigator.of(context).pop();
                    Navigator.of(previousContext).pop();
                  },
                  child: Text('Yes')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('No'))
            ],
          );
        });
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
            Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: Text('Update'),
                    onPressed: () => submitData(context),
                  ),
                  TextButton(
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => deleteData(context),
                  )
                ])
          ],
        ),
      ),
    );
  }
}
