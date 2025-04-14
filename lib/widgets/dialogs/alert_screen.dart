import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


 mostrarAlerta( BuildContext context, String titulo, String subtitulo ) {

  if ( Platform.isAndroid ) {
    return showDialog(
      context: context,
      builder: ( dialogContext) => AlertDialog(
        title: Text( titulo ),
        content: Text( subtitulo ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5,
            textColor: Colors.blue,
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Ok')
          )
        ],
      )
    );
  }

  showCupertinoDialog(
    context: context, 
    builder: ( _ ) => CupertinoAlertDialog(
      title: Text( titulo ),
      content: Text( subtitulo ),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    )
  );

}