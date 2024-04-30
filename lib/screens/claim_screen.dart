import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:insuranceapp/idgenerator/uniquegenerator.dart';
import 'package:insuranceapp/models/incident_model.dart';
import 'package:insuranceapp/screens/incident_report.dart';
import 'package:intl/intl.dart';
import 'package:insuranceapp/main.dart';

import '../global_variables.dart';

final formatter = DateFormat.yMd();

class ClaimInsurance extends StatefulWidget {
  const ClaimInsurance({super.key});

  @override
  State<ClaimInsurance> createState() => _ClaimInsuranceState();
}

class _ClaimInsuranceState extends State<ClaimInsurance> {
  final _formkey = GlobalKey<FormState>();
  var _incidentType = '';
  var _incidentDate;
  var _description = '';
  var _incidentCost = 0;
  var _vehicleServiceAddress = '';
  var _vehilceServiceContact = 0;
  var _vehicleServiceIncharge = '';
  var _vehicleServiceType = '';
  var _vehicleServiceName = '';
  String _selectedVehicleId = '';
  String incident_Id = '';
  DateTime? _selectedDate;
  final _serviceCompanyDetails = '';

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

  final TextEditingController _dateController = TextEditingController();

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
      _incidentDate = pickedDate;
      _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate!);
    });
  }

  void _saveDetails() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      incident_Id = generateUniqueId([]);
      var vServiceId = generateUniqueId([]);

      print('Incident Cost: $_incidentCost');
      //print(_dateController.text);
      incidentModel inc = incidentModel(
          incidentID: incident_Id,
          incidentCost: _incidentCost,
          incidentDate: _dateController.text,
          incidentType: _incidentType,
          Description: _description);

      print(inc.incidentCost);
      print(inc.incidentID);
      print(inc.incidentDate);
      print(inc.incidentType);
      print(inc.Description);

      vehicleServiceModel vService = vehicleServiceModel(
          vsId: vServiceId,
          vId: _selectedVehicleId,
          custId: userCustID,
          vsName: _vehicleServiceName,
          vsAddress: _vehicleServiceAddress,
          vsContact: _vehilceServiceContact,
          vsIncharge: _vehicleServiceIncharge,
          vsType: _vehicleServiceType);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => IncidentReport(
            incidentInfo: inc,
            vServiceInfo: vService,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        title: Text(
          "Incident Details",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        backgroundColor: HexColor('#b0c4de'),
      )),
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
                    // labelStyle: TextStyle(
                    //     color: _myfocusNode.hasFocus
                    //         ? Colors.blue.shade400
                    //         : Colors.black),
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                  //focusNode: _myfocusNode,
                  items: userVehicleIds
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  onSaved: (value) {
                    _incidentType = value!;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.warning_amber_outlined,
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
                        'Incident Type', // Replace with your desired label text
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
                    _incidentDate = value!;
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
                    labelText: 'Incident Date(YYYY-MM-DD)',
                    // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  onSaved: (value) {
                    _description = value!;
                  },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.description_outlined,
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
                        'Description', // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 500) {
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
                    _incidentCost = int.parse(value!);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.currency_rupee_outlined,
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
                        'Incident Cost', // Replace with your desired label text
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
                  height: 20.0,
                ),
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
                    _vehicleServiceName = value!;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.car_repair_outlined,
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
                        'Vehicle Service Name', // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 20) {
                      return 'Must be between 1 and 20 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  onSaved: (value) {
                    _vehicleServiceAddress = value!;
                  },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
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
                        'Vehicle Service Address', // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Must be between 1 and 50 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  onSaved: (value) {
                    _vehilceServiceContact = int.parse(value!);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.contact_phone_outlined,
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
                        'Vehicle Service Contact', // Replace with your desired label text
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
                    _vehicleServiceIncharge = value!;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.car_repair_outlined,
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
                        'Vehicle Service Incharge', // Replace with your desired label text
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 20) {
                      return 'Must be between 1 and 20 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  onSaved: (value) {
                    _vehicleServiceType = value!;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: Icon(
                      Icons.car_repair_outlined,
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
                        'Vehicle Service Type', // Replace with your desired label text
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
                    'Next',
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
