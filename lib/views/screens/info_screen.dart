import 'package:flutter/material.dart';
import 'package:gallery/core/api/services.dart';
import 'package:gallery/core/constants/asset_paths.dart';
import 'package:gallery/core/constants/hive_constants.dart';
import 'package:gallery/core/models/models.dart';
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
  void _deleteInfo(int index) {
    walletBox.deleteAt(index);

    print('Item deleted from box at index: $index');
  }

  // Pull to refresh wallet data
  Future<void> _reloadWalletBalances() async {
    var walletService = WalletService();

    for (var index = 0; index < walletBox.length; index++) {
      Wallet existingWallet = walletBox.getAt(index);
      var newBalance =
          await walletService.fetchWalletBalance(existingWallet.address);

      var newWallet = Wallet(
        name: existingWallet.name,
        password: existingWallet.password,
        phrase: existingWallet.phrase,
        privateKey: existingWallet.privateKey,
        publicKey: existingWallet.publicKey,
        address: existingWallet.address,
        fork: existingWallet.fork,
        balance: newBalance,
      );

      await walletBox.putAt(index, newWallet);
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
            // ignore: avoid_types_on_closure_parameters
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
                      child: Card(
                        elevation: 8,
                        shadowColor: Colors.lightGreen,
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(AssetPaths.chiaLogo),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              title: Text(
                                  '${walletData.fork.name} (${walletData.name})'),
                              subtitle:
                                  Text(walletData.fork.ticker.toUpperCase()),
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
                              title: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(walletData.balanceForDisplay())),
                              subtitle: Text(walletData.address.toString()),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.all(
                                  10.0), //change for side padding
                              title: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: OutlinedButton(
                                          onPressed: () {},
                                          child: const Text('Receive'))),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: OutlinedButton(
                                          onPressed: () {},
                                          child: const Text('Send'))),
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
        ));
  }
}
