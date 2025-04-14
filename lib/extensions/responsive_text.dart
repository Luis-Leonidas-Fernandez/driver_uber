import 'package:flutter/material.dart';
import 'package:inri_driver/utils/responsive_text.dart';

extension ResponsiveTextStyle on BuildContext {

  TextStyle get h1 => TextStyle(
    fontSize: ResponsiveText.getSize(this, 32),
    fontWeight:  FontWeight.bold
    );

  TextStyle get h2 => TextStyle(
    fontSize: ResponsiveText.getSize(this, 24),
    fontWeight:  FontWeight.bold
    );  

  TextStyle get bodyLarge => TextStyle(
    fontSize: ResponsiveText.getSize(this, 17),
    color: Colors.white,  
    fontWeight: FontWeight.w600  
    );    

   TextStyle get bodyMedium => TextStyle(
    fontSize: ResponsiveText.getSize(this, 16),    
    ); 

    TextStyle get bodySmall => TextStyle(
    fontSize: ResponsiveText.getSize(this, 14),    
    ); 





}