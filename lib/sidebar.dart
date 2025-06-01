import 'package:flutter/material.dart';
import 'package:projet_8016586/ajoutepatient%20(3).dart';
import 'package:projet_8016586/home_screen%20(5).dart';

import 'package:projet_8016586/recommendation.dart';
import 'package:projet_8016586/theme_service.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onToggle;

  const Sidebar({
    super.key,
    required this.isOpen,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: themeService.surfaceColor,
      ),
      duration: const Duration(milliseconds: 300),
      width: isOpen ? 230 : 90,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: IconButton(
              icon: Icon(isOpen ? Icons.arrow_back : Icons.arrow_forward),
              color: Colors.black87,
              onPressed: onToggle,
              tooltip: 'Toggle Sidebar',
            ),
          ),
          const SizedBox(height: 70),
          _buildSidebarButton(
              context,
              Icons.people,
              'Patient Management',
              themeService,
              HomeScreen(
                themeService: themeService,
              )),
          _buildSidebarButton(context, Icons.person_add, 'Add Patient',
              themeService, const Ajoutepatient()),
          _buildSidebarButton(
              context,
              Icons.calendar_month,
              'Appointments',
              themeService,
              RecommendationDialog(
                themeService: themeService,
              )),
        ],
      ),
    );
  }

  Widget _buildSidebarButton(BuildContext context, IconData icon, String label,
      ThemeService themeService, Widget direction) {
    return Container(
      decoration: BoxDecoration(
        color: themeService.surfaceColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8.0),
        ),
      ),
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => direction),
          );
        },
        style: TextButton.styleFrom(
          foregroundColor: themeService.textColor,
          textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              fontSize: 14.5),
          fixedSize: const Size(double.infinity, 55),
          alignment: isOpen ? Alignment.centerLeft : Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(16),
        ),
        child: Row(
          mainAxisAlignment:
              isOpen ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Icon(icon),
            if (isOpen) const SizedBox(width: 16),
            if (isOpen)
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
