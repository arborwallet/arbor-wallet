import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../views/widgets/layout/arbor_on_boarding_layout.dart';
import '../../core/constants/arbor_colors.dart';
import '../../core/models/onboarding_text.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'welcome_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingScreen extends StatelessWidget {
  final pageDecoration = const PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
    bodyTextStyle: TextStyle(fontSize: 19.0),
    descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    pageColor: Colors.white,
    imagePadding: EdgeInsets.zero,
  );

  @override
  Widget build(BuildContext context) {
    return ArborOnBoardingLayout(
      globalBackgroundColor: ArborColors.green,
      pages: onBoardingTextList
          .map(
            (e) => PageViewModel(
          titleWidget:Container(
            margin: EdgeInsets.only(top: 120.h),
            padding: EdgeInsets.only(left: 20.w,right: 20.w,),
            child: Center(
              child: SvgPicture.asset(
                e.assetPath,
                height: 0.3.sh,
                //height: MediaQuery.of(context).size.height * 0.5,
              ),
            ),
          ),
          bodyWidget: _OnBoardingTextWidget(
            onBoardingText: e,
          ),
        ),
      )
          .toList(),
      onDone: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute<Widget>(
          builder: (context) => WelcomeScreen(),
        ),
      ),
      onSkip: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute<Widget>(
          builder: (context) => WelcomeScreen(),
        ),
      ),
      showSkipButton: true,
      showNextButton: true,
      showDoneButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: Text(
        'SKIP',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontSize: 18.sp,
        ),
      ),
      next: Text(
        'NEXT',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontSize: 18.sp,
        ),
      ),
      done: const Text('SKIP',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 18,
          )),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Colors.white,
        activeSize: const Size(10.0, 10.0),
        activeShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        activeColor: ArborColors.deepGreen,
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}

class _OnBoardingTextWidget extends StatelessWidget {
  final OnBoardingText onBoardingText;

  _OnBoardingTextWidget(
      {required this.onBoardingText,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${onBoardingText.title}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            '${onBoardingText.description}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            softWrap: true,
          ),
          SizedBox(
            height: 40.h,
          ),
        ],
      ),
    );
  }
}
