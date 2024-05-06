import 'package:flutter/material.dart';

import '../../../../strings.dart';

import 'add_patient_field.dart';

class AddPatientWidget extends StatefulWidget {
  const AddPatientWidget({super.key});

  @override
  State createState() => _AddPatientWidgetState();
}

class _AddPatientWidgetState extends State<AddPatientWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        title: const Text(addPatientPageTitle),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_mockup.webp',
              fit: BoxFit.cover, // Cover the entire container without scaling
            ),
          ),
          // Content on top of the background image
          const AddPatientField()
        ],
      ),
    );
  }
}
