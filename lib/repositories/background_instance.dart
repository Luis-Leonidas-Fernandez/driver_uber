
import 'package:inri_driver/repositories/background_location_repositories.dart';

class BackgroundInstance extends BackgroundLocationRepository{

 @override
  Future<void> startForegroundService()async {
    return;
  }
  @override
  Future<void> stopForegroundService()async {
   return;
  }
}