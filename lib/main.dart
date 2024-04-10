import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'drawer.dart';

// void main() {
//   runApp(AuthenticationApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(AuthenticationApp());
}

class AuthenticationApp extends StatefulWidget {
  @override
  State<AuthenticationApp> createState() => _AuthenticationAppState();
}

class _AuthenticationAppState extends State<AuthenticationApp> {
  @override

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _scheduleDailyNotification();
  }

  Future<void> _initializeNotifications() async {
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleDailyNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'daily_notification',
      'Daily Reminder',
      'Daily reminder notification',
      importance: Importance.high,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Reminder',
      'PLease add Expense!',
      _nextInstanceOfTime(9, 0), // Set the time for the notification
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }

    return scheduledDate;
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English
        Locale('ar', ''), // Arabic
      ],
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInScreen(),
    );
  }
}



// class SignInScreen extends StatefulWidget {
//   @override
//   _SignInScreenState createState() => _SignInScreenState();
// }
//
// class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Locale _currentLocale;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     );
//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);
//     _slideAnimation = Tween<Offset>(begin: Offset(0, -0.5), end: Offset.zero).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _currentLocale = Locale('en', ''); // Default language
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void _signIn() {
//     String email = _emailController.text;
//     String password = _passwordController.text;
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => ExpenseListPage()),
//     );
//   }
//
//   void _signUp() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => SignUpScreen()),
//     );
//   }
//
//   void _changeLanguage(Locale locale) {
//     setState(() {
//       _currentLocale = locale;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var localizedStrings = AppLocalizations.of(context);
//     if (localizedStrings == null) {
//       // Handle the case where localization is not available
//       return CircularProgressIndicator(); // or any other fallback UI
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(localizedStrings.translate(AppLocalizations.signIn)),
//       ),
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.network(
//             'https://img.freepik.com/free-photo/wooden-background_24972-623.jpg?size=626&ext=jpg', // Replace with your network image URL
//             fit: BoxFit.cover,
//           ),
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 DropdownButton<Locale>(
//                   value: _currentLocale,
//                   onChanged: (Locale? newLocale) {
//                     if (newLocale != null) {
//                       _changeLanguage(newLocale);
//                     }
//                   },
//                   items: [
//                     DropdownMenuItem(
//                       value: Locale('en', ''),
//                       child: Text('English'),
//                     ),
//                     DropdownMenuItem(
//                       value: Locale('ar', ''),
//                       child: Text('Arabic'),
//                     ),
//                   ],
//                 ),
//                 SlideTransition(
//                   position: _slideAnimation,
//                   child: FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: TextField(
//                       style: TextStyle(color: Colors.white),
//                       controller: _emailController,
//                       decoration: InputDecoration(
//                         labelText: localizedStrings.translate(AppLocalizations.email),
//                         labelStyle: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16.0),
//                 SlideTransition(
//                   position: _slideAnimation,
//                   child: FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: TextField(
//                       style: TextStyle(color: Colors.white),
//                       controller: _passwordController,
//                       decoration: InputDecoration(
//                         labelText: localizedStrings.translate(AppLocalizations.password),
//                         labelStyle: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                       obscureText: true,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16.0),
//                 SlideTransition(
//                   position: _slideAnimation,
//                   child: FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (_emailController.text == "" || _passwordController.text == "") {
//                           String message = localizedStrings.translate(AppLocalizations.pleaseEnterAllDetails);
//                           var snackBar = SnackBar(
//                             content: Text(message),
//                             duration: Duration(seconds: 3),
//                           );
//                           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                         } else {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(builder: (context) => ExpenseListPage()),
//                           );
//                           // _signIn;
//                         }
//                       },
//                       child: Text(localizedStrings.translate(AppLocalizations.signIn)),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 8.0),
//                 SlideTransition(
//                   position: _slideAnimation,
//                   child: FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: TextButton(
//                       onPressed: _signUp,
//                       child: Text(localizedStrings.translate(AppLocalizations.signUp)),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _slideAnimation = Tween<Offset>(begin: Offset(0, -0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _signIn() {
    String email = _emailController.text;
    String password = _passwordController.text;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ExpenseListPage()),
    );
  }

  void _signUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var localizedStrings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.signIn),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://img.freepik.com/free-photo/wooden-background_24972-623.jpg?size=626&ext=jpg', // Replace with your network image URL
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.email,
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.password,
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      obscureText: true,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_emailController.text == "" ||
                            _passwordController.text == "") {
                          String message =AppLocalizations.pleaseEnterAllDetails;
                          var snackBar = SnackBar(
                            content: Text(message),
                            duration: Duration(seconds: 3),
                          );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBar);
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExpenseListPage()),
                          );
                          // _signIn;
                        }
                      },
                      child: Text(AppLocalizations.signIn),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: TextButton(
                      onPressed: _signUp,
                      child: Text(AppLocalizations.signUp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class AppLocalizations {
  late Map<String, String> _localizedStrings;

  Future<bool> load(Locale locale) async {
    String langCode = locale.languageCode;
    String jsonString = await rootBundle.loadString('assets/$langCode.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  static const String signIn = "signIn";
  static const String signUp = "signUp";
  static const String email = "email";
  static const String password = "password";
  static const String pleaseEnterAllDetails = "pleaseEnterAllDetails";

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations();
    await localizations.load(locale);
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}







class SignUpScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://i.pinimg.com/736x/7e/55/74/7e5574621f1a4dafcd873cacd192f1be.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: (){
                  if(_emailController.text == "" || _passwordController.text == ""){
                    String message = "Please Enter All Details ";
                    var snackBar = SnackBar(
                      content: Text(message),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  else{
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ExpenseListPage()),
                    );
                    // _signIn;
                  }
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ExpenseListPage()));
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class ExpenseListPage extends StatefulWidget {
  @override
  _ExpenseListPageState createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  List<Expense> expenses = [];
  DateTime? selectedDate; // Variable to store the selected date

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Please Add Expense'),
      ),
      key: _scaffoldKey,
      drawer: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.black54),
        child: MyDrawer(),
      ),
      body: Column(
        children: [
          // Add a button to select date
          ElevatedButton(
            onPressed: () {
              _selectDate(context);
            },
            child: Text(
              selectedDate == null
                  ? 'Find by Date'
                  : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredExpenses.length, // Use filtered expenses
              itemBuilder: (BuildContext context, int index) {
                final expense = filteredExpenses[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsp17lsvz6gFGjHO06wa2ku7sSiTtwvYW3ZhG1xBm7sw&s'),
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
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _navigateToEditExpensePage(expense);
                                    },
                                    child: Icon(Icons.edit, size: 20),
                                  ),
                                  SizedBox(width: 10),

                                ],
                              ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Date: ${DateFormat('yyyy-MM-dd').format(expense.date)}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),

                              ),

                              InkWell(
                                onTap: () {
                                  _deleteExpense(expense);
                                },
                                child: Icon(Icons.delete, size: 20,color: Colors.redAccent,),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddExpensePage();
        },
        tooltip: 'Add Expense',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }


  List<Expense> get filteredExpenses {
    if (selectedDate == null) {
      return expenses;
    } else {
      return expenses.where((expense) =>
      DateFormat('yyyy-MM-dd').format(expense.date) ==
          DateFormat('yyyy-MM-dd').format(selectedDate!)).toList();
    }
  }

  void _navigateToAddExpensePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddExpensePage()),
    );
    if (result != null && result is Expense) {
      setState(() {
        expenses.add(result);
      });
    }
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

  void _deleteExpense(Expense expense) {
    setState(() {
      expenses.remove(expense);
    });
  }
}



