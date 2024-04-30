import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:insuranceapp/database_connection/db_connect.dart';
import 'package:insuranceapp/global_variables.dart';
import 'package:insuranceapp/idgenerator/uniquegenerator.dart';
import 'package:insuranceapp/models/incident_model.dart';

class ClaimSettlement extends StatefulWidget {
  const ClaimSettlement(
      {super.key,
      required this.incidentInfo,
      required this.vServiceInfo,
      required this.incReportInfo,
      required this.claimInfo,
      required this.cvgId});
  final ClaimModel claimInfo;
  final incidentModel incidentInfo;
  final IncidentReportModel incReportInfo;
  final vehicleServiceModel vServiceInfo;
  final String cvgId;
  @override
  State<ClaimSettlement> createState() => _ClaimSettlementState();
}

class _ClaimSettlementState extends State<ClaimSettlement> {
  String? _claimSettlementID = '';
  String? _claimID = '';
  String? _customerID = '';
  String? _vehicleID = '';
  var _dateofSettlement;
  int? _amtPaid = 0;
  late incidentModel inc;
  late vehicleServiceModel vService;
  late IncidentReportModel incReport;
  late ClaimModel clInfo;
  late String coverageId;
  late ClaimSettlementModel ClSetInfo;

  void _getDetails() async {
    inc = widget.incidentInfo;
    vService = widget.vServiceInfo;
    incReport = widget.incReportInfo;
    clInfo = widget.claimInfo;

    _claimSettlementID = generateUniqueId([]);
    _claimID = clInfo.claimId;
    _customerID = userCustID;
    _vehicleID = vService.vId;
    _dateofSettlement = clInfo.dateOfClaim;
    _amtPaid = clInfo.claimAmt;
    coverageId = widget.cvgId;

    ClSetInfo = ClaimSettlementModel(
      claimSetId: _claimSettlementID,
      claimId: _claimID,
      custId: _customerID,
      vehicleId: _vehicleID,
      dateSettled: _dateofSettlement,
      coverageId: coverageId,
      amountPaid: _amtPaid,
    );
  }

  void _saveDetails() async {
    final dbHelper = DatabaseHelper();
    try {
      await dbHelper.connectToDatabase();
      var conn = dbHelper.connection;
      try {
        var response1 = await conn.query(
            'INSERT into INCIDENT(Incident_Id, Incident_Type, Incident_Date, Description, Incident_Cost) VALUES (?,?,?,?,?)',
            [
              inc.incidentID,
              inc.incidentType,
              inc.incidentDate,
              inc.Description,
              inc.incidentCost
            ]);

        print('table 1 done');

        var response2 = await conn.query(
            'INSERT into INCIDENT_REPORT(Incident_Report_Id, Incident_Type, Incident_Inspector,Incident_Cost, Incident_Report_Description,Incident_Id,Cust_Id) VALUES (?,?,?,?,?,?,?)',
            [
              incReport.incidentReportID,
              incReport.incidentType,
              incReport.incidentInsepector,
              incReport.incidentCost,
              incReport.incidentDescription,
              incReport.incidentID,
              incReport.customerId
            ]);

         print('table 2 done');
        var response3 = await conn.query(
            'INSERT into VEHICLE_SERVICE(Vehicle_Service_Id, Vehicle_Id, Cust_Id, Vehicle_Service_Name, Vehicle_Service_Address, Vehicle_Service_Contact, Vehicle_Service_Incharge, Vehicle_Service_Type) VALUES (?,?,?,?,?,?,?,?)',
            [
                vService.vsId,
                vService.vId,
                vService.custId,
                vService.vsName,
                vService.vsAddress,
                vService.vsContact,
                vService.vsIncharge,
                vService.vsType
            ]);
            print('table 3 done');
        var response4 = await conn.query(
            'INSERT into CLAIM(Claim_Id, Agreement_Id, Claim_Amount, Incident_Id, Damage_Type, Date_Of_Claim, Claim_Status, Cust_Id) VALUES (?,?,?,?,?,?,?,?)',
            [
              clInfo.claimId,
              clInfo.agreementId,
              clInfo.claimAmt,
              clInfo.incidentId,
              clInfo.damageType,
              clInfo.dateOfClaim,
              clInfo.claimStatus,
              clInfo.customerId
            ]);
            print('table 4 done');
        var response5 = await conn.query(
            'INSERT into CLAIM_SETTLEMENT(Claim_Settlement_Id, Vehicle_Id, Date_Settled,Amount_Paid, Coverage_Id,Claim_Id,Cust_Id) VALUES (?,?,?,?,?,?,?)',
            [
              ClSetInfo.claimSetId,
              ClSetInfo.vehicleId,
              ClSetInfo.dateSettled,
              ClSetInfo.amountPaid,
              ClSetInfo.coverageId,
              ClSetInfo.claimId,
              ClSetInfo.custId
            ]);
            print('table 5 done');
         Navigator.of(context)
                        .popUntil((route) => route.isFirst);

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
    _getDetails();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        title: Text(
          "Claim Details",
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
                              text: 'Claim Settlement ID  : ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          const WidgetSpan(
                            child: Icon(
                              Icons.currency_rupee_outlined,
                              size: 20.0,
                              color: Colors.blue,
                            ), // Your desired icon
                          ),
                          TextSpan(text: _claimSettlementID),
                        ],
                      ),
                      style:
                          const TextStyle(color: Colors.blue, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
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
                              text: 'Claim ID  : ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          const WidgetSpan(
                            child: Icon(
                              Icons.currency_rupee_outlined,
                              size: 20.0,
                              color: Colors.blue,
                            ), // Your desired icon
                          ),
                          TextSpan(text: _claimID),
                        ],
                      ),
                      style:
                          const TextStyle(color: Colors.blue, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
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
                              text: 'Customer ID  : ',
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
              const SizedBox(height: 10),
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
                              text: 'Vehicle ID : ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          TextSpan(text: _vehicleID),
                        ],
                      ),
                      style:
                          const TextStyle(color: Colors.blue, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
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
                              text: 'Date Settled : ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          TextSpan(text: _dateofSettlement.toString()),
                        ],
                      ),
                      style:
                          const TextStyle(color: Colors.blue, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
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
                              text: 'Amount Paid : ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          TextSpan(text: '$_amtPaid'),
                        ],
                      ),
                      style:
                          const TextStyle(color: Colors.blue, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
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
                  'OK',
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
