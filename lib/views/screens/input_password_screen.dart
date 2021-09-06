import '/core/arbor_colors.dart';
import 'package:flutter/material.dart';

class InputPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ArborColors.green,
        title: Text('Restore Wallet'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              'Type your 12-word password to restore your existing wallet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: ArborColors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              children: [
                AnimatedCrossFade(
                  firstChild: firstChild(context),
                  secondChild: secondChild(context),
                  crossFadeState: CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget firstChild(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '1 - 4',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: ArborColors.white,
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }

  Widget secondChild(BuildContext context) {
    return Container();
  }
}
