import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PortionSlider extends StatefulWidget {
  const PortionSlider({
    Key key,
  })  : super(key: key);

  @override
  _PortionSliderState createState() => _PortionSliderState();
}

class _PortionSliderState extends State<PortionSlider> {

  @override
  Widget build(BuildContext context) {
    return new _RangeSliderRenderObjectWidget();
  }
}

class _RangeSliderRenderObjectWidget extends LeafRenderObjectWidget {
  const _RangeSliderRenderObjectWidget({
    Key key,
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return new _RenderPortionSlider(context);
  }
}

class _RenderPortionSlider extends RenderBox {

  final BuildContext _context;

  _RenderPortionSlider(this._context);

  static const double _overlayRadius = 16.0;
  static const double _overlayDiameter = _overlayRadius * 2.0;
  static const double _trackHeight = 2.0;
  static const double _preferredTrackWidth = 144.0;
  static const double _preferredTotalWidth = _preferredTrackWidth + 2 * _overlayDiameter;
  static const double _thumbRadius = 6.0;

  @override
  bool get sizedByParent => true;

  @override
  void performResize(){
    size = new Size(
      constraints.hasBoundedWidth ? constraints.maxWidth : _preferredTotalWidth,
      constraints.hasBoundedHeight ? constraints.maxHeight : _overlayDiameter,
    );
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return 2 * _overlayDiameter;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _preferredTotalWidth;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _overlayDiameter;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _overlayDiameter;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;

    _paintTrack(canvas, offset);
    _paintThumbs(canvas, offset);
  }

  double trackLength;
  double trackVerticalCenter;
  double trackLeft;
  double trackTop;
  double trackBottom;
  double trackRight;

  void _paintTrack(Canvas canvas, Offset offset){
    final double trackRadius = _trackHeight / 2.0;

    trackLength = size.width - 2 * _overlayDiameter;
    trackVerticalCenter = offset.dy + (size.height) / 2.0;
    trackLeft = offset.dx + _overlayDiameter;
    trackTop = trackVerticalCenter - trackRadius;
    trackBottom = trackVerticalCenter + trackRadius;
    trackRight = trackLeft + trackLength;

    Rect trackLeftRect = new Rect.fromLTRB(trackLeft, trackTop, trackRight, trackBottom);

    Paint trackPaint = new Paint()..color = Theme.of(_context).accentColor;

    canvas.drawRect(trackLeftRect, trackPaint);
  }

  void _paintThumbs(Canvas canvas, Offset offset){
    Offset thumbUpperCenter = new Offset(trackRight, trackVerticalCenter);

    canvas.drawCircle(thumbUpperCenter, _thumbRadius, new Paint()..color = Theme.of(_context).primaryColor);
  }
}