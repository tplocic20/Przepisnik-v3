import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';

class BottomModalWrapper extends StatelessWidget {
  final Widget? child;
  late final bool showDragHandle;

  BottomModalWrapper({required this.child}) {
    this.showDragHandle = false;
  }

  BottomModalWrapper.withDragHandle({required this.child}) {
    this.showDragHandle = true;
  }

  @override
  Widget build(BuildContext context) {
    return SmoothContainer(
      smoothness: 0.6,
      borderRadius: BorderRadius.circular(45),
      color: Theme.of(context).canvasColor,
      margin: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Stack(
          children: [
            this.showDragHandle
                ? Positioned(
                    top: 0,
                    left: MediaQuery.of(context).size.width / 2 - 25 - 10,
                    child: Container(
                        child: Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    )))
                : Container(),
            child!
          ],
        ),
      ),
    );
  }
}

class BottomModalInputWrapper extends StatelessWidget {
  final Widget? child;

  BottomModalInputWrapper({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        child: child,
      ),
    );
  }
}
