import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:insuranceapp/database_connection/db_connect.dart';
import 'package:insuranceapp/global_variables.dart';
import 'package:insuranceapp/idgenerator/uniquegenerator.dart';
import 'package:intl/intl.dart';

class Policy_renewable extends StatefulWidget {
  const Policy_renewable(
      {super.key, required this.applicationIds, required this.agreementIds});
  final List<String> agreementIds;
  final List<String> applicationIds;
  @override
  State<Policy_renewable> createState() => _Policy_renewableState();
}

class _Policy_renewableState extends State<Policy_renewable> {
  final _formkey = GlobalKey<FormState>();
  String currentDate = '';
  var expiryDate;
  var policyRenewableID;
  DateTime now = DateTime.now();
  var _selectedAgreementId;
  //currentDate = DateFormat('yyyy-MM-dd').format(now);
  List<String> agreementIds = [];
  @override
  void initState() {
    super.initState();
    _retrieveDetails(); //Call _retrieveDetails when the page is loaded
  }

  void _retrieveDetails() async {
    currentDate = DateFormat('yyyy-MM-dd').format(now);
    expiryDate =
        DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 365)));
    agreementIds = widget.agreementIds;
    policyRenewableID = generateUniqueId([]);
  }

  void _saveDetails() async {
    print('entered');
    print(_formkey.currentState);
    //if (_formkey.currentState!.validate()) {
    //  print('entered if loop');
    //  _formkey.currentState!.save();
    //  print('selected agreement id is $_selectedAgreementId');
    //}
    if (_formkey.currentState != null && _formkey.currentState!.validate()) {
      print('entered if loop');
      _formkey.currentState!.save();
      print('selected agreement id is $_selectedAgreementId');
    } else {
      print('Form key currentState is null or validation failed');
      return; // Exit the method if currentState is null or validation failed
    }
    print('selected agreement id is $_selectedAgreementId');
    print('current date is $currentDate');
    print('enetered if loop');
    final dbHelper = DatabaseHelper();
    try {
      await dbHelper.connectToDatabase();
      var conn = dbHelper.connection;
      try {
        var result4 = await conn.query(
            'Select Application_Id from INSURANCE_POLICY where Agreement_id = ?',
            [_selectedAgreementId]);
        print('Details retrieved successfully');
        var selectedApplicationId = result4.first[0];
        print('application id is $selectedApplicationId');
        var result2 = await conn.query(
            'INSERT INTO POLICY_RENEWABLE(Policy_Renewable_Id, Date_Of_Renewal, Agreement_id,Application_Id,Cust_Id) values (?,?,?,?,?)',
            [
              policyRenewableID,
              currentDate,
              _selectedAgreementId,
              selectedApplicationId,
              userCustID
            ]);
        print('Details inserted successfully');
        print('Details saved successfully');
        var result3 = await conn.query(
          'UPDATE INSURANCE_POLICY set Start_Date = ?, Expiry_Date = ? WHERE Agreement_id = ?',
          [currentDate, expiryDate, _selectedAgreementId]
        );

        print('Details saved successfully');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Policy renewed successfully'),
          ),
        );
        Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
      } catch (e) {
        print('Error retrieving details: $e');
      }
    } catch (e) {
      print('Error connecting to database: $e');
    } finally {
      await dbHelper.closeConnection();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        title: Text(
          "Policy Renewal",
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
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                          children: [
                            TextSpan(
                              text: 'Policy Start Date:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade400),
                            ),
                            TextSpan(
                              text: '     $currentDate',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade300),
                            ),
                          ],
                        ),
                        maxLines: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Modify the DropdownButtonFormField to select agreement IDs
                DropdownButtonFormField<String>(
                  items: agreementIds
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an agreement ID';
                    }
                    return null; // Return null if the value is valid
                  },
                  value: agreementIds.isNotEmpty
                      ? agreementIds[0]
                      : null, // Initial value
                  onChanged: (newValue) {
                    print('newValue: $newValue');
                  },
                  onSaved: (value) {
                    _selectedAgreementId = value!;
                    print('Selected Agreement ID: $_selectedAgreementId');
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.library_books_outlined, // Icon for agreement IDs
                      color: HexColor('#b0c4de'),
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border width as needed
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: HexColor('#b0c4de'),
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border width as needed
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.blue.shade400,
                        style: BorderStyle.solid,
                        width: 2.5, // Adjust the border width as needed
                      ),
                    ),
                    labelText:
                        'Select Agreement ID', // Label text for the dropdown
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () => _saveDetails(),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      backgroundColor: HexColor(
                          '#b0c4de'), // Change the background color as needed
                    ),
                    child: const Text(
                      'Renew',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
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
