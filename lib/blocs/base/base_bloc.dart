import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inri_driver/models/base.dart';
import 'package:inri_driver/models/bases_conductor.dart';
import 'package:inri_driver/service/base_service.dart';

part 'base_event.dart';
part 'base_state.dart';

class BaseBloc extends Bloc<BaseEvent, BaseState> {


  BaseBloc() : super(const BaseState(baseSelected: null)) {

     on<AddBaseEvent>((event, emit) {
      emit(state.copyWith( baseSelected: event.baseSelected));      
    });

    on<SetBasesDisponiblesEvent>((event, emit) {
      emit(state.copyWith(basesDisponibles: event.basesDisponibles));
    });

    on<ClearBaseEvent>((event, emit) {
  emit(const BaseState(baseSelected: null, basesDisponibles: []));
});

  }

  void addBase(BaseModel data) async {
    
    final obj = BaseModel(zona: data.zona, base: data.base);
  
    add(AddBaseEvent(obj));

    final base = state.baseSelected;
    final result = base.toString();
    // ignore: avoid_print
    print("STATE base bloc: $result");

  }

  void setBasesDisponibles(List<BaseConductor> bases) {
    add(SetBasesDisponiblesEvent(bases));
  }

  void getAllBasesAndSaveInBloc(BaseBloc baseBloc) async {
  try {
    final baseService = BaseService();
    final bases = await baseService.getBases();
    baseBloc.setBasesDisponibles(bases);

  } catch (e) {
   return;
  }
}
}
