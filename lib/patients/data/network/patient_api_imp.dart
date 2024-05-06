
import 'dart:convert';
import 'package:flutter_alphatec_javier/patients/domain/model/patient_api.dart';
import 'package:http/http.dart';

import '../../domain/model/patient.dart';

class PatientApiImpl implements PatientApi {
  final Client httpClient;

  PatientApiImpl({required this.httpClient});

  @override
  Future<List<Patient>> fetchPatients(int pageLimit) async {
    final response = await httpClient.get(
      Uri.https(
        'randomapi.com',
        '/api/6de6abfedb24f889e0b5f675edc50deb',
        <String, String>{'fmt': 'raw'},
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> outerList = json.decode(response.body) as List<dynamic>;
      if (outerList.isNotEmpty) {
        final List<dynamic> innerList = outerList.first as List<dynamic>;
        return innerList.take(pageLimit).map((dynamic item) {
          if (item is Map<String, dynamic>) {
            // passing -1 for ID since we don't currently get that from api response
            return Patient.fromMap(item, true);
          } else {
            throw Exception('Invalid item format');
          }
        }).toList();
      } else {
        throw Exception('Empty outer list');
      }
    }
    throw Exception('Error fetching posts');
  }
}