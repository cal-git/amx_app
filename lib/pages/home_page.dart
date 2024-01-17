import 'package:amx_app/models/snkapi_cliente_model.dart';
import 'package:amx_app/widgets/custom_textformfield_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var durationSanckBar = const Duration(
    days: 1,
  );
  final player = AudioPlayer();
  DateTime today = DateTime.now();
  bool autofocusNumSerie = false;
  int codInvent = 0;
  int contadorTotal = 0;
  int contadorParcial = 0;
  TextEditingController dateController = TextEditingController();
  TextEditingController numeroSerie = TextEditingController();
  var maskFormater = MaskTextInputFormatter(
    mask: "##/##/####",
    type: MaskAutoCompletionType.lazy,
  );
  final _formkey = GlobalKey<FormState>();
  bool isLoading = true;
  bool isButtonEnabled = false;
  bool enableData = true;
  bool enabledNumeroSerie = false;
  FocusNode focusNode = FocusNode();
  bool enableDropDown = true;
  SnkApiClient snkApiClient = SnkApiClient();
  List<Company> listCompanies = [];
  Company? selectedCompany;
  List<Location> listLocations = [];
  Location? selectedLocation;
  User user = User(
    codusu: 0,
    nomeUsu: '',
    password: '',
    jsessionid: '',
    nomeUsuCplt: '',
    email: '',
  );

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    focusNode.dispose();
  }

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int codUsu = prefs.getInt('codUsu')!;
    String? jsessionid = prefs.getString('jsessionid')!;
    String? nomeUsu = prefs.getString('nomeUsu')!;
    String? password = prefs.getString('password')!;
    String? nomeUsuCplt = prefs.getString('nomeUsuCplt')!;
    String? email = prefs.getString('email')!;

    user = User(
        codusu: codUsu,
        nomeUsu: nomeUsu,
        password: password,
        jsessionid: jsessionid,
        nomeUsuCplt: nomeUsuCplt,
        email: email);

    listCompanies = await snkApiClient.getCompanies(user: user);
    listCompanies.sort((a, b) => a.codEmp.compareTo(b.codEmp));
    selectedCompany = listCompanies.first;

    listLocations = await snkApiClient.getLocations(user: user);
    selectedLocation = listLocations.first;

    setState(() {
      isLoading = false;
    });
  }

  void dropdownCompanyCallback(Location? location) {
    setState(() {
      selectedLocation = location;
    });
  }

  void submitButton() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
    }
  }

  String capitalizeFirstLetter(String text) {
    if (text == null || text.isEmpty) {
      return text;
    }

    List<String> words = text.toLowerCase().split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }

    return words.join(' ');
  }

  Future<int> getcodInvent() async {
    var nuInvNs = await snkApiClient.getNuInvns(
      user: user,
      codEmp: selectedLocation!.codEmp,
      codLocal: selectedLocation!.codLocal,
      dataInvent: dateController.text,
    );

    if (nuInvNs != null) {
      codInvent = nuInvNs.nuInvNs;
      return codInvent;
    } else {
      return 0;
    }
  }

  Future<NumSerie?> postNumSerie() async {
    var numSerie = await snkApiClient.postNumSerie(
        user: user,
        nuInvNs: codInvent,
        numSerie: numeroSerie.text,
        contagem: 1);
    return numSerie;
  }

  Future<int> getContadorTotal() async {
    contadorTotal =
        await snkApiClient.getTotalNumSerie(codInvent: codInvent, user: user);
    return contadorTotal;
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contagem de Inventário',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 26),
        Container(
          padding: const EdgeInsets.all(
            16.0,
          ), // Adicione espaço interno ao redor da Column
          decoration: BoxDecoration(
            // border: Border.all(
            //   color: Colors.black.withOpacity(0.1), // Cor da borda
            //   width: 2.0, // Largura da borda
            // ),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Text('Nome'),
                  const Icon(
                    Icons.emergency_rounded,
                    color: Color(0xFFE12121),
                    size: 10,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    capitalizeFirstLetter(user.nomeUsuCplt),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  const Text('Depósito'),
                  const Icon(
                    Icons.emergency_rounded,
                    color: Color(0xFFE12121),
                    size: 10,
                  ),
                  const SizedBox(width: 7),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFE6E6E6),
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    height: 40,
                    child: DropdownButton<Location>(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      underline: const SizedBox(),
                      iconEnabledColor: Colors.black,
                      focusColor: Colors.white,
                      value: selectedLocation,
                      dropdownColor: Colors.white,
                      onChanged: (Location? location) => setState(() {
                        selectedLocation = location;
                      }),
                      items: listLocations
                          .map<DropdownMenuItem<Location>>((Location location) {
                        return DropdownMenuItem(
                          enabled: enableDropDown,
                          value: location,
                          child: Text(location.text),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  const Text('Data do Inventário'),
                  const Icon(
                    Icons.emergency_rounded,
                    color: Color(0xFFE12121),
                    size: 10,
                  ),
                  const SizedBox(width: 7),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const DatePicker(),
                  //       ),
                  //     );
                  //   },
                  //   child: Text('Data'),
                  // ),
                  CustomTextFormField(
                    enabled: enableData,
                    maxLength: 10,
                    onChanged: (value) async {
                      if (value.length == 10) {
                        codInvent = await getcodInvent();
                        if (codInvent != 0) {
                          contadorTotal = await getContadorTotal();
                          setState(() {
                            isButtonEnabled = true;
                            enableData = false;
                            enabledNumeroSerie = true;
                            autofocusNumSerie = true;
                            enableDropDown = false;
                            //contadorTotal = contadorTotal;
                          });
                        } else {
                          setState(() {
                            enabledNumeroSerie = false;
                          });
                          final snackBar = SnackBar(
                            backgroundColor: Colors.red[900],
                            content: const Text(
                              'Não existe um inventário aberto para esta data no depósito selecionado.',
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
                          setState(() {
                            contadorTotal = 0;
                          });
                        }
                      }
                    },
                    controller: dateController,
                    inputFormatters: [maskFormater],
                  ),
                  const SizedBox(width: 7),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => const Color(0xFF00224b),
                  ),
                  shape: MaterialStateProperty.resolveWith(
                    (states) => RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onPressed: isButtonEnabled
                    ? () {
                        setState(() {
                          enableData = true;
                          enableDropDown = true;
                          enabledNumeroSerie = false;
                          isButtonEnabled = false;
                          numeroSerie.clear();
                          dateController.clear();
                          contadorTotal = 0;
                          contadorParcial = 0;
                        });
                      }
                    : null,
                child: const Text(
                  'Modificar Parâmetros',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(
            16.0,
          ), // Adicione espaço interno ao redor da Column
          decoration: BoxDecoration(
            // border: Border.all(
            //   color: Colors.black.withOpacity(0.1), // Cor da borda
            //   width: 2.0, // Largura da borda
            // ),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Número de Série'),
                  const Icon(
                    Icons.emergency_rounded,
                    color: Color(0xFFE12121),
                    size: 10,
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: SizedBox(
                      width: 115,
                      child: CustomTextFormField(
                        focusNode: focusNode,
                        maxLength: 10,
                        controller: numeroSerie,
                        enabled: enabledNumeroSerie,
                        onFieldSubmitted: (value) async {
                          var numSerie = await postNumSerie();
                          if (numSerie != null && numSerie.status == 0) {
                            if (numSerie.statusMessage!
                                .contains('já foi lido')) {
                              await player.play(
                                AssetSource(
                                    'sounds/dcc765_LeituraDuplicada.wav'),
                              );
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red[900],
                                content: const Text(
                                  'Número de série já lido nesta contagem.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              numeroSerie.clear();
                              FocusScope.of(context).requestFocus(focusNode);
                            } else {
                              await player.play(
                                AssetSource('sounds/dcc765_Erro.wav'),
                              );
                              setState(() {
                                enabledNumeroSerie = false;
                              });
                              final snackBar = SnackBar(
                                duration: durationSanckBar,
                                backgroundColor: Colors.red[900],
                                content: const Text(
                                  'Número de série inválido.',
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
                                    setState(() {
                                      numeroSerie.clear();
                                      enabledNumeroSerie = true;
                                    });
                                    FocusScope.of(context)
                                        .requestFocus(focusNode);
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          } else {
                            setState(() {
                              contadorParcial = contadorParcial + 1;
                            });
                            await player.play(
                              AssetSource('sounds/dcc765_LeituraOK.wav'),
                            );
                            numeroSerie.clear();
                            FocusScope.of(context).requestFocus(focusNode);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () => setState(() {}),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => const Color(0xFF00224b),
                ),
                shape: MaterialStateProperty.resolveWith(
                  (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              child: Text(
                'Contador Parcial: $contadorParcial',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                contadorTotal = contadorTotal + contadorParcial;
                contadorParcial = 0;
              }),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => const Color(0xFF00224b),
                ),
                shape: MaterialStateProperty.resolveWith(
                  (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              child: const Text(
                'Zerar Contador Parcial',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => setState(() {}),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => const Color(0xFF00224b),
                ),
                shape: MaterialStateProperty.resolveWith(
                  (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              child: Text(
                'Contador Total: $contadorTotal',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
