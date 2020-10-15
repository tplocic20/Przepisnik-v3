import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:przepisnik_v3/components/shared/navigation-menu.dart';
import 'package:przepisnik_v3/models/routes.dart';

const double _kFlingVelocity = 2.0;

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
      this.actionButtonLocation,
      this.customActions = const <Widget>[],
      this.backButtonOverride = false})
      : assert(frontLayer != null),
        assert(scope != null);

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with TickerProviderStateMixin {

  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  
  AnimationController _backdropAnimationController;
  bool _mainMenuFlag = true;
  Animation<double> _mainMenuAnimation;
  AnimationController _mainMenuAnimationController;

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double layerTitleHeight = 48.0;
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - layerTitleHeight;

    Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, layerTitleHeight * 6, 0.0, layerTop - layerSize.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_backdropAnimationController.view);

    return Stack(
      key: _backdropKey,
      children: <Widget>[
        ExcludeSemantics(
          child: NavigationMenu(
            routeScope: widget.scope,
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
        velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
    toggleMainMenuIcon();
  }

  void toggleMainMenuIcon() {
    if (_mainMenuFlag = !_mainMenuFlag) {
      _mainMenuAnimationController.reverse();
    } else {
      _mainMenuAnimationController.forward();
    }
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

    _mainMenuAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _mainMenuAnimation = CurvedAnimation(
        curve: Curves.linear,
        parent: _mainMenuAnimationController
    );
  }

  @override
  void dispose() {
    _backdropAnimationController.dispose();
    _mainMenuAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> barActions = [
      ...widget.customActions,
      IconButton(
        icon: AnimatedIcon(
          progress: _mainMenuAnimation,
          icon: AnimatedIcons.menu_close,
        ),
        onPressed: _toggleBackdropLayerVisibility,
      )
    ];
    var appBar = AppBar(
      brightness: Brightness.light,
      elevation: 0.0,
      titleSpacing: 0.0,
      leading: widget.backButtonOverride ? IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed:_goBackNavigation,
      ) : null,
      title: GestureDetector(
        child: Padding(
          child:  widget.title,
          padding: EdgeInsets.only(left: widget.backButtonOverride ? 0 : 15),
        ),
      ),
      actions: barActions,
    );
    return Scaffold(
        extendBody: true,
        appBar: appBar,
        body: LayoutBuilder(builder: _buildStack),
        floatingActionButtonLocation: widget.actionButtonLocation != null
            ? widget.actionButtonLocation
            : FloatingActionButtonLocation.centerDocked,
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
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}
