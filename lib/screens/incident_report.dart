import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:insuranceapp/idgenerator/uniquegenerator.dart';
import 'package:insuranceapp/models/incident_model.dart';
import 'package:insuranceapp/models/incident_model.dart';
import 'package:insuranceapp/screens/claim_details.dart';

class IncidentReport extends StatefulWidget {
  const IncidentReport(
      {super.key, required this.incidentInfo, required this.vServiceInfo});

  final incidentModel incidentInfo;
  final vehicleServiceModel vServiceInfo;

  @override
  State<IncidentReport> createState() => _IncidentReportState();
}

class _IncidentReportState extends State<IncidentReport> {
   String? _incidentReportID = '';
   String? _incidentID = '';
   String? _customerID = '';
   String? _incidentInspector = '';
  int?  _incidentCost;
   String? _incidentType = '';
   String? _incidentDescription = '';
  late incidentModel inc;
  late vehicleServiceModel vService;
  
  void _saveDetails() async {
    IncidentReportModel incR = IncidentReportModel(
      incidentReportID: _incidentReportID,
      incidentID: _incidentID,
      incidentCost: _incidentCost,
      customerId: _customerID,
      incidentType: _incidentType,
      incidentDescription: _incidentDescription,
      incidentInsepector: _incidentInspector,
    );

    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ClaimDetails(
            incidentInfo: inc,
            vServiceInfo: vService,
            incReportInfo: incR,
          ),
        ),
      );

  }
  
  
  @override
  void initState() {
    super.initState();
    inc = widget.incidentInfo;
    vService = widget.vServiceInfo;
    print(inc.incidentID);
    print(vService.custId);

    _incidentReportID = generateUniqueId([]);
    _incidentInspector = 'Randomizer';
    _incidentCost = inc.incidentCost;
    _customerID = vService.custId;
    _incidentType = inc.incidentType;
    _incidentDescription = inc.Description;
    _incidentID = inc.incidentID; 
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        title: Text(
          "Incident Report",
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                              text: 'Incident Report ID  : ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          TextSpan(text: _incidentReportID),
                        ],
                      ),
                      style:
                          const TextStyle(color: Colors.blue, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
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
                              text: 'Customer ID : ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          TextSpan(text: _customerID),
                        ],
                      ),
                      style:
                          const TextStyle(color: Colors.blue, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
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
                              text: 'Incident Inspector :  ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          TextSpan(text: _incidentInspector),
                        ],
                      ),
                      style:
                          const TextStyle(color: Colors.blue, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
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
                              text: 'Incident Cost  : ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          const WidgetSpan(
                            child: Icon(
                              Icons.currency_rupee_outlined,
                              size: 20.0,
                              color: Colors.blue,
                            ), // Your desired icon
                          ),
                          TextSpan(text: '$_incidentCost'),
                        ],
                      ),
                      style:
                          const TextStyle(color: Colors.blue, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
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
                              text: 'Incident Type  : ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          TextSpan(text: _incidentType),
                        ],
                      ),
                      style:
                          const TextStyle(color: Colors.blue, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 14, 0, 14),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: HexColor('#b0c4de'),
                    style: BorderStyle.solid,
                    width: 2.5,
                  ),
                ),
                child: Row(
                  children: [
                    Flexible(
                      // Wrap the row inside Flexible
                      fit: FlexFit
                          .loose, // Allow the row to grow beyond its intrinsic width
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Incident Description  : ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            TextSpan(text: _incidentDescription),
                          ],
                        ),
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
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
    );
  }
}
