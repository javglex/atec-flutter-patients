
import 'dart:developer';

import '../domain/model/patient.dart';
import '../domain/model/patient_api.dart';
import '../domain/model/patient_repository.dart';
import 'db/patient_db.dart';

/// Patient repository used to fetch and manipulate patient data
class PatientRepositoryImpl implements PatientRepository {
  PatientRepositoryImpl({
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
  @override
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

  /// Called whenever there is a local database update
  /// Retries latest patients
  @override
  Future<List<Patient>> refreshPatients() async {
    List<Patient> localPatients = await _databaseService.getPatients();
    final List<Patient> combinedPatients = [
      ...localPatients.reversed, // newest entry displayed first
      ...cachedNetworkPatients
    ];

    return combinedPatients;
  }

  /// Adds a new patient to the database (for this demo app only from the database)
  @override
  Future<void> addPatient(String firstName, String lastName) async {
    try {
      _databaseService.addPatient(firstName, lastName);
    } catch (e) {
      log("$e");
    }
    return;
  }

  /// Deletes a patient (for this demo app only from the database)
  @override
  Future<void> deletePatient(int id) async {
    try {
      _databaseService.deletePatient(id);
    } catch (e) {
      log("$e");
    }
    return;
  }
}