import 'package:flutter/material.dart';

class PresentationContainer extends StatelessWidget {
  const PresentationContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
  
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) { 
        final isSmallScreen = height <= 670;

        return Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage('assets/background_image.webp'),
                fit: BoxFit.cover,                
                opacity: 0.8
              ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color.fromARGB(255, 156, 156, 156)
                  .withValues(),
                  width: 1.6 
          ),
          gradient: LinearGradient(colors: [
            const Color.fromARGB(188, 126, 124, 250).withValues(),
            const Color.fromARGB(188, 126, 124, 250),
                 
            
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        constraints: BoxConstraints(
          maxWidth: width * 0.95,
          minHeight: isSmallScreen ? 115 : 145),
      
        child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
             const SizedBox(height: 20),
              
              Align(
                alignment: const Alignment(-1.0, 0.0),
                child: Text(
                  "30% UP",
                  style: TextStyle(
                      color: Colors.yellowAccent,
                      letterSpacing: 0.5,
                      fontSize: isSmallScreen ? 20 : 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: const Alignment(-0.5, 0.0),
                child: Text(
                  "Descubre bonificaciones por cantidad de viajes cumplidos",
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0.5,
                      fontSize: isSmallScreen ? 12 : 14,
                      fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
        ),
      );
       },
      
    );
  }
}
