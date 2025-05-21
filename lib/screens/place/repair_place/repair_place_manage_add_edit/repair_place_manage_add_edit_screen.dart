import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/size_config.dart';
import 'package:flutter_application_1/models/garage.dart';

import 'components/body.dart';

class RepairPlaceManageAddEditScreen extends StatelessWidget {
  static String routeName = "/repair_place_manage_add_edit";

  const RepairPlaceManageAddEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen:
    SizeConfig().init(context);

    final RepairPlaceManageAddEditArguments? agrs = ModalRoute.of(context)!
        .settings
        .arguments as RepairPlaceManageAddEditArguments?;

    final String modeStr = agrs == null ? "Thêm mới" : "Cập nhật";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          modeStr + " tiệm sửa xe",
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Body(garage: agrs?.garage),
    );
  }
}

class RepairPlaceManageAddEditArguments {
  final Garage garage;

  RepairPlaceManageAddEditArguments({required this.garage});
}
