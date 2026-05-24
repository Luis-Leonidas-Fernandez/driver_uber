import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:inri_driver/blocs/base/base_bloc.dart';

import 'package:inri_driver/blocs/blocs.dart';
import 'package:inri_driver/controllers/register_user_controllers.dart';

import 'package:inri_driver/pages/create_base.dart';
import 'package:inri_driver/pages/images_acces.dart';
import 'package:inri_driver/pages/notifications_access.dart';
import 'package:inri_driver/pages/privacy_page.dart';
import 'package:inri_driver/pages/register_login/register/register_page.dart';
import 'package:inri_driver/repositories/background_instance.dart';

import 'package:inri_driver/service/addresses_service.dart';
import 'package:inri_driver/service/auth_service.dart';
import 'package:inri_driver/routes/routes.dart';
import 'package:inri_driver/service/tarifario_loader.dart';
import 'package:inri_driver/splash/splash_screen.dart';
import 'package:inri_driver/widgets/loading/shimmer.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:intl/number_symbols_data.dart';

import 'package:intl/number_symbols.dart';
import 'package:inri_driver/config/number_symbol.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:google_fonts/google_fonts.dart';



void main() async {

    WidgetsFlutterBinding.ensureInitialized();

      // 🔒 Importante para probar sin internet:
      //GoogleFonts.config.allowRuntimeFetching = false;

    // Cargar tarifas desde assets
     final tarifas = await TarifarioLoader.cargarDesdeAssets();    


    HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );    

    Intl.defaultLocale = 'es_ARG';

    
    initializeDateFormatting('es_ARG', '');
    
    final enUS = numberFormatSymbols['en_US'] as NumberSymbols;

    numberFormatSymbols['es_ARG'] = enUS.copyWith(
      currencySymbol: r'$',
    );
    
  runApp(

    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TarifarioBloc()..add(InitTarifarioEvent(tarifas))),
        BlocProvider(create: (context) => PrecioDistanciaBloc(tarifas: tarifas) ),
        BlocProvider(create: (context) => BaseBloc() ),
        BlocProvider(create: (context) => CronometroBloc() ),
        BlocProvider(create: (context) => AuthBloc(authService: AuthService(), registerUserController: RegisterUserController())),
        BlocProvider(create: (context) => GpsBloc() ), 
        BlocProvider(create: (context) => NotificationBloc()),
        BlocProvider(create: (context) => ImagesBloc()),
        BlocProvider(create: (context) => AddressBloc(addressService: AddressService(), authBloc: BlocProvider.of<AuthBloc>(context),
        cronometroBloc: BlocProvider.of<CronometroBloc>(context), precioDistanciaBloc: BlocProvider.of<PrecioDistanciaBloc>(context))),
        BlocProvider(create: (context) => LocationBloc(addressBloc: BlocProvider.of<AddressBloc>(context)) ),
        BlocProvider(create: (context) => MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context),
        addressBloc: BlocProvider.of<AddressBloc>(context), backgroundLocationRepository: BackgroundInstance() )),
               
      ],

      child: const MyApp() 
      )
  );
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'driver inri',
      initialRoute: 'splash',
      routes: {  
    
        'login'         : (BuildContext context) => const LoginPage(),
        'privacy'       : (BuildContext context) => const PrivacyPage(),
        'create-base'   : (BuildContext context) => const BuildCreateBasePage(),
        'register'      : (BuildContext context) => const RegisterPage(),
        'shimmer'         : (BuildContext context) => const ShimmerLoadingHome(),
        'home'          : (BuildContext context) => const HomePage(),
        'gps'           : (BuildContext context) => const GpsAccessPage(),
        'loading'       : (BuildContext context) => const LoadingPage(),
        'notification'  : (BuildContext context) => const NotificationsAccessPage(),
        'images'        : (BuildContext context) => const ImageAccessPage(),
        'splash'        : (BuildContext context) => const SplashScreen(), 
                          
      },
    
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        //textTheme: GoogleFonts.robotoTextTheme(),
      ),
    );
  }
}

