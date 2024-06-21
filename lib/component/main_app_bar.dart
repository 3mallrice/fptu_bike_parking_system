import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/api/model/bai_model/login_model.dart';
import 'package:fptu_bike_parking_system/core/helper/local_storage_helper.dart';
import 'package:fptu_bike_parking_system/representation/feedback.dart';
import 'package:logger/logger.dart';

import '../core/helper/asset_helper.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    var log = Logger();
    late UserData? userData = UserData.fromJson(
        LocalStorageHelper.getValue(LocalStorageKey.userData));
    log.i('$userData');
    return SafeArea(
      child: AppBar(
        automaticallyImplyLeading: false,
        elevation: 5,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        // shadowColor: Theme.of(context).colorScheme.background,
        flexibleSpace: FractionallySizedBox(
          widthFactor: 0.9,
          child: Container(
            alignment: Alignment.center,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).colorScheme.background,
                      child: userData.avatar == null
                          ? Image.asset(
                              AssetHelper.imgLogo,
                              fit: BoxFit.fill,
                            )
                          : ClipOval(
                              child: Image.network(
                                userData.avatar ?? '',
                                fit: BoxFit.fill,
                              ),
                            ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          userData.name?.toUpperCase() ?? 'Anonymous',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(FeedbackScreen.routeName);
                  },
                  icon: Icon(
                    Icons.headset_mic_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(90);
}
