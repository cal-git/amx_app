import 'package:amx_app/widgets/validator_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/snkapi_cliente_model.dart';
import '../widgets/custom_textformfield_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hasErrorNomeUsu = false;
  bool hasErrorPassword = false;
  var duration = const Duration(
      days: 1,
      hours: 0,
      minutes: 0,
      seconds: 0,
      milliseconds: 0,
      microseconds: 0);
  bool _isChecked = true;
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeUsuController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Validator validator = Validator();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _fazerLogin() async {
    String nomeUsu = _nomeUsuController.text;
    String password = _passwordController.text;
    final snkapiClient = SnkApiClient();

    try {
      User user =
          await snkapiClient.login(nomeUsu: nomeUsu, password: password);
      String jsessionid = user.jsessionid;
      String nomeUsuCplt = user.nomeUsuCplt;
      String email = user.email;
      int codUsu = user.codusu;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('jsessionid', jsessionid);
      prefs.setString('nomeUsu', nomeUsu);
      prefs.setString('password', password);
      prefs.setString('nomeUsuCplt', nomeUsuCplt);
      prefs.setString('email', email);
      prefs.setInt('codUsu', codUsu);

      if (!context.mounted) return;
      Navigator.of(context).pushReplacementNamed('/Home');
    } catch (e) {
      final snackBar = SnackBar(
        backgroundColor: Colors.red[900],
        content: const Text(
          'Usuário ou senha inválido.',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'OK',
          onPressed: () {
            //TODO
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      isChecked();
      _fazerLogin();
    }
  }

  void isChecked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isChecked', _isChecked);
  }

  void _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedNomeUsu = prefs.getString('nomeUsu');
    String? savedPassword = prefs.getString('password');
    bool? isChecked = prefs.getBool('isChecked');

    if (isChecked == true && savedNomeUsu != null && savedPassword != null) {
      setState(() {
        _nomeUsuController.text = savedNomeUsu;
        _passwordController.text = savedPassword;
      });
    }
  }

  bool get _botaoHabilitado =>
      _nomeUsuController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  void _habilitarBotao() {
    setState(() {
      
    });
  }

  void openURL() async {
    final Uri urlSnkAmx =
        Uri.parse('http://americanflex.snk.ativy.com:40031/mge/');
    if (!await launchUrl(urlSnkAmx)) {
      throw Exception('Não foi possível abrir a URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = 1300;
          bool removerImagem = constraints.maxWidth < maxWidth;
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (!removerImagem)
                const Image(
                  image: AssetImage('assets/images/Modelo 1_v2.jpg'),
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft,
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 430,
                      height: 520,
                      padding: const EdgeInsets.symmetric(vertical: 73),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(
                                  (0.10 * 255).round(), 0, 28, 75),
                              offset: const Offset(12.0, 12.0),
                              blurRadius: 62.0,
                              spreadRadius: 0.0,
                            ),
                          ]),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26.0),
                                color: const Color(0xFFC4CED7).withOpacity(0.3),
                              ),
                              child: const Image(
                                image:
                                    AssetImage('assets/images/user_747376.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text('Bem Vindo(a).',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            ),
                            const SizedBox(height: 25),
                            CustomTextFormField(
                              hasError: hasErrorNomeUsu,
                              onFieldSubmitted: (value) {
                                {
                                  if (hasErrorNomeUsu == true ||
                                      hasErrorPassword == true) {
                                    return;
                                  } else {
                                    _submitForm();
                                  }
                                }
                              },
                              onChanged: (value) {
                                _nomeUsuController.text = value;
                                _habilitarBotao();
                                if (value.isEmpty) {
                                  setState(() {
                                    hasErrorNomeUsu = true;
                                  });
                                } else {
                                  setState(() {
                                    hasErrorNomeUsu = false;
                                  });
                                }
                              },
                              height: 52,
                              obscureText: false,
                              hintText: hasErrorNomeUsu? 'Informe um usuário' : 'Usuário',
                              hintStyle: hasErrorNomeUsu? const TextStyle(color: Color(0xFFD32F2F)) : null,
                              controller: _nomeUsuController,
                              autofocus: false,
                            ),
                            const SizedBox(height: 8),
                            CustomTextFormField(
                              hasError: hasErrorPassword,
                              onChanged: (value) {
                                _passwordController.text = value;
                                _habilitarBotao();
                                if (value.isEmpty) {
                                  setState(() {
                                    hasErrorPassword = true;
                                  });
                                } else {
                                  setState(() {
                                    hasErrorPassword = false;
                                  });
                                }
                              },
                              onFieldSubmitted: (value) {
                                {
                                  if (hasErrorNomeUsu == true ||
                                      hasErrorPassword == true) {
                                    return;
                                  } else {
                                    _submitForm();
                                  }
                                }
                              },
                              obscureText: _obscureText,
                              height: 52,
                              hintText: hasErrorPassword? 'Informe uma senha' : 'Senha',
                              hintStyle: hasErrorPassword? const TextStyle(color: Color(0xFFD32F2F)) : null,
                              controller: _passwordController,
                              suffixIcon: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: hasErrorPassword
                                        ? const Color(0xFFD32F2F)
                                        : const Color(0xFF00224b),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Checkbox(
                                  value: _isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isChecked = value!;
                                      isChecked();
                                    });
                                  },
                                  activeColor: const Color(0xFF00224b),
                                  checkColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xFFD0D5DD),
                                  ),
                                ),
                                Text(
                                  'Lembrar-me',
                                  style: textTheme.bodyMedium,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 112.5),
                                  child: GestureDetector(
                                    onTap: () => {
                                      openURL(),
                                    },
                                    child: const MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Text(
                                        'Esqueceu a Senha?',
                                        style: TextStyle(
                                          color: Color(0xFF00224b),
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            MouseRegion(
                              cursor: _botaoHabilitado
                                  ? SystemMouseCursors.click
                                  : SystemMouseCursors.basic,
                              child: GestureDetector(
                                onTap: () async {
                                  _botaoHabilitado ? _submitForm() : null;
                                },
                                child: Container(
                                  width: 360,
                                  height: 44,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF00224b),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Center(
                                    child: Text(
                                      'ENTRAR',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
