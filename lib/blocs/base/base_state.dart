part of 'base_bloc.dart';

class BaseState extends Equatable {  


final BaseModel? baseSelected;
final List<BaseConductor>? basesDisponibles;

const BaseState({
   
  this.baseSelected,
  this.basesDisponibles

});

BaseState copyWith({
    
  BaseModel? baseSelected,
  List<BaseConductor>? basesDisponibles,
 
})
=> BaseState(
  
  baseSelected: baseSelected?? this.baseSelected,
  basesDisponibles: basesDisponibles?? this.basesDisponibles

);

  
  @override
  List<Object?> get props => [baseSelected, basesDisponibles];
}


class BaseInitialState extends BaseState {
  const BaseInitialState(): super( baseSelected: null);
}