import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../data/patient_repository.dart';
import '../../domain/model/patient.dart';

part 'patient_event.dart';
part 'patient_state.dart';


// debounce requests so that we don't spam our API too much
const throttleDuration = Duration(milliseconds: 500);
const initialPageLimit = 50;
const pageLimit = 25;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}


/// Bloc pertaining to our patient data.
/// Acts as a middleman between our data and presentation layers (similar to MVVM architecture)
/// [PatientEvent] tells bloc when to fetch more patients
/// [PatientState] is emitted on presentation layer. includes patient data
class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientRepository patientRepo;

  PatientBloc({required this.patientRepo}) : super(const PatientState()) {
    on<PatientFetched>(
      _onPatientsFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<AddPatient>(
      _onAddNewPatient
    );
    on<DeletePatient>(
      _onDeletePatient
    );
  }

  Future<void> _onDeletePatient(DeletePatient event, Emitter<PatientState> emit) async {
    try {
      patientRepo.deletePatient(event.id);
    } catch (e) {
      emit(state.copyWith(status: PatientStatus.failure));
    }
  }

  Future<void> _onAddNewPatient(AddPatient event, Emitter<PatientState> emit) async {
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
        patients: List.from([
          patient
        ])..addAll(state.patients)
      ));
    } catch (e) {
      emit(state.copyWith(status: PatientStatus.failure));
    }
  }

  Future<void> _onPatientsFetched(PatientFetched event, Emitter<PatientState> emit) async {
    if (state.hasReachedMax) return;
    try {
      // initial load
      if (state.status == PatientStatus.initial) {
        final patients = await patientRepo.getPatients(initialPageLimit, true);
        return emit(state.copyWith(
          status: PatientStatus.success,
          patients: patients,
          hasReachedMax: false,
        ));
      }
      // load subsequent pages
      final patients = await patientRepo.getPatients(pageLimit, false);
      emit(patients.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
        status: PatientStatus.success,
        patients: List.of(state.patients)..addAll(patients),
        hasReachedMax: false,
      ));
    } catch (e) { // TODO: catch specific expected errors
      log("network error $e");
      emit(state.copyWith(status: PatientStatus.failure));
    }
  }
}