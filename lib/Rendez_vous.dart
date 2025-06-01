import 'package:flutter/material.dart';
import 'package:projet_8016586/DoctorClient.dart';
import 'package:projet_8016586/RendezvousPrincipaleDOC.dart';
import 'package:projet_8016586/RendezvousPrincipaleASS.dart';
import 'package:projet_8016586/database.dart';
import 'package:projet_8016586/sidebar.dart';
import 'package:projet_8016586/theme_service.dart';
import 'package:provider/provider.dart';

class RendyvousASS extends StatefulWidget {
  const RendyvousASS({super.key});

  @override
  State<RendyvousASS> createState() => _MyRendyvousStateASS();
}

class RendyvousDOC extends StatefulWidget {
  final HostInfo thiz;

  const RendyvousDOC({super.key, required this.thiz});

  @override
  State<RendyvousDOC> createState() => _MyRendyvousStateDOC(thiz);
}

class _MyRendyvousStateASS extends State<RendyvousASS> {
  bool _isSidebarOpen = true;

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    return Scaffold(
      backgroundColor: themeService.isDarkMode
          ? const Color.fromARGB(255, 0, 10, 27)
          : const Color.fromARGB(255, 242, 251, 255),
      body: Row(
        children: [
          Sidebar(
            isOpen: _isSidebarOpen,
            onToggle: _toggleSidebar,
          ),
          const Expanded(
            // 🔄 remove `const` because children depend on runtime variable
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RendezvousPrincipaleASS(), // ✅ Now valid
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _MyRendyvousStateDOC extends State<RendyvousDOC> {
  bool _isSidebarOpen = true;
  final HostInfo thiz; // ✅ Store thiz as a field

  _MyRendyvousStateDOC(this.thiz); // ✅ Assign thiz in constructor

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    return Scaffold(
      backgroundColor: themeService.isDarkMode
          ? const Color.fromARGB(255, 0, 10, 27)
          : const Color.fromARGB(255, 242, 251, 255),
      body: Row(
        children: [
          Sidebar(
            isOpen: _isSidebarOpen,
            onToggle: _toggleSidebar,
          ),
          Expanded(
            // 🔄 remove `const` because children depend on runtime variable
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RendezvousPrincipaleDOC(thiz: thiz), // ✅ Now valid
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
