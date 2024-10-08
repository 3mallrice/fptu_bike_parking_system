import 'package:bai_system/api/model/bai_model/login_model.dart';
import 'package:bai_system/core/helper/local_storage_helper.dart';
import 'package:bai_system/representation/notification_screen.dart';
import 'package:bai_system/representation/settings_profile.dart';
import 'package:bai_system/representation/support.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../core/helper/asset_helper.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    var log = Logger();
    String currentEmail = LocalStorageHelper.getCurrentUserEmail() ?? "";
    late UserData? userData = GetLocalHelper.getUserData(currentEmail);
    log.i('$userData');
    return SafeArea(
      child: AppBar(
        automaticallyImplyLeading: false,
        elevation: 5,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        // shadowColor: Theme.of(context).colorScheme.surface,
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
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(SettingAndProfileScreen.routeName);
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        child: userData == null
                            ? Image.asset(
                                AssetHelper.imgLogo,
                                fit: BoxFit.fill,
                              )
                            : ClipOval(
                                child: Image.network(
                                  userData.avatar,
                                  fit: BoxFit.fill,
                                ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              userData != null
                                  ? userData.name.toUpperCase()
                                  : 'Anonymous',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: userData != null &&
                                        userData.customerType ==
                                            CustomerType.paid
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onError,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                userData != null ? userData.customerType : '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(SupportScreen.routeName);
                      },
                      child: Icon(
                        Icons.headset_mic_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(NotificationScreen.routeName);
                      },
                      child: Icon(
                        Icons.notifications,
                        color: Theme.of(context).colorScheme.primary,
                        size: 25,
                      ),
                    ),
                  ],
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
