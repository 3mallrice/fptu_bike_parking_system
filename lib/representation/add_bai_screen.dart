import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';

import '../component/app_bar_component.dart';
import '../component/shadow_button.dart';

class AddBai extends StatelessWidget {
  static String routeName = '/addBai';
  const AddBai({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCom(
        leading: true,
        appBarText: 'Add Bike',
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).size.height *
                  0.1, // Adjust for app bar height
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.only(top: 25),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShadowContainer(
                        padding: const EdgeInsets.all(0),
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              //TODO: Add image picker
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_rounded,
                                  size: 50,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Upload your vehicle image\nrequired*',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PLATE NUMBER',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ShadowContainer(
                            padding: const EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height * 0.065,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter plate number',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                                suffixIcon: Icon(
                                  Icons.edit_rounded,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        'By tapping ADD you agree to add new bike to your account.',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: const ShadowButton(
                      buttonTitle: 'ADD',
                      margin: EdgeInsets.symmetric(vertical: 20),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
