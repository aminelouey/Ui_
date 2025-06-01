import 'package:flutter/material.dart';
import 'package:projet_8016586/Patients_Provider.dart';
import 'package:projet_8016586/home_screen%20(5).dart';
import 'package:projet_8016586/sidebar.dart';
import 'package:projet_8016586/theme_service.dart';
import 'package:provider/provider.dart';

class Ajoutepatient extends StatefulWidget {
  const Ajoutepatient({super.key});

  @override
  State<Ajoutepatient> createState() => _AjoutepatientState();
}

class _AjoutepatientState extends State<Ajoutepatient> {
  bool _isSidebarOpen = true;
  DateTime? selectedDate;
  String? selectedGenre;

  final TextEditingController dateconsController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController traitementController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialiser la date de consultation avec la date actuelle
    final now = DateTime.now();
    dateconsController.text = "${now.day}/${now.month}/${now.year}";
  }

  @override
  void dispose() {
    ageController.dispose();
    nameController.dispose();
    phoneController.dispose();
    dateconsController.dispose();
    diagnosisController.dispose();
    traitementController.dispose();
    super.dispose();
  }

  Widget _buildAppBar(ThemeService themeService) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen(themeService: themeService)));
            },
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 8),
          const Text(
            'New Patient',
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
                      _buildLabel('2- Age: ', themeService),
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
                          controller: ageController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),

                          // onTap: () => _selectDate(context),
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
                      _buildLabel("4- Consultation Date", themeService)
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
                      const SizedBox(width: 80),
                      Container(
                        height: 45,
                        width: 300,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextField(
                            controller: dateconsController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  //diagnosi button :
                  Padding(
                    padding: const EdgeInsets.only(left: 35.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildLabel("5-Diagnosi : ", themeService),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: Row(children: [
                      SizedBox(
                        height: 45,
                        width: 300,
                        child: TextField(
                          controller: diagnosisController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ]),
                  ),

                  const SizedBox(height: 20),

                  // Treatment row
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      _buildLabel('5- Treatment:', themeService),
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
                          controller: traitementController,
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
                              ? Colors.white
                              : Colors.blue,
                        ),
                        width: 180,
                        height: 40,
                        child: SizedBox.expand(
                          child: TextButton(
                            onPressed: () async {
                              final String name = nameController.text.trim();
                              final String diagnosis =
                                  diagnosisController.text.trim();
                              final String phone = phoneController.text.trim();
                              final String visitdate =
                                  dateconsController.text.trim();
                              final int age =
                                  int.parse(ageController.text.trim());
                              final String traitement =
                                  traitementController.text.trim();

                              if (name.isEmpty ||
                                  phone.isEmpty ||
                                  // age.isEmpty ||
                                  traitement.isEmpty ||
                                  diagnosis.isEmpty) {
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
                                final pro = PatientProvider();
                                await pro.addPatient(name, phone, age);
                                print(
                                    "Patient diagnosi : $diagnosis, patient traitment : $traitement");
                                await pro.updateDiagnosis(name, diagnosis);
                                await pro.updateTreatment(name, traitement);
                                await pro.updateAppointment(name, visitdate);

                                // ajoute AGE :

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Patient registered successfully')),
                                );

                                // Reset fields
                                nameController.clear();
                                dateconsController.clear(); // Reset visit dat
                                phoneController.clear();
                                diagnosisController.clear();
                                ageController.clear();
                                traitementController.clear();
                                selectedGenre = null;
                                setState(() {});
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("Errorrrrrrrr: ${e.toString()}"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                      themeService: themeService,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                color: Colors.black,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Ajoutepatient(),
                                ),
                              );
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
