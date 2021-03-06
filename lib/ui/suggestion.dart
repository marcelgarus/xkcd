import 'dart:math';
import 'package:flutter/material.dart';


/// A suggestion chip to be displayed at the bottom of the screen.
/// 
/// You can provide an [icon] and a [label] as well as an [onTap] callback.
/// Also, you can change the [show] parameter to show or hide the chip.
class Suggestion extends StatefulWidget {
  Suggestion({
    @required this.show,
    @required this.onTap,
    @required this.icon,
    @required this.label,
  }) :
      assert(show != null),
      assert(onTap != null),
      assert(icon != null),
      assert(label != null);
  
  /// Whether the suggestion chip is shown. If you change this, it jumpily
  /// animates to its new position.
  final bool show;

  /// A callback to be called if the suggestion is tapped.
  final VoidCallback onTap;

  /// The icon.
  final Widget icon;

  /// The label;
  final Widget label;


  @override
  _SuggestionState createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> with SingleTickerProviderStateMixin {
  bool lastShown;
  double position = 0.0;
  double rotation = 0.0;
  AnimationController controller;
  Animation<double> positionAnimation;

  /// Initializes the controller and the animations.
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250)
    )..addListener(_update);
    positionAnimation = CurvedAnimation(curve: ElasticOutCurve(), parent: controller);
  }

  void _update() => setState(() {
    final double t = controller.value ?? 0.0;
    position = 56 * (1.0 - positionAnimation.value);
    rotation = lastShown ?? false ? 0.2 * (t * t - t) * sin(20 * t) : 0.0;
  });

  /// Called every build. If the widget's [show] property changed, we animate.
  void _tick() {
    if (widget.show == lastShown)
      return;

    if (lastShown == null) {
      lastShown = widget.show;
      _update();
      return;
    }

    if (widget.show)
      controller.forward();
    else
      controller.reverse();

    lastShown = widget.show;
  }

  @override
  Widget build(BuildContext context) {
    _tick();

    return ClipRect(
      child: Transform.translate(
        offset: Offset(0.0, position),
        child: Transform.rotate(
          angle: rotation,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Transform.scale(
              scale: 0.8,
              child: FloatingActionButton.extended(
                backgroundColor: Colors.white,
                elevation: 8.0,
                icon: widget.icon,
                label: widget.label,
                onPressed: widget.onTap,
              )
            )
          )
        ),
      )
    );
  }
}
