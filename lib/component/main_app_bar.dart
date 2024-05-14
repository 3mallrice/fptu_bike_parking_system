import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/core/helper/asset_helper.dart';
import 'package:fptu_bike_parking_system/representation/qr_code.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
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
                      child: Image.asset(
                        AssetHelper.imgLogo,
                        fit: BoxFit.fill,
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
                          'PHUC BUI',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(QrCodeScreen.routeName),
                      icon: Icon(
                        Icons.qr_code_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () =>
                    //       // change dark/light here
                    //       Provider.of<ThemeProvider>(context, listen: false)
                    //           .toggleTheme(),
                    //   icon: Icon(
                    //     Icons.brightness_4,
                    //     color: Theme.of(context).colorScheme.primary,
                    //   ),
                    // ),
                    //Customer support
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.headset_mic_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                )
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