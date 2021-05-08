import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'loadingKey',
              child: LoaderAnimation(),
            )
          ],
        ),
        Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Center(
              child: Text(
                'Proszę czekać',
                style: TextStyle(fontSize: 20),
              ),
            ))
      ],
    );
  }
}

class LoaderAnimation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Lottie.network(
        'https://assets9.lottiefiles.com/private_files/lf30_fqBsFC.json',
        height: 200,
        fit: BoxFit.fitHeight);
  }
}

