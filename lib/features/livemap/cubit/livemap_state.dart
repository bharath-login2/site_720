
part of 'livemap_cubit.dart';

abstract class LiveMapState {}

class LiveMapInitial extends LiveMapState {}

class LiveMapLoading extends LiveMapState {}

class LiveMapLoaded extends LiveMapState {
  final LiveMapModel model;

  LiveMapLoaded(this.model);
}

class LiveMapError extends LiveMapState {
  final String message;

  LiveMapError(this.message);
}