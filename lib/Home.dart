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

  Future<List<Post>> _recuperarPostagens() async {
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

  @override
  Widget build(BuildContext context) {
    String resposta = "";
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço avançado"),
      ),
      body: FutureBuilder<List<Post>>(
        future: _recuperarPostagens(),
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
      ),
    );
  }
}
