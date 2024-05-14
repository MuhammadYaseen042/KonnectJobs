part of 'accepted_jobs_cubit.dart';

sealed class AcceptedJobsState {
  AcceptedJobsState({this.acceptedApplicationId});
  String? acceptedApplicationId;
}

final class AcceptedJobsInitial extends AcceptedJobsState {}

final class RequestAccepted extends AcceptedJobsState {
  RequestAccepted(String? acceptedApplicationId)
      : super(acceptedApplicationId: acceptedApplicationId);
}
