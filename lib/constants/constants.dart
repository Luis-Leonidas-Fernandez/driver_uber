import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
//import 'package:inri_driver/blocs/blocs.dart';



class AppConstants {

  AppConstants._();
  
  static const Color redColor    =  Color.fromARGB(255, 243, 44, 30);
  static const Color yellowColor =  Color.fromARGB(255, 243, 221, 26);
  static const Color greenColor  =  Color.fromARGB(255, 51, 241, 58);
  static const Color blueColor   =  Color.fromARGB(255, 20, 144, 245);

 var myDefaultBackground = HexColor("#1A0E2D");
var myDashboradColor = HexColor("#EDF1F2");
var navBarColor = HexColor("#703dc3");
var firstColor = HexColor("#6528F7");
var binevenidoColor = HexColor("#D7BBF5");
var tableColor = HexColor("#EFE9FE");
var titleColor = HexColor("#A27EFA");
var containerColor = HexColor("#743DF7");
static final containerColors = HexColor("#743DF7");

var violet = const Color.fromARGB(255, 95, 92, 243);

var inputColor = const Color.fromARGB(255, 161, 184, 248);
var obscureColor = HexColor("#2b0057");
var secondColorButton = HexColor("#6562FB");
var ternaryColorButton = HexColor("#000000");




static final cardColor = HexColor("#0B1225");
static final blurCarColor = HexColor("#4E5361");
static final secondColor = HexColor("#5A24DE");
static final backgroundbottom = HexColor("#402788");
static final  textColor = HexColor("##FFFFFF");
static final yellow = HexColor("##BBFF9B");
static final black = HexColor("#000000");
static final blur = HexColor("#497bff");


  static String getFormattedDate() {
    final now = DateTime.now();
    return "${now.day}-${now.month}-${now.year}";
  }

  static String getFormattedTime() {
    final now = DateTime.now();
    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }

 static final backgroundCard = LinearGradient(colors: [

  cardColor,
  cardColor,
 
  
  
],
begin: Alignment.topLeft, end: Alignment.bottomRight
);



static final bottomCard = LinearGradient(colors: [


  blurCarColor,
  cardColor,
  cardColor,

  
  
  
  
],
begin: Alignment.topCenter, end: Alignment.bottomCenter
);



static const gradiente = LinearGradient(colors: [

  Color.fromARGB(255, 93, 146, 196),
  Color.fromARGB(153, 54, 2, 196),//209
  Color.fromARGB(253, 54, 2, 196),
  Color.fromARGB(253, 54, 2, 196)  
  
  
],
begin: Alignment.topLeft, end: Alignment.bottomRight
);


static const cardgradiente = LinearGradient(colors: [

  Color.fromARGB(255, 119, 149, 245),
  Color.fromARGB(255, 119, 149, 245),

  
  
  
],
begin: Alignment.topCenter, end: Alignment.bottomCenter
);

static final  buttongradiente = LinearGradient(colors: [  
  
  
  backgroundbottom,
  backgroundbottom,   
  secondColor, 
  

],
begin: Alignment.topCenter, end: Alignment.bottomCenter
);



  // static AppBar customAppBar(BuildContext context,  AddressBloc addressBloc, AuthBloc usuarioBloc) {    
    
  //   final nombre = usuarioBloc.state.usuario!.nombre;
  //   ResponsiveUtil responsiveUtil = ResponsiveUtil(context);
  //   double responsiveFontSize = responsiveUtil.getResponsiveFontSize(19);

  //   return AppBar(
  //     backgroundColor: cardColor,
  //     elevation: 0,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         bottomLeft: Radius.circular(22),
  //         bottomRight: Radius.circular(22),
  //       ),
  //     ),
  //     title: Center(
  //       child: Text(
  //         'Bienvenido a Inri $nombre',
  //         style: TextStyle(
  //           fontSize: responsiveFontSize,
  //           fontWeight: FontWeight.w100,
  //           fontFamily: 'Satisfy',           
  //           color: Colors.white
  //         ),
  //       ),
  //     ),
  //     leading: Builder(
  //       builder: (BuildContext context) {
  //         return IconButton(
  //           icon: const Icon(
  //             Icons.exit_to_app_rounded,
  //             color: Colors.white,
  //           ),
  //           onPressed: () async {
  //             LogOutApp.instance.finishApp();

  //             // emitir un estado limpio              
  //             addressBloc.add(const OnClearStateEvent());
  //             Navigator.pushReplacementNamed(context, 'login');
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }
}
