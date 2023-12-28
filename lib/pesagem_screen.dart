import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sismov/db.dart';
import 'package:sismov/home_screen.dart';
import 'package:sismov/login_screen.dart';
import 'package:sismov/solicitacao.dart';
import 'package:mysql1/mysql1.dart';

class PesagemScreen extends StatefulWidget {
  @override
  State<PesagemScreen> createState() => _PesagemScreenState();
}

var db = Mysql();
List<TextEditingController> listController = [TextEditingController()];

class _PesagemScreenState extends State<PesagemScreen> {
  salvaPeso(String peso, codEnsaio, idItemEnsaio, lastId) async {
    print(lastId);
    if (lastId != '') {
      String sql = '''INSERT INTO mvt_rastreabilidade_ensaio
              (idMvtRastreabilidadeEnsaio, idRQ, idFuncionario, dataHora, status,
              codEnsaio, idItemEnsaio, valorDinamico)
              VALUES(0, 84, 1, "", "Pesagem feita", "$codEnsaio", $idItemEnsaio, "Pesagem(g): $peso")''';
      await db.getConnection().then((conn) async {
        await conn.query(sql);
        await conn.close();
      }).onError((error, stackTrace) {
        print(error);
        return null;
      });
    } else {
      String sql = '''UPDATE mvt_rastreabilidade_ensaio
              SET valorDinamico = "Pesagem(g): $peso"
              WHERE idMvtRastreabilidadeEnsaio = $lastId''';
      await db.getConnection().then((conn) async {
        await conn.query(sql);
        await conn.close();
      }).onError((error, stackTrace) {
        print(error);
        return null;
      });
    }
  }

  Future<List<Solicitacao>> getMSQLData() async {
    String sql =
        '''SELECT ce.codEnsaio, descricao, idItemEnsaio,idsolicitacao, rr.idMvtRastreabilidadeEnsaio
              FROM mvt_item_ensaio cr
              left JOIN mvt_rastreabilidade_ensaio rr USING(idItemEnsaio)
              inner JOIN cad_ensaio ce USING(idensaio)
              WHERE idsolicitacao = $code''';

    final List<Solicitacao> mylist = [];
    await db.getConnection().then((conn) async {
      listController.clear();
      await conn.query(sql).then((results) {
        for (var res in results) {
          final Solicitacao sol = Solicitacao(
            codEnsaio: res['codEnsaio'].toString(),
            lastId: res['idMvtRastreabilidadeEnsaio'].toString(),
            descricao: res['descricao'].toString(),
            idItemEnsaio: res['idItemEnsaio'].toString(),
          );
          mylist.add(sol);
          listController.add(TextEditingController());
        }
      }).onError((error, stackTrace) {
        print(error);
        return null;
      });
      await conn.close();
    });
    return mylist;
  }

  confirmaPeso(String peso, codEnsaio, idItemEnsaio, lastId) {
    if (peso.isEmpty) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Peso inválido"),
                content: const Text("Insira uma pesagem válida!"),
                actions: <Widget>[
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: const Text("OK"))
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Salvar?"),
                content: const Text("Deseja salvar a pesagem?"),
                actions: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      onPressed: () => Navigator.pop(context, 'Cancelar'),
                      child: Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.black),
                      )),
                  ElevatedButton(
                    onPressed: () {
                      salvaPeso(peso, codEnsaio, idItemEnsaio, lastId);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Pesagem salva com sucesso!')));
                      Navigator.pop(context, 'Cancelar');
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: const Text('Salvar'),
                  ),
                ],
              ));
    }
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
              accountName: Text(nome),
              accountEmail: Text(usuario),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.black,
                child: ClipOval(
                    child: Icon(
                  Icons.person,
                  color: Colors.white,
                )),
              ),
              decoration: const BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    fit: BoxFit.fill, image: AssetImage('images/fundo.jpg')),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner_outlined),
              title: const Text('Escaner'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return HomeScreen();
                    },
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
                title: const Text('Sair'),
                leading: const Icon(Icons.exit_to_app),
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
        title: Text('Pesagem da solicitação: $code'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: showFutureDBData(),
      ),
    );
  }

  showFutureDBData() {
    return FutureBuilder<List<Solicitacao>>(
        future: getMSQLData(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final sol = snapshot.data![index];
              return Card(
                elevation: 2.5,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 60,
                                child: Text(
                                  sol.codEnsaio + ": " + sol.descricao,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              SizedBox(
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          285,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: listController[index],
                                        decoration: InputDecoration(
                                          hintText: "Peso",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.blue,
                                            ),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    SizedBox(
                                      child: IconButton(
                                        icon: const Icon(
                                            Icons.check_circle_rounded),
                                        color: Colors.green,
                                        onPressed: () {
                                          confirmaPeso(
                                              listController[index].text,
                                              sol.codEnsaio,
                                              sol.idItemEnsaio,
                                              sol.lastId);
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    SizedBox(
                                      child: IconButton(
                                        icon: const Icon(Icons.cancel),
                                        color: Colors.red,
                                        onPressed: () {
                                          listController[index].text = '';
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Row(children: <Widget>[
                                  SizedBox(
                                    child: Text(
                                      sol.idItemEnsaio,
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.green),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Text(
                                      sol.lastId,
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.red),
                                    ),
                                  )
                                ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
