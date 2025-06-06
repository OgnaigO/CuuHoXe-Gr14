import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart'; // Import LatLng từ latlong2
import 'package:provider/provider.dart';
import 'package:flutter_application_1/helper/util.dart';
import 'package:flutter_application_1/models/garage.dart';
import 'package:flutter_application_1/providers/garage_provider.dart';
import 'package:flutter_application_1/screens/place/repair_place/repair_place/components/location_filter_form.dart';

import '/components/custom_surfix_icon.dart';
import '/components/default_button.dart';
import '/config/size_config.dart';
import 'location_input.dart';

class RepairPlaceForm extends StatefulWidget {
  Garage? garage;

  RepairPlaceForm({Key? key, this.garage}) : super(key: key);

  @override
  _RepairPlaceFormState createState() => _RepairPlaceFormState();
}

class _RepairPlaceFormState extends State<RepairPlaceForm> {
  Garage _garage = Garage(); 
  final _formKey = GlobalKey<FormState>();
  final _provinceDistrictWardController = TextEditingController();

  @override
  void initState() {
    _garage = widget.garage ?? Garage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String modeStr = _garage.id == null ? "Thêm mới" : "Cập nhật";

    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildProvinceDistrictWardSelectDialog(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLocationInput(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildDescriptionFormField(),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: modeStr,
            press: () => _saveForm(),
          ),
        ],
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      initialValue: _garage.name,
      onSaved: (newValue) => _garage.name = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter your name";
        }
        if (value.length < 2 || value.length > 64) {
          return "Size must be between 2 and 64";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Name",
        hintText: "Enter your name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildPhoneFormField() {
    return TextFormField(
      initialValue: _garage.phone,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => _garage.phone = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter your phone";
        }
        if (value.length < 10) {
          return "Size must be greater than 10";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Phone",
        hintText: "Enter your phone",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      initialValue: _garage.address,
      onSaved: (newValue) => _garage.address = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter your address";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Address",
        hintText: "Enter your address",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildProvinceDistrictWardSelectDialog() {
    String initialValue = "";
    if (_garage.province?.name != null &&
        _garage.district?.name != null &&
        _garage.ward?.name != null) {
      initialValue = _garage.province!.name! +
          " / " +
          _garage.district!.name! +
          " / " +
          _garage.ward!.name!;

      _provinceDistrictWardController.text = initialValue;
    }

    return TextFormField(
      controller: _provinceDistrictWardController,
      onTap: () => _showMyDialog(),
      readOnly: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Select your Location";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Tỉnh / Huyện / Xã",
        hintText: "-- Select your location --",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: EdgeInsets.fromLTRB(
            0,
            getProportionateScreenWidth(20),
            getProportionateScreenWidth(20),
            getProportionateScreenWidth(20),
          ),
          child: const Icon(Icons.arrow_drop_down),
        ),
      ),
    );
  }

  TextFormField buildDescriptionFormField() {
    return TextFormField(
      initialValue: _garage.description,
      keyboardType: TextInputType.multiline,
      minLines: 2,
      maxLines: 5,
      onSaved: (newValue) => _garage.description = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter description";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Description",
        hintText: "Enter your description",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Chat bubble Icon.svg"),
      ),
    );
  }

  Widget buildLocationInput() {
    return LocationInput(
      onSelectPlace: (latLngSelected) {
        _garage.latitude = latLngSelected.latitude;
        _garage.longitude = latLngSelected.longitude;
      },
      latLngInitial: _garage.latitude != null
          ? LatLng(_garage.latitude!, _garage.longitude!)
          : null,
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Location Select',
            textAlign: TextAlign.center,
          ),
          titleTextStyle: const TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: LocationFilterForm(
            onSubmit: (provinceSelected, districtSelected, wardSelected) {
              _garage.province = provinceSelected;
              _garage.district = districtSelected;
              _garage.ward = wardSelected;
              _provinceDistrictWardController.text = provinceSelected.name! +
                  " / " +
                  districtSelected.name! +
                  " / " +
                  wardSelected.name!;
            },
          ),
        );
      },
    );
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_garage.province == null ||
        _garage.district == null ||
        _garage.ward == null) {
      await Util.showDialogNotification(
          context: context,
          title: "Thiếu thông tin",
          content: "Vui lòng cập nhật Tỉnh/Huyện/Xã");

      return;
    }

    if (_garage.latitude == null || _garage.longitude == null) {
      await Util.showDialogNotification(
          context: context,
          title: "Thiếu thông tin",
          content: "Vui lòng cập nhật vị trí bản đồ");

      return;
    }

    _formKey.currentState!.save();

    try {
      if (_garage.id == null) {
        await Provider.of<GarageProvider>(context, listen: false)
            .create(_garage);
      } else {
        await Provider.of<GarageProvider>(context, listen: false)
            .update(_garage);
      }

      Navigator.of(context).pop();
    } catch (error) {
      await Util.showDialogNotification(
          context: context, content: error.toString());
    }
  }
}
