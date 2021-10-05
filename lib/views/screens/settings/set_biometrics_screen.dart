import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:flutter/material.dart';

class SetBiometricsScreen extends StatefulWidget {
  const SetBiometricsScreen({Key? key}) : super(key: key);

  @override
  _SetBiometricsScreenState createState() => _SetBiometricsScreenState();
}

class _SetBiometricsScreenState extends State<SetBiometricsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ArborColors.green,
      child: SafeArea(child: Scaffold(
        backgroundColor: ArborColors.green,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          leading:  IconButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            icon: Icon(
              Icons.arrow_back,
              color: ArborColors.white,
            ),
          ),

          backgroundColor: ArborColors.green,
        ),
      )),
    );
  }
}
