import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/component/empty_box.dart';
import 'package:logger/web.dart';

import '../api/model/bai_model/bai_model.dart';
import '../api/service/bai_be/bai_service.dart';
import '../component/image_not_found_component.dart';
import '../component/loading_component.dart';
import '../component/shadow_container.dart';
import '../core/const/frondend/message.dart';
import '../core/helper/asset_helper.dart';
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
      final List<BaiModel>? fetchedBikes = await api.getBai();
      if (mounted) {
        setState(() {
          bikes = fetchedBikes;
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
      body: Stack(
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
        message: StaticMessage.emptyBaiList,
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
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ShadowContainer(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: FancyShimmerImage(
                        width: double.infinity,
                        imageUrl: bikes![index].plateImage!,
                        boxFit: BoxFit.cover,
                        errorWidget: const ImageNotFound(),
                        shimmerBaseColor:
                            Theme.of(context).colorScheme.background,
                        shimmerHighlightColor:
                            Theme.of(context).colorScheme.outlineVariant,
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
                          bikes![index].plateNumber!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          bikes![index].vehicleType!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.circle, size: 4),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16),
                            color:
                                _getStatusColor(bikes![index].status!, context),
                          ),
                          child: Text(
                            bikes![index].status!,
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
      default:
        return Theme.of(context).colorScheme.outline;
    }
  }
}
