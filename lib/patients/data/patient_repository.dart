
import 'dart:developer';

import '../domain/model/patient.dart';
import 'db/patient_db.dart';
import 'network/patient_api.dart';


class PatientRepository {
  PatientRepository({
    required PatientApi patientApiClient,
    required PatientDatabaseService databaseService,
  })   : _patientApiClient = patientApiClient,
        _databaseService = databaseService;

  final PatientApi _patientApiClient;
  final PatientDatabaseService _databaseService;
  List<Patient> cachedNetworkPatients = [];

  /// Fetches patients list from network and local DB
  /// After fetch, merges both results if they are successful
  /// [pageLimit] and [includeOffline] are used for pagination
  Future<List<Patient>> getPatients(int pageLimit, bool includeOffline) async {
    List<Patient> localPatients = [];
    if (includeOffline) {
      localPatients = await _databaseService.getPatients();
    }
    final networkPatients = await _patientApiClient.fetchPatients(pageLimit);
    cachedNetworkPatients += networkPatients;
    final List<Patient> combinedPatients = [
      ...localPatients.reversed, // newest entry displayed first
      ...networkPatients
    ];

    return combinedPatients;
  }

  Future<List<Patient>> refreshPatients() async {
    List<Patient> localPatients = await _databaseService.getPatients();
    final List<Patient> combinedPatients = [
      ...localPatients.reversed, // newest entry displayed first
      ...cachedNetworkPatients
    ];

    return combinedPatients;
  }

  Future<void> addPatient(String firstName, String lastName) async {
    try {
      _databaseService.addPatient(firstName, lastName);
    } catch (e) {
      log("$e");
    }
    return;
  }

  Future<void> deletePatient(int id) async {
    try {
      _databaseService.deletePatient(id);
    } catch (e) {
      log("$e");
    }
    return;
  }
}