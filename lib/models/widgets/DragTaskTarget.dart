import 'package:flutter/material.dart';

typedef OnTaskDroppedCallback = void Function(int index);

class DragTaskTarget extends StatefulWidget {
  final Function(int) onTaskDropped;
  final Function dialogClosed;
  final int index;
  final Widget child;

  const DragTaskTarget({
    super.key,
    required this.onTaskDropped,
    required this.dialogClosed,
    required this.index,
    required this.child,
  });

  @override
  DragTaskTargetState createState() => DragTaskTargetState();
}

class DragTaskTargetState extends State<DragTaskTarget> {
  bool isHovered = false;
  void resethover() {
    setState(() {
      isHovered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onAcceptWithDetails: (data) {
        widget.onTaskDropped(widget.index);
        resethover();
      },
      onWillAcceptWithDetails: (data) {
        setState(() {
          isHovered = true;
        });
        return true;
      },
      onLeave: (data) {
        resethover();
      },
      builder: (context, candidateData, rejectedData) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 4, end: isHovered ? 15 : 4),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  height: value,
                  color: Colors.transparent,
                ),
                Container(
                  width: double.infinity,
                  height: 3,
                  color: isHovered
                      ? Theme.of(context).colorScheme.secondaryFixed
                      : Colors.transparent,
                ),
                Container(
                  width: double.infinity,
                  height: value,
                  color: Colors.transparent,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
