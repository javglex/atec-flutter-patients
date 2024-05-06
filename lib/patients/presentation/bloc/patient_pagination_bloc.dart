import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../domain/model/patient.dart';
import '../../domain/model/patient_repository.dart';

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


/// Bloc pertaining to our patient list data and pagination.
///
/// Acts as a middleman between our data and presentation layers (similar to MVVM architecture)
/// [PatientEvent] tells bloc when to fetch more patients
/// [PatientState] is emitted on presentation layer. includes patient data
class PatientPaginationBloc extends Bloc<PatientEvent, PatientListState> {
  final PatientRepository patientRepo;

  PatientPaginationBloc({required this.patientRepo}) : super(const PatientListState(status: PatientStatus.initial)) {
    on<PatientFetched>(
      _onPatientsFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<PatientRefresh>(
      _onRefreshPatients
    );
  }

  Future<void> _onRefreshPatients(PatientRefresh event, Emitter<PatientListState> emit) async {
    if (event.localOnly) {
      try {
        final patients = await patientRepo.refreshPatients();
        return emit(state.copyWith(
            status: PatientStatus.success,
            patients: patients
        ));
      } catch (e) { // TODO: catch specific expected errors
        log("network error $e");
        emit(state.copyWith(status: PatientStatus.failure));
      }
    }
  }

  Future<void> _onPatientsFetched(PatientFetched event, Emitter<PatientListState> emit) async {
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