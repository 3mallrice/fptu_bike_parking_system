import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fptu_bike_parking_system/core/helper/asset_helper.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrCodeScreen extends StatelessWidget {
  static const String routeName = '/qr-code';
  const QrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    QrCode qrCode = QrCode.fromData(
      data: 'SE160537',
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );

    QrImage qrImage = QrImage(qrCode);

    qrImage.toImageAsBytes(
      size: 512,
      format: ImageByteFormat.png,
      decoration: PrettyQrDecoration(
        image: const PrettyQrDecorationImage(
          image: AssetImage(AssetHelper.imgLogo),
          fit: BoxFit.fill,
        ),
        background: Theme.of(context).colorScheme.background,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: Theme.of(context).colorScheme.primary),
        ),
        title: const Text('My Code'),
        elevation: 5,
        shadowColor: Theme.of(context).colorScheme.secondary,
      ),
      //QR code here
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    width: MediaQuery.of(context).size.width * 0.88,
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      shape: BoxShape.rectangle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.secondary,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: Text(
                            'Bui Huu Phuc',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: Text(
                            'SE160537',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: PrettyQrView.data(
                            data: 'SE160537',
                            decoration: PrettyQrDecoration(
                              background:
                                  Theme.of(context).colorScheme.background,
                              image: const PrettyQrDecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(AssetHelper.imgLogo),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AssetHelper.fptu,
                                height: MediaQuery.of(context).size.width * 0.1,
                                fit: BoxFit.fitHeight,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '|',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w100,
                                      ),
                                ),
                              ),
                              Image.asset(
                                scale: 2,
                                AssetHelper.baiLogo,
                                height:
                                    MediaQuery.of(context).size.width * 0.16,
                                fit: BoxFit.fitHeight,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(top: 10),
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.07,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: ClipOval(
                  child: Image.network(
                    'https://imgv3.fotor.com/images/gallery/cartoon-character-generated-by-Fotor-ai-art-creator.jpg',
                    fit: BoxFit.fitHeight,
                    height: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
