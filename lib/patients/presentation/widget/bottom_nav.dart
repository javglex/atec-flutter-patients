
import 'package:flutter/material.dart';
import 'package:flutter_alphatec_javier/patients/presentation/views/patient_add/add_patient_page.dart';
import 'package:flutter_alphatec_javier/patients/presentation/views/patient_list/patient_list_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/patient_repository.dart';
import '../bloc/patient_bloc.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigation();
}

class _BottomNavigation extends State<BottomNavigation> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const AddPatientWidget();
        break;
      case 1:
        page = const PatientListPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      bottomNavigationBar:NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.add), label: 'Add Patient',
          ),
          NavigationDestination(
              icon: Icon(Icons.list), label: "Patient List"
          ),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
      body: BlocProvider(
        create: (_) => PatientBloc(
            patientRepo: RepositoryProvider.of<PatientRepository>(context)
        )..add(PatientFetched()), // fetch patients when this bloc is first created
        child: Row(
          children: [
            Expanded(
              child: SafeArea(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ),
          ],
        ),
      ),


    );
  }
}