import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/coustom_bottom_nav_bar.dart';
import 'package:flutter_application_1/config/enums.dart';

import 'components/body.dart';

class SendRescueReviewsScreen extends StatelessWidget {
  static String routeName = "/send_emergency_rescue/reviews";

  const SendRescueReviewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Emergency rescue reviews"),
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
