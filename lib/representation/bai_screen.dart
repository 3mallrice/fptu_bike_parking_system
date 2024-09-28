import 'package:bai_system/api/model/bai_model/api_response.dart';
import 'package:bai_system/api/model/bai_model/login_model.dart';
import 'package:bai_system/component/empty_box.dart';
import 'package:bai_system/component/response_handler.dart';
import 'package:bai_system/representation/bai_details.dart';
import 'package:bai_system/representation/support.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:shimmer/shimmer.dart';

import '../api/model/bai_model/bai_model.dart';
import '../api/service/bai_be/bai_service.dart';
import '../component/dialog.dart';
import '../component/image_not_found_component.dart';
import '../component/loading_component.dart';
import '../component/shadow_container.dart';
import '../core/const/frontend/message.dart';
import '../core/const/utilities/util_helper.dart';
import '../core/helper/asset_helper.dart';
import '../core/helper/local_storage_helper.dart';
import '../representation/add_bai_screen.dart';

class BaiScreen extends StatefulWidget {
  const BaiScreen({super.key});

  static String routeName = '/bais_screen';

  @override
  State<BaiScreen> createState() => _BaiScreenState();
}

class _BaiScreenState extends State<BaiScreen> with ApiResponseHandler {
  late final _currentEmail = LocalStorageHelper.getCurrentUserEmail() ?? "";
  late final _currentCustomerType = LocalStorageHelper.getValue(
      LocalStorageKey.currentCustomerType, _currentEmail);

  var log = Logger();
  CallBikeApi api = CallBikeApi();
  bool isCalling = true;
  List<BaiModel>? bikes;

  @override
  void initState() {
    super.initState();
    _fetchBikes();
  }

  Future<void> _fetchBikes() async {
    try {
      final APIResponse<List<BaiModel>> fetchedBikes = await api.getBai();

      if (!mounted) return;

      final bool isResponseValid = await handleApiResponseBool(
        context: context,
        response: fetchedBikes,
        showErrorDialog: _showErrorDialog,
      );

      if (!isResponseValid) return;

      setState(() {
        bikes = fetchedBikes.data;
        isCalling = false;
      });
    } catch (e) {
      log.e('Error fetching bikes: $e');
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
        onRefresh: _fetchBikes,
        child: Stack(
          children: [
            ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Align(
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
              ],
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
      height: 100,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Total Bai',
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
          if (_currentCustomerType == CustomerType.paid)
            Expanded(
              flex: 1,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
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
        buttonMessage: _currentCustomerType == CustomerType.paid
            ? LabelMessage.add(message: ListName.bai)
            : "Need help?",
        buttonAction: () => _currentCustomerType == CustomerType.paid
            ? Navigator.of(context).pushNamed(AddBai.routeName)
            : Navigator.of(context).pushNamed(SupportScreen.routeName),
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
                arguments: {
                  'baiId': bai.id,
                  'onPopCallback': () =>
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _fetchBikes();
                        });
                      }),
                },
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
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                      child: CachedNetworkImage(
                        width: double.infinity,
                        imageUrl: _currentCustomerType == CustomerType.paid
                            ? bai.plateImage
                            : 'https://img.freepik.com/premium-photo/guinea-pig-riding-toy-train-cartoon-style_714091-95319.jpg?w=900',
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
                    padding: const EdgeInsets.all(10),
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
                    padding: const EdgeInsets.only(bottom: 10, left: 10),
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
                  Container(
                    alignment: Alignment.centerLeft,
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Text(
                      _messageSwitch(bai.status),
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: _getStatusColor(bai.status, context),
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.justify,
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OKDialog(
          title: ErrorMessage.error,
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.justify,
          ),
          onClick: () {
            Navigator.of(context).pop();
            setState(() {
              isCalling = false;
            });
          },
        );
      },
    );
  }

  Color _getStatusColor(String status, BuildContext context) {
    return switch (status) {
      'ACTIVE' => Theme.of(context).colorScheme.primary,
      'PENDING' => Theme.of(context).colorScheme.onError,
      'REJECTED' => Theme.of(context).colorScheme.error,
      _ => Theme.of(context).colorScheme.outline,
    };
  }

  String _messageSwitch(String status) {
    return switch (status) {
      'PENDING' =>
        'To activate your registration, please park your vehicle at our facility for the first time!',
      'REJECTED' => 'Wrong information. Please correct it!',
      'INACTIVE' =>
        'While your vehicle is inactive, it remains usable, but the wallet feature for paying parking fees will be disabled.',
      'ACTIVE' => 'Your vehicle is active and ready for use. Enjoy your ride!',
      _ => 'Unknown status, please contact support!',
    };
  }
}
