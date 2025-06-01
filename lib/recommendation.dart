import 'package:flutter/material.dart';
import 'package:projet_8016586/DoctorClient.dart';

import 'package:projet_8016586/Rendez_vous.dart';
import 'package:projet_8016586/home_screen%20(5).dart';
import 'package:projet_8016586/theme_service.dart';
import 'package:provider/provider.dart';

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
          backgroundColor: Colors.blueGrey,
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
                  Text(
                    'Which account do you choose?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
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
                                builder: (context) => const RendyvousASS()),
                          );
                        },
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

  Widget _accountButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 442,
        height: 90,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: theme.brightness == Brightness.dark
                ? Colors.white24
                : Colors.black12,
          ),
          color: theme.colorScheme.surface, // s’adapte au thème
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const SizedBox(width: 24),
            Icon(icon, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 20),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _showAppointmentDialog(
      BuildContext context, DoctorClient doctor) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Map<String, HostInfo> assistants = await doctor.gaussDiscover();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            width: 600,
            height: 600,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      color: colorScheme.onBackground,
                      iconSize: 24,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'searching...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: colorScheme.onBackground,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // New appointment
                  Container(
                    width: double.infinity,
                    height: 459,
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colorScheme.outline),
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
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 10.0, right: 10.0),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color:
                                          colorScheme.primary.withOpacity(0.3),
                                      border: Border.all(
                                          color: colorScheme.outlineVariant),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.shadowColor
                                              .withOpacity(0.2),
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
                                          style: TextStyle(
                                            color: colorScheme.onSurface,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 40),
                                        Text(
                                          "IP: ${hostInfo.ip}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(width: 40),
                                        Text(
                                          "Port: ${hostInfo.port}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: colorScheme.onSurface,
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
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
