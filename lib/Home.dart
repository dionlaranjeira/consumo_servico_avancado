import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _preco = "";
  Future<Map> _obterPreco() async{
    var url = "https://www.blockchain.com/ticker";
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    
     Map<String, dynamic> respostaMap = json.decode(reply);

     return respostaMap;

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _obterPreco(),
      builder: (context, snapshot){
        String resultado = "";
        switch(snapshot.connectionState){
          case ConnectionState.none:
            resultado = "Conexão nome";
            break;
          case ConnectionState.waiting:
            resultado = "Conexão waiting";
            break;
          case ConnectionState.active:
            resultado = "Conexão active";
            break;
          case ConnectionState.done:


            if(snapshot.hasError){
              resultado = "Erro ao carregar os dados";
            }
            else{
              double valor = snapshot.data!["BRL"]["buy"];
              resultado = "Preço do bitcoin: ${valor.toString()}";
            }

            break;
        }

        return Center(
          child: Text(resultado),
        );
      },
    );
  }
}
