import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sismov/home_screen.dart';
import 'package:mysql1/mysql1.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

String nome = '';
String usuario = '';

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  var loginController = TextEditingController();
  var senhaController = TextEditingController();
  var isObscure = true.obs;

  void mudaTela(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return HomeScreen();
        },
      ),
    );
  }

  login(String login, senha) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: '192.168.25.88',
        port: 3306,
        user: 'root',
        db: 'lanali',
        password: 'teste'));

    var results = await conn.query('''SELECT nome, login, senha 
          FROM adm_funcionario_credencial 
          INNER JOIN cad_funcionario using(idfuncionario)
          WHERE login = '$login' AND senha = '$senha' ''');
    for (var row in results) {
      nome = row[0];
      usuario = row[1];
    }
    if (results.isEmpty) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Login Inválido"),
                content: Text("Usuário e/ou senha inválido"),
                actions: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: Text("OK"))
                ],
              ));
    } else {
      mudaTela(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Bem vindo $nome!'),
      ));
      loginController.clear();
      senhaController.clear();
    }
    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 219, 219),
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
                    height: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                        child: Column(
                          children: [
                            const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "SisMov",
                                    style: TextStyle(
                                        height: 5,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  // email
                                  TextFormField(
                                    controller: loginController,
                                    validator: (val) => val == ""
                                        ? "Por favor digite um usuário"
                                        : null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Colors.black,
                                      ),
                                      hintText: "Usuário",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
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
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  // senha
                                  Obx(
                                    () => TextFormField(
                                      controller: senhaController,
                                      obscureText: isObscure.value,
                                      validator: (val) => val == ""
                                          ? "Por favor digite uma senha"
                                          : null,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          color: Colors.black,
                                        ),
                                        suffixIcon: Obx(() => GestureDetector(
                                              onTap: () {
                                                isObscure.value =
                                                    !isObscure.value;
                                              },
                                              child: Icon(
                                                isObscure.value
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Colors.black,
                                              ),
                                            )),
                                        hintText: "Senha",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
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
                                    height: 18,
                                  ),
                                  // botao
                                  Material(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      onTap: () {
                                        login(loginController.text,
                                            senhaController.text);
                                      },
                                      borderRadius: BorderRadius.circular(30),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 28,
                                        ),
                                        child: Text(
                                          "Entrar",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
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
