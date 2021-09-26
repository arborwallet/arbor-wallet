import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/core/enums/status.dart';
import 'package:arbor/core/providers/auth_provider.dart';
import 'package:arbor/core/utils/navigation_utils.dart';
import 'package:arbor/views/screens/base/base_screen.dart';
import 'package:arbor/views/widgets/keypad/arbor_keypad.dart';
import 'package:arbor/views/widgets/pin/pin_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UnlockWithPinScreen extends StatelessWidget {
  
  final bool unlock;
  final bool fromRoot;
  
  const UnlockWithPinScreen({Key? key,this.unlock:true,this.fromRoot:false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (_, model, __) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (model.setPinStatus == Status.SUCCESS) {
          if(model.unlock==true){
            NavigationUtils.pushReplacement(context, BaseScreen());
          }else{
            Navigator.pop(context,true);
          }

          model.clearStatus();
        }
      });
      return Container(
        color: ArborColors.green,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: ArborColors.green,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              leading:fromRoot?null: IconButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: ArborColors.white,
                ),
              ),
              title: Text(
                'Unlock With Pin',
                style: TextStyle(
                  color: ArborColors.white,
                ),
              ),
              backgroundColor: ArborColors.green,
            ),
            body: Container(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Enter your ${model.pinLength} digit",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: ArborColors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        ShakeAnimatedWidget(
                          child: PinIndicator(
                            currentPinLength: model.currentPin.length,
                            totalPinLength: model.pinLength,
                          ),
                          enabled: model.invalidPin,
                          duration: Duration(milliseconds: 200),
                          shakeAngle: Rotation.deg(z: 10.0),
                          curve: Curves.linear,
                        )
                      ],
                    ),
                  ),
                  ArborKeyPad(
                    size: ArborKeyPadSize.compact,
                    onKeyPressed: (key) => unlock? model.unlockWithPin(key):model.disablePin(key),
                    clearIcon: Icon(
                      Icons.arrow_back,
                      size: 14.0,
                      color: ArborColors.white,
                    ),
                    onBackKeyPressed: () => model.clear(),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

}
