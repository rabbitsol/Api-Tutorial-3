import 'dart:convert';

import 'package:apitutorial3/model/usercomplexmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51MCm2JET9uPNaQelbIuvA0LertTImT4LCQeoWQErxf2y4gMWx4r2vZumNsskIIhDXEowN5hItUBGiUHq6n0GXvRJ00G8Qjbq4J';
 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UserComplexModel> userList = [];
  Future<List<UserComplexModel>> getUserApi() async {
    final response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map i in data) {
        print(i['name']);
        userList.add(UserComplexModel.fromJson(i));
      }
      return userList;
    } else {
      return userList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("API Tutorial 3"),
          centerTitle: true,
          actions: [ 
            IconButton(onPressed: (){
              Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: CardField(
          onCardChanged: (card) {
            print(card);
          },
        ));
            }, icon: const Icon(Icons.more_vert))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Center(
            child: Expanded(
                child: FutureBuilder(
                    future: getUserApi(),
                    builder: (context,
                        AsyncSnapshot<List<UserComplexModel>> snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else {
                        return ListView.builder(
                            itemCount: userList.length,
                            itemBuilder: (context, index) {
                              return Material(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: const Color.fromARGB(255, 98, 121, 132),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    ReuseableRow(
                                        title: 'Name',
                                        value: snapshot.data![index].name
                                            .toString()),
                                    ReuseableRow(
                                        title: 'Username',
                                        value: snapshot.data![index].username
                                            .toString()),
                                    ReuseableRow(
                                        title: 'Email',
                                        value: snapshot.data![index].email
                                            .toString()),
                                    ReuseableRow(
                                        title: 'Address',
                                        value: snapshot
                                                .data![index].address!.city
                                                .toString() +
                                            snapshot
                                                .data![index].address!.zipcode
                                                .toString() +
                                            snapshot
                                                .data![index].address!.geo!.lat
                                                .toString() +
                                            snapshot
                                                .data![index].address!.geo!.lng
                                                .toString()),
                                    ReuseableRow(
                                        title: 'Contact No.',
                                        value: snapshot.data![index].phone
                                            .toString()),
                                    ReuseableRow(
                                        title: 'Website',
                                        value: snapshot.data![index].website
                                            .toString()),
                                    ReuseableRow(
                                        title: 'Company',
                                        value: snapshot
                                            .data![index].company!.name
                                            .toString()),
                                  ]),
                                ),
                              );
                            });
                      }
                    })),
          ),
        ));
  }
}

class ReuseableRow extends StatelessWidget {
  const ReuseableRow({super.key, required this.title, required this.value});
  final String title, value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          Text(value, style: const TextStyle(color: Colors.white))
        ],
      ),
    );
  }
}
