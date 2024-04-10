import 'package:flutter/material.dart';
import 'main.dart';

class ExpenseListPageSum extends StatefulWidget {
  @override
  _ExpenseListPageSumState createState() => _ExpenseListPageSumState();
}

class _ExpenseListPageSumState extends State<ExpenseListPageSum> {
  List<Expense> expenses = [];

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Summary'),
      ),
      body:
      ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (BuildContext context, int index) {
          final expense = expenses[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child:
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsp17lsvz6gFGjHO06wa2ku7sSiTtwvYW3ZhG1xBm7sw&s'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          expense.description,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                            onTap: (){
                              _navigateToEditExpensePage(expense);
                            },
                            child: Icon(Icons.edit,size: 20,)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      '\$Total : ${expense.amount.toString()}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Date: ${expense.date.toString()}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          );
        },
      ),

    );
  }

  void _navigateToEditExpensePage(Expense expense) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditExpensePage(expense)),
    );
    if (result != null && result is Expense) {
      setState(() {
        expenses[expenses.indexOf(expense)] = result;
      });
    }
  }
}




