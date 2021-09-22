import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/core/constants/asset_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WebDrawer extends StatelessWidget {
  final VoidCallback? onWalletsTapped;
  final VoidCallback? onSettingsTapped;
  const WebDrawer({Key? key, this.onWalletsTapped, this.onSettingsTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 40),
      child: Drawer(
        child: Container(
          color: ArborColors.green,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: ArborColors.green,
                ),
                child: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.all(20),
                  child: Image.asset(AssetPaths.logo),
                ),
              ),
              ListTile(
                onTap: onWalletsTapped,
                leading: SizedBox(
                  width: 40,
                  child: SvgPicture.asset(
                    AssetPaths.wallet,
                  ),
                ),
                title: Text(
                  'Wallets',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ArborColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Divider(
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
              ListTile(
                onTap: onSettingsTapped,
                leading: SizedBox(
                  width: 40,
                  child: SvgPicture.asset(
                    AssetPaths.settings,
                  ),
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ArborColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
