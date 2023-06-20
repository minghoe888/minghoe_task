import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/AutogeneratedResponse.dart';
import '../model/DetailsResponse.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key, required this.id});

  final String id;

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  Autogenerated autogenerated = Autogenerated();
  List<Details> details = [];
  List<Details> _foundUsers = [];
  bool isLoaded = false;

  Future fetchEndpoint() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/${widget.id}'));
    if (response.statusCode == 200) {
      final jsonresponse = json.decode(response.body);
      setState(() {
        autogenerated = Autogenerated.fromJson(jsonresponse);
        fetchDetail();
        isLoaded = true;
      });
    } else {
      throw Exception('Failed to fetch posts');
    }
  }

  Future fetchDetail() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/comments?postId=${widget.id}'));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      setState(() {
        details = parsed.map<Details>((json) => Details.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to fetch posts');
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Details> results = [];
    if (enteredKeyword.isEmpty) {
      results = details;
    } else {
      results = details
          .where((user) =>
          user.name!.toLowerCase().contains(enteredKeyword.toLowerCase()) || user.email!.toLowerCase().contains(enteredKeyword.toLowerCase()) || user.body!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundUsers = results;
    });
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
        title: const Text('Second Page'),
      ),
      body: isLoaded ?
      Column(
        children: [
          Expanded(
            child: ListTile(
              leading: Text(autogenerated.userId!.toString()),
              trailing: Text(autogenerated.id!.toString()),
              title: Text(autogenerated.title!.toString()),
              subtitle: Text(autogenerated.body!.toString()),
            ),
          ),
          TextField(
            onChanged: (value) => _runFilter(value),
            decoration: const InputDecoration(
                labelText: 'Search', suffixIcon: Icon(Icons.search)),
          ),
          Expanded(
            child:  _foundUsers.isNotEmpty ? ListView.separated(
              itemCount: _foundUsers.length,
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Text(_foundUsers[index].postId!.toString()),
                  trailing: Text(_foundUsers[index].id!.toString()),
                  title: Text('${_foundUsers[index].email!} Name:- ${_foundUsers[index].name!}'),
                  subtitle: Text(_foundUsers[index].body!.toString()),
                );
              },
            ) : ListView.separated(
              itemCount: details.length,
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Text(details[index].postId!.toString()),
                  trailing: Text(details[index].id!.toString()),
                  title: Text('${details[index].email!} Name:- ${details[index].name!}'),
                  subtitle: Text(details[index].body!.toString()),
                );
              },
            ),
          ),
        ],
      ): Container(),
    );
  }
}