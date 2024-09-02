import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project1/book_model.dart';

class BookDetails extends StatefulWidget {
  final BookModel book;

  const BookDetails({super.key, required this.book});

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  bool isLoadingAdd = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Details Page",
            style: TextStyle(color: Colors.black),
          ),
          leading: InkWell(
              onTap: () => Navigator.pushNamed(context, '/main_page'),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                Image.network(
                  widget.book.imageUrl.toString(),
                  width: 150,
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.book.name.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      Text(widget.book.author.toString()),
                      SizedBox(
                          child: Text(
                        widget.book.desciption.toString(),
                      )),
                      Text('\$${widget.book.price.toString()}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 10,
                      ),
                      isLoadingAdd == true
                          ? const CircularProgressIndicator(
                              color: Colors.redAccent,
                            )
                          : ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.redAccent)),
                              onPressed: () async {
                                setState(() {
                                  isLoadingAdd = true;
                                });
                                var request = await http.post(
                                    Uri.parse(
                                        'http://fromproject.ir/00/add-cart.php'),
                                    body: {
                                      'name': widget.book.name.toString(),
                                      'desciption': widget.book.desciption.toString(),
                                      'price': widget.book.price.toString(),
                                      'author': widget.book.author.toString(),
                                      'imageurl':widget.book.imageUrl.toString(),
                                    });
                                print(request.statusCode);
                                if (request.statusCode == 200) {
                                  setState(() {
                                    isLoadingAdd = false;
                                  });
                                } else {
                                  print(request.statusCode);
                                }
                              },
                              child: Text("ADD TO CART")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
