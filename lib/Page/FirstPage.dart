import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/AutogeneratedResponse.dart';
import 'SecondPage.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key, required this.title});

  final String title;

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<Autogenerated> autogenerated = [];

  Future fetchEndpoint() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      setState(() {
        autogenerated = parsed.map<Autogenerated>((json) => Autogenerated.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to fetch posts');
    }
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchEndpoint();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.separated(
        itemCount: autogenerated.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Text(autogenerated[index].userId!.toString()),
            trailing: Text(autogenerated[index].id!.toString()),
            title: Text(autogenerated[index].title!.toString()),
            subtitle: Text(autogenerated[index].body!.toString()),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondPage(id: autogenerated[index].id!.toString())),
              );
            },
          );
        },
      ),
    );
  }
}