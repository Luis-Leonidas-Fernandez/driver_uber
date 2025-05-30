

import 'dart:async';
import 'dart:isolate';


class IsolateMain {

    IsolateMain._internal();
    static final IsolateMain _instance = IsolateMain._internal();
    static IsolateMain get instance => _instance;

    Isolate? _isolate;
    final receivePort = ReceivePort();
    late StreamSubscription subscriptionIsolate;
    

    static void isolatePosition( SendPort sendPort) async {   
  
      Timer.periodic(const Duration(seconds: 1), (_) {
 
      sendPort.send(DateTime.now().toString());

     });
   
    }   
  

    void initIsolatePosition() async {

    try {

         _isolate?.kill();
         _isolate = await Isolate.spawn<SendPort>(isolatePosition,receivePort.sendPort);
     

    } on IsolateSpawnException {
      // Intentionally ignored
    }      
   
                            
        subscriptionIsolate = receivePort.listen((message) { 
        
   });


  }

  
  
  void finishIsolate(){
    subscriptionIsolate.cancel();
    _isolate?.kill();


  }

  
  
  

}

 