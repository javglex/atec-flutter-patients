import 'package:flutter/material.dart';
import 'package:flutter_alphatec_javier/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/patient_pagination_bloc.dart';
import '../../bloc/patient_updates_bloc.dart';

class AddPatientField extends StatefulWidget {
  const AddPatientField({super.key});

  @override
  State<AddPatientField> createState() => _AddPatientFieldState();
}

class _AddPatientFieldState extends State<AddPatientField> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  bool _isButtonEnabled = false;
  String lastPatientAdded = "";

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _firstNameController.addListener(_checkButtonState);
    _lastNameController.addListener(_checkButtonState);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _checkButtonState() {
    setState(() {
      _isButtonEnabled = _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PatientBloc, PatientUpdateState>(
        listener: (context, state) {
          if (state.status == PatientStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(patientAddErrorMessage)),
            );
          }
          if (state.status == PatientStatus.success) {
            context.read<PatientPaginationBloc>().add(PatientRefresh());
            _showSuccessDialog(lastPatientAdded);
          }
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Card.outlined(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    enterNewPatientText,
                    style: Theme.of(context).textTheme.bodyLarge
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                        labelText: patientFirstNameText,
                        border: const UnderlineInputBorder(),
                        fillColor: Theme.of(context).colorScheme.surface,
                        filled: true),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                        labelText: patientLastNameText,
                        border: const UnderlineInputBorder(),
                        fillColor: Theme.of(context).colorScheme.surface,
                        filled: true),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isButtonEnabled ? _addNewPatient : null,
                    child: const Text(addNewPatientText),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _addNewPatient() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      lastPatientAdded = "$firstName $lastName";
      context.read<PatientBloc>()
          .add(AddPatient(firstName: firstName, lastName: lastName));

      // Clear the text fields after adding the patient
      _firstNameController.clear();
      _lastNameController.clear();
      // Close the keyboard
      FocusScope.of(context).unfocus();
    } else {
      // display error message if any fields are somehow still empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(patientMissingNames)),
      );
    }
  }

  void _showSuccessDialog(String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(patientAddSuccessMessage),
          content: Text('Patient $name has been registered'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Close the keyboard
                FocusScope.of(context).unfocus();
              },
              child: const Text(okText),
            ),
          ],
        );
      },
    );
  }
}
