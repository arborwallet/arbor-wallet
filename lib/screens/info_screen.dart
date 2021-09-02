import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:arbor/screens/update_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:arbor/screens/add_screen.dart';

import 'package:arbor/hive_constants.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late final Box contactBox;

  // Delete info from wallet box
  _deleteInfo(int index) {
    contactBox.deleteAt(index);

    print('Item deleted from box at index: $index');
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    contactBox = Hive.box(HiveConstants.walletBox);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arbor Wallet'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: contactBox.listenable(),
        builder: (context, Box box, widget) {
          if (box.isEmpty) {
            return const Center(
              child: Text('Tap + to create a new wallet.'),
            );
          } else {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                var currentBox = box;
                var walletData = currentBox.getAt(index)!;

                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UpdateScreen(
                        index: index,
                        wallet: walletData,
                      ),
                    ),
                  ),
                  child: Card (
                    elevation: 8,
                    shadowColor: Colors.lightGreen,
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: Icon(Icons.account_balance_wallet),
                      title: Text('${walletData.fork.name} (${walletData.name})'),
                      subtitle: Text(walletData.address),
                      trailing: IconButton(
                        onPressed: () => _deleteInfo(index),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
