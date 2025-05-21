import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/default_button.dart';
import 'package:flutter_application_1/config/constants.dart';
import 'package:flutter_application_1/config/size_config.dart';
import 'package:flutter_application_1/screens/emergency_rescue/send/send_rescue_confirm/components/partner_pic.dart';
import 'package:flutter_application_1/screens/emergency_rescue/send/send_rescue_confirm/components/send_rescue_confirm_detail.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: double.maxFinite,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Center(
          child: Column(
            children: [
              PartnerPic(),
              SizedBox(height: 40),
              SendRescueConfirmDetail(
                title: "Name",
                content: "Codedy",
              ),
              SizedBox(height: 15),
              SendRescueConfirmDetail(
                title: "Phone",
                content: "0978123456",
              ),
              SizedBox(height: 15),
              SendRescueConfirmDetail(
                title: "Intend time",
                content: "4 minute",
              ),
              SizedBox(height: 50),
              SizedBox(
                width: 150.0,
                height: 60,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    "Confirm",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 150.0,
                height: 60,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
