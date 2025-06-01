import 'package:flutter/material.dart';
import 'package:projet_8016586/AssistantHost.dart';

import 'package:projet_8016586/database.dart';
import 'package:projet_8016586/sidebar.dart';
import 'package:projet_8016586/theme_service.dart';
import 'package:provider/provider.dart';

class AddApointment extends StatefulWidget {
  final AssitantHost host;
  final AppDatabase adb;

  const AddApointment({super.key, required this.adb, required this.host});

  @override
  State<AddApointment> createState() => _AjoutepatientState();
}

class _AjoutepatientState extends State<AddApointment> {
  bool _isSidebarOpen = true;
  DateTime? selectedDate;
  String? selectedGenre;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  late final AssitantHost host;
  late final AppDatabase adb;

  @override
  void initState() {
    super.initState();
    host = widget.host;
    adb = widget.adb;
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  @override
  void dispose() {
    dateController.dispose();
    nameController.dispose();
    phoneController.dispose();
    noteController.dispose();

    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text =
            "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
      });
    }
  }

  Widget _buildAppBar(ThemeService themeService) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              //Navigator.push(context,
              //    MaterialPageRoute(builder: (context) => _rendyvousASS));
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 8),
          const Text(
            'New Appointment',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
                themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeService.toggleTheme(),
            tooltip: 'Change theme',
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            isOpen: _isSidebarOpen,
            onToggle: _toggleSidebar,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildAppBar(themeService),
                  const SizedBox(height: 20),

                  // Name and Birth date row
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      _buildLabel('1- Full Name:', themeService),
                      const SizedBox(width: 280),
                      _buildLabel('2- Date of Appointment: ', themeService),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(width: 32),
                      SizedBox(
                        height: 45,
                        width: 300,
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 80),
                      SizedBox(
                        height: 45,
                        width: 300,
                        child: TextField(
                          controller: dateController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onTap: () => _selectDate(context),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // date visit and phone ;
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      _buildLabel('3-Phone Number:', themeService),
                      const SizedBox(width: 245),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(width: 32),
                      SizedBox(
                        height: 45,
                        width: 300,
                        child: TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                            hintText: '+213 ...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Treatment row
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      _buildLabel('5- Note:', themeService),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      SizedBox(
                        height: 400,
                        width: 650,
                        child: TextField(
                          controller: noteController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  // Buttons
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      // Save button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: themeService.isDarkMode
                              ? themeService.foregroundColor
                              : Colors.blue,
                        ),
                        width: 180,
                        height: 40,
                        child: SizedBox.expand(
                          child: TextButton(
                            onPressed: () async {
                              final String name = nameController.text.trim();

                              final String phone = phoneController.text.trim();
                              final String visitdate =
                                  dateController.text.trim();

                              final String note = noteController.text.trim();

                              if (name.isEmpty ||
                                  phone.isEmpty ||
                                  note.isEmpty ||
                                  visitdate.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Please fill in all fields')),
                                );
                                return;
                              }

                              try {
                                // Phone number validation
                                final String phone = phoneController.text
                                    .trim()
                                    .replaceAll(RegExp(r'[^0-9]'), '');
                                if (phone.isEmpty) {
                                  throw "Invalid phone number";
                                }

                                // final dbHelper = DataHelper();

                                final pro = Appointmentee(
                                  name: name,
                                  date: visitdate,
                                  phoneNumber: phone,
                                  note: note,
                                );
                                adb.insertAppointment(pro);
                                host.kepler();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Appointmente registered successfully')),
                                );
                                // RendezvousPrincipaleASS()
                                // Reset fields
                                nameController.clear();
                                dateController.clear();
                                phoneController.clear();
                                noteController.clear();
                                selectedGenre = null;

                                setState(() {});
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Error: ${e.toString()}"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                Navigator.pop(context, true);
                              }
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                color: themeService.isDarkMode
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 200),
                      // Cancel button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: themeService.isDarkMode
                              ? const Color.fromARGB(255, 250, 88, 88)
                              : const Color.fromARGB(255, 179, 179, 179),
                        ),
                        width: 180,
                        height: 40,
                        child: SizedBox.expand(
                          child: TextButton(
                            onPressed: () {
                              // ???
                              /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddApointment(host: host, adb: adb),
                                ),
                              );*/
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                color: themeService.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLabel(String text, ThemeService themeService) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.5,
        fontFamily: 'Poppins',
        color: themeService.isDarkMode ? Colors.white : Colors.black,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
