import 'package:flutter/material.dart';
import 'package:project1/book_details.dart';
import 'package:project1/book_model.dart';
import 'package:project1/main_page.dart';
import 'package:project1/setting_page.dart';
import 'package:project1/store.dart';
import 'package:project1/theme.dart';
import 'package:provider/provider.dart';


void main() async{
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      routes: {
        '/book_details': (context) => BookDetails(
              book: BookModel(id: '0', name: 'name', desciption: 'desciption', price: 'price', author: 'author', imageUrl: 'imageUrl'),
            ),
        '/main_page': (context) => const MainPage(),
        '/setting_page': (context) => const Settings(),
        '/store':(context) => StorPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const MainPage(), // You need to provide a Book instance here
    );
  }
}
