import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bai_system/api/model/bai_model/api_response.dart';
import 'package:bai_system/component/empty_box.dart';
import 'package:bai_system/core/const/utilities/util_helper.dart';
import 'package:bai_system/representation/bai_details.dart';
import 'package:logger/web.dart';
import 'package:shimmer/shimmer.dart';

import '../api/model/bai_model/bai_model.dart';
import '../api/service/bai_be/bai_service.dart';
import '../component/image_not_found_component.dart';
import '../component/loading_component.dart';
import '../component/shadow_container.dart';
import '../core/const/frondend/message.dart';
import '../core/helper/asset_helper.dart';
import '../core/helper/return_login_dialog.dart';
import '../representation/add_bai_screen.dart';

class BaiScreen extends StatefulWidget {
  const BaiScreen({super.key});

  static String routeName = '/bais_screen';

  @override
  State<BaiScreen> createState() => _BaiScreenState();
}

class _BaiScreenState extends State<BaiScreen> {
  var log = Logger();
  CallBikeApi api = CallBikeApi();
  bool isCalling = true;
  List<BaiModel>? bikes;

  @override
  void initState() {
    super.initState();
    fetchBikes();
  }

  Future<void> fetchBikes() async {
    try {
      final APIResponse<List<BaiModel>> fetchedBikes = await api.getBai();

      if (fetchedBikes.isTokenValid == false &&
          fetchedBikes.message == ErrorMessage.tokenInvalid) {
        log.e('Token is invalid');

        if (!mounted) return;
        //show login dialog
        ReturnLoginDialog.returnLogin(context);
        return;
      }

      if (mounted) {
        setState(() {
          bikes = fetchedBikes.data;
          isCalling = false;
        });
      }
    } catch (e) {
      log.e('Error fetching bikes: $e');
      // Xử lý lỗi nếu cần thiết
      if (mounted) {
        setState(() {
          isCalling = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchBikes,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      _buildTotalBikeContainer(context),
                      const SizedBox(height: 30),
                      _buildBikeInformation(context),
                    ],
                  ),
                ),
              ),
            ),
            if (isCalling) const LoadingCircle()
          ],
        ),
      ),
    );
  }

  Widget _buildTotalBikeContainer(BuildContext context) {
    return ShadowContainer(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.1,
      padding: const EdgeInsets.all(0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Total bike',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '${bikes?.length ?? 0}',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AddBai.routeName),
                icon: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBikeInformation(BuildContext context) {
    if (!isCalling && (bikes == null || bikes!.isEmpty)) {
      return EmptyBox(
        message: EmptyBoxMessage.emptyList(label: ListName.bai),
        buttonMessage: LabelMessage.add(message: ListName.bai),
        buttonAction: () => Navigator.of(context).pushNamed(AddBai.routeName),
      );
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: bikes?.length ?? 0,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final bai = bikes![index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                BaiDetails.routeName,
                arguments: bai.id,
              );
            },
            child: ShadowContainer(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: CachedNetworkImage(
                        width: double.infinity,
                        imageUrl: bai.plateImage,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Theme.of(context).colorScheme.background,
                          highlightColor:
                              Theme.of(context).colorScheme.outlineVariant,
                          child: Container(color: Colors.grey),
                        ),
                        errorWidget: (context, url, error) =>
                            const ImageNotFound(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                      bottom: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10),
                        Image.asset(
                          AssetHelper.plateNumber,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          UltilHelper.formatPlateNumber(bai.plateNumber),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 10, left: 10, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          bai.vehicleType,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.circle, size: 4),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5),
                            color: _getStatusColor(bai.status, context),
                          ),
                          child: Text(
                            bai.status,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status, BuildContext context) {
    switch (status) {
      case 'ACTIVE':
        return Theme.of(context).colorScheme.primary;
      case 'INACTIVE':
        return Theme.of(context).colorScheme.outline;
      case 'PENDING':
        return Theme.of(context).colorScheme.onSecondary;
      case 'REJECTED':
        return Theme.of(context).colorScheme.error;
      default:
        return Theme.of(context).colorScheme.outline;
    }
  }
}
