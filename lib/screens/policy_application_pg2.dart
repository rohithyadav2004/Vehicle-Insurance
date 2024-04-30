// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:insuranceapp/database_connection/db_connect.dart';
import 'package:insuranceapp/global_variables.dart';
import 'package:insuranceapp/idgenerator/uniquegenerator.dart';
import 'package:intl/intl.dart';

class SelectionofPolicy extends StatefulWidget {
  final ThemeData theme;
  String coverage_level;
  String coverage_desc;
  SelectionofPolicy(
      {super.key,
      required this.theme,
      required this.coverage_level,
      required this.coverage_desc});

  @override
  State<SelectionofPolicy> createState() => _SelectionofPolicyState();
}

class _SelectionofPolicyState extends State<SelectionofPolicy> {
  final _formkey = GlobalKey<FormState>();
  final FocusNode _myfocusNode = FocusNode();
  bool _isLoading = true;
  String newApplnId = '';
  String newAgrId = '';
  String newPolNo = '';
  String newNok_Id = '';
  String newPremium_Id = '';
  String newReceiptId = '';
  String newQuoteId = '';
  String productId = '';
  bool acceptTerms = false;
  String cvg_level = '';
  String cvg_desc = '';
  String coverage_terms = '';
  String TandC = '';
  var currentDate;
  var expiryDate;
  String _selectedVehicleId ='';
  String newCoverage_Id = '';
  int max_cvg_amt = 400000;
  late Map<String, FocusNode> focusNodes;
  String? _selectedGender = 'Male';
  IconData? _prefixIcon = Icons.person_outline;
  var _nokName = '';
  var _nokPhoneNo = 0;
  var _nokAddress = '';
  var _nokGender = '';
  var _nokMaritalSt = '';
  String? _selectedMaritalStatus;
  IconData _prefixIcon_two = Icons.person_outline;
  String? _selectedInterval;
  IconData _prefixIcon3 = Icons.calendar_today;

  int totalPremiumAmt = 0;

  var coverage_type = '';
  var _premiumPaymentAmt = 0;

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

