import 'dart:convert';
import 'package:http/http.dart' as http;

SnkApiClient client = SnkApiClient();
void main() async {
  var user = await client.login(nomeUsu: 'cvfaquim', password: 'solrac@CV99');
  // var contadorTotal = await client.getTotalNumSerie(codInvent: 1, user: user);
  // print(contadorTotal);
  // var listLocations = await client.getLocations(user: user);
  // for (var location in listLocations) {
  // }
  // var inventNs = await client.getNuInvns(
  //     user: user, codEmp: 1, codLocal: 1, dataInvet: '06/10/2023');
  // print(inventNs.nuInvNs);

  var numSerie = await client.postNumSerie(
      user: user, contagem: 1, nuInvNs: 1, numSerie: '0057885588');
}

class SnkApiClient {
  final String strHost = "americanflex.snk.ativy.com";
  final String strPort = '40031';

  final int lngTimeout = 59000;
  var client = http.Client();

  Future<User> login({
    required String nomeUsu,
    required String password,
  }) async {
    try {
      nomeUsu = nomeUsu.toUpperCase();
      final Uri uri = Uri.parse(
          'http://$strHost:$strPort/mge/services.sbr?serviceName=MobileLoginSP.login&outputType=json');

      var loginResponse = await client.post(uri,
          body: jsonEncode({
            "serviceName": "MobileLoginSP.login",
            "requestBody": {
              "NOMUSU": {"\$": nomeUsu},
              "INTERNO": {"\$": password},
              "KEEPCONNECTED": {"\$": "S"}
            }
          }));

      if (loginResponse.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(loginResponse.bodyBytes)) as Map;
        String jsessionid = decodedResponse['responseBody']['jsessionid']['\$'];

        final Uri uri = Uri.parse(
            'http://$strHost:$strPort/mge/services.sbr?serviceName=DbExplorerSP.executeQuery&outputType=json');
        Map<String, String> headers = {
          'Cookie': 'JSESSIONID=$jsessionid',
        };

        var userResponse = await client.post(uri,
            headers: headers,
            body: jsonEncode({
              "serviceName": "DbExplorerSP.executeQuery",
              "requestBody": {
                "sql":
                    "SELECT CODUSU, NOMEUSU, NOMEUSUCPLT, EMAIL FROM TSIUSU WHERE CODUSU=STP_GET_CODUSULOGADO()"
              }
            }));

        if (userResponse.statusCode == 200) {
          var decodedResponse = jsonDecode(utf8.decode(userResponse.bodyBytes));
          decodedResponse =
              decodedResponse['responseBody']['rows'][0] as List<dynamic>;
          return User.fromJson(
              password: password,
              jsessionid: jsessionid,
              json: decodedResponse);
        } else {
          throw Exception('Falha ao carregar dados do usuário $nomeUsu');
        }
      } else {
        throw Exception('Falha no login');
      }
    } catch (e) {
      throw Exception('Falha no login: $e');
    } finally {
      //client.close();
    }
  }

  Future<List<Company>> getCompanies({required User user}) async {
    try {
      final Uri uri = Uri.parse(
          'http://$strHost:$strPort/mge/service.sbr?serviceName=CRUDServiceProvider.loadRecords&outputType=json');

      Map<String, String> headers = {
        'Cookie': 'JSESSIONID=${user.jsessionid}',
      };
      var companyResponse = await client.post(uri,
          headers: headers,
          body: jsonEncode({
            "serviceName": "CRUDServiceProvider.loadRecords",
            "requestBody": {
              "dataSet": {
                "rootEntity": "Empresa",
                "includePresentationFields": "S",
                "offsetPage": "0",
                "entity": {
                  "fieldset": {
                    "list": "CODEMP,NOMEFANTASIA,RAZAOSOCIAL,RAZAOABREV"
                  }
                }
              }
            }
          }));
      var json = jsonDecode(utf8.decode(companyResponse.bodyBytes));
      json = json['responseBody']['entities']['entity'];
      if (json is List) {
        return json.map((item) => Company.fromJson(json: item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    } finally {}
  }

  Future<List<Location>> getLocations({required User user}) async {
    Uri uri = Uri.parse(
        'http://$strHost:$strPort/mge/service.sbr?serviceName=DbExplorerSP.executeQuery&outputType=json');

    Map<String, String> headers = {
      'Cookie': 'JSESSIONID=${user.jsessionid}',
    };

    try {
      var response = await client.post(uri,
          headers: headers,
          body: jsonEncode({
            "serviceName": "DbExplorerSP.executeQuery",
            "requestBody": {"sql": "SELECT * FROM AD_AMXDEPOSITO"}
          }));
      if (response.statusCode == 200) {
        var json = jsonDecode(utf8.decode(response.bodyBytes));
        json = json['responseBody']['rows'] as List<dynamic>;
        return json
            .map<Location>((json) => Location.fromJson(json: json))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    } finally {
      //client.close();
    }
  }

  Future<InventNs?> getNuInvns({
    required User user,
    required int codEmp,
    required int codLocal,
    required String dataInvent,
  }) async {
    Uri uri = Uri.parse(
        'http://$strHost:$strPort/mge/service.sbr?serviceName=DbExplorerSP.executeQuery&outputType=json');

    Map<String, String> headers = {
      'Cookie': 'JSESSIONID=${user.jsessionid}',
    };

    try {
      var response = await client.post(uri,
          headers: headers,
          body: jsonEncode({
            "serviceName": "DbExplorerSP.executeQuery",
            "requestBody": {
              "sql":
                  "SELECT * FROM AD_INVENTNS WHERE CODLOCAL=$codLocal AND CODEMP=$codEmp AND SITUACAO='ABERTO' AND DTINV=TO_DATE('$dataInvent','dd/mm/yyyy')"
            }
          }));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        json = json['responseBody']['rows'][0] as List<dynamic>;
        return InventNs.fromJson(json: json);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    } finally {
      //client.close();
    }
  }

  Future<NumSerie?> postNumSerie({
    required User user,
    required int nuInvNs,
    required String numSerie,
    required int contagem,
    String? dataLeitura,
  }) async {
    Uri uri = Uri.parse(
        'http://$strHost:$strPort/mge/service.sbr?serviceName=DatasetSP.save&outputType=json');

    Map<String, String> headers = {
      'Cookie': 'JSESSIONID=${user.jsessionid}',
    };

    try {
      var response = await client.post(
        uri,
        headers: headers,
        body: jsonEncode(
          {
            "serviceName": "DatasetSP.save",
            "requestBody": {
              "entityName": "AD_INVENTNSLEITURA",
              "standAlone": false,
              "fields": ["NUINVNS", "CONTAGEM", "NUMSERIE", "CODUSU"],
              "records": [
                {
                  "values": {
                    "0": "$nuInvNs",
                    "1": "$contagem",
                    "2": "$numSerie",
                    "3": "${user.codusu}"
                  }
                }
              ]
            },
          },
        ),
      );
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        print(json);
        return NumSerie.fromJson(json: json);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    } finally {
      //client.close();
    }
  }

  Future<int> getTotalNumSerie({
    required int codInvent,
    required User user,
  }) async {
    Uri uri = Uri.parse(
        'http://$strHost:$strPort/mge/service.sbr?serviceName=DbExplorerSP.executeQuery&outputType=json');

    Map<String, String> headers = {
      'Cookie': 'JSESSIONID=${user.jsessionid}',
    };

    var response = await client.post(
      uri,
      headers: headers,
      body: jsonEncode(
        {
          "serviceName": "DbExplorerSP.executeQuery",
          "requestBody": {
            "sql":
                "SELECT COUNT(*) FROM AD_INVENTNSLEITURA WHERE NUINVNS = $codInvent"
          },
        },
      ),
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      json = json['responseBody']['rows'][0][0];
      return json;
    } else {
      return 0;
    }
  }
}

class User {
  int codusu;
  String nomeUsu;
  String password;
  String jsessionid;
  String nomeUsuCplt;
  String email;

  User(
      {required this.codusu,
      required this.nomeUsu,
      required this.password,
      required this.jsessionid,
      required this.nomeUsuCplt,
      required this.email});

  factory User.fromJson(
      {required String password,
      required String jsessionid,
      required List<dynamic> json}) {
    return User(
      password: password,
      jsessionid: jsessionid,
      codusu: json[0] as int,
      nomeUsu: json[1] as String,
      nomeUsuCplt: json[2] as String,
      email: json[3] as String,
    );
  }
}

class Company {
  final int codEmp;
  final String nomeFantasia;
  final String razaoSocial;
  final String razaoAbrev;

  Company({
    required this.codEmp,
    required this.nomeFantasia,
    required this.razaoSocial,
    required this.razaoAbrev,
  });

  factory Company.fromJson({required Map json}) {
    return Company(
      codEmp: int.parse(json['f0']['\$']),
      nomeFantasia: json['f1']['\$'] as String,
      razaoSocial: json['f2']['\$'] as String,
      razaoAbrev: json['f3']['\$'] as String,
    );
  }
}

class Location {
  final int codEmp;
  final String nomeFantasia;
  final int codLocal;
  final String descrLocal;
  final String trprod;
  final String trtransf;
  final String value;
  final String text;

  Location({
    required this.codEmp,
    required this.nomeFantasia,
    required this.codLocal,
    required this.descrLocal,
    required this.trprod,
    required this.trtransf,
    required this.value,
    required this.text,
  });

  factory Location.fromJson({required List<dynamic> json}) {
    return Location(
      codEmp: json[0] as int,
      nomeFantasia: json[1] as String,
      codLocal: json[2] as int,
      descrLocal: json[3] as String,
      trprod: json[4] as String,
      trtransf: json[5] as String,
      value: json[6] as String,
      text: json[7] as String,
    );
  }
}

class InventNs {
  final int nuInvNs;
  final int codEmp;
  final String dtInv;
  final String situacao;
  final int codLocal;

  InventNs({
    required this.nuInvNs,
    required this.codEmp,
    required this.dtInv,
    required this.situacao,
    required this.codLocal,
  });

  factory InventNs.fromJson({required List<dynamic> json}) {
    return InventNs(
        nuInvNs: json[0] as int,
        codEmp: json[1] as int,
        dtInv: json[2] as String,
        situacao: json[3] as String,
        codLocal: json[4] as int);
  }
}

class NumSerie {
  final int status;
  final String? statusMessage;
  final String? numSerie;

  NumSerie({
    required this.status,
    this.statusMessage,
    this.numSerie,
  });

  factory NumSerie.fromJson({required Map json}) {
    int statusNumSerie = int.parse(json['status']);
    if (statusNumSerie == 0) {
      return NumSerie(
          status: statusNumSerie,
          statusMessage: json['statusMessage'] as String);
    } else {
      return NumSerie(
        status: statusNumSerie,
        numSerie: json['responseBody']['result'][0][2],
      );
    }
  }
}
