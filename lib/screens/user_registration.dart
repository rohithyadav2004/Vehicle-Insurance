// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:insuranceapp/database_connection/db_connect.dart';
import 'package:insuranceapp/screens/login_screen.dart';
import 'package:intl/intl.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:insuranceapp/main.dart';
import 'package:insuranceapp/idgenerator/uniquegenerator.dart';

final formatter = DateFormat.yMd();

class user_registration extends StatefulWidget {
  const user_registration({super.key});

  @override
  State<user_registration> createState() => _user_registrationState();
}

class _user_registrationState extends State<user_registration> {
  final _formkey = GlobalKey<FormState>();
  var _fname = '';
  var _lname = '';
  var _dob;
  var _gender = '';
  var _address = '';
  var _phoneNo = 0;
  var _email = '';
  var _maritalSt = '';
  var _passportNo = '';
  var _ppsNo = 0;
  String? _selectedGender = 'Male';
  IconData? _prefixIcon;
  String? _selectedMaritalStatus;
  String? _selectedMembershipType;
  IconData _prefixIcon_two = Icons.person_outline;
  int? _selectedVehicleClass;
  IconData _prefixIcon_three = Icons.person_outline;
  String? _selectedVehicleType;
  IconData _prefixIcon_four = Icons.directions_car;
  DateTime? _selectedDate;
  var _vRegno = '';
  var _vValue = 0;
  var _vType = '';
  var _vSize = 0;
  var _vCapacity = 0;
  var _vManufacturer = '';
  var _vChassisNo = 0;
  var _vModelno = '';
  var _vEngineno = 0;
  final TextEditingController _dateController = TextEditingController();
  String newCustID = '';
  String newVehicleID = '';

