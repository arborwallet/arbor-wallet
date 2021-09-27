import 'package:arbor/core/constants/hive_constants.dart';
import 'package:arbor/views/screens/add_wallet/add_wallet_screen.dart';
import 'package:arbor/views/screens/base/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import '../../../core/constants/arbor_colors.dart';
import '../../../core/constants/asset_paths.dart';
import '../../widgets/arbor_button.dart';
import '../restore_wallet/restore_wallet_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late final Box walletBox;

  @override
  void initState() {
    super.initState();
    walletBox = Hive.box(HiveConstants.walletBox);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArborColors.green,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
        child: _WelcomeScreenBody(
          isEmpty: walletBox.isEmpty,
        ),
      ),
    );
  }
}

class _WelcomeScreenBody extends StatelessWidget {
  final bool isEmpty;
  _WelcomeScreenBody({this.isEmpty: true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: SvgPicture.asset(
            AssetPaths.safeWallet,
            height: 0.3.sh,
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Text(
          'Control Your Wealth',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          'Funds are under your control and your privacy is protected, no account required',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
          softWrap: true,
        ),
        Spacer(),
        ArborButton(
          backgroundColor: ArborColors.deepGreen,
          title: 'Get Started',
          onPressed: () {
            if (isEmpty) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddWalletScreen()));
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => BaseScreen()),
                (route) => false,
              );
            }
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        ArborButton(
          backgroundColor: ArborColors.deepGreen,
          title: 'I already have a wallet',
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RestoreWalletScreen()));
          },
        ),
      ],
    );
  }
}
