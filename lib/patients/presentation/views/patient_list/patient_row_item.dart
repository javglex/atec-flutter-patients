
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/model/patient.dart';
import '../../bloc/patient_bloc.dart';

class PatientRow extends StatelessWidget {
  final Patient patient;

  const PatientRow({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    if (patient.isUploaded) {
      // If the patient is not uploaded, return the non-dismissible row
      return _buildRow(context);
    }

    return Dismissible(
      key: UniqueKey(), // Use a unique key for each Dismissible
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      onDismissed: (direction) {
        context.read<PatientBloc>().add(DeletePatient(id: patient.id));
      },
      child: _buildRow(context),
    );
  }

  Widget _buildRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            child: const Icon(Icons.person),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${patient.firstName} ${patient.lastName}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Icon(
                  patient.isUploaded ? Icons.cloud_done : Icons.cloud_off,
                  color: Theme.of(context).colorScheme.primary,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}