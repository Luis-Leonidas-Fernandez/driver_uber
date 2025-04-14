import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inri_driver/blocs/blocs.dart';
import 'package:inri_driver/pages/home_page.dart';
import 'package:inri_driver/views/map_create_base.dart';


class BuildCreateBasePage extends StatelessWidget {
  const BuildCreateBasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) { 

          final isBaseRegistered = state.usuario?.base?.isNotEmpty == true;
  
          print('[ base registrada :] $isBaseRegistered');
                    
           
           return isBaseRegistered == true
           ? const HomePage()
           : const MapCreateBase(); 
          }
          )
      ),
    );
  }
}

