import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/rounded_icon_btn.dart';
import 'package:flutter_application_1/config/constants.dart';
import 'package:flutter_application_1/config/size_config.dart';
import 'package:flutter_application_1/helper/url_launcher_helper.dart';
import 'package:flutter_application_1/helper/util.dart';
import 'package:flutter_application_1/models/user.dart';

class UserDescription extends StatelessWidget {
  const UserDescription({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Center(
          child: Text(
            user.firstName! + " " + user.lastName!,
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 5),
        const Center(
          child: Text(
            "Muốn hỗ trợ bạn",
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(10),
            right: getProportionateScreenWidth(10),
            bottom: getProportionateScreenWidth(10),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.phone),
                title: Text(
                  user.phone!,
                  style: TextStyle(color: kTextColor),
                ),
                trailing: user.phone != null
                    ? RoundedIconBtn(
                        icon: Icons.phone_in_talk,
                        showShadow: true,
                        press: () {
                          try {
                            UrlLauncherHelper.launchURL("tel:" + user.phone!);
                          } catch (e) {
                            Util.showDialogNotification(
                                context: context, content: e.toString());
                          }
                        },
                      )
                    : null,
              ),
              ListTile(
                leading: Icon(Icons.map_outlined),
                title: Text("1.5 Km",
                  style: TextStyle(color: kTextColor),
                ),
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text(
                  "Khoảng 15 phút di chuyển",
                  style: TextStyle(color: kTextColor),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        const Center(
          child: Text(
            "Bạn cần xác nhận để tôi tới giúp bạn.\nSẽ cần một chút thời gian để tôi\ndi chuyển tới vị trí của bạn và hỗ trợ.",
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
