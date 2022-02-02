import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

const double _backdropVelocity = 2.0;
const double _layerTitleHeight = 48.0;
const double _layerItemHeight = 65;

class BackdropSimple extends StatefulWidget {
  final Widget? frontLayer;
  final Widget? bottomMainBtn;
  final Widget title;
  final bool backButtonOverride;
  final FloatingActionButtonLocation actionButtonLocation;

  const BackdropSimple(
      {@required this.frontLayer,
        this.bottomMainBtn,
        this.title = const Text(''),
        this.actionButtonLocation = FloatingActionButtonLocation.centerDocked,
        this.backButtonOverride = false})
      : assert(frontLayer != null);

  @override
  _BackdropSimpleState createState() => _BackdropSimpleState();
}

class _BackdropSimpleState extends State<BackdropSimple> {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'BackdropSimple');

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - _layerTitleHeight;


    return Stack(
      key: _backdropKey,
      children: <Widget>[
        ExcludeSemantics(
          child: Column(
            children: [
              Container()
            ],
          ).backgroundColor(Theme.of(context).primaryColor),
        ),
        Positioned(
          child: _FrontLayer(
            child: widget.frontLayer!,
          ),
        ),
      ],
    );
  }

  void _goBackNavigation() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
    List<Widget> barActions = [];
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
      title: widget.title,
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
          child: _defaultBottomNavBar(),
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
      color: Theme.of(context).backgroundColor,
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
