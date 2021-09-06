import 'package:arbor/core/constants/asset_paths.dart';

class OnBoardingText {
  final String title;
  final String description;
  final String assetPath;

  OnBoardingText({required this.title, required this.description,required this.assetPath});
}

List<OnBoardingText> onBoardingTextList = [
  OnBoardingText(
      title: 'Receive',
      description:
          'Receive crypto by scanning or sharing your unique QR code or address',
    assetPath: AssetPaths.receive,
  ),
  OnBoardingText(
      title: 'Send',
      description:
          'Send crypto in a few taps by scanning a QR code or pasting an address',
    assetPath: AssetPaths.send,
  ),
];
