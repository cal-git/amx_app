import 'package:amx_app/responsive/constants.dart';
import 'package:amx_app/widgets/custom_painter_widget.dart';
import 'package:amx_app/widgets/validator_widget.dart';
import 'package:amx_app/widgets/window_buttons_widget.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          myWindowTitleBarBox,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/Logo AMX Azul.png'),
                ),
                const SizedBox(height: 32),
                Text(
                  'Bem-vindo(a).',
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Entre com seu usuário Sankhya e Senha.',
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextFormField(
                        obscureText: false,
                        hintText: 'Usuário',
                        controller: _nomeUsuController,
                        onFieldSubmitted: (value) => _submitForm(),
                        validator: (value) =>
                            validator.usernameValidator(value),
                        autofocus: false,
                        labelText: 'Usuário',
                      ),
                      const SizedBox(height: 12),
                      CustomTextFormField(
                        obscureText: _obscureText,
                        hintText: 'Senha',
                        controller: _passwordController,
                        onFieldSubmitted: (value) => _submitForm(),
                        validator: (value) =>
                            validator.passwordValidator(value),
                        autofocus: false,
                        labelText: 'Senha',
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
                              color: const Color(0xFF00224b),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
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
                      const SizedBox(height: 32),
                      Container(
                        width: 360,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () async {
                            _submitForm();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                              (states) => const Color(0xFF00224b),
                            ),
                            shape: MaterialStateProperty.resolveWith(
                              (states) => const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          child: const Text(
                            'ENTRAR',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
