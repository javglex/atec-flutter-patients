import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';

import '../../domain/model/patient.dart';

/// Local database for storing serialized [Patient] objects
class PatientDatabaseService {
  Database? _database;

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    _database = await openDatabase(
        // Set the path to the database file.
        join(await getDatabasesPath(), 'patients_database.db'),
        onCreate: (db, version) {
        // Create patient table with first, last and email fields
        // patient ID created automatically on insertion.
        return db.execute(
          'CREATE TABLE patients(id INTEGER PRIMARY KEY AUTOINCREMENT, first TEXT, last TEXT, email TEXT)',
        );
      },
      version: 2,
    );
  }

  /// Adds a new patient to the database. Email is ignored for this demo
  Future<void> addPatient(String name, String lastName) async {

    if (_database == null) {
      await initialize();
    }

    // Insert new patient, replace if it already exists
    await _database?.insert(
      'patients',
      {
        'first': name,
        'last': lastName,
        'email': ""
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Deletes a patient from the database by ID
  Future<void> deletePatient(int id) async {

    if (_database == null) {
      await initialize();
    }
    // Delete the patient from the table using id.
    await _database?.delete(
      'patients',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  /// Retrieves a list of all patients in the database
  Future<List<Patient>> getPatients() async {
    final List<Patient>? patientList;

    try { // Get a reference to the database.
      if (_database == null) {
        await initialize();
      }

      // Query the table for all patients.
      final List<Map<String, dynamic>>? patients = await _database?.query('patients');
      // Map the raw database response to Patient objects
      patientList = patients?.map( (patient) =>
          Patient.fromMap(patient, false)
      ).toList();
    } catch (e) { // TODO: catch expected (more specific) db errors instead
      log(e.toString());
      return [];
    }
    return patientList??[];
  }
}