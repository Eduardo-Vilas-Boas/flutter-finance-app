import 'package:flutter/material.dart';
import 'package:flutter_finance_app/services/utils.dart';

import '../models/UserTransaction.dart';
import 'EditTransaction.dart';

class TransactionList extends StatelessWidget {
  final List<UserTransaction> transactions;
  final void Function() executeUpdate;

  TransactionList(this.transactions, this.executeUpdate);

  void _alterTransaction(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (bContext) {
        return GestureDetector(
          onTap: () {},
          child: EditTransaction(
              userTransaction: transactions[index],
              executeUpdate: executeUpdate),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Column(
        children: <Widget>[
          Text(
            'No transactions added yet!',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              height: 200,
              child:
                  Image.asset('assets/images/waiting.png', fit: BoxFit.cover)),
        ],
      );
    } else {
      return ListView.builder(
        itemCount: transactions.length,
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          return Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.purple,
                      width: 2,
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '\$${transactions[index].amount.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      transactions[index].category +
                          " - " +
                          transactions[index].description,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      transactions[index].date.day.toString() +
                          "/" +
                          transactions[index].date.month.toString() +
                          "/" +
                          transactions[index].date.year.toString() +
                          " " +
                          getTimeString(TimeOfDay(
                              hour: transactions[index].date.hour,
                              minute: transactions[index].date.minute)),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: GestureDetector(
                        child: Icon(Icons.edit, color: Colors.black),
                        onTap: () => _alterTransaction(context, index)))
              ],
            ),
          );
        },
      );
    }
  }
}
