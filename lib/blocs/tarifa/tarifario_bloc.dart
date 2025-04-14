import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inri_driver/models/tarifa.dart';

part 'tarifario_event.dart';
part 'tarifario_state.dart';

class TarifarioBloc extends Bloc<TarifarioEvent, TarifarioState> {
  TarifarioBloc() : super(const TarifarioInitial()) {
    on<InitTarifarioEvent>((event, emit) {      
      emit(TarifarioLoaded(event.tarifas));
    });
  }
}
