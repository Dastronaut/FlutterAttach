import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense/models/transaction.dart';

class ListTransaction extends StatelessWidget {
  final List<Transaction> transactions;
  ListTransaction(this.transactions);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: this
          .transactions
          .map(
            (e) => Card(
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
                      '\$ ${e.amount.toString()}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat.yMMMMd().format(e.date),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
