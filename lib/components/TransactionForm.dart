import 'package:flutter/material.dart';
import 'package:flutter_finance_app/models/Category.dart';
import 'package:flutter_finance_app/services/utils.dart';
import 'package:select_form_field/select_form_field.dart';

class TransactionForm extends StatefulWidget {
  final TextEditingController categoryController;
  final TextEditingController descriptionController;
  final TextEditingController amountController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final Function submitData;

  final void Function() executeUpdate;

  TransactionForm(
      {required this.executeUpdate,
      required this.descriptionController,
      required this.categoryController,
      required this.amountController,
      required this.dateController,
      required this.timeController,
      required this.submitData});

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();

    List<Map<String, dynamic>> _itemsTemp = [];

    Category.categoryDictionary.forEach((key, value) => _itemsTemp
        .add({'value': key, 'label': key, 'icon': value[Category.icon]}));

    setState(() {
      _items = _itemsTemp;
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
            SelectFormField(
              type: SelectFormFieldType.dropdown, // or can be dialog
              initialValue: Category.categoryOrder
                      .contains(this.widget.categoryController.text)
                  ? this.widget.categoryController.text
                  : null,
              labelText: 'Spending category',
              items: _items,
              onChanged: (val) => setState(() {
                this.widget.categoryController.text = val;
              }),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
              controller: this.widget.descriptionController,
              onSubmitted: (_) => this.widget.submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: this.widget.amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => this.widget.submitData(),
            ),
            TextField(
              readOnly: true,
              controller: this.widget.dateController,
              decoration: InputDecoration(hintText: 'Pick your Date'),
              onTap: () async {
                var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100));
                this.widget.dateController.text =
                    date.toString().substring(0, 10);
              },
            ),
            TextField(
              readOnly: true,
              controller: this.widget.timeController,
              decoration: InputDecoration(hintText: 'Pick your Time'),
              onTap: () async {
                var time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                        hour: DateTime.now().hour,
                        minute: DateTime.now().minute));

                this.widget.timeController.text = getTimeString(time!);
              },
            )
          ],
        ),
      ),
    );
  }
}
