import 'package:arbor/core/constants/arbor_colors.dart';
import 'package:arbor/views/screens/home/home_screen.dart';
import 'package:arbor/views/screens/settings/settings_screen.dart';
import 'package:arbor/views/widgets/layout/web_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewBaseScreen extends StatefulWidget {
  const NewBaseScreen({Key? key}) : super(key: key);

  @override
  _NewBaseScreenState createState() => _NewBaseScreenState();
}

class _NewBaseScreenState extends State<NewBaseScreen> {

  CrossFadeState currentState = CrossFadeState.showFirst;
  String title="Arbor Wallet";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          // Android back button hack
          SystemNavigator.pop();
        }
        return Future.value(true);
      },
      child: Container(
        color: ArborColors.green,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                '$title',
                style: TextStyle(
                  color: ArborColors.white,
                ),
              ),
              centerTitle: true,
              backgroundColor: ArborColors.green,
            ),
            drawer: ArborDrawer(
              onWalletsTapped: () {
                if(currentState==CrossFadeState.showFirst){
                  closeDrawer();
                }else{
                  setState(() {
                    title="Arbor Wallet";
                    currentState=CrossFadeState.showFirst;
                    closeDrawer();
                  });
                }
              },
              onSettingsTapped: (){
                if(currentState==CrossFadeState.showSecond){
                  closeDrawer();
                }else{
                  setState(() {
                    title="Settings";
                    currentState=CrossFadeState.showSecond;
                    closeDrawer();
                  });
                }
              },
            ),
            body: Column(
              children: [
                Expanded(child: AnimatedCrossFade(
                  firstChild: HomeScreen(),
                  secondChild: SettingsScreen(),
                  crossFadeState: currentState,
                  duration: const Duration(milliseconds: 300),
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }

  closeDrawer(){
    Navigator.pop(context);
  }
}