  void _saveDetails() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      final dbHelper = DatabaseHelper();
      try {
        await dbHelper.connectToDatabase();
        var conn = dbHelper.connection;
        try {
          var result3 = await conn.query('show tables');
          print(result3);
          var result1 = await conn.query('Select Cust_Id from Customer');
          var result2 = await conn.query('Select Vehicle_Id from Vehicle');
          List<String> cIDs = [];
          List<String> vIDs = [];
          for (var row in result1) {
            cIDs.add(row['Cust_Id'] as String);
          }
          print(cIDs);
          print(result2);
          for (var row in result2) {
            vIDs.add(row['Vehicle_Id'] as String);
          }
          print(vIDs);
          newCustID = generateUniqueId(cIDs);
          newVehicleID = generateUniqueId(vIDs);
          print(newVehicleID);
          print(newCustID);
          var insertcust = await conn.query(
              'INSERT INTO Customer (Cust_Id, Cust_FName, Cust_LName, Cust_DOB, Cust_Gender, Cust_Address, Cust_MOB_Number, Cust_Email, Cust_Passport_Number, Cust_Marital_Status, Cust_PPS_Number) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
              [
                newCustID,
                _fname,
                _lname,
                _dob,
                _gender,
                _address,
                _phoneNo,
                _email,
                _passportNo,
                _maritalSt,
                _ppsNo
              ]);
          print('table1 insertion done');

          var insertveh = await conn.query(
              'INSERT INTO Vehicle (Vehicle_Id, Policy_Id, Dependent_NOK_Id, Vehicle_Registration_Number, Vehicle_Value, Vehicle_Type, Vehicle_Size, Vehicle_Number_Of_Seat, Vehicle_Manufacturer, Vehicle_Engine_Number, Vehicle_Chasis_Number, Vehicle_Number, Vehicle_Model_Number, Cust_Id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
              [
                newVehicleID,
                null,
                null,
                _vRegno,
                _vValue,
                _vType,
                _vSize,
                _vCapacity,
                _vManufacturer,
                _vEngineno,
                _vChassisNo,
                '1',
                _vModelno,
                newCustID
              ]);
          print('tabel2 insertion done');
        } catch (e) {
          print('Error inserting values: $e');
        }
      } catch (e) {
        print('Error connecting to database:$e');
      } finally {
        await dbHelper.closeConnection();
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('New IDs Generated'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('New Customer ID: $newCustID'),
                Text('New Vehicle ID: $newVehicleID'),
                const SizedBox(height: 20),
                const Text(
                    'Please note down these IDs or take a screenshot for future login purposes.'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  // Navigate to the login screen
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MaterialApp(
                        theme: theme,
                        home: const LoginScreen(),
                        debugShowCheckedModeBanner: false,
                      ),
                    ),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      //Navigator.of(context).pushReplacement(
      //  MaterialPageRoute(
      //    builder: (context) => MaterialApp(
      //      theme: theme,
      //      home: const LoginScreen(),
      //      debugShowCheckedModeBanner: false,
      //    ),
      //  ),
      //);
    }
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 100, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? now,
        firstDate: firstDate,
        lastDate: now);
    //print(_vType);
    setState(() {
      _selectedDate = pickedDate;
      _dob = pickedDate;
      _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate!);
    });
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a date';
    }

    final dateFormat = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateFormat.hasMatch(value)) {
      return 'Date must be in the format YYYY-MM-DD';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        title: Text(
          "User Registration",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        //backgroundColor: Colors.amber[500],
        backgroundColor: HexColor('#b0c4de'),
      )),
      //backgroundColor: HexColor('#FFE99B'),
      //backgroundColor: Colors.amber[200],
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Customer Details",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (value) {
                    _fname = value!;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: HexColor('#b0c4de'),
                    ),
                    //fillColor: HexColor('#FFE99B'), // Adjust the color as needed
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    labelText:
                        'First Name', // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 10) {
                      return 'Must be between 1 and 10 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  onSaved: (value) {
                    _lname = value!;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: HexColor('#b0c4de'),
                    ),
                    //fillColor: HexColor('#FFE99B'), // Adjust the color as needed
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    labelText:
                        'Last Name', // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 10) {
                      return 'Must be between 1 and 10 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  onSaved: (value) {
                    _dob = value!;
                  },
                  validator: _validateDate,
                  controller: _dateController,
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.date_range_outlined),
                      onPressed: _presentDatePicker,
                      color: HexColor('#b0c4de'),
                    ),
                    //fillColor: HexColor('#FFE99B'), // Adjust the color as needed
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    labelText: 'DOB(YYYY-MM-DD)',
                    // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                DropdownButtonFormField<String>(
                  onSaved: (value) {
                    _gender = value!;
                  },
                  value: _selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                      // Check the selected gender and update the prefix icon accordingly
                      if (_selectedGender == 'Male') {
                        _prefixIcon = Icons.male; // Icon for male
                      } else if (_selectedGender == 'Female') {
                        _prefixIcon = Icons.female; // Icon for female
                      } else {
                        _prefixIcon = Icons.person_outline; // Default icon
                      }
                    });
                  },
                  items: <String>[
                    'Select Gender', // Placeholder or initial value
                    'Male',
                    'Female',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      _prefixIcon, // Use the dynamically updated prefix icon
                      color: HexColor('#b0c4de'),
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5,
                      ),
                    ),
                    labelText: 'Gender',
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value == 'Select Gender') {
                      return 'Please select a gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  onSaved: (value) {
                    _address = value!;
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 100) {
                      return 'Must be between 1 and 100 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                      color: HexColor('#b0c4de'),
                    ),
                    //fillColor: HexColor('#FFE99B'), // Adjust the color as needed
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    labelText:
                        'Address', // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _phoneNo = int.parse(value!);
                  },
                  validator: _validatePhoneNumber,
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.phone,
                      color: HexColor('#b0c4de'),
                    ),
                    //fillColor: HexColor('#FFE99B'), // Adjust the color as needed
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    labelText:
                        'Phone no', // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  onSaved: (value) {
                    _email = value!;
                  },
                  validator: _validateEmail,
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: HexColor('#b0c4de'),
                    ),
                    //fillColor: HexColor('#FFE99B'), // Adjust the color as needed
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    labelText:
                        'Email address', // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                DropdownButtonFormField<String>(
                  onSaved: (value) {
                    _maritalSt = value!;
                  },
                  value: _selectedMaritalStatus,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMaritalStatus = newValue;
                      // Check the selected marital status and update the prefix icon accordingly
                      if (_selectedMaritalStatus == 'Single') {
                        _prefixIcon_two =
                            Icons.person_outline; // Icon for single
                      } else if (_selectedMaritalStatus == 'Married') {
                        _prefixIcon_two =
                            Icons.family_restroom; // Icon for married
                      } else {
                        _prefixIcon_two = Icons.person_outline; // Default icon
                      }
                    });
                  },
                  items: <String>[
                    'Select Marital Status', // Placeholder or initial value
                    'Single',
                    'Married',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      _prefixIcon_two, // Use the dynamically updated prefix icon
                      color: HexColor('#b0c4de'),
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5,
                      ),
                    ),
                    labelText: 'Marital Status',
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value == 'Select Marital Status') {
                      return 'Please select marital status';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  onSaved: (value) {
                    _passportNo = value!;
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 20) {
                      return 'Must be between 1 and 20 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.assignment_ind_outlined,
                      color: HexColor('#b0c4de'),
                    ),
                    //fillColor: HexColor('#FFE99B'), // Adjust the color as needed
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    labelText:
                        'Passport No.', // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _ppsNo = int.parse(value!);
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null ||
                        int.tryParse(value)! <= 0) {
                      return 'Must be a valid number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.assignment_ind_outlined,
                      color: HexColor('#b0c4de'),
                    ),
                    //fillColor: HexColor('#FFE99B'), // Adjust the color as needed
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    labelText:
                        'PPS No.', // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                DropdownButtonFormField<String>(
                  onSaved: (value) {
                    _selectedMembershipType = value!;
                  },
                  value: _selectedMembershipType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMembershipType = newValue;
                      // Check the selected status and update the prefix icon
                      if (_selectedMembershipType == 'GOLD') {
                        _prefixIcon_two = Icons.star; // Icon for GOLD
                      } else if (_selectedMembershipType == 'SILVER') {
                        _prefixIcon_two = Icons.star_border; // Icon for SILV
                      } else if (_selectedMembershipType == 'BRONZE') {
                        _prefixIcon_two = Icons.star_half; // Icon for BRONZE
                      } else {
                        _prefixIcon_two = Icons.help_outline; // Default icon
                      }
                    });
                  },
                  items: <String>[
                    'Select Status', // Placeholder or initial value
                    'GOLD',
                    'SILVER',
                    'BRONZE',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      _prefixIcon_two, // Use the dynamically updated prefix
                      color: HexColor('#b0c4de'),
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5,
                      ),
                    ),
                    labelText: 'Status',
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value == 'Select Status') {
                      return 'Please select a status';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Vehicle Details",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onSaved: (value) {
                    _vRegno = value!;
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 20) {
                      return 'Must be between 1 and 20 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.directions_car_filled_outlined,
                      color: HexColor('#b0c4de'),
                    ),
                    //fillColor: HexColor('#FFE99B'), // Adjust the color as needed
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    labelText:
                        'Vehicle Registration No.', // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  onSaved: (value) {
                    _vValue = int.parse(value!);
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null ||
                        int.tryParse(value)! <= 0) {
                      return 'Must be a valid number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.currency_rupee_sharp,
                      color: HexColor('#b0c4de'),
                    ),
                    //fillColor: HexColor('#FFE99B'), // Adjust the color as needed
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    labelText:
                        'Vehicle value', // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                DropdownButtonFormField<String>(
                  onSaved: (value) {
                    _vType = value!;
                  },
                  value: _selectedVehicleType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedVehicleType = newValue;
                      // Check the selected vehicle type and update the prefix icon accordingly
                      if (_selectedVehicleType == 'Two-wheeler') {
                        _prefixIcon_four =
                            Icons.motorcycle; // Icon for two-wheeler
                      } else if (_selectedVehicleType == 'Four-wheeler') {
                        _prefixIcon_four =
                            Icons.directions_car; // Icon for four-wheeler
                      } else if (_selectedVehicleType == 'Six-wheeler') {
                        _prefixIcon_four =
                            Icons.local_shipping; // Icon for six-wheeler
                      } else {
                        _prefixIcon_four = Icons.directions_car; // Default icon
                      }
                    });
                  },
                  items: <String>[
                    'Select Vehicle Type', // Placeholder or initial value
                    'Two-wheeler',
                    'Four-wheeler',
                    'Six-wheeler',
                    // Add more options as needed
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      _prefixIcon_four, // Use the dynamically updated prefix icon
                      color: HexColor('#b0c4de'),
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5,
                      ),
                    ),
                    labelText: 'Vehicle Type',
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value == 'Select Vehicle Type') {
                      return 'Please select vehicle type';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                DropdownButtonFormField<int>(
                  onSaved: (value) {
                    _vSize = value!;
                  },
                  value: _selectedVehicleClass,
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedVehicleClass = newValue!;
                      // Check the selected vehicle class and update the prefix icon accordingly
                      if (_selectedVehicleClass == 1) {
                        _prefixIcon_three =
                            Icons.directions_car; // Icon for light-duty
                      } else if (_selectedVehicleClass == 2) {
                        _prefixIcon_three =
                            Icons.local_shipping; // Icon for medium-duty
                      } else if (_selectedVehicleClass == 3) {
                        _prefixIcon_three =
                            Icons.fire_truck_outlined; // Icon for heavy-duty
                      } else {
                        _prefixIcon_three =
                            Icons.directions_car; // Default icon
                      }
                    });
                  },
                  items: <int>[
                    1, // Value for Light-Duty
                    2, // Value for Medium-Duty
                    3, // Value for Heavy-Duty
                  ].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value
                          .toString()), // Convert int to String for display
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      _prefixIcon_three, // Use the dynamically updated prefix icon
                      color: HexColor('#b0c4de'),
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5,
                      ),
                    ),
                    labelText: 'Vehicle Class',
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a vehicle class';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  onSaved: (value) {
                    _vCapacity = int.parse(value!);
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null ||
                        int.tryParse(value)! <= 0) {
                      return 'Must be a valid number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.event_seat_outlined,
                      color: HexColor('#b0c4de'),
                    ),
                    //fillColor: HexColor('#FFE99B'), // Adjust the color as needed
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    labelText:
                        'Vehicle capacity(No of seats in numeric format):', // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  onSaved: (value) {
                    _vManufacturer = value!;
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 20) {
                      return 'Must be between 1 and 20 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.precision_manufacturing_outlined,
                      color: HexColor('#b0c4de'),
                    ),
                    //fillColor: HexColor('#FFE99B'), // Adjust the color as needed
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    labelText:
                        'Vehicle Manufacturer', // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  onSaved: (value) {
                    _vChassisNo = int.parse(value!);
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null ||
                        int.tryParse(value)! <= 0) {
                      return 'Must be a valid number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.playlist_add_check_circle_sharp,
                      color: HexColor('#b0c4de'),
                    ),
                    //fillColor: HexColor('#FFE99B'), // Adjust the color as needed
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    labelText:
                        'Vehicle Chassis number', // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  onSaved: (value) {
                    _vModelno = value!;
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 20) {
                      return 'Must be between 1 and 20 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.password_rounded,
                      color: HexColor('#b0c4de'),
                    ),
                    //fillColor: HexColor('#FFE99B'), // Adjust the color as needed
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    labelText:
                        'Vehicle model number', // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  onSaved: (value) {
                    _vEngineno = int.parse(value!);
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null ||
                        int.tryParse(value)! <= 0) {
                      return 'Must be a valid number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.directions_car_filled_outlined,
                      color: HexColor('#b0c4de'),
                    ),
                    //fillColor: HexColor('#FFE99B'), // Adjust the color as needed
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border color as needed
                      ),
                    ),
                    labelText:
                        'Vehicle Engine no.', // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                //DropdownButtonFormField<String>(
                //  onSaved: (value) {
                //    _selectedMembershipType = value!;
                //  },
                //  value: _selectedMembershipType,
                //  onChanged: (String? newValue) {
                //    setState(() {
                //      _selectedMembershipType = newValue;
                //      // Check the selected status and update the prefix icon accordingly
                //      if (_selectedMembershipType == 'GOLD') {
                //        _prefixIcon_two = Icons.star; // Icon for GOLD
                //      } else if (_selectedMembershipType == 'SILVER') {
                //        _prefixIcon_two = Icons.star_border; // Icon for SILVER
                //      } else if (_selectedMembershipType == 'BRONZE') {
                //        _prefixIcon_two = Icons.star_half; // Icon for BRONZE
                //      } else {
                //        _prefixIcon_two = Icons.help_outline; // Default icon
                //      }
                //    });
                //  },
                //  items: <String>[
                //    'Select Status', // Placeholder or initial value
                //    'GOLD',
                //    'SILVER',
                //    'BRONZE',
                //  ].map<DropdownMenuItem<String>>((String value) {
                //    return DropdownMenuItem<String>(
                //      value: value,
                //      child: Text(value),
                //    );
                //  }).toList(),
                //  decoration: InputDecoration(
                //    filled: true,
                //    prefixIcon: Icon(
                //      _prefixIcon_two, // Use the dynamically updated prefix icon
                //      color: HexColor('#b0c4de'),
                //    ),
                //    fillColor: Colors.white,
                //    border: OutlineInputBorder(
                //      borderRadius: BorderRadius.circular(8.0),
                //      borderSide: BorderSide(
                //        color: HexColor('#b0c4de'),
                //        style: BorderStyle.solid,
                //        width: 2.5,
                //      ),
                //    ),
                //    enabledBorder: OutlineInputBorder(
                //      borderRadius: BorderRadius.circular(8.0),
                //      borderSide: BorderSide(
                //        color: HexColor('#b0c4de'),
                //        style: BorderStyle.solid,
                //        width: 2.5,
                //      ),
                //    ),
                //    labelText: 'Status',
                //    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                //  ),
                //  validator: (value) {
                //    if (value == null ||
                //        value.isEmpty ||
                //        value == 'Select Status') {
                //      return 'Please select a status';
                //    }
                //    return null;
                //  },
                //),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  onPressed: _saveDetails,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    backgroundColor: HexColor(
                        '#b0c4de'), // Change the background color as needed
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
