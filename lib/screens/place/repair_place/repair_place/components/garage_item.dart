import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_application_1/components/rounded_icon_btn.dart';
import 'package:flutter_application_1/helper/location_helper.dart';
import 'package:flutter_application_1/helper/url_launcher_helper.dart';
import 'package:flutter_application_1/helper/util.dart';
import 'package:flutter_application_1/models/garage.dart';
import 'package:flutter_application_1/screens/place/repair_place/repair_place_details/repair_place_details_screen.dart';

class GarageItem extends StatelessWidget {
  Garage garage;

  GarageItem({
    required this.garage,
    Key? key,
  }) : super(key: key);

  Future<double> _getDistanceInKilometers() async {
    return LocationHelper.getDistanceInKilometers(
      garage.latitude!,
      garage.longitude!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => Navigator.pushNamed(
          context,
          RepairPlaceDetailsScreen.routeName,
          arguments: RepairPlaceDetailsArguments(garage: garage),
        ),
        leading: Hero(
            tag: garage.id.toString(),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              child: garage.garageImages.isNotEmpty
                  ? AspectRatio(
                      aspectRatio: 3 / 2,
                      child: FadeInImage.assetNetwork(
                        placeholder: "assets/images/placeholder_processing.gif",
                        image: garage.garageImages[0].imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Text("No\nImage", textAlign: TextAlign.center),
            )),
        title: Text(
          garage.name!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: FutureBuilder<double>(
          future: _getDistanceInKilometers(),
          builder: (context, snapshot) => Text(
            (snapshot.hasData
                    ? '${snapshot.data!.toStringAsFixed(1)} Km | '
                    : '') +
                garage.phone! +
                '\n' +
                garage.address!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: RoundedIconBtn(
          icon: Icons.directions,
          showShadow: true,
          press: () {
            try {
              UrlLauncherHelper.launchURL(
                  "https://www.google.com/maps/search/?api=1&query=${garage.latitude},${garage.longitude}");
            } catch (e) {
              Util.showDialogNotification(
                  context: context, content: e.toString());
            }
          },
        ),
        isThreeLine: true,
      ),
    );
  }
}
