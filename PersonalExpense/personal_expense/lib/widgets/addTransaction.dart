import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransHandle;
  NewTransaction(this.addTransHandle);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController(),
      amountController = TextEditingController();

  void inputTxtSubmit() {
    if (titleController.text.isEmpty || amountController.text.isEmpty) return;
    final String titleTxt = titleController.text;
    final double amountTxt = double.parse(amountController.text);
    widget.addTransHandle(titleTxt, amountTxt);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              controller: amountController,
              onSubmitted: (_) => inputTxtSubmit(),
            ),
            TextButton(
              onPressed: () {
                print(titleController.text);
                print(amountController.text);
                inputTxtSubmit();
              },
              child: Text('Add Transaction'),
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.purple)),
            ),
          ],
        ),
      ),
    );
  }
}
