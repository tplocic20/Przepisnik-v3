import 'package:flutter/material.dart';

const double _kPanelHeaderCollapsedHeight = 48.0;
const double _kPanelHeaderExpandedHeight = 64.0;
const double _borderRadiusOpen = 25.0;
const double _borderRadiusClosed = 0.0;

class RoundedExpansionPanelList extends StatelessWidget {

  const RoundedExpansionPanelList(
      {Key? key,
        this.children = const <ExpansionPanel>[],
        this.expansionCallback,
        this.animationDuration = kThemeAnimationDuration})
      : super(key: key);

  final List<ExpansionPanel> children;

  final ExpansionPanelCallback? expansionCallback;

  final Duration animationDuration;

  bool _isChildExpanded(int index) {
    return children[index].isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = <Widget>[];
    const EdgeInsets kExpandedEdgeInsets = const EdgeInsets.symmetric(
        vertical: _kPanelHeaderExpandedHeight - _kPanelHeaderCollapsedHeight);

    for (int index = 0; index < children.length; index += 1) {
      if (_isChildExpanded(index) && index != 0 && !_isChildExpanded(index - 1))
        items.add(new Divider(
          key: new _SaltedKey<BuildContext, int>(context, index * 2 - 1),
          height: 15.0,
          color: Colors.transparent,
        ));

      final Row header = new Row(
        children: <Widget>[
          new Expanded(
            child: new AnimatedContainer(
              duration: animationDuration,
              curve: Curves.fastOutSlowIn,
              margin: _isChildExpanded(index)
                  ? kExpandedEdgeInsets
                  : EdgeInsets.zero,
              child: new SizedBox(
                height: _kPanelHeaderCollapsedHeight,
                child: children[index].headerBuilder(
                  context,
                  children[index].isExpanded,
                ),
              ),
            ),
          ),
          new Container(
            margin: const EdgeInsetsDirectional.only(end: 8.0),
            child: new ExpandIcon(
              isExpanded: _isChildExpanded(index),
              padding: const EdgeInsets.all(16.0),
              onPressed: (bool isExpanded) {
                if (expansionCallback != null)
                  expansionCallback!(index, isExpanded);
              },
            ),
          ),
        ],
      );

      BorderRadius childRadius = BorderRadius.all(Radius.circular(_borderRadiusOpen));
      if (!_isChildExpanded(index)) {
        Radius top = Radius.circular(_borderRadiusClosed);
        Radius bottom = Radius.circular(_borderRadiusClosed);

        if (index == 0 || _isChildExpanded(index -1)) {
          top = Radius.circular(_borderRadiusOpen);
        }
        if (index == children.length -1 || _isChildExpanded(index + 1)) {
          bottom = Radius.circular(_borderRadiusOpen);
        }
        childRadius = BorderRadius.vertical(top: top, bottom: bottom);
      }
      items.add(
        new Container(
          key: new _SaltedKey<BuildContext, int>(context, index * 2),
          child: new Material(
            shadowColor: Theme.of(context).colorScheme.secondary,
            elevation: 1.5,
            borderRadius: childRadius,
            child: new Column(
              children: <Widget>[
                header,
                new AnimatedCrossFade(
                  firstChild: new Container(height: 0.0),
                  secondChild: children[index].body,
                  firstCurve:
                  const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                  secondCurve:
                  const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                  sizeCurve: Curves.fastOutSlowIn,
                  crossFadeState: _isChildExpanded(index)
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: animationDuration,
                ),
              ],
            ),
          ),
        ),
      );

      if (_isChildExpanded(index) && index != children.length - 1)
        items.add(new Divider(
          key: new _SaltedKey<BuildContext, int>(context, index * 2 + 1),
          height: 15.0,
          color: Colors.transparent,
        ));
    }

    return new Column(
      children: items,
    );
  }
}

class _SaltedKey<S, V> extends LocalKey {
  const _SaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final _SaltedKey<S, V> typedOther = other;
    return salt == typedOther.salt && value == typedOther.value;
  }

  @override
  int get hashCode => hashValues(runtimeType, salt, value);

  @override
  String toString() {
    final String saltString = S == String ? '<\'$salt\'>' : '<$salt>';
    final String valueString = V == String ? '<\'$value\'>' : '<$value>';
    return '[$saltString $valueString]';
  }
}