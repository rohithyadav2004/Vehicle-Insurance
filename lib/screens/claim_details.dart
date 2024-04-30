import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:insuranceapp/database_connection/db_connect.dart';
import 'package:insuranceapp/global_variables.dart';
import 'package:insuranceapp/idgenerator/uniquegenerator.dart';
import 'package:insuranceapp/models/incident_model.dart';
import 'package:insuranceapp/screens/claim_settlement.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class ClaimDetails extends StatefulWidget {
  const ClaimDetails(
      {super.key,
      required this.incidentInfo,
      required this.vServiceInfo,
      required this.incReportInfo});

  final incidentModel incidentInfo;
  final IncidentReportModel incReportInfo;
  final vehicleServiceModel vServiceInfo;

  @override
  State<ClaimDetails> createState() => _ClaimDetailsState();
}

class _ClaimDetailsState extends State<ClaimDetails> {
  String? _claimID = '';
  var _custId;
  int _claimAmt = 0;
  var coverage_level;
  var _incidentId = '';
  String _damageType = '';
  var _dateofClaim;
  String _claimStatus = '';
  String _agreementId = '';
  bool _isLoading = true;
  late incidentModel inc;
  late vehicleServiceModel vService;
  late IncidentReportModel incReport;
  var coverageId;

  void _saveDetails() async {
    ClaimModel cMod = ClaimModel(
        claimId: _claimID!,
        customerId: _custId,
        claimAmt: _claimAmt,
        agreementId: _agreementId,
        incidentId: _incidentId,
        damageType: _damageType,
        dateOfClaim: _dateofClaim,
        claimStatus: _claimStatus);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ClaimSettlement(
          incidentInfo: inc,
          vServiceInfo: vService,
          incReportInfo: incReport,
          claimInfo: cMod,
          cvgId: coverageId,
        ),
      ),
    );
  }

  void _getDetails() async {
    inc = widget.incidentInfo;
    vService = widget.vServiceInfo;
    incReport = widget.incReportInfo;

    final dbHelper = DatabaseHelper();
    try {
      await dbHelper.connectToDatabase();
      var conn = dbHelper.connection;
      try {
        print('entered');
        var response = await conn.query(
          'SELECT Policy_Id FROM Vehicle WHERE Vehicle_Id = ?',
          [vService.vId],
        );
        print('response done');
        var result = response.first;
        var policyId = result['Policy_Id'];

        var response2 = await conn.query(
          'select Agreement_id from INSURANCE_POLICY where Policy_Number = ?',
          [policyId],
        );
        print('response2 done');

        var result2 = response2.first;
        _claimID = generateUniqueId([]);
        _agreementId = result2['Agreement_id'];
        print(_agreementId);
        var response3 = await conn.query(
            'SELECT Coverage_Id from INSURANCE_POLICY_COVERAGE where Agreement_id = ?',
            [_agreementId]);
        print('response3 done');

        var result3 = response3.first;
        var cvgId = result3['Coverage_Id'];
        coverageId = cvgId;

        print(cvgId);

        var response4 = await conn.query(
            'Select Coverage_Level from COVERAGE where Coverage_Id = ?',
            [cvgId]);
        print('response4 done');

        var result4 = response4.first;
        coverage_level = result4['Coverage_Level'];
        print('coverage level is $coverage_level');

        if (coverage_level == 'Basic') {
          if (inc.incidentCost! > 100000) {
            _claimAmt = 100000;
          } else {
            _claimAmt = inc.incidentCost!;
          }
        } else if (coverage_level == 'Standard') {
          if (inc.incidentCost! > 300000) {
            _claimAmt = 100000;
          } else {
            _claimAmt = inc.incidentCost!;
          }
        } else {
          if (inc.incidentCost! > 500000) {
            _claimAmt = 100000;
          } else {
            _claimAmt = inc.incidentCost!;
          }
        }

        _incidentId = inc.incidentID!;
        _damageType = vService.vsType!;
        DateTime now = DateTime.now();
        _dateofClaim = DateFormat('yyyy-MM-dd').format(now);
        _claimStatus = 'APPROVED';
        _custId = userCustID;
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
      body: _isLoading // Show loading indicator if data is still loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
                                    text: 'Claim ID  : ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                //const WidgetSpan(
                                //  child: Icon(
                                //    Icons.currency_rupee_outlined,
                                //    size: 20.0,
                                //    color: Colors.blue,
                                //  ), // Your desired icon
                                //),
                                TextSpan(text: _claimID),
                              ],
                            ),
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 16.0),
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
                                    text: 'Claim Amount  : ',
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
                                TextSpan(text: '$_claimAmt'),
                              ],
                            ),
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 16.0),
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
                                    text: 'Damage Type  : ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                TextSpan(text: _damageType),
                              ],
                            ),
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 16.0),
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
                                    text: 'Date of claim : ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                TextSpan(text: '$_dateofClaim'),
                              ],
                            ),
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 16.0),
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
                                    text: 'Claim Approval : ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                TextSpan(text: _claimStatus),
                              ],
                            ),
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: _saveDetails,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          backgroundColor: HexColor('#b0c4de'),
                        ),
                        child: const Text(
                          'Claim',
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
    );
  }
}
