
import 'package:bloc/bloc.dart';
import 'package:flutter_alphatec_javier/patients/presentation/bloc/patient_pagination_bloc.dart';

import '../../domain/model/patient.dart';
import '../../domain/model/patient_repository.dart';

/// Bloc for manipulating our patient data.
///
/// [PatientEvent] tells bloc to delete or add a patient
/// [PatientState] is emitted on presentation layer. includes request success or error.
class PatientBloc extends Bloc<PatientEvent, PatientUpdateState> {
  final PatientRepository patientRepo;

  PatientBloc({required this.patientRepo}) : super(const PatientUpdateState(status: PatientStatus.initial)) {
    on<AddPatient>(
      _onAddNewPatient
    );
    on<DeletePatient>(
      _onDeletePatient
    );
  }

  Future<void> _onDeletePatient(DeletePatient event, Emitter<PatientUpdateState> emit) async {
    try {
      patientRepo.deletePatient(event.id);
      emit(state.copyWith(status: PatientStatus.success));
    } catch (e) {
      emit(state.copyWith(status: PatientStatus.failure));
    }
  }

  Future<void> _onAddNewPatient(AddPatient event, Emitter<PatientUpdateState> emit) async {
    try {
      patientRepo.addPatient(event.firstName, event.lastName);
      Patient patient = Patient(
        id: -1,
        firstName: event.firstName,
        lastName: event.lastName,
        email: "", isUploaded: false
      );
      emit(state.copyWith(
        status: PatientStatus.success,
        patient: patient
      ));
    } catch (e) {
      emit(state.copyWith(status: PatientStatus.failure));
    }
  }
}