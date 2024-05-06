import 'package:flutter_alphatec_javier/patients/domain/model/patient.dart';

abstract class PatientRepository {
  Future<List<Patient>> getPatients(int pageLimit, bool includeOffline);
  Future<List<Patient>> refreshPatients();
  Future<void> addPatient(String firstName, String lastName);
  Future<void> deletePatient(int id);
}