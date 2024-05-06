// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';
import 'package:flutter_alphatec_javier/patients/data/db/patient_db.dart';
import 'package:flutter_alphatec_javier/patients/data/patient_repository.dart';
import 'package:flutter_alphatec_javier/patients/domain/model/patient.dart';
import 'package:flutter_alphatec_javier/patients/domain/model/patient_api.dart';
import 'package:flutter_alphatec_javier/patients/domain/model/patient_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockPatientApi extends Mock implements PatientApi {}

class MockPatientDatabaseService extends Mock implements PatientDatabaseService {}

void main() {
  group('PatientRepository', () {
    late PatientRepository repository;
    late MockPatientApi mockPatientApi;
    late MockPatientDatabaseService mockDatabaseService;

    setUp(() {
      mockPatientApi = MockPatientApi();
      mockDatabaseService = MockPatientDatabaseService();
      repository = PatientRepositoryImpl(
        patientApiClient: mockPatientApi,
        databaseService: mockDatabaseService,
      );
    });

    test('getPatients returns combined list from network and local DB', () async {
      final localPatients = [const Patient(id: 1, firstName: 'Javier', lastName: 'Gonzalez', email: '', isUploaded: false)];
      final networkPatients = [const Patient(id: 2, firstName: 'Jane', lastName: 'Doe', email: '', isUploaded: true)];
      when(() => mockDatabaseService.getPatients()).thenAnswer((_) => Future.value(localPatients));
      when(() => mockPatientApi.fetchPatients(any())).thenAnswer((_) => Future.value(networkPatients));

      final patients = await repository.getPatients(2, true);

      // Assert
      expect(patients.length, equals(2));
      expect(patients[0].firstName, equals('Javier'));
      expect(patients[0].id, equals(1));
      expect(patients[1].firstName, equals('Jane'));
      expect(patients[1].id, equals(2));
    });
  });
}