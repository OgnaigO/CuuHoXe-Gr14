import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/coustom_bottom_nav_bar.dart';
import 'package:flutter_application_1/config/enums.dart';
import 'package:flutter_application_1/screens/my_account/edit_my_account/edit_my_account_screen.dart';

import 'components/body.dart';

class MyAccountScreen extends StatelessWidget {
  static String routeName = "/my_account";

  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, EditMyAccount.routeName),
            icon: Icon(Icons.edit),
            tooltip: "Edit my account",
          ),
        ],
      ),
      body: Body(),
    );
  }
}
