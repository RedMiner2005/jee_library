import 'package:flutter/material.dart';

class DisabledScreen extends StatelessWidget {
  const DisabledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget> [
            Text(
                "We're sorry!",
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            Text("Your device has been disabled by the admin")
          ],
        ),
      ),
    );
  }
}
