import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'Post.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _urlBase = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _recuperarPostagensGET() async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request =
        await httpClient.getUrl(Uri.parse(_urlBase + "/posts"));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();

    var respostaJson = json.decode(reply);

    List<Post> postagens = [];
    for (var post in respostaJson) {
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      postagens.add(p);
    }

    return postagens;
  }




  void _enviarPostagensPOST() async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(_urlBase+"/posts"));
    request.headers.set('content-type', 'application/json');

    var jsonMap = {
      "userId":1267,
      "id":null,
      "title":"testando post",
      "body":"novo post adicionado ao servidor"
    };

    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();

    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    int statusCodes = await response.statusCode;
    httpClient.close();
    print("RESPOSTA!"+reply.toString());
    print("STATUS CODE " + statusCodes.toString());
  }

  @override
  Widget build(BuildContext context) {
    String resposta = "";
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço avançado"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                    onPressed: _enviarPostagensPOST,
                    child: Text("SALVAR"),
                ),
                ElevatedButton(
                  onPressed: (){},
                  child: Text("ATUALIZAR"),
                ),
                ElevatedButton(
                  onPressed: (){},
                  child: Text("EXCLUIR"),
                ),
              ],
            ),

           Expanded(child:  FutureBuilder<List<Post>>(
             future: _recuperarPostagensGET(),
             builder: (context, snapshot) {
               switch (snapshot.connectionState) {
                 case ConnectionState.none:
                   break;
                 case ConnectionState.waiting:
                   return Center(
                     child: CircularProgressIndicator(),
                   );
                   break;
                 case ConnectionState.active:
                 case ConnectionState.done:
                   if (snapshot.hasError) {
                     resposta = "Erro ao carregar";
                   } else {
                     return ListView.builder(
                         itemCount: snapshot.data?.length,
                         itemBuilder: (context, index) {
                           List<Post>? lista = snapshot.data;
                           Post post = lista![index];

                           return ListTile(
                             title: Text(post.title),
                             subtitle: Text(post.body),
                           );
                         });
                   }
                   break;
               }
               return Center(
                 child: Text(resposta),
               );
             },
           ),),

          ],
        ),
      ),
    );
  }
}
