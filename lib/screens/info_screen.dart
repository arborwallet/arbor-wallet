
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/models/models.dart';
import '../hive_constants.dart';
import '/api/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'add_screen.dart';
import 'expanded_info_screen.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late final Box walletBox;

  // Delete info from wallet box
  _deleteInfo(int index) {
    walletBox.deleteAt(index);

    print('Item deleted from box at index: $index');
  }

  // Pull to refresh wallet data
  Future<void> _reloadWalletBalances() async {
    WalletService walletService = WalletService();

    for (int index=0; index < walletBox.length; index++) {
      Wallet existingWallet = walletBox.getAt(index);
      int newBalance = await walletService.fetchWalletBalance(existingWallet.address);

      Wallet newWallet = Wallet(
        name: existingWallet.name,
        password: existingWallet.password,
        phrase: existingWallet.phrase,
        privateKey: existingWallet.privateKey,
        publicKey: existingWallet.publicKey,
        address: existingWallet.address,
        fork: existingWallet.fork,
        balance: newBalance,
      );

      walletBox.putAt(index, newWallet);
    }
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    walletBox = Hive.box(HiveConstants.walletBox);
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
      body: RefreshIndicator(
        onRefresh: _reloadWalletBalances,
        child: ValueListenableBuilder(
          valueListenable: walletBox.listenable(),
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
                        builder: (context) => ExpandedInfoScreen(
                          index: index,
                          wallet: walletData,
                        ),
                      ),
                    ),
                    child: Card (
                      elevation: 8,
                      shadowColor: Colors.lightGreen,
                      margin: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                  image: AssetImage("assets/images/chia-logo.png"),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            title: Text('${walletData.fork.name} (${walletData.name})'),
                            subtitle: Text(walletData.fork.ticker.toUpperCase()),
                            trailing: IconButton(
                              onPressed: () => _deleteInfo(index),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          ListTile(
                            // title: Text(walletData.balance.toStringAsFixed(walletData.fork.precision)),
                            title: FittedBox(fit: BoxFit.contain, child: Text(walletData.balanceForDisplay())),
                            subtitle: Text(walletData.address.toString()),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.all(10.0),//change for side padding
                            title: Row(
                              children: <Widget>[
                                Expanded(child: OutlinedButton(onPressed: () {},child: Text("Receive"))),
                                SizedBox(width: 10),
                                Expanded(child: OutlinedButton(onPressed: () {},child: Text("Send"))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      )
    );
  }
}
