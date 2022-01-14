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
      "title":"testando método post",
      "body":"nova postagem adicionado ao servidor"
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

  void _enviarPostagensPOST_BY_CLASS() async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(_urlBase+"/posts"));
    request.headers.set('content-type', 'application/json');

    Post post = new Post(1267, 1, "testando método post", "nova postagem adicionado ao servidor");

    request.add(utf8.encode(json.encode(post.toJson())));
    HttpClientResponse response = await request.close();

    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    int statusCodes = await response.statusCode;
    httpClient.close();
    print("RESPOSTA!"+reply.toString());
    print("STATUS CODE " + statusCodes.toString());
  }

  void _atualizarPostagensPUT() async {

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.putUrl(Uri.parse(_urlBase+"/posts/2"));
    request.headers.set('content-type', 'application/json');

    var jsonMap = {
      "userId":120,
      "id":2,
      "title":"testando método put",
      "body":"atualizando postagem"
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

  void _atualizarPostagensPATCH() async {

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.patchUrl(Uri.parse(_urlBase+"/posts/2"));
    request.headers.set('content-type', 'application/json');

    var jsonMap = {
      "userId":120,
      "body":"atualizando postagem"
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

  void _deletarPostagensDELETE() async {

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.deleteUrl(Uri.parse(_urlBase+"/posts/2"));
    HttpClientResponse response = await request.close();
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: _enviarPostagensPOST_BY_CLASS,
                    child: Text("SALVAR"),
                ),
                ElevatedButton(
                  onPressed: _atualizarPostagensPUT,
                  child: Text("ATUALIZAR"),
                ),
                ElevatedButton(
                  onPressed: _deletarPostagensDELETE,
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
