import 'package:flutter_bloc/flutter_bloc.dart';

part 'accepted_jobs_state.dart';

class AcceptedJobsCubit extends Cubit<AcceptedJobsState> {
  AcceptedJobsCubit() : super(AcceptedJobsInitial());

  void workRequestAccepted(String acceptedApplicantId) {
    emit(RequestAccepted(acceptedApplicantId));
  }
}
