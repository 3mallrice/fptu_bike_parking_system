import 'package:bai_system/core/helper/asset_helper.dart';
import 'package:bai_system/representation/login.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  static String routeName = '/intro_screen';

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AssetHelper.splash),
                  Text(
                    'FPTU Bike Parking System',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'A smart and modern parking mangement system.',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AssetHelper.intro2_1,
                    fit: BoxFit.fitHeight,
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Image.asset(
                    AssetHelper.intro2_2,
                    fit: BoxFit.fitHeight,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Welcome!',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'This app is the simplest way to pay your parking using your smartphone only.',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AssetHelper.baiLogo,
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Let's go!",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'Easy to pay, easy to manage.',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: Size(double.infinity,
                    Theme.of(context).buttonTheme.height * 1.5),
                maximumSize: Size(double.infinity,
                    Theme.of(context).buttonTheme.height * 1.5),
              ),
              onPressed: () async {
                Navigator.of(context)
                    .pushReplacementNamed(LoginScreen.routeName);
              },
              child: Text(
                'Get Started',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                    ),
              ),
            )
          : Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: Theme.of(context).buttonTheme.height * 1.5,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => controller.jumpToPage(2),
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(
                        spacing: 16.0,
                        dotColor: Theme.of(context).colorScheme.outline,
                        activeDotColor: Theme.of(context).colorScheme.primary,
                      ),
                      onDotClicked: (index) => controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.nextPage(
                      duration: const Duration(microseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                    child: Text(
                      'Next',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
