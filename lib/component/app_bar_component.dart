import 'package:flutter/material.dart';

class AppBarCom extends StatelessWidget implements PreferredSizeWidget {
  final String? appBarText;
  final bool leading;
  final Widget? leftIcon;
  final String? routeName;
  final Color? backgroundColor;
  final Color? textColor;
  final List<Widget>? action;

  const AppBarCom({
    super.key,
    this.appBarText,
    required this.leading,
    this.leftIcon,
    this.backgroundColor,
    this.textColor,
    this.action,
    this.routeName,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        automaticallyImplyLeading: leading,
        leading: leading
            ? leftIcon ??
                IconButton(
                  onPressed: () {
                    routeName == null
                        ? Navigator.of(context).pop()
                        : Navigator.of(context)
                            .pushReplacementNamed(routeName!);
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                    ),
                  ),
                )
            : null,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.outline),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(appBarText ?? ""),
        titleTextStyle: Theme.of(context).textTheme.displayMedium,
        elevation: 4,
        actions: action,
      ),
    );
  }
}
