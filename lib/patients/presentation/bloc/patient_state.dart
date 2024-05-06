part of 'patient_bloc.dart';

enum PatientStatus { initial, success, failure }

/// Represents patient data and status
/// PatientBloc will emit this state to the PatientListPage widget after data is fetched.
final class PatientState extends Equatable {
  const PatientState({
    this.status = PatientStatus.initial,
    this.patients = const <Patient>[],
    this.hasReachedMax = false,
  });

  final PatientStatus status;
  final List<Patient> patients;
  final bool hasReachedMax;

  PatientState copyWith({
    PatientStatus? status,
    List<Patient>? patients,
    bool? hasReachedMax,
  }) {
    return PatientState(
      status: status ?? this.status,
      patients: patients ?? this.patients,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PatientListState { status: $status, hasReachedMax: $hasReachedMax, patients: ${patients.length} }''';
  }

  @override
  List<Object> get props => [status, patients, hasReachedMax];
}