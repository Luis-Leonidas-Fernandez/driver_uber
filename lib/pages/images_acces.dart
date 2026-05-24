import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inri_driver/blocs/blocs.dart';
import 'package:inri_driver/pages/create_base.dart';


class ImageAccessPage extends StatelessWidget {
  const ImageAccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<ImagesBloc, ImagesState>(
          builder: (context, state) { 

            final notificationEnabled = state.isImagePermissionGranted;            

    
           return notificationEnabled == true
           ? const BuildCreateBasePage()
           : const _AccessImagesButton(); 
          }
          )
      ),
    );
  }
}

class _AccessImagesButton extends StatelessWidget {
  const _AccessImagesButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Text('Habilitar acceso a las Imagenes'),
       MaterialButton(
        color: Colors.black,
        shape: const StadiumBorder(),
        elevation: 0,
        onPressed: (){
          //solicita privilegios de nontificacion
          final imageBloc = BlocProvider.of<ImagesBloc>(context);
           
          imageBloc.requestImagePermission();
          
        },
        child:  const Text('Solicitar Acceso',
        style:  TextStyle(color: Colors.white ))
        )
      ],
    );
  }
}
