import 'package:flutter/material.dart';
import 'package:flutter_finance_app/models/Category.dart';
import 'package:select_form_field/select_form_field.dart';

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
  List<Map<String, dynamic>> _items = [];


  @override
  void initState() {
    super.initState();

    List<Map<String, dynamic>> _itemsTemp = [];
    
    Category.categoryDictionary.forEach((key, value) => 
      _itemsTemp.add({
        'value': key,
        'label': key,
        'icon': value
        })
    );

    setState(() {
      _items = _itemsTemp;
    });
  }

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
                    SelectFormField(
                      type: SelectFormFieldType.dropdown, // or can be dialog
                      initialValue: null,
                      labelText: 'Spending category',
                      items: _items,
                      onChanged: (val) => setState(() {
                        categoryController.text = val;
                      }),
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