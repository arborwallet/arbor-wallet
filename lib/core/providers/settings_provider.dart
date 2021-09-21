import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';


class SettingsProvider extends ChangeNotifier {
  
  
  launchURL({required String url}) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }


}
