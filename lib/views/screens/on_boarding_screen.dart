
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:arbor/core/arbor_colors.dart';
import 'package:arbor/core/models/onboarding_text.dart';
import 'package:arbor/views/screens/welcome_screen.dart';
import 'package:arbor/views/widgets/layout/arbor_on_boarding_layout.dart';
import 'package:introduction_screen/introduction_screen.dart';

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
              titleWidget: Container(
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.55,
                child: Center(
                  child: SvgPicture.asset(
                    e.assetPath,
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
                ),
              ),
              bodyWidget: _OnBoardingTextWidget(
                onBoardingText: e,
                onNextPressed: () {},
              ),
            ),
          )
          .toList(),
      onDone: () => Navigator.push(
        context,
        MaterialPageRoute<Widget>(
          builder: (context) => WelcomeScreen(),
        ),
      ),
      onSkip: () => Navigator.push(
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
      skip: const Text('SKIP',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white,fontSize: 18,),),
      next: const Text('NEXT',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white,fontSize: 18,),),
      done: const Text('SKIP',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white,fontSize: 18,)),
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
  final VoidCallback onNextPressed;

  _OnBoardingTextWidget(
      {required this.onBoardingText, required this.onNextPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${onBoardingText.title}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '${onBoardingText.description}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            softWrap: true,
          ),
          const SizedBox(
            height: 30,
          ),
          /*TextButton(
            onPressed: onNextPressed,
            style: TextButton.styleFrom(
              primary: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Next',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          )*/
        ],
      ),
    );
  }
}
