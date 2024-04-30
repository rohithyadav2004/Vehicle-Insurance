import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:insuranceapp/main.dart';
import 'package:insuranceapp/screens/policy_application_pg2.dart';

class ApplicationScreen extends StatefulWidget {
  final ThemeData theme;
  const ApplicationScreen({super.key, required this.theme});

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  bool showFullDescription_basic = false;
  bool showFullDescription_standard = false;
  bool showFullDescription_premium = false;

  String selectedOption = '';
  String selectedCoverageDesc = '';

  String basic_cvg_desc =
      'Provides basic liability coverage up to ₹5,00,000 for bodily injury and property damage caused by the insured vehicle.';
  String standard_cvg_desc =
      'Offers comprehensive coverage for the insured vehicle, including protection against theft, vandalism, and natural disasters, up to ₹10,00,00 in coverage.';
  String premium_cvg_desc =
      'Delivers premium collision coverage for the insured vehicle, covering repair or replacement costs in the event of a collision, up to ₹15,00,00 in coverage.';

  void _toggleExpansion(String cardType) {
    setState(() {
      print('Toggling expansion for card: $cardType');
      switch (cardType) {
        case 'basic':
          showFullDescription_basic = !showFullDescription_basic;
          showFullDescription_standard = true;
          showFullDescription_premium = true;
          break;
        case 'standard':
          showFullDescription_standard = !showFullDescription_standard;
          showFullDescription_basic = true;
          showFullDescription_premium = true;
          break;
        case 'premium':
          showFullDescription_premium = !showFullDescription_premium;
          showFullDescription_basic = true;
          showFullDescription_standard = true;
          break;
      }
      print(
          'Basic: $showFullDescription_basic \n Standard: $showFullDescription_standard \n Premium : $showFullDescription_premium');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Application",
          style: widget.theme.textTheme.headlineSmall!.copyWith(
            color: widget.theme.colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: HexColor('#b0c4de'),
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 19,
              ),
              GestureDetector(
                onTap: () => _toggleExpansion('basic'),
                child: Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.hardEdge,
                  elevation: 2,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: showFullDescription_basic ? null : 200,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: HexColor('#b0c4de'),
                        width: showFullDescription_basic ? 0 : 5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: widget.theme.textTheme.titleLarge!.copyWith(
                              color: widget.theme.colorScheme.onBackground,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Basic',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              TextSpan(
                                text: '\n$basic_cvg_desc',
                              ),
                            ],
                          ),
                          maxLines: showFullDescription_basic ? 3 : 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // if (showFullDescription_basic == true)
                        //   InkWell(
                        //     onTap: () => _toggleExpansion('basic'),
                        //     child: const Text(
                        //       '',
                        //       style: TextStyle(color: Colors.blue),
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 37,
              ),
              GestureDetector(
                onTap: () => _toggleExpansion('standard'),
                child: Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.hardEdge,
                  elevation: 2,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: showFullDescription_standard ? null : 225,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: HexColor('#b0c4de'),
                        width: showFullDescription_standard ? 0 : 5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: widget.theme.textTheme.titleLarge!.copyWith(
                              color: widget.theme.colorScheme.onBackground,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Standard',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              TextSpan(
                                text: '\n$standard_cvg_desc',
                              ),
                            ],
                          ),
                          maxLines: showFullDescription_standard ? 3 : 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // if (showFullDescription_standard == true)
                        //   InkWell(
                        //     onTap: () => _toggleExpansion('standard'),
                        //     child: const Text(
                        //       '',
                        //       style: TextStyle(color: Colors.blue),
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 37,
              ),
              GestureDetector(
                onTap: () => _toggleExpansion('premium'),
                child: Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.hardEdge,
                  elevation: 2,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: showFullDescription_premium ? null : 225,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: HexColor('#b0c4de'),
                        width: showFullDescription_premium ? 0 : 5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: widget.theme.textTheme.titleLarge!.copyWith(
                              color: widget.theme.colorScheme.onBackground,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Premium',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              TextSpan(text: '\n$premium_cvg_desc'),
                            ],
                          ),
                          maxLines: showFullDescription_premium ? 3 : 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // if (showFullDescription_premium == true)
                        //   InkWell(
                        //     onTap: () => _toggleExpansion('premium'),
                        //     child: const Text(
                        //       '',
                        //       style: TextStyle(color: Colors.blue),
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    if (showFullDescription_basic == false &&
                        showFullDescription_standard == false &&
                        showFullDescription_premium == false) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Select an option',
                          ),
                        ),
                      );
                    } else if (showFullDescription_basic == false) {
                      selectedOption = 'Basic';
                    } else if (showFullDescription_standard == false) {
                      selectedOption = 'Standard';
                    } else if (showFullDescription_premium == false) {
                      selectedOption = 'Premium';
                    }
                    print(selectedOption);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SelectionofPolicy(
                          theme: theme,
                          coverage_level: selectedOption,
                          coverage_desc: selectedCoverageDesc,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        side: BorderSide.none),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    backgroundColor: HexColor('#b0c4de'),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
