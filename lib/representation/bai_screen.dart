import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/component/shadow_container.dart';
import 'package:fptu_bike_parking_system/core/helper/asset_helper.dart';

class BaiScreen extends StatefulWidget {
  const BaiScreen({super.key});

  static String routeName = '/bais_screen';

  @override
  State<BaiScreen> createState() => _BaiScreenState();
}

class _BaiScreenState extends State<BaiScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // Bike List
  List<Bike> bikes = [
    Bike(
      bikeId: '1',
      bikeImageURL: 'https://vnn-imgs-f.vgcloud.vn/2018/04/14/09/xe-ga-3.jpg',
      plateNumber: '29A-12345',
      bikeType: 'Automatic',
      status: 'Accepted',
    ),
    Bike(
      bikeId: '2',
      bikeImageURL:
          'https://xedien.com.vn/upimages/articles/xemay50cc/WaveVictoria/xe-wave-1.jpg',
      plateNumber: '29A-12346',
      bikeType: 'Manual',
      status: 'Pending',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                ShadowContainer(
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
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              '2',
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
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                //Bike Information
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: bikes.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: ShadowContainer(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Image.network(
                                      bikes[index].bikeImageURL,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Image.asset(
                                        AssetHelper.plateNumber,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      bikes[index].plateNumber,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Bike {
  String bikeId;
  String bikeImageURL;
  String plateNumber;
  String bikeType;
  String status;

  Bike({
    required this.bikeId,
    required this.bikeImageURL,
    required this.plateNumber,
    required this.bikeType,
    required this.status,
  });
}