class AddExpensePage extends StatefulWidget {
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _descriptionController = TextEditingController();

  void _submitExpense() {
    final enteredAmount = double.parse(_amountController.text);
    final enteredDescription = _descriptionController.text;

    if (enteredAmount <= 0 || enteredDescription.isEmpty) {
      return;
    }

    final newExpense = Expense(
      amount: enteredAmount,
      date: _selectedDate,
      description: enteredDescription,
    );

    Navigator.of(context).pop(newExpense);
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://img.freepik.com/free-photo/landmarks-shanghai-along-huangpu-river_1359-1008.jpg?size=626&ext=jpg&ga=GA1.1.729847587.1712657817&semt=ais'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (_) => _submitExpense(),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                  controller: _descriptionController,
                  onSubmitted: (_) => _submitExpense(),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _submitExpense,
                child: Text('Add Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditExpensePage extends StatefulWidget {
  final Expense expense;

  EditExpensePage(this.expense);

  @override
  _EditExpensePageState createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.expense.amount.toString();
    _selectedDate = widget.expense.date;
    _descriptionController.text = widget.expense.description;
  }

  void _submitExpense() {
    final enteredAmount = double.parse(_amountController.text);
    final enteredDescription = _descriptionController.text;

    if (enteredAmount <= 0 || enteredDescription.isEmpty) {
      return;
    }

    final updatedExpense = Expense(
      amount: enteredAmount,
      date: _selectedDate,
      description: enteredDescription,
    );

    Navigator.of(context).pop(updatedExpense);
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Expense'),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.network(
              'https://img.freepik.com/free-photo/buildings-with-sky_23-2148107156.jpg?size=626&ext=jpg&ga=GA1.1.729847587.1712657817&semt=ais',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (_) => _submitExpense(),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Description'),
                  controller: _descriptionController,
                  onSubmitted: (_) => _submitExpense(),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                    ),
                    TextButton(
                      onPressed: _presentDatePicker,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _submitExpense,
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Expense {
  final double amount;
  final DateTime date;
  final String description;

  Expense({required this.amount, required this.date, required this.description});
}


