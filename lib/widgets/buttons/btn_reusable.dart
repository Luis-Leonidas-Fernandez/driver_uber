import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inri_driver/constants/constants.dart';



class ButtonReusable extends StatefulWidget {

  final VoidCallback onPressed;
  final String text;
  const ButtonReusable(
      {super.key, required this.text, required this.onPressed});

  @override
  State<ButtonReusable> createState() => _ButtonReusableState();
}

class _ButtonReusableState extends State<ButtonReusable>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isTap = false;
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return GestureDetector(
            onTap: () {
             
              if (!isAnimating ) {
                setState(() {
                  isTap = true;
                  isAnimating = true;
                });
                controller.forward().whenComplete(() {
                  widget.onPressed();
                  controller.reverse().whenComplete(() {
                    setState(() {
                      isTap = false;
                      isAnimating = false;
                    });
                  });
                });
              }              

            },
            child: Container(
                width: 372,
                height: screenHeight < 362 ? 50 : 59,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
            
                    
                    AppConstants.backgroundbottom,
                    AppConstants.backgroundbottom,
                   const Color.fromARGB(255, 127, 224, 253),
                    
                  ],
                  stops: isTap? [ 0.0, controller.value, 1.0] : [1.0,0.0,0.0],
                  begin: Alignment.centerRight, end: Alignment.centerLeft),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                    width: 300,
                    height: screenHeight < 362 ? 51 : 55,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppConstants.blur.withValues(),
                            width: 2.5),
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(188, 126, 124, 250)
                                  .withValues(),
                              const Color.fromARGB(161, 47, 67, 247)
                                  .withValues(),
                              const Color.fromARGB(161, 47, 67, 247)
                                  .withValues(),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Row(children: [
                      Container(
                        constraints:
                            const BoxConstraints(maxHeight: 54, maxWidth: 95),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8)),
                            gradient: LinearGradient(
                              colors: [
                                AppConstants.blur.withValues(),
                                const Color.fromARGB(188, 126, 124, 250)
                                    .withAlpha(2),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.text,
                            style: GoogleFonts.roboto(
                                fontSize: screenWidth <= 348 ? 16 : 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.7),
                          ),
                        ),
                      ),
                      Container(
                        constraints:
                            const BoxConstraints(maxHeight: 54, maxWidth: 95),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8)),
                            gradient: LinearGradient(
                              colors: [
                                AppConstants.blur.withValues(),
                                const Color.fromARGB(188, 126, 124, 250)
                                    .withAlpha(2),
                              ],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                            )),
                      ),
                    ]))),
          );
        },
      ),
    );
  }
}