  void _saveDetails() async {
    final dbHelper = DatabaseHelper();
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      try {
        await dbHelper.connectToDatabase();
        var conn = dbHelper.connection;
        try {
          var result1 = await conn.query(
              'INSERT into Application (Application_Id, Vehicle_Id, Application_Status, Coverage, Cust_Id) VALUES (?,?,?,?,?)',
              [
                newApplnId,
                _selectedVehicleId,
                'APPROVED',
                coverage_type,
                userCustID
              ]);
          var result2 = await conn.query(
              'INSERT into COVERAGE(Coverage_Id, Coverage_Amount, Coverage_Type, Coverage_Level, Product_Id, Coverage_Description, Coverage_Terms) VALUES (?,?,?,?,?,?,?)',
              [
                newCoverage_Id,
                max_cvg_amt,
                coverage_type,
                cvg_level,
                productId,
                widget.coverage_desc,
                coverage_terms
              ]);
          var result3 = await conn.query(
              'INSERT into INSURANCE_POLICY(Agreement_id, Policy_Number, Start_Date, Expiry_Date, Term_Condition_Description, Application_Id, Cust_Id) VALUES (?,?,?,?,?,?,?)',
              [
                newAgrId,
                newPolNo,
                currentDate,
                expiryDate,
                TandC,
                newApplnId,
                userCustID
              ]);

          var result4 = await conn.query(
              'INSERT into INSURANCE_POLICY_COVERAGE(Agreement_id, Application_Id, Cust_Id, Coverage_Id) VALUES (?,?,?,?)',
              [newAgrId, newApplnId, userCustID, newCoverage_Id]);

          var result5 = await conn.query(
              'INSERT into NOK(Nok_Id, Nok_Name, Nok_Address, Nok_Phone_Number, Nok_Gender, Nok_Marital_Status, Agreement_id, Application_Id, Cust_Id) VALUES (?,?,?,?,?,?,?,?,?)',
              [
                newNok_Id,
                _nokName,
                _nokAddress,
                _nokPhoneNo,
                _nokGender,
                _nokMaritalSt,
                newAgrId,
                newApplnId,
                userCustID
              ]);

          var result6 = await conn.query(
              'INSERT into PREMIUM_PAYMENT(Premium_Payment_Id, Policy_Number, Premium_Payment_Amount, Premium_Payment_Schedule, Receipt_Id, Cust_Id) VALUES (?,?,?,?,?,?)',
              [
                newPremium_Id,
                newPolNo,
                _premiumPaymentAmt,
                _selectedInterval,
                newReceiptId,
                userCustID
              ]);

          var result7 = await conn.query(
              'INSERT into RECEIPT(Receipt_Id, Time, Cost, Premium_Payment_Id, Cust_Id) VALUES (?,?,?,?,?)',
              [
                newReceiptId,
                currentDate,
                _premiumPaymentAmt,
                newPremium_Id,
                userCustID
              ]);

          var result8 = await conn.query(
              'INSERT into QUOTE(Quote_Id, Issue_Date, Valid_From_Date, Valid_Till_Date, Description, Product_Id, Coverage_Level, Application_Id, Cust_Id) VALUES (?,?,?,?,?,?,?,?,?)',
              [
                newQuoteId,
                currentDate,
                currentDate,
                expiryDate,
                cvg_desc,
                productId,
                cvg_level,
                newApplnId,
                userCustID
              ]);

          var result9 = await conn.query(
            'UPDATE Vehicle set Policy_Id =?, Dependent_NOK_Id = ? where Vehicle_Id = ?',
            [newPolNo,newNok_Id,_selectedVehicleId]
          );

          var quoteDetails =
              '•Receipt ID: $newReceiptId\n•Cost: $_premiumPaymentAmt\n•Date: $currentDate';

          // ignore: use_build_context_synchronously
          print('dialogue');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'YOUR RECEIPT',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue),
                ),
                content: Text(
                  quoteDetails,
                  style: const TextStyle(fontSize: 18),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .popUntil((route) => route.isFirst),
                    child: const Text('Ok'),
                  ),
                ],
              );
            },
          );
          print('Done entering all tables');
        } catch (e) {
          print('Error retrieving details: $e');
        }
      } catch (e) {
        print('Error connecting to database: $e');
      } finally {
        await dbHelper.closeConnection();
      }
    }
  }

  void _getDate() async {
    DateTime now = DateTime.now();
    DateTime exp = now.add(const Duration(days: 365));
    currentDate = DateFormat('yyyy-MM-dd').format(now);
    expiryDate = DateFormat('yyyy-MM-dd').format(exp);
  }

  void _getDetails() async {
    final dbHelper = DatabaseHelper();
    try {
      await dbHelper.connectToDatabase();
      var conn = dbHelper.connection;
      try {
        var result2 = await conn.query(
            'Select Application_Id from Application where Cust_Id = ?',
            [userCustID]);
        List<String> aplnIDs = [];
        for (var row in result2) {
          aplnIDs.add(row['Application_Id'] as String);
        }
        newApplnId = generateUniqueId(aplnIDs);
        List<String> agrIds = [];
        newAgrId = generateUniqueId(agrIds);
        newCoverage_Id = generateUniqueId([]);
        newNok_Id = generateUniqueId([]);
        newPolNo = generateUniqueId([]);
        newPremium_Id = generateUniqueId([]);
        newReceiptId = generateUniqueId([]);
        newQuoteId = generateUniqueId([]);
        _getDate();
        if (widget.coverage_level == 'Basic') {
          totalPremiumAmt = 20000;
          coverage_type = 'Liability';
          max_cvg_amt = 100000;
          productId = '1';
          coverage_terms =
              '•Standard liability limits as per state regulations.\n•Coverage for bodily injury and property damage caused to others.\n•Exclusions may apply for intentional acts or use of the insured vehicle for commercial purposes.';
          cvg_level = 'Basic';
          cvg_desc = widget.coverage_desc;
          TandC =
              '\n•No Claim Bonus can not be allowed if policy is not renewed within 90 days of its expiry.\n•For break in cases, policy issuance will be post inspection of the vehicle or Two working days from date of receipt of premium.\n•‘An insured becomes entitled to NCB only at the renewal of a policy after the expiry of the full duration of 12 months.\n•This insurance policy is valid only within India';
        } else if (widget.coverage_level == 'Standard') {
          totalPremiumAmt = 30000;
          coverage_type = 'Liability , Comprehensive';
          max_cvg_amt = 300000;
          productId = '2';
          coverage_terms =
              '•Increased liability limits for enhanced protection.\n•Additional coverage for legal expenses and court costs.\n•Limited coverage for uninsured/underinsured motorist incidents.\n•Lower deductible options available for added flexibility.\n•Coverage for emergency roadside assistance and towing.\n•Additional coverage for glass breakage and rental car reimbursement during repairs.';
          TandC =
              '\n•No Claim Bonus can not be allowed if policy is not renewed within 90 days of its expiry.\n•For break in cases, policy issuance will be post inspection of the vehicle or Two working days from date of receipt of premium.\n•‘An insured becomes entitled to NCB only at the renewal of a policy after the expiry of the full duration of 12 months.\n•This insurance policy is valid only within India';
        } else if (widget.coverage_level == 'Premium') {
          totalPremiumAmt = 50000;
          coverage_type = 'Liability, Comprehensive, Collision';
          max_cvg_amt = 500000;
          productId = '3';
          coverage_terms =
              '•Maximum liability limits for comprehensive protection.\n•Additional coverage for medical expenses and lost wages.\n•Enhanced coverage for uninsured/underinsured motorist incidents, including hit-and-run accidents.\n•₹0 deductible option for comprehensive protection.\n•Coverage for personal belongings damaged or stolen from the insured vehicle.\n•Enhanced coverage for high-value vehicles and custom accessories.\n•₹0 deductible option for collision protection.Coverage for original manufacturer parts and OEM repair.\n•Enhanced coverage for leased or financed vehicles, including gap insurance.';
          TandC =
              '\n•No Claim Bonus can not be allowed if policy is not renewed within 90 days of its expiry.\n•For break in cases, policy issuance will be post inspection of the vehicle or Two working days from date of receipt of premium.\n•‘An insured becomes entitled to NCB only at the renewal of a policy after the expiry of the full duration of 12 months.\n•This insurance policy is valid only within India';
        }
        setState(() {
          _isLoading = false;
        });
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
  void initState() {
    super.initState();
    print(acceptTerms);
    focusNodes = {
      'field1': FocusNode(),
      'field2': FocusNode(),
      'field3': FocusNode(),
    };

    _getDetails(); //Call _retrieveDetails when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    String coverageLevel = widget.coverage_level;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          coverageLevel,
          style: widget.theme.textTheme.headlineSmall!.copyWith(
            color: widget.theme.colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: HexColor('#b0c4de'),
      ),
      backgroundColor: Colors.white,
      body: _isLoading // Show loading indicator if data is still loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        enabled: false, // Disable the text field
                        initialValue: userCustID, // Set the initial value
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(
                            Icons.person_outline,
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
                          labelText: 'Customer ID',
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        enabled: false, // Disable the text field
                        initialValue: newApplnId, // Set the initial value
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(
                            Icons.person_outline,
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
                          labelText: 'Application ID',
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      DropdownButtonFormField<String>(
                        value: userVehicleIds.isNotEmpty
                            ? userVehicleIds[0]
                            : null, // Initial value
                        onChanged: (newValue) {
                          // Handle onChanged event
                        },
                        onSaved: (value) {
                          _selectedVehicleId = value!;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(
                            Icons.directions_car_outlined,
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
                              'Select Vehicle\'s Vehicle Id', // Label text for the dropdown
                          labelStyle: TextStyle(
                              color: _myfocusNode.hasFocus
                                  ? Colors.blue.shade400
                                  : Colors.black),
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        ),
                        focusNode: _myfocusNode,
                        items: userVehicleIds
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              color: HexColor('#b0c4de'),
                              style: BorderStyle.solid,
                              width: 2.5),
                        ),
                        child: Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Coverage amt. : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  const WidgetSpan(
                                    child: Icon(
                                      Icons.currency_rupee_outlined,
                                      size: 20.0,
                                      color: Colors.blue,
                                    ), // Your desired icon
                                  ),
                                  TextSpan(text: '$max_cvg_amt'),
                                ],
                              ),
                              style: const TextStyle(
                                  color: Colors.blue, fontSize: 16.0),
                            ),
                            const SizedBox(width: 8.0),
                            const Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  //hintText: 'Coverage amt',
                                  prefixText: 'Coverage amt',
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        height: 87,
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
                                style:
                                    widget.theme.textTheme.titleLarge!.copyWith(
                                  color: widget.theme.colorScheme.onBackground,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Coverage type',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.blue),
                                  ),
                                  TextSpan(
                                    text: ': \n$coverage_type',
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.blue),
                                  ),
                                ],
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              'Coverage Terms and Conditions',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.blue),
                            ),
                            content: Text(
                              coverage_terms,
                              style: const TextStyle(fontSize: 18),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Ok'),
                              ),
                            ],
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          height: 61,
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
                                  style: widget.theme.textTheme.titleLarge!
                                      .copyWith(
                                    color:
                                        widget.theme.colorScheme.onBackground,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'Coverage terms',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.blue),
                                    ),
                                    TextSpan(
                                      text: '(Tap to know more)',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.blueGrey.shade600),
                                    ),
                                  ],
                                ),
                                maxLines: 14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        enabled: false, // Disable the text field
                        initialValue: newAgrId, // Set the initial value
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(
                            Icons.policy_outlined,
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
                          labelText: 'Policy No:',
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        height: 47,
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
                                style: widget.theme.textTheme.headlineLarge!
                                    .copyWith(
                                  color: widget.theme.colorScheme.onBackground,
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
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        height: 47,
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
                                style: widget.theme.textTheme.headlineLarge!
                                    .copyWith(
                                  color: widget.theme.colorScheme.onBackground,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Policy Expiry Date:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade400),
                                  ),
                                  TextSpan(
                                    text: '     $expiryDate',
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
                      const SizedBox(
                        height: 10.0,
                      ),
                      GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              'Coverage Terms and Conditions',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.blue),
                            ),
                            content: Text(
                              coverage_terms,
                              style: const TextStyle(fontSize: 18),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Ok'),
                              ),
                            ],
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          height: 85,
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
                                  style: widget.theme.textTheme.titleLarge!
                                      .copyWith(
                                    color:
                                        widget.theme.colorScheme.onBackground,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'Terms and Conditions',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.blue),
                                    ),
                                    TextSpan(
                                      text: '(Tap to know more)',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.blueGrey.shade600),
                                    ),
                                  ],
                                ),
                                maxLines: 14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      CheckboxListTile(
                        value: acceptTerms,
                        title: const Text("I accept the terms and conditions"),
                        controlAffinity: ListTileControlAffinity.platform,
                        onChanged: (bool? value) {
                          setState(() {
                            print(acceptTerms);
                            print('entered');
                            acceptTerms = value!;
                            print('exit');
                            print(acceptTerms);
                          });
                        },
                        checkColor: Colors.white,
                        activeColor: Colors.green.shade400,
                        enabled: true,
                      ),
                      const SizedBox(height: 25),
                      Text(
                        "Customer NOK Details",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        onSaved: (value) {
                          _nokName = value!;
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
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.blue.shade400,
                              style: BorderStyle.solid,
                              width: 2.5, // Adjust the border width as needed
                            ),
                          ),
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
                          _nokAddress = value!;
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
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.blue.shade400,
                              style: BorderStyle.solid,
                              width: 2.5, // Adjust the border width as needed
                            ),
                          ),
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
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _nokPhoneNo = int.parse(value!);
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
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.blue.shade400,
                              style: BorderStyle.solid,
                              width: 2.5, // Adjust the border width as needed
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      DropdownButtonFormField<String>(
                        onSaved: (value) {
                          _nokMaritalSt = value!;
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
                              _prefixIcon_two =
                                  Icons.person_outline; // Default icon
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
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.blue.shade400,
                              style: BorderStyle.solid,
                              width: 2.5, // Adjust the border width as needed
                            ),
                          ),
                          labelText: 'Marital Status',
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                      DropdownButtonFormField<String>(
                        onSaved: (value) {
                          _nokGender = value!;
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
                              _prefixIcon =
                                  Icons.person_outline; // Default icon
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
                          //focusColor: Colors.green.shade700,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.blue.shade400,
                              style: BorderStyle.solid,
                              width: 2.5, // Adjust the border width as needed
                            ),
                          ),
                          labelText: 'Gender',
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                      const SizedBox(height: 25),
                      Text(
                        "Premium Payment Information",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField<String>(
                        onSaved: (value) {
                          _selectedInterval = value!;
                        },
                        value: _selectedInterval,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedInterval = newValue;
                            // Update the prefix icon based on the selection
                            if (_selectedInterval == 'Semi-Yearly') {
                              _prefixIcon3 =
                                  Icons.timelapse; // Icon for Semi-Yearly
                              _premiumPaymentAmt = totalPremiumAmt ~/ 2;
                            } else if (_selectedInterval == 'Quarterly') {
                              _prefixIcon3 =
                                  Icons.date_range; // Icon for Quarterly
                              _premiumPaymentAmt = totalPremiumAmt ~/ 4;
                            } else if (_selectedInterval == 'Annually') {
                              _prefixIcon3 = Icons.event; // Icon for Annually
                            } else {
                              _prefixIcon3 =
                                  Icons.calendar_today; // Default icon
                              _premiumPaymentAmt = (totalPremiumAmt).toInt();
                            }
                          });
                        },
                        items: <String>[
                          'Select Interval', // Placeholder or initial value
                          'Semi-Yearly',
                          'Quarterly',
                          'Annually', // New option
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(
                            _prefixIcon3, // Use the dynamically updated prefix icon
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              style: BorderStyle.solid,
                              width: 2.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColorLight,
                              style: BorderStyle.solid,
                              width: 2.5,
                            ),
                          ),
                          labelText: 'Premium Payment Schedule',
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == 'Select Interval') {
                            return 'Please select an interval';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        enabled: false, // Disable the text field
                        initialValue: _premiumPaymentAmt
                            .toString(), // Set the initial value
                        onChanged: (value) => _premiumPaymentAmt = int.parse(value),
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(
                            Icons.currency_rupee_outlined,
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
                          labelText: 'Premium Payment Amount',
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 14, 0, 14),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              color: HexColor('#b0c4de'),
                              style: BorderStyle.solid,
                              width: 2.5),
                        ),
                        child: Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Total Premium Amt. : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  const WidgetSpan(
                                    child: Icon(
                                      Icons.currency_rupee_outlined,
                                      size: 20.0,
                                      color: Colors.blue,
                                    ), // Your desired icon
                                  ),
                                  TextSpan(text: '$totalPremiumAmt'),
                                ],
                              ),
                              style: const TextStyle(
                                  color: Colors.blue, fontSize: 16.0),
                            ),
                          ],
                        ),
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
                      const SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
