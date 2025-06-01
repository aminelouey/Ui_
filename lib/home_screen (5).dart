import 'package:flutter/material.dart';
import 'package:projet_8016586/Data_Helper.dart';
import 'package:projet_8016586/Patients_Model.dart';
import 'package:projet_8016586/ajoutepatient%20(3).dart';
import 'package:projet_8016586/patient_table%20(3).dart';

import 'theme_service.dart';
import 'sidebar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final ThemeService themeService;
  final Patient? newPatient;

  const HomeScreen({super.key, this.newPatient, required this.themeService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSidebarOpen = true;

  final DataHelper _dbHelper = DataHelper();
  List<Patient> _patients = [];

  final TextEditingController _searchController = TextEditingController();
  List<Patient> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _fetchPatients();
    _searchController.addListener(() {
      _searchPatients(_searchController.text.trim());
    });
  }

  // Search patients based on text input
  void _searchPatients(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final results = await _dbHelper.getAllPatients();
    setState(() {
      _searchResults = results.map((patient) {
        return Patient(
          id: patient['Id'],
          fullName: patient['Full_Name'],
          age: patient['Age'] ?? 0,
          diagnosis: patient['Diagnosis'],
          appointmentDate: patient['Date'] ?? 'N/A',
          phoneNumber: '',
          treatment: '',
        );
      }).toList();
    });
  }

// widget de sherch bar :

  // Fetch all patients
  void _fetchPatients() async {
    final patientData = await _dbHelper.getAllPatients();
    print("Patient data: $patientData"); // Ajouter ce log
    setState(() {
      _patients = patientData.map((patient) {
        return Patient(
          id: patient['Id'],
          fullName: patient['Full_Name'],
          age: patient['Age'] ??
              0, // Utiliser la valeur par défaut si elle est null,
          diagnosis: patient['Diagnosis'] ?? 'N/A',
          appointmentDate: patient['Date'] ?? 'N/A', phoneNumber: '',
          treatment: '',
        );
      }).toList();
    });
    print("Mapped patients: $_patients"); // Ajouter ce log
  }

// set state of sidebar :
  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final double screen = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: themeService.backgroundColor,
      body: Stack(
        children: [
          Row(
            children: [
              //sidebar
              Sidebar(
                isOpen: _isSidebarOpen,
                onToggle: _toggleSidebar,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildAppBar(themeService),
                    const SizedBox(height: 40),
                    const Row(
                      children: [
                        SizedBox(width: 100),
                        // patient text
                        Text(
                          'Patients',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            fontFamily: "poppins",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      children: [
                        SizedBox(width: 100),
                        // Manage your patients here
                        Text(
                          'Manage your patients here',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "poppins",
                              fontWeight: FontWeight.w100),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 75),
                        _buildSearchBar(),
                        buildSizedBox2(screen),
                        // new patient button :
                        Container(
                          width: 220,
                          height: 43,
                          decoration: BoxDecoration(
                            color: themeService.buttonColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Ajoutepatient()),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: themeService.isDarkMode
                                      ? Colors.black
                                      : Colors.white,
                                  size: 22,
                                ),
                                const SizedBox(width: 13),
                                Text(
                                  'New Patient',
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w100,
                                    color: themeService.isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // patient table:
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 60),
                                  PatientTable(
                                    themeService: themeService,
                                    patients: _patients,
                                    onRefresh: _fetchPatients,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //resultat de search bar
          if (_searchController.text.isNotEmpty && _searchResults.isNotEmpty)
            Positioned(
              top: 279,
              left: _isSidebarOpen ? 326 : 166,
              child: Container(
                width: 350,
                constraints: const BoxConstraints(maxHeight: 250),
                decoration: BoxDecoration(
                  color: themeService.surfaceColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final patient = _searchResults[index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _searchController.clear();
                            _searchResults = [];
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Patient Details"),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Name: ${patient.fullName}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        "Last visit: ${patient.appointmentDate}"),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Close"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.person_outline,
                                  size: 20, color: Colors.grey),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      patient.fullName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Colors.grey[400]),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

// Search bar
  Widget _buildSearchBar() {
    final themeService = Provider.of<ThemeService>(context);
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: themeService.surfaceColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          _searchPatients(value.trim());
        },
        decoration: InputDecoration(
          hintText: 'Search patient ...',
          hintStyle: const TextStyle(fontWeight: FontWeight.normal),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

// Appbar
  Widget _buildAppBar(ThemeService themeService) {
    return Container(
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

// sizebox
  Widget buildSizedBox2(double screen) {
    if (screen > 1250) {
      return SizedBox(width: 330);
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
}
