
import 'package:flutter/material.dart';
import 'package:flutter_alphatec_javier/patients/presentation/views/patient_list/patient_row_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../strings.dart';
import '../../bloc/patient_pagination_bloc.dart';
import '../../widget/bottom_loader.dart';

class PatientList extends StatefulWidget {
  const PatientList({super.key});

  @override
  State<PatientList> createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientPaginationBloc, PatientListState>(
      builder: (context, state) {
        switch (state.status) {
          case PatientStatus.failure:
            return Center(
                child: Text(
                    style: Theme.of(context).textTheme.bodyLarge,
                    fetchPatientErrorText
                )
            );
          case PatientStatus.success:
            if (state.patients.isEmpty) {
              return const Center(child: Text(fetchPatientEmptyText));
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.patients.length
                    ? const BottomLoader()
                    : PatientRow(patient: state.patients[index]);
              },
              itemCount: state.hasReachedMax
                  ? state.patients.length
                  : state.patients.length + 1,
              controller: _scrollController,
            );
          case PatientStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  // when we reach end of list, requests more patients from network (pagination)
  void _onScroll() {
    if (_isBottom) context.read<PatientPaginationBloc>().add(PatientFetched());
  }

  // calculate the bottom of our scrollable list
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}