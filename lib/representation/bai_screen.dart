import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/api_response.dart';
import 'package:fptu_bike_parking_system/component/dialog.dart';
import 'package:fptu_bike_parking_system/component/empty_box.dart';
import 'package:fptu_bike_parking_system/core/const/utilities/util_helper.dart';
import 'package:logger/web.dart';
import 'package:shimmer/shimmer.dart';

import '../api/model/bai_model/bai_model.dart';
import '../api/service/bai_be/bai_service.dart';
import '../component/image_not_found_component.dart';
import '../component/loading_component.dart';
import '../component/shadow_container.dart';
import '../component/snackbar.dart';
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
  CallBikeApi callBaiApi = CallBikeApi();
  bool isCalling = true;
  bool isDeleting = false;
  List<BaiModel>? bikes;

  @override
  void initState() {
    super.initState();
    fetchBikes();
  }

  Future<void> fetchBikes() async {
    try {
      final APIResponse<List<BaiModel>> fetchedBikes =
          await callBaiApi.getBai();

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
          return Dismissible(
            confirmDismiss: confirmDismiss(context, bai.status, bai.id),
            onDismissed: (direction) async {
              log.i('Item dismissed: ${bai.id}');
              bikes!.removeAt(index);
            },
            behavior: HitTestBehavior.deferToChild,
            direction: DismissDirection.startToEnd,
            background: dismissiableBackground(context),
            key: ValueKey<String>(bai.id),
            child: Padding(
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
                            bikes![index].plateNumber,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            UltilHelper.formatDateMMMddyyyy(
                                bikes![index].createDate),
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: 11,
                                    ),
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
                            bikes![index].vehicleType,
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
                              color: _getStatusColor(
                                  bikes![index].status, context),
                            ),
                            child: Text(
                              bikes![index].status,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Show dialog when user dismisses an item
  Future<bool?> Function(DismissDirection)? confirmDismiss(
      BuildContext context, String status, String id) {
    return (DismissDirection direction) async {
      bool isPermission = false;
      if (status == 'PENDING') {
        isPermission = true;
      }
      if (!isPermission) {
        return showDialog<bool>(
          context: context,
          builder: (context) {
            return OKDialog(
              title: Message.permissionDeny,
              content: Text(
                Message.permissionDenyMessage(message: ListName.bai),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onClick: () => Navigator.of(context).pop(false),
            );
          },
        );
      }

      // Show confirmation dialog
      bool? result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return ConfirmDialog(
            title: Message.confirmTitle,
            content: Text(
              Message.deleteConfirmation(message: ListName.bai),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onConfirm: () async {
              bool isDeleted = await onDismissed(id);
              if (mounted) {
                pop(isDeleted);
              }
              return isDeleted;
            },
            onCancel: () => Navigator.of(context).pop(false),
          );
        },
      );

      // Fetch bikes if needed
      if (result == true) {
        fetchBikes();
      }

      return result;
    };
  }

  // return true if the item is removed successfully
  void pop(bool isDeleted) => Navigator.of(context).pop(isDeleted);

  // Remove the item from the data source
  Future<bool> onDismissed(String id) async {
    try {
      setState(() {
        isDeleting = true;
      });
      APIResponse<int> response = await callBaiApi.deleteBai(id);
      log.i('Response: ${response.message}');

      if (response.isTokenValid == false &&
          response.message == ErrorMessage.tokenInvalid) {
        log.e('Token is invalid');

        if (!mounted) return false;
        //show login dialog
        ReturnLoginDialog.returnLogin(context);
        return false;
      }

      setState(() {
        isDeleting = false;
      });

      switch (response.data) {
        case 200:
          showSnackBar(true);

          return true;

        case 404:
          showSnackBar(false,
              failMessage: ErrorMessage.notFound(message: ListName.bai));
          return false;

        default:
          showSnackBar(false,
              failMessage: Message.deleteUnSuccess(message: ListName.bai));
          return false;
      }
    } catch (e) {
      log.e('Error removing item: $e');
      setState(() {
        isDeleting = false;
      });
      showSnackBar(false);
      return false;
    }
  }

  void showSnackBar(bool isDeleted, {String? failMessage}) {
    showCustomSnackBar(
      MySnackBar(
        prefix: Icon(
          Icons.cancel_rounded,
          color: Theme.of(context).colorScheme.surface,
        ),
        message: isDeleted
            ? Message.deleteSuccess(message: ListName.bai)
            : failMessage,
        backgroundColor: isDeleted
            ? Theme.of(context).colorScheme.onError
            : Theme.of(context).colorScheme.error,
      ),
    );
  }

  // show custom snackbar
  void showCustomSnackBar(MySnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: snackBar,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
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

  Widget dismissiableBackground(BuildContext context) {
    return (isDeleting)
        ? Container(
            padding: const EdgeInsets.only(left: 25),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              color: Theme.of(context).colorScheme.surface,
            ),
            alignment: Alignment.centerLeft,
            child: const LoadingCircle(size: 60),
          )
        : Container(
            padding: const EdgeInsets.only(left: 25),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              color: Theme.of(context).colorScheme.outline,
            ),
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete_rounded,
              color: Theme.of(context).colorScheme.surface,
              size: 45,
            ),
          );
  }
}
