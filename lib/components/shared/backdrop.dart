import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:przepisnik_v3/components/settings-module/settings/settings.dart';
import 'package:przepisnik_v3/components/shared/przepisnik-icon.dart';
import 'package:przepisnik_v3/components/start/home.dart';
import 'package:przepisnik_v3/globals/globals.dart' as globals;
import 'package:przepisnik_v3/services/auth-service.dart';
import 'package:styled_widget/styled_widget.dart';

const double _backdropVelocity = 2.0;
const double _layerTitleHeight = 48.0;
const double _layerItemHeight = 65;

class Backdrop extends StatefulWidget {
  final Widget? frontLayer;
  final List<Widget>? backLayer;
  final Widget? bottomNavigation;
  final Widget? bottomMainBtn;
  final Widget title;
  final bool backButtonOverride;
  final FloatingActionButtonLocation actionButtonLocation;

  const Backdrop(
      {@required this.frontLayer,
      this.backLayer,
      this.bottomNavigation,
      this.bottomMainBtn,
      this.title = const Text(''),
      this.actionButtonLocation = FloatingActionButtonLocation.centerDocked,
      this.backButtonOverride = false})
      : assert(frontLayer != null);

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop> with TickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');

  AnimationController? _backdropAnimationController;
  double _lastDragPos = 0.0;
  bool _dragDirection = false;

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - _layerTitleHeight;

    Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0,
          (((widget.backLayer!.length > 0 ? widget.backLayer!.length : 1) *
                  _layerItemHeight) +
              _layerItemHeight),
          0.0,
          layerTop - layerSize.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_backdropAnimationController!.view);

    void backdropGrab(position) {
      if (!_frontLayerVisible) {
        _backdropAnimationController!.value = 1 -
            ((((widget.backLayer!.length > 0 ? widget.backLayer!.length : 1) *
                            _layerItemHeight) +
                        _layerItemHeight) +
                    position) /
                (((widget.backLayer!.length > 0
                            ? widget.backLayer!.length
                            : 1) *
                        _layerItemHeight) +
                    _layerItemHeight);
      }
    }

    void backdropGrabEnd() {
      _backdropAnimationController!.fling(
          velocity: _backdropAnimationController!.value < 0.40
              ? -_backdropVelocity
              : _backdropVelocity);
    }

    Widget getBackDropButton(Widget icon, Widget nextPage) {
      return ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary),
              onPressed: () {
                _toggleBackdropLayerVisibility();
                showCupertinoModalBottomSheet(
                    context: context, builder: (context) => nextPage);
              },
              child: Container(child: icon))
          .height(50)
          .width(60)
          .padding(horizontal: 10);
    }

    Widget commonBackdropOptions() {
      return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              getBackDropButton(
                  PrzepisnikIcon(icon: 'settings', size: 35), SettingsPage()),
              getBackDropButton(
                  PrzepisnikIcon(icon: 'customer', size: 35), SettingsPage()),
            ]),
            OutlinedButton.icon(
              onPressed: () {
                AuthService().signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false);
              },
              style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              icon: PrzepisnikIcon(
                  icon: 'logout',
                  size: 35,
                  color: Theme.of(context).colorScheme.secondary),
              label: Text('Wyloguj'),
            ).height(50).padding(horizontal: 10),
          ])
          .backgroundColor(Theme.of(context).primaryColor)
          .width(MediaQuery.of(context).size.width)
          .alignment(Alignment.topCenter)
          .height(100)
          .gestures(
              onVerticalDragUpdate: (DragUpdateDetails details) =>
                  backdropGrab(details.localPosition.dy),
              onVerticalDragEnd: (DragEndDetails details) => backdropGrabEnd());
    }

    return Stack(
      key: _backdropKey,
      children: <Widget>[
        ExcludeSemantics(
          child: Column(
            children: [
              SizedBox(height: 5),
              Styled.widget(
                child: Column(
                  children: widget.backLayer ?? [],
                ),
              ).height((((widget.backLayer!.length > 0
                      ? widget.backLayer!.length
                      : 1) *
                  _layerItemHeight))),
              commonBackdropOptions()
            ],
          ).backgroundColor(Theme.of(context).primaryColor),
          excluding: _frontLayerVisible,
        ),
        PositionedTransition(
          rect: layerAnimation,
          child: _FrontLayer(
            child: widget.frontLayer!,
          ),
        ),
      ],
    );
  }

  bool get _frontLayerVisible {
    final AnimationStatus status = _backdropAnimationController!.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility() {
    _backdropAnimationController!.fling(
        velocity: _frontLayerVisible ? -_backdropVelocity : _backdropVelocity);
  }

  void _goBackNavigation() {
    _backdropAnimationController!.fling(velocity: _backdropVelocity);
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
    globals.globalBackdropHandler = () {
      _backdropAnimationController!.fling(velocity: _backdropVelocity);
    };
  }

  @override
  void dispose() {
    _backdropAnimationController!.dispose();
    super.dispose();
  }

  Widget _defaultBottomBtn() {
    return Container();
  }

  Widget _defaultBottomNavBar() {
    return BottomAppBar(
      elevation: 0,
      notchMargin: 5,
      color: Colors.transparent,
      child: Container(
        height: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> barActions = [
      IconButton(
        icon: AnimatedIcon(
          progress: _backdropAnimationController!.view,
          icon: AnimatedIcons.close_menu,
        ),
        onPressed: _toggleBackdropLayerVisibility,
      )
    ];
    var appBar = AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      shadowColor: Colors.transparent,
      elevation: 0.0,
      titleSpacing: 0.0,
      leading: widget.backButtonOverride
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _goBackNavigation,
            )
          : null,
      title: GestureDetector(
        child: Styled.widget(child: widget.title)
            .width(MediaQuery.of(context).size.width)
            .padding(left: widget.backButtonOverride ? 0 : 15),
        onVerticalDragUpdate: (DragUpdateDetails details) {
          if (_frontLayerVisible && widget.backLayer != null) {
            _dragDirection = details.localPosition.dy > _lastDragPos;
            _lastDragPos = details.localPosition.dy;
            _backdropAnimationController!.value =
                ((((widget.backLayer!.length > 0
                                    ? widget.backLayer!.length
                                    : 1) *
                                _layerItemHeight) +
                            _layerItemHeight) -
                        details.localPosition.dy +
                        30) /
                    (((widget.backLayer!.length > 0
                                ? widget.backLayer!.length
                                : 1) *
                            _layerItemHeight) +
                        _layerItemHeight);
          }
        },
        onVerticalDragEnd: (DragEndDetails details) {
          _backdropAnimationController!.fling(
              velocity:
                  _dragDirection && _backdropAnimationController!.value < 0.55
                      ? -_backdropVelocity
                      : _backdropVelocity);
        },
      ),
      actions: widget.backLayer != null ? barActions : [],
    );
    return Scaffold(
        extendBody: true,
        appBar: appBar,
        body: LayoutBuilder(builder: _buildStack),
        floatingActionButtonLocation: widget.actionButtonLocation,
        floatingActionButton: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          child: widget.bottomMainBtn ?? _defaultBottomBtn(),
        ),
        bottomNavigationBar: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          child: widget.bottomNavigation ?? _defaultBottomNavBar(),
        ));
  }
}

class _FrontLayer extends StatelessWidget {
  const _FrontLayer({
    Key? key,
    @required this.child,
  }) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16.0,
      color: Theme.of(context).colorScheme.background,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  clipBehavior: Clip.antiAlias,
                  child: child)),
        ],
      ),
    );
  }
}
