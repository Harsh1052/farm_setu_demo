import 'package:equatable/equatable.dart';

import '../../domain/entities/climate.dart';

abstract class ClimateChartState extends Equatable {

  @override
  List<Object> get props => [];
}

class ClimateLoading extends ClimateChartState {}

class ClimateLoaded extends ClimateChartState {
  final List<ClimateData> climateData;

  ClimateLoaded(this.climateData);

  @override
  List<Object> get props => [climateData];
}

class ClimateError extends ClimateChartState {
  final String message;

  ClimateError(this.message);

  @override
  List<Object> get props => [message];
}