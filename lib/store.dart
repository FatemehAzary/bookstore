import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:project1/shop_model.dart';

class StorPage extends StatefulWidget {
  @override
  State<StorPage> createState() => _StorPageState();
}

class _StorPageState extends State<StorPage> {
  List<ShopModel> lisDataBook = [];
  bool isLoadingGetHttp = false;
  bool isLoadingDelethttp = false;

  getHttp() async {
    var request =
        await http.get(Uri.parse('http://fromproject.ir/00/get-cart.php'));

    var response = convert.jsonDecode(request.body);
    if (request.statusCode == 200) {
      for (int i = 0; i < response.length - 1; i++) {
        lisDataBook.add(ShopModel(
            id: response['$i']['id'],
            name: response['$i']['name'],
            desciption: response['$i']['desciption'],
            price: response['$i']['price'],
            author: response['$i']['author'],
            imageUrl: response['$i']['imageUrl']));
      }

      setState(() {
        isLoadingGetHttp = false;
      });
    }
  }

  deletHttp(id) async {
    var request = await http.post(
        Uri.parse('http://fromproject.ir/00/delete-cart.php'),
        body: {'id': id});

    print(request.statusCode);
    if (request.statusCode == 200) {
      setState(() {
        isLoadingDelethttp = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isLoadingGetHttp = true;
    getHttp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Store Page",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
        width: double.infinity,
        child: isLoadingGetHttp == true
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: lisDataBook.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final bookData = lisDataBook[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 150,
                      height: 150,
                      color: Colors.white60,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Image.network(
                                  bookData.imageUrl.toString(),
                                  width: 150,
                                  height: 200,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(bookData.name.toString()),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.redAccent)),
                                    onPressed: () {
                                      deletHttp(bookData.id);
                                      lisDataBook.removeAt(index);
                                    },
                                    child: const Text("Remove frome cart"),
                                  )
                                ],
                              ),
                            ]),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
