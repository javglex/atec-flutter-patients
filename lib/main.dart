import 'package:flutter/material.dart';
import 'package:flutter_alphatec_javier/patients/data/db/patient_db.dart';
import 'package:flutter_alphatec_javier/patients/data/network/patient_api.dart';
import 'package:flutter_alphatec_javier/patients/data/patient_repository.dart';
import 'package:flutter_alphatec_javier/patients/presentation/widget/bottom_nav.dart';
import 'package:flutter_alphatec_javier/simple_bloc_observer.dart';
import 'package:flutter_alphatec_javier/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;


void main() {
  Bloc.observer = const SimpleBlocObserver();
  // not using a DI library. Create our own dependencies
  final patientDatabaseService = PatientDatabaseService();
  final patientApi = PatientApi(httpClient: http.Client());

  runApp(
      MyApp(
          patientDatabaseService: patientDatabaseService,
          patientApi: patientApi
      )
  );
}

class MyApp extends StatefulWidget {
  final PatientDatabaseService patientDatabaseService;
  final PatientApi patientApi;

  const MyApp({
    super.key,
    required this.patientDatabaseService,
    required this.patientApi
  });

  @override
  State<MyApp> createState() => _AppState(
      patientDatabaseService: patientDatabaseService,
      patientApi: patientApi
  );
}

class _AppState extends State<MyApp> {
  final PatientDatabaseService patientDatabaseService;
  final PatientApi patientApi;
  late final PatientRepository _patientRepository;

  _AppState({
    required this.patientDatabaseService,
    required this.patientApi,
  });

  @override
  void initState() {
    super.initState();
    patientDatabaseService.initialize();
    _patientRepository = PatientRepository(
        patientApiClient: patientApi,
        databaseService: patientDatabaseService
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _patientRepository,
      child: MaterialApp(
        title: appTitle,
        home: const BottomNavigation(),
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey)
        ),
      ),
    );
  }
}