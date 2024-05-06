part of 'patient_pagination_bloc.dart';


sealed class PatientEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Event which tells [PatientPaginationBloc] to fetch more patients
///
/// Triggered by user scrolling through list of patients
/// [localOnly] used to refresh items from DB
final class PatientFetched extends PatientEvent {
  final bool localOnly;
  PatientFetched({this.localOnly = false});
}

/// Event which tells [PatientPaginationBloc] to refresh patients
///
/// Used to refresh the list when user adds or removes patients
final class PatientRefresh extends PatientEvent {
  final bool localOnly;
  PatientRefresh({this.localOnly = true});
}


/// Event which tells [PatientBloc] to add a new patient
final class AddPatient extends PatientEvent {
  final String firstName;
  final String lastName;

  AddPatient({ required this.firstName, required this.lastName});
}

/// Event which tells [PatientBloc] to remove a new patient by id
final class DeletePatient extends PatientEvent {
  final int id;
  DeletePatient({required this.id});
}