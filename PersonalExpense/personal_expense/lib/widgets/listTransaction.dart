import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense/models/transaction.dart';

class ListTransaction extends StatelessWidget {
  final List<Transaction> _transactions;
  ListTransaction(this._transactions);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return Card(
            color: Colors.amber,
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    '\$ ${_transactions[index].amount.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _transactions[index].title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      DateFormat.yMMMMd().format(_transactions[index].date),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        itemCount: _transactions.length,
      ),
    );
  }
}
