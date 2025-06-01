import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projet_8016586/Add_Apointment.dart';
import 'package:projet_8016586/database.dart';
import 'package:projet_8016586/theme_service.dart';
import 'package:provider/provider.dart';
import 'AssistantHost.dart';

class RendezvousPrincipaleASS extends StatefulWidget {
  const RendezvousPrincipaleASS({
    super.key,
  });

  @override
  _RendezVousPageASSState createState() => _RendezVousPageASSState();
}

class _RendezVousPageASSState extends State<RendezvousPrincipaleASS> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Appointmentee>> appointmentListFuture = Future.value([]);
  List<Appointmentee> filteredAppointments = [];

  AppDatabase adb = AppDatabase();

  late AssitantHost host;

  late Future<AssitantHost> _hostFuture;

  @override
  void initState() {
    super.initState();
    _hostFuture = initServer();
    _searchController.addListener(_filterAppointments);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterAppointments);
    _searchController.dispose();
    super.dispose();
  }

  void _filterAppointments() {
    final query = _searchController.text.toLowerCase();
    appointmentListFuture.then((appointments) {
      setState(() {
        filteredAppointments = appointments.where((appointment) {
          return appointment.name.toLowerCase().contains(query);
        }).toList();
      });
    });
  }

  Future<AssitantHost> initServer() async {
    final host = await AssitantHost.create(Platform.localHostname, adb);
    await host.start();
    return host;
  }

  TextEditingController nameController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController dateController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final double screen = MediaQuery.of(context).size.width;

    return FutureBuilder<AssitantHost>(
      future: _hostFuture,
      builder: (context, hostSnapshot) {
        if (hostSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (hostSnapshot.hasError) {
          return Center(child: Text('Error: ${hostSnapshot.error}'));
        } else if (hostSnapshot.hasData) {
          final host = hostSnapshot.data!;
          print('Host: ${host.hostname}  Port: ${host.port}');

          appointmentListFuture = adb.getAppointments();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(themeService),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.only(left: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Assistant Appointments',
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text('Manage your appointments here',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w100)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 80),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildSearchBar(themeService),
                          buildSizedBox2(screen),
                          Container(
                            width: 220,
                            height: 43,
                            decoration: BoxDecoration(
                              color: themeService.isDarkMode
                                  ? themeService.foregroundColor
                                  : const Color.fromARGB(255, 0, 64, 255)
                                      .withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddApointment(
                                            adb: adb,
                                            host: host,
                                            key: null,
                                          )),
                                ).then((value) {
                                  if (value == true) {
                                    setState(() {
                                      appointmentListFuture =
                                          adb.getAppointments();
                                    });
                                  }
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.add,
                                      color: themeService.isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                      size: 22),
                                  const SizedBox(width: 13),
                                  Text('New Appointment',
                                      style: TextStyle(
                                        color: themeService.isDarkMode
                                            ? Colors.black
                                            : Colors.white,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          buildSizedBox3(screen),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Container(
                        width: (screen <= 900) ? 810 : 900,
                        height: 700,
                        decoration: BoxDecoration(
                          color: themeService.isDarkMode
                              ? const Color.fromARGB(255, 0, 10, 27)
                                  .withOpacity(0.6)
                              : Colors.white.withOpacity(0.6),
                          border: Border.all(
                              color: const Color.fromARGB(255, 214, 214, 214)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 25, horizontal: 25),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text("Today's Appointments",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: FutureBuilder<List<Appointmentee>>(
                                  future: appointmentListFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return const Center(
                                          child: Text('No appointments found'));
                                    }

                                    final appointments =
                                        _searchController.text.isEmpty
                                            ? snapshot.data!
                                            : filteredAppointments;

                                    if (appointments.isEmpty &&
                                        _searchController.text.isNotEmpty) {
                                      return const Center(
                                          child: Text(
                                              'No matching appointments found'));
                                    }

                                    return ListView.builder(
                                      itemCount: appointments.length,
                                      itemBuilder: (context, index) {
                                        final appointment = appointments[index];
                                        return Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(12),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 16),
                                          decoration: BoxDecoration(
                                            color: themeService.foregroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color.fromARGB(
                                                        255, 138, 138, 138)
                                                    .withOpacity(0.1),
                                                blurRadius: 5,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: ListTile(
                                            title: Row(
                                              children: [
                                                const Text("Full Name:   ",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black)),
                                                Text(
                                                  appointment.name,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text("Date : ",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .black)),
                                                      Text(
                                                        appointment.date ?? '',
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                          "Phone Number : ",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .black)),
                                                      Text(
                                                        appointment
                                                                .phoneNumber ??
                                                            '',
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.red),
                                                  onPressed: () async {
                                                    try {
                                                      await adb
                                                          .deleteAppointment(
                                                              appointment.name);
                                                      setState(() {
                                                        appointmentListFuture =
                                                            adb.getAppointments();
                                                      });
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Appointment deleted successfully'),
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                      );
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Error deleting appointment: $e'),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                                const Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.black),
                                              ],
                                            ),
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      "Détails Appointement",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    content: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            "Full Name :      ${appointment.name}",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                            )),
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(
                                                            "Date :      ${appointment.date ?? ''}",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                            )),
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(
                                                            "Phone Number :       ${appointment.phoneNumber ?? ''}",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                            )),
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(
                                                            "Note :      ${appointment.note ?? ''}",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                            )),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: const Text(
                                                            "Fermer"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return const Center(child: Text("Unknown Error"));
      },
    );
  }

  Widget _buildSearchBar(ThemeService themeService) {
    return Container(
      decoration: BoxDecoration(
        color: themeService.isDarkMode
            ? const Color.fromARGB(255, 0, 10, 27)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      width: MediaQuery.of(context).size.width > 900
          ? 350
          : MediaQuery.of(context).size.width,
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          _filterAppointments();
        },
        decoration: InputDecoration(
          hintText: 'Search appointment by name...',
          hintStyle: const TextStyle(fontWeight: FontWeight.w100),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

Widget _buildAppBar(ThemeService themeService) {
  return Container(
    color: themeService.isDarkMode
        ? const Color.fromARGB(255, 0, 10, 27)
        : const Color.fromARGB(255, 242, 251, 255),
    height: 60,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(
              themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          onPressed: () => themeService.toggleTheme(),
          tooltip: 'Change theme',
        ),
      ],
    ),
  );
}

Widget buildSizedBox(double screen) {
  if (screen < 1100) {
    return SizedBox(width: 300);
  } else {
    return Container();
  }
}

Widget buildSizedBox2(double screen) {
  if (screen > 1100) {
    return SizedBox(width: 320);
  } else {
    return Container();
  }
}

Widget buildSizedBox3(double screen) {
  if (screen < 1100) {
    return SizedBox(width: 100);
  } else {
    return Container();
  }
}
