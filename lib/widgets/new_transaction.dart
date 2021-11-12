import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();

  void submitData() {
    final enteredCategory = categoryController.text;
    final enteredDescription = descriptionController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredCategory.isEmpty || enteredDescription.isEmpty || enteredAmount <= 0) {
      return;
    }

    widget.addTransaction(
      enteredCategory,
      enteredDescription,
      enteredAmount,
      DateTime.now().millisecondsSinceEpoch
    );
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
                    TextField(
                      decoration: InputDecoration(labelText: 'Category'),
                      controller: categoryController,
                      onSubmitted: (_) => submitData(),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Description'),
                      controller: descriptionController,
                      onSubmitted: (_) => submitData(),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Amount'),
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => submitData(),
                    ),
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