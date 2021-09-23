import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/settings-module/settings/settings.dart';
import 'package:przepisnik_v3/components/start/home.dart';
import 'package:przepisnik_v3/services/auth-service.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:przepisnik_v3/globals/globals.dart' as globals;

const double _backdropVelocity = 2.0;
const double _layerTitleHeight = 48.0;
const double _backDropMaxHeight = _layerTitleHeight * 6;

class Backdrop extends StatefulWidget {
  final Widget? frontLayer;
  final Widget? backLayer;
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
          0.0, _backDropMaxHeight, 0.0, layerTop - layerSize.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_backdropAnimationController!.view);

    void closeBackdrop() {
      _backdropAnimationController!.fling(velocity: _backdropVelocity);
    }

    if (globals.globalBackdropHandler != null) {
      globals.globalBackdropHandler = closeBackdrop;
    }

    void backdropGrab(position) {
      if (!_frontLayerVisible) {
        _backdropAnimationController!.value =
            1 - (_backDropMaxHeight + position) / _backDropMaxHeight;
      }
    }

    void backdropGrabEnd() {
      _backdropAnimationController!.fling(
          velocity: _backdropAnimationController!.value < 0.40
              ? -_backdropVelocity
              : _backdropVelocity);
    }

    Widget commonBackdropOptions() {
      return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              ElevatedButton(
                onPressed: () {
                  closeBackdrop();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                child: const Icon(Icons.settings_rounded).padding(all: 0),
              ).width(60).height(50).padding(horizontal: 10),
              ElevatedButton(
                onPressed: () {
                  closeBackdrop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                child: const Icon(Icons.person_rounded).padding(all: 0),
              ).width(60).height(50).padding(horizontal: 10),
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
                  primary: Theme.of(context).accentColor,
                  side: BorderSide(color: Theme.of(context).accentColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              icon: const Icon(Icons.logout_rounded),
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
              Styled.widget(
                child: widget.backLayer,
              ).height(215),
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
      color: Theme.of(context).primaryColorLight,
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
        child: Styled.widget(child: widget.title)
            .width(MediaQuery.of(context).size.width)
            .padding(left: widget.backButtonOverride ? 0 : 15),
        onVerticalDragUpdate: (DragUpdateDetails details) {
          if (_frontLayerVisible && widget.backLayer != null) {
            _dragDirection = details.localPosition.dy > _lastDragPos;
            _lastDragPos = details.localPosition.dy;
            _backdropAnimationController!.value =
                (_backDropMaxHeight - details.localPosition.dy + 30) /
                    _backDropMaxHeight;
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
