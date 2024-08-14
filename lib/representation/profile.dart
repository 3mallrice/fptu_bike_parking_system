import 'package:flutter/material.dart';
import 'package:bai_system/api/model/bai_model/login_model.dart';
import 'package:bai_system/component/app_bar_component.dart';
import 'package:bai_system/component/shadow_container.dart';
import 'package:bai_system/core/helper/local_storage_helper.dart';
import 'package:logger/logger.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static String routeName = '/profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var log = Logger();
  late final UserData? userData;

  @override
  void initState() {
    super.initState();
    userData = GetLocalHelper.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCom(
        leading: true,
        appBarText: 'View Profile',
      ),
      body: SingleChildScrollView(
        child: Align(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  // padding: const EdgeInsets.all(1),
                  height: MediaQuery.of(context).size.width * 0.36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  child: userData == null
                      ? Text(
                          getInitials(userData?.name ?? 'Anonymous User'),
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                fontSize: 64,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.background,
                              ),
                        )
                      : ClipOval(
                          child: Image.network(
                            userData?.avatar ?? '',
                            fit: BoxFit.fill,
                          ),
                        ),
                ),
                const SizedBox(height: 15),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fullname',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                      const SizedBox(height: 5),
                      ShadowContainer(
                        child: Text(
                          userData?.name ?? 'Anonymous',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                      const SizedBox(height: 5),
                      ShadowContainer(
                        child: Text(
                          userData?.email ?? 'anonymous@fpt.edu.vn',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // split name into many parts by space and get the first letter of each part
  String getInitials(String name) {
    List<String> parts = name.split(' ');
    String initials = '';
    for (var part in parts) {
      initials += part[0];
    }
    return initials.toUpperCase();
  }
}
