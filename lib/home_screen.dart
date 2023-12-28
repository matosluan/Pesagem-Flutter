import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:sismov/pesagem_screen.dart';
import 'package:mysql1/mysql1.dart';
import 'package:sismov/login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String code = '';

class _HomeScreenState extends State<HomeScreen> {
  escaner() async {
    // code = code = await FlutterBarcodeScanner.scanBarcode(
    //     "#FFFFFF", "Cancelar", true, ScanMode.BARCODE);
    code = '1000';
    if (code.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return PesagemScreen();
          },
        ),
      );
    }
    return code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 219, 219),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('$nome'),
              accountEmail: Text('$usuario'),
              currentAccountPicture: const CircleAvatar(
                child: ClipOval(
                    child: Icon(
                  Icons.person,
                  color: Colors.white,
                )),
                backgroundColor: Colors.black,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    fit: BoxFit.fill, image: AssetImage('images/fundo.jpg')),
              ),
            ),
            ListTile(
              leading: Icon(Icons.leaderboard_rounded),
              title: Text('Pesagem'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return PesagemScreen();
                    },
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
                title: Text('Sair'),
                leading: Icon(Icons.exit_to_app),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return LoginScreen();
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Escaner'),
        backgroundColor: Colors.black,
      ),
      body: LayoutBuilder(
        builder: (context, cons) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: cons.maxHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.document_scanner_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    escaner();
                                  },
                                  label: Text(
                                    "Escanear",
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 0, 0, 0),
                                    fixedSize: const Size(210, 50),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
