// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:insuranceapp/database_connection/db_connect.dart';
import 'package:insuranceapp/global_variables.dart';
import 'package:insuranceapp/screens/login_screen.dart';
import 'package:intl/intl.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:insuranceapp/main.dart';
import 'package:insuranceapp/idgenerator/uniquegenerator.dart';

class NewVehicleRegistration extends StatefulWidget {
  const NewVehicleRegistration({super.key});

  @override
  State<NewVehicleRegistration> createState() => _NewVehicleRegistrationState();
}

class _NewVehicleRegistrationState extends State<NewVehicleRegistration> {
  final _formkey = GlobalKey<FormState>();
  final _fname = '';
  final _lname = '';
  var _dob;
  final _gender = '';
  final _address = '';
  final _phoneNo = 0;
  final _email = '';
  final _membershipType = '';
  final _passportNo = '';
  final _ppsNo = 0;
  final String _selectedGender = 'Male';
  IconData? _prefixIcon;
  String? _selectedMembershipType;
  final IconData _prefixIcon_two = Icons.person_outline;
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
          var result2 = await conn.query('Select Vehicle_Id from Vehicle');
          List<String> vIDs = [];
          print(result2);
          for (var row in result2) {
            vIDs.add(row['Vehicle_Id'] as String);
          }
          print(vIDs);
          newVehicleID = generateUniqueId(vIDs);
          print(newVehicleID);
          
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
                userCustID
              ]);
          userVehicleIds.add(newVehicleID);
          print(userVehicleIds);
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
            title: const Text('New Vehicle ID Generated'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('New Vehicle ID: $newVehicleID'),
                const SizedBox(height: 20),
                const Text(
                    'Please note down your new Vehicle ID for future reference.'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  // Navigate to the login screen
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      Navigator.of(context).pop();
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
              children: [Text(
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
                ),],
            ),
          ),
        ),
      ),
    );
  }
}
