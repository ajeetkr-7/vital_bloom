import 'package:flutter/material.dart';

class AlwaysRefreshable extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  const AlwaysRefreshable({Key? key, required this.onRefresh,required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Stack(
        children: [
          ListView(),
          child,
        ],
      ),
    );
  }
}
