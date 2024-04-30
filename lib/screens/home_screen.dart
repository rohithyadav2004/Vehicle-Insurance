import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:insuranceapp/database_connection/db_connect.dart';
import 'package:insuranceapp/global_variables.dart';
import 'package:insuranceapp/main.dart';
import 'package:insuranceapp/models/incident_model.dart';
import 'package:insuranceapp/screens/claim_screen.dart';
import 'package:insuranceapp/screens/newVehicleRegistration.dart';
import 'package:insuranceapp/screens/policy_application.dart';
import 'package:insuranceapp/screens/policy_renewal.dart';
import 'package:insuranceapp/screens/vehicle_card.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String fName = '';
  bool _isLoading = true; // Tracks the loading state
  String _selectedItem = '';
  List<String> pIDs = [];
   List<String> Agreement_ids = [];
   List<String> Start_Date = [];
    List<String> Expiry_Date = [];
    List<String> Application_Ids = [];
    List<String> Vehicle_Ids_having_policy = [];
    List<String> Vehicle_Registration_Number = [];
    List<String> Vehicle_Type = [];
    List<VehicleCardModel> VCs =[];
    DateTime now = DateTime.now();
    var currentDate;
  @override
  void initState() {
    super.initState();
    _retrieveDetails(); //Call _retrieveDetails when the page is loaded
  }

  void _retrieveDetails() async {
    final dbHelper = DatabaseHelper();
    try {
      await dbHelper.connectToDatabase();
      var conn = dbHelper.connection;
      try {
        var response = await conn.query(
          'SELECT Cust_FName FROM Customer WHERE Cust_Id = ?',
          [userCustID],
        );
        print('done retrieving customer id');
        var result2 = await conn.query(
            'Select Vehicle_Id from Vehicle where Cust_Id = ?', [userCustID]);
        List<String> vIDs = [];
        for (var row in result2) {
          vIDs.add(row['Vehicle_Id'] as String);
        }
        print('done retrieving vehicle id');
        userVehicleIds = List.from(vIDs);
        var row = response.first;

        var result3 = await conn.query(
          'SELECT Application_Id,Agreement_id,Policy_Number,Start_Date,Expiry_Date FROM INSURANCE_POLICY WHERE Cust_Id = ?', [userCustID],
        );

        for (var row in result3) {
          pIDs.add(row['Policy_Number'] as String);
        }
        print('done retrieving policy id $pIDs');
        
        for (var row in result3) {
          Agreement_ids.add(row['Agreement_id'] as String);
        }
        print('done retrieving agreement id $Agreement_ids');

        for (var row in result3) {
          Start_Date.add(DateFormat('yyyy-MM-dd').format(row['Start_Date']).toString());
        }
        print('done retrieving start date $Start_Date');

        for (var row in result3) {
          Expiry_Date.add(DateFormat('yyyy-MM-dd').format(row['Expiry_Date']).toString());
        }
        print('done retrieving expiry date $Expiry_Date');

        for (var row in result3) {
          Application_Ids.add(row['Application_Id'] as String);
        }
        print('done retrieving application id $Application_Ids');

        for(int i =0;i<Application_Ids.length;i++){
          var result4 = await conn.query(
          'SELECT Vehicle_Id FROM Application WHERE Application_Id = ?', [Application_Ids[i]],
          );
          for (var row in result4) {
          Vehicle_Ids_having_policy.add(row['Vehicle_Id'] as String);
          }
        }
        print('done retrieving vehicle id from application $Vehicle_Ids_having_policy'); 

        for(int i =0; i< Vehicle_Ids_having_policy.length;i++){
          var result5 = await conn.query(
          'SELECT Vehicle_Registration_Number,Vehicle_Type FROM Vehicle WHERE Vehicle_Id = ?', [Vehicle_Ids_having_policy[i]],
          );
          for (var row in result5) {
          Vehicle_Registration_Number.add(row['Vehicle_Registration_Number'] as String);
          Vehicle_Type.add(row['Vehicle_Type'] as String);
          }
        }
        print('done retrieving vehicle registration number $Vehicle_Registration_Number');
        print('done retrieving vehicle type $Vehicle_Type');



        for(int i=0; i< Vehicle_Ids_having_policy.length ; i++){
          bool isExpired = now.isBefore(DateTime.parse(Expiry_Date[i]));
          print('expirt date Done');
          VCs.add(VehicleCardModel(
            vehicleType: Vehicle_Type[i],
            vehicleRegistrationNumber: Vehicle_Registration_Number[i],
            expiryDate: isExpired
          ));
        }
        print('LOoop Done');
        print(VCs);

        setState(() {
          fName = row['Cust_FName'];
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
  Widget build(BuildContext context) {
    print('entered');
    print(VCs.isEmpty);
    print(Agreement_ids);

    Widget content = Expanded(
      child: ListView.builder(
        itemCount: VCs.length,
        itemBuilder: (ctx , index) => VehicleCard(vehicleType: VCs[index].vehicleType, vehicleRegistrationNumber: VCs[index].vehicleRegistrationNumber, isPolicyExpired: VCs[index].expiryDate)
      ),
    );
    if(VCs.isEmpty){
      print('Entered this');
      content = 
        Text('Uh oh... you haven\'t bought any policies.\n Get to quick services to get started!',style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),);
    }
    return Scaffold(
      appBar: (AppBar(
        title: Text(
          "Home",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        //backgroundColor: Colors.blue.shade700,
        backgroundColor: HexColor('#b0c4de'),
      )),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    HexColor('#b0c4de'),
                    HexColor('#b0c4de').withOpacity(0),
                  ],
                  //colors:  [
                  //  Colors.blue.shade700,
                  //  Colors.blue.shade700.withOpacity(0.7),
                  //],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.miscellaneous_services_sharp,
                    size: 48,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  const SizedBox(width: 18),
                  Text(
                    'Quick services',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            ExpansionTile(
              leading: Icon(
                Icons.policy_outlined,
                size: 26,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              title: Text(
                'Policy',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 24,
                    ),
              ),
              initiallyExpanded: _selectedItem == 'Policy',
              onExpansionChanged: (value) {
                setState(() {
                  if (value) {
                    _selectedItem = 'Policy';
                  }else {
                    _selectedItem = '';
                  }
                });
              },
              children: [
                ListTile(
                  leading: Icon(
                    Icons.security,
                    size: 26,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  title: Text(
                    'Apply',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 24,
                        ),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => ApplicationScreen(
                          theme: Theme.of(context),
                        ),
                      ),
                    )
                        .then((_) {
                      // This code will be executed when the user returns to the home page
                      // Pop all routes until you reach the home page
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                      // Push the home page route again to trigger its initState()
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    });
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.card_giftcard,
                    size: 26,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  title: Text(
                    'Claim',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 24,
                        ),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => const ClaimInsurance(),
                      ),
                    )
                        .then((_) {
                      // This code will be executed when the user returns to the home page
                      // Pop all routes until you reach the home page
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                      // Push the home page route again to trigger its initState()
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    });
                    // Handle Claim option
                  },
                ),
              ],
            ),
            //ListTile(
            //  leading: Icon(
            //    Icons.card_membership_outlined,
            //    size: 26,
            //    color: Theme.of(context).colorScheme.onBackground,
            //  ),
            //  title: Text(
            //    'Membership',
            //    style: Theme.of(context).textTheme.titleSmall!.copyWith(
            //          color: Theme.of(context).colorScheme.onBackground,
            //          fontSize: 24,
            //        ),
            //  ),
            //  onTap: () {
            //    
            //  },
            //),
            ListTile(
              leading: Icon(
                Icons.autorenew_outlined,
                size: 26,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              title: Text(
                'Policy Renewal',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 24,
                    ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Policy_renewable(agreementIds: Agreement_ids, applicationIds: Application_Ids),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.directions_car_filled_outlined,
                size: 26,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              title: Text(
                'New vehicle registration',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 24,
                    ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NewVehicleRegistration(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: _isLoading // Show loading indicator if data is still loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: const EdgeInsets.all(24),
              child :Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: VCs.isEmpty ? 0 : 20,
                  ),
                  Text(
                    "Hi $fName !!",
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Text(
                    VCs.isEmpty ? "" : 'Your active Policies:',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24.0,),
                  content,
                ],
              )),
            );
    //);
  }
}
