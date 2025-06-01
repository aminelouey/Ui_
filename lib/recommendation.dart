import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projet_8016586/AssistantHost.dart';
import 'package:projet_8016586/DoctorClient.dart';

import 'package:projet_8016586/Rendez_vous.dart';
import 'package:projet_8016586/database.dart';
import 'package:projet_8016586/home_screen%20(5).dart';
import 'package:projet_8016586/theme_service.dart';

class RecommendationDialog extends StatefulWidget {
  final ThemeService themeService;
  const RecommendationDialog({super.key, required this.themeService});

  @override
  State<RecommendationDialog> createState() => _RecommendationDialogState();
}

class _RecommendationDialogState extends State<RecommendationDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAppointmentDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
        themeService: widget.themeService); // or other background widget
  }

  void showAppointmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          backgroundColor: const Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
                color: Color.fromARGB(255, 214, 214, 214), width: 1),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 549, maxWidth: 549, minHeight: 350, maxHeight: 350),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Which account do you choose?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const SizedBox(width: 25),
                      _accountButton(
                        context,
                        icon: Icons.person,
                        label: 'Doctor',
                        onTap: () {
                          DoctorClient dc = DoctorClient();
                          _showAppointmentDialog(context, dc);
                        },
                        foregroundColor: Colors.black,
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const SizedBox(width: 25),
                      _accountButton(
                        context,
                        icon: Icons.group,
                        label: 'Assistant',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RendyvousASS()));
                        },
                        foregroundColor: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _accountButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap,
      required Color foregroundColor}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(2),
      child: Container(
        width: 442,
        height: 90,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: const Color.fromARGB(125, 0, 0, 0),
          ),
          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            // BoxShadow(
            //   color: Colors.blueGrey,
            //   blurRadius: 12,
            //   offset: const Offset(0, 6),
            // ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 24),
            Icon(icon, color: Colors.blueAccent, size: 20),
            const SizedBox(width: 20),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: foregroundColor,
              ),
            ),
            const Spacer(),
            // Container(
            //   width: 15,
            //   height: 15,
            //   decoration: const BoxDecoration(
            //     color: Color(0xFF7CFF7C),
            //     shape: BoxShape.circle,
            //   ),
            // ),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _showAppointmentDialog(
      BuildContext context, DoctorClient doctor) async {
    Map<String, HostInfo> assistants = await doctor.gaussDiscover();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            width: 600, // Custom width
            height: 600, // Custom height
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.black,
                      iconSize: 24,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'searching...',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                  ),
                  const SizedBox(height: 15),
                  //New appointment
                  Container(
                    width: double.infinity,
                    height: 459,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: assistants.length,
                            itemBuilder: (context, index) {
                              final entry = assistants.entries.elementAt(index);
                              final host = entry.key;
                              final hostInfo = entry.value;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RendyvousDOC(
                                                key: null,
                                                thiz: hostInfo,
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 10.0, right: 10.0),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF90CAF9),
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                                  255, 138, 138, 138)
                                              .withOpacity(0.5),
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        Text(
                                          " $host",
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 40),
                                        Text(
                                          "IP: ${hostInfo.ip}",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 40),
                                        Text(
                                          "Port: ${hostInfo.port}",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
