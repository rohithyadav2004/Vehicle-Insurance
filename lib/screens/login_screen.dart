import 'package:flutter/material.dart';
import 'package:insuranceapp/global_variables.dart';
import 'package:insuranceapp/main.dart';
import 'package:insuranceapp/screens/home_screen.dart';
import 'package:insuranceapp/screens/user_registration.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:http/http.dart' as http;
import 'package:insuranceapp/database_connection/db_connect.dart';
import 'package:intl/intl.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _customerIdController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneNoController = TextEditingController();
  void _validateLogin() async {
    print('entered');
    print(_customerIdController.text);
    print(_dobController.text);
    print(_phoneNoController.text);
    final dbHelper = DatabaseHelper();
    if (_customerIdController.text.isNotEmpty &&
        _dobController.text.isNotEmpty &&
        _phoneNoController.text.isNotEmpty) {
      try {
        await dbHelper.connectToDatabase();
        var conn = dbHelper.connection;
        var response = await conn.query(
          'SELECT Cust_Id, Cust_DOB, Cust_MOB_Number FROM Customer WHERE Cust_Id = ? AND Cust_DOB = ? AND Cust_MOB_Number = ?',
          [
            _customerIdController.text,
            _dobController.text,
            _phoneNoController.text,
          ],
        );
        if (response.isNotEmpty) {
          var row = response.first;
          var customerId = row['Cust_Id'];
          var dob = DateFormat('yyyy-MM-dd').format(row['Cust_DOB']).toString();
          var phoneNo = row['Cust_MOB_Number'].toInt().toString();
          print(customerId);
          print(dob);
          print(phoneNo);

          if (customerId == _customerIdController.text &&
              dob == _dobController.text &&
              phoneNo == _phoneNoController.text) {
            print('ID: $customerId, DOB: $dob, Phone No: $phoneNo');
            userCustID = customerId;
            print(userCustID);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
            return; // Exit the function after successful login
          }
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Authentication failed\nEnter valid login credentials',
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication failed\nError: $e'),
          ),
        );
        print('Error during login: $e');
      } finally {
        await dbHelper.closeConnection();
      }
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all required fields'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardspace = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body:Container(
        //decoration: const BoxDecoration(
        //  gradient: LinearGradient(
        //    begin: Alignment.topLeft,
        //    end: Alignment.bottomRight,
        //    colors: [Colors.purple, Colors.red],
        //  ),
        //),
        width: double.maxFinite,
        height: double.maxFinite,
        margin: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardspace + 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                _header(context),
                const SizedBox(
                  height: 20,
                ),
                _logo(context),
                const SizedBox(
                  height: 40,
                ),
                _inputField(context),
                const SizedBox(
                  height: 20,
                ),
                _forgotPassword(context),
                _signup(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _header(context) {
    return Column(
      children: [
        Text(
          "Welcome",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
        ),
        const Text("Enter your credential to login"),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          controller: _customerIdController,
          decoration: InputDecoration(
              hintText: "Customer_id",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Colors.blue.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.person)),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _dobController,
          decoration: InputDecoration(
            hintText: "Date of birth(YYYY-MM-DD)",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Colors.blue.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: false,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _phoneNoController,
          decoration: InputDecoration(
            hintText: "Phone number",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Colors.blue.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: false,
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: _validateLogin,
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  side: BorderSide.none),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              backgroundColor: Colors.blue,
            ),
            child: const Text(
              "Login",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  _loginbutton(context) {
    return ElevatedButton(
      onPressed: _validateLogin,
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            side: BorderSide.none),
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.blue,
      ),
      child: const Text(
        "Login",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  _logo(context) {
    return Container(
      child: Image.asset(
        'lib/assets/logo.png',
        height: 200,
        width: 200,
      ),
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Colors.blue),
      ),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account? "),
        TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MaterialApp(
                    theme: theme,
                    home: const user_registration(),
                    debugShowCheckedModeBanner: false,
                  ),
                ),
              );
            },
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Colors.blue),
            ))
      ],
    );
  }
}
