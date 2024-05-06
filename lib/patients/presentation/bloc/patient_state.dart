part of 'patient_pagination_bloc.dart';

enum PatientStatus { initial, success, failure }

abstract class PatientState extends Equatable {
  const PatientState({this.status = PatientStatus.initial});

  final PatientStatus status;

  @override
  List<Object?> get props => [status];
}

class PatientListState extends PatientState {
  const PatientListState({
    this.patients = const <Patient>[],
    this.hasReachedMax = false,
    required super.status
  }) : super();

  final List<Patient> patients;
  final bool hasReachedMax;

  PatientListState copyWith({
    List<Patient>? patients,
    bool? hasReachedMax,
    PatientStatus? status,
  }) {
    return PatientListState(
      patients: patients ?? this.patients,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return '''PatientListState { status: $status, hasReachedMax: $hasReachedMax, patients: ${patients.length} }''';
  }

  @override
  List<Object> get props => [status, patients, hasReachedMax];
}

class PatientUpdateState extends PatientState {
  const PatientUpdateState({
    this.patient,
    required super.status,
  });

  final Patient? patient;

  PatientUpdateState copyWith({
    Patient? patient,
    PatientStatus? status,
  }) {
    return PatientUpdateState(
      patient: patient ?? this.patient,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return '''PatientUpdateState { status: $status, patient: $patient }''';
  }

  @override
  List<Object?> get props => [status, patient];
}