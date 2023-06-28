import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  final String text;

  const LoadingIndicator({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SpinKitDoubleBounce(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
          const SizedBox(height: 20),
          Text(text),
        ]),
      );
}
