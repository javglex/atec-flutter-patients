
import 'package:flutter_alphatec_javier/patients/domain/model/patient.dart';

abstract class PatientApi {
  Future<List<Patient>> fetchPatients(int pageLimit);
}