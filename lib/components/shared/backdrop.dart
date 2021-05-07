import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/shared/navigation-menu.dart';
import 'package:przepisnik_v3/models/routes.dart';

const double _backdropVelocity = 2.0;
const double _layerTitleHeight = 48.0;
const double _backDropMaxHeight = _layerTitleHeight * 6;

class Backdrop extends StatefulWidget {
  final Widget frontLayer;
  final Widget bottomNavigation;
  final Widget bottomMainBtn;
  final List<Widget> customActions;
  final Routes scope;
  final Widget title;
  final bool backButtonOverride;
  final FloatingActionButtonLocation actionButtonLocation;

  const Backdrop(
      {@required this.scope,
      @required this.frontLayer,
      this.bottomNavigation,
      this.bottomMainBtn,
      this.title,
      this.actionButtonLocation = FloatingActionButtonLocation.centerDocked,
      this.customActions = const <Widget>[],
      this.backButtonOverride = false})
      : assert(frontLayer != null),
        assert(scope != null);

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop> with TickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');

  AnimationController _backdropAnimationController;
  double _lastDragPos = 0.0;
  bool _dragDirection;

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - _layerTitleHeight;

    Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, _backDropMaxHeight, 0.0, layerTop - layerSize.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_backdropAnimationController.view);

    void closeBackdrop() {
      _backdropAnimationController.fling(velocity: _backdropVelocity);
    }

    void backdropGrab(position) {
      if (!_frontLayerVisible) {
        _backdropAnimationController.value =
            1 - (_backDropMaxHeight + position) /
                _backDropMaxHeight;
      }
    }

    void backdropGrabEnd() {
      _backdropAnimationController.fling(
          velocity: _backdropAnimationController.value < 0.25
              ? -_backdropVelocity
              : _backdropVelocity);
    }

    return Stack(
      key: _backdropKey,
      children: <Widget>[
        ExcludeSemantics(
          child: NavigationMenu(
            routeScope: widget.scope,
            closeBackdrop: closeBackdrop,
            backDropGrab: backdropGrab,
            backDropGrabEnd: backdropGrabEnd,
          ),
          excluding: _frontLayerVisible,
        ),
        PositionedTransition(
          rect: layerAnimation,
          child: _FrontLayer(
            child: widget.frontLayer,
          ),
        ),
      ],
    );
  }

  bool get _frontLayerVisible {
    final AnimationStatus status = _backdropAnimationController.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility() {
    _backdropAnimationController.fling(
        velocity: _frontLayerVisible ? -_backdropVelocity : _backdropVelocity);
  }

  void _goBackNavigation() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _backdropAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _backdropAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> barActions = [
      ...widget.customActions,
      IconButton(
        icon: AnimatedIcon(
          progress: _backdropAnimationController.view,
          icon: AnimatedIcons.close_menu,
        ),
        onPressed: _toggleBackdropLayerVisibility,
      )
    ];
    var appBar = AppBar(
      brightness: Brightness.light,
      elevation: 0.0,
      titleSpacing: 0.0,
      leading: widget.backButtonOverride
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _goBackNavigation,
            )
          : null,
      title: GestureDetector(
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              child: widget.title,
              padding:
                  EdgeInsets.only(left: widget.backButtonOverride ? 0 : 15),
            )),
        onVerticalDragUpdate: (DragUpdateDetails details) {
          if (_frontLayerVisible) {
            _dragDirection = details.localPosition.dy > _lastDragPos;
            _lastDragPos = details.localPosition.dy;
            _backdropAnimationController.value =
                (_backDropMaxHeight - details.localPosition.dy + 30) /
                    _backDropMaxHeight;
          }
        },
        onVerticalDragEnd: (DragEndDetails details) {
          _backdropAnimationController.fling(
              velocity: _dragDirection != null &&
                      _dragDirection &&
                      _backdropAnimationController.value < 0.75
                  ? -_backdropVelocity
                  : _backdropVelocity);
        },
      ),
      actions: barActions,
    );
    return Scaffold(
        extendBody: true,
        appBar: appBar,
        body: LayoutBuilder(builder: _buildStack),
        floatingActionButtonLocation: widget.actionButtonLocation,
        floatingActionButton: widget.bottomMainBtn,
        bottomNavigationBar: widget.bottomNavigation);
  }
}

class _FrontLayer extends StatelessWidget {
  const _FrontLayer({
    Key key,
    this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16.0,
      color: Color(0xFFf2f5f7),
      // color: Color(0xFFfffaf5),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              clipBehavior: Clip.antiAlias,
              child: child
            )
          ),
        ],
      ),
    );
  }
}
