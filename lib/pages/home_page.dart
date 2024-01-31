import 'package:amx_app/models/snkapi_cliente_model.dart';
import 'package:amx_app/responsive/constants.dart';
import 'package:amx_app/widgets/custom_textformfield_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DateFormat f = DateFormat('yyyy-MM-dd hh:mm');
  String formattedDate = '';
  bool autofocusNumSerie = false;
  int codInvent = 0;
  int contadorTotal = 0;
  int contadorParcial = 0;
  TextEditingController dateController = TextEditingController();
  TextEditingController numeroSerie = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          myDrawer,
          Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Contagem de Inventário',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                        borderSide: BorderSide(
                          color: Color(0xFF79747E),
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                        borderSide: BorderSide(
                          color: Color(0xFF00224b),
                          width: 2.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      hintText: 'Data',
                      label: Text('Data'),
                      suffixIcon: Icon(
                        Icons.date_range_outlined,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Visibility(
                      child: Container(
                        width: 400,
                        height: 300,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(
                                  (0.10 * 255).round(), 0, 28, 75),
                              offset: const Offset(12.0, 12.0),
                              blurRadius: 62.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                        ),
                        child: SfDateRangePicker(
                          selectionMode: DateRangePickerSelectionMode.single,
                          headerStyle: const DateRangePickerHeaderStyle(
                            backgroundColor: Color(0xFF00224b),
                            textAlign: TextAlign.center,
                            textStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          showNavigationArrow: true,
                          selectionColor: const Color(0xFF00224b),
                          todayHighlightColor: const Color(0xFF00224b),
                          monthCellStyle: const DateRangePickerMonthCellStyle(
                            todayTextStyle: TextStyle(
                              color: Color(0xFF00224b),
                            ),
                          ),
                        ),
                      ),
                    ),
                    DropdownButton<Location>(
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
                  ],
                ),
                // ElevatedButton(
                //     onPressed: () async {
                //       var date = await showDatePickerDialog(
                //         context: context,
                //         initialDate: DateTime.timestamp(),
                //         minDate: DateTime(2020, 10, 10),
                //         maxDate: DateTime(2024, 12, 31),
                //         currentDate: DateTime(2022, 10, 15),
                //         selectedDate: DateTime(2022, 10, 16),
                //         currentDateDecoration: const BoxDecoration(),
                //         currentDateTextStyle: const TextStyle(),
                //         daysOfTheWeekTextStyle: const TextStyle(),
                //         disbaledCellsDecoration: const BoxDecoration(),
                //         disbaledCellsTextStyle: const TextStyle(),
                //         enabledCellsDecoration: const BoxDecoration(),
                //         enabledCellsTextStyle: const TextStyle(),
                //         selectedCellDecoration: const BoxDecoration(),
                //         selectedCellTextStyle: const TextStyle(),
                //         leadingDateTextStyle: const TextStyle(
                //           fontFamily: 'Inter',
                //           fontSize: 14,
                //         ),
                //         slidersColor: const Color(0xFF00224b),
                //         highlightColor: const Color(0xFF00224b),
                //         slidersSize: 20,
                //         splashColor: Colors.grey,
                //         splashRadius: 40,
                //         centerLeadingDate: true,
                //       );
                //       if (date != null) {
                //         formattedDate = DateFormat('dd/MM/yyyy').format(date);
                //         print(formattedDate);
                //       }
                //     },
                //     child: Text('Calendário'),
                //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
