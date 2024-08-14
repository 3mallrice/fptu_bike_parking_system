// ignore_for_file: unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/api_response.dart';
import 'package:fptu_bike_parking_system/api/service/bai_be/bai_service.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:fptu_bike_parking_system/core/const/frondend/message.dart';
import 'package:fptu_bike_parking_system/core/const/utilities/util_helper.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';

import '../api/model/bai_model/bai_model.dart';
import '../component/app_bar_component.dart';
import '../component/image_not_found_component.dart';
import '../core/helper/return_login_dialog.dart';

class BaiDetails extends StatefulWidget {
  final String id;
  const BaiDetails({
    super.key,
    required this.id,
  });

  static String routeName = '/bai_details';

  @override
  State<BaiDetails> createState() => _BaiDetailsState();
}

class _BaiDetailsState extends State<BaiDetails> {
  late final vehicleId = widget.id;
  BaiModel? bai;
  final callVehicleApi = CallBikeApi();

  var log = Logger();

  List<VehicleTypeModel> _vehicleType = [];

  bool isEdit = false;

  Future<void> fetchBaiDetail(String id) async {
    try {
      APIResponse<BaiModel> response =
          await callVehicleApi.getCustomerBaiById(id);

      if (response.isTokenValid == false &&
          response.message == ErrorMessage.tokenInvalid) {
        log.e('Token is invalid');
        if (!mounted) return;
        ReturnLoginDialog.returnLogin(context);
        return;
      }

      if (response.data != null) {
        setState(() {
          bai = response.data!;
        });
      } else {
        log.e('Failed to fetch Bai details: ${response.message}');
      }
    } catch (e) {
      log.e('Error during fetch Bai details: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBaiDetail(vehicleId);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleTextStyle =
        Theme.of(context).textTheme.displayLarge!.copyWith(
              color: Theme.of(context).colorScheme.outline,
              fontSize: 28,
            );

    TextStyle contentTextStyle =
        Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.outline,
            );

    if (bai == null) {
      return const Scaffold(
        appBar: AppBarCom(
          leading: true,
        ),
        body: Center(
          child:
              CircularProgressIndicator(), // Show a loading indicator while fetching data
        ),
      );
    }

    return Scaffold(
      appBar: const AppBarCom(
        leading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            (bai?.plateImage == null)
                ? const ImageNotFound()
                : CachedNetworkImage(
                    width: double.infinity,
                    imageUrl: bai!.plateImage,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.background,
                      highlightColor:
                          Theme.of(context).colorScheme.outlineVariant,
                      child: Container(color: Colors.grey),
                    ),
                    errorWidget: (context, url, error) => const ImageNotFound(),
                  ),
            const SizedBox(height: 30),
            ShadowContainer(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    UltilHelper.formatPlateNumber(bai!.plateNumber),
                    style: titleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Created at:',
                        style: contentTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        UltilHelper.formatDateMMMddyyyy(bai!.createDate),
                        style: contentTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vehicle type:',
                        style: contentTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        bai!.vehicleType,
                        style: contentTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status:',
                        style: contentTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        bai!.status,
                        style: (bai!.status == 'ACTIVE')
                            ? contentTextStyle.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : (bai!.status == 'PENDING')
                                ? contentTextStyle.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  )
                                : (bai!.status == 'REJECTED')
                                    ? contentTextStyle.copyWith(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      )
                                    : (bai!.status == 'INACTIVE')
                                        ? contentTextStyle.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline)
                                        : contentTextStyle, // Default style if none of the conditions are met
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSecondary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: bai!.status == 'PENDING' ||
                            bai!.status == 'REJECTED',
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isEdit = !isEdit;
                              log.d('Edit status: $isEdit');
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSecondary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.edit_document,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Visibility(
              visible: isEdit,
              child: ShadowContainer(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Plate number',
                      style: contentTextStyle,
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter plate number',
                        hintStyle: contentTextStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          gapPadding: 2.0,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSecondary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: Theme.of(context).colorScheme.onSecondary,
                        hoverColor: Theme.of(context).colorScheme.primary,
                        focusColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSecondary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      hint: Text('Select option', style: contentTextStyle),
                      items: [
                        DropdownMenuItem(
                            value: 'Option 1', child: Text('Option 1')),
                        DropdownMenuItem(
                            value: 'Option 2', child: Text('Option 2')),
                        DropdownMenuItem(
                            value: 'Option 3', child: Text('Option 3')),
                      ],
                      onChanged: (value) {
                        print('Selected: $value');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
