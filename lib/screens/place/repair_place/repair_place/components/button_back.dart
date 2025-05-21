import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/config/constants.dart';
import 'package:flutter_application_1/config/size_config.dart';

class ButtonBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.30),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SizedBox(
        height: getProportionateScreenWidth(40),
        width: getProportionateScreenWidth(40),
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: kPrimaryColor, shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
            backgroundColor: Colors.white.withOpacity(0.9),
            padding: EdgeInsets.zero,
          ),
          onPressed: () => Navigator.pop(context),
          child: SvgPicture.asset(
            "assets/icons/Back ICon.svg",
            height: 15,
          ),
        ),
      ),
    );
  }
}
