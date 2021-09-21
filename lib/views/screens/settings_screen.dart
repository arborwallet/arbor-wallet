import '../../core/constants/arbor_colors.dart';
import 'package:flutter/material.dart';

class RestoreWalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ArborColors.green,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ArborColors.green,
          appBar: AppBar(
            backgroundColor: ArborColors.green,
            centerTitle: true,
              title: Text(
                'Settings',
                style: TextStyle(
                  color: ArborColors.white,
                ),
              ),
              leading:  IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: ArborColors.white,
                ),
              )
          ),
          body: Container(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Text("General"),
                settingsItem("Visit DFI Discord Channel"),
                settingsItem("View Privacy Policy"),
                SizedBox(height:10),
                Text("Arbor Data"),
                settingsItem("Delete Arbor Data"),
                
                
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget settingsItem(String title){
    return Container(
                  padding:EdgeInsets.all(10,),
                  margin:EdgeInsets.only(bottom:10),
                  decoration:BoxDecoration(
                    color: ArborColors.deepGreen,
                    borderRadius:BorderRadius.all(Radius.circular(8),),
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                  
                      SizedBox(width:16),
                      Text("Visit DFI Discord Channel"),
                      
                    ]
                  )
                );
  }
  
}
