import 'package:equatable/equatable.dart';

abstract class ClimateChartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchClimateData extends ClimateChartEvent {
  final String countryURL;
  final bool isTableData;

  FetchClimateData(this.countryURL,this.isTableData);

  @override
  List<Object> get props => [countryURL,isTableData];
}


