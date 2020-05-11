import 'package:flutter/material.dart';

class FancyFab extends StatefulWidget {
  final Color color;

  FancyFab({Key key, this.color: Colors.blue}) : super(key: key);

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _animateColor;
  Animation<double> _animateIcon;
  Animation<double> _opacityButtons;
  Curve _curve = Curves.easeOut;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateColor = ColorTween(
      begin: widget.color,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: _curve,
      ),
    ));
    _opacityButtons = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget toggle() {
    return FloatingActionButton(
      backgroundColor: _animateColor.value,
      onPressed: animate,
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.search_ellipsis,
        progress: _animateIcon,
      ),
    );
  }

  Widget button({String buttonText, void Function() onPressed}) {
    return Container(
      child: FlatButton(
        textColor: Colors.white,
        child: Text(buttonText),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Opacity(
          opacity: _opacityButtons.value,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                button(
                    buttonText: 'Search Books',
                    onPressed: () => Navigator.pushNamed(context, 'bookSearch',
                        arguments: 'bookSearchResults')),
                button(
                    buttonText: 'Search Borrowers',
                    onPressed: () => Navigator.pushNamed(
                          context,
                          'borrowerSearch',
                        )),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 12.0,
        ),
        toggle(),
      ],
    );
  }
}
