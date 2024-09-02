import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:project1/book_details.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'book_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double value = 25.0;
  late SharedPreferences _pref;
  String prefKey = "value";
  List<BookModel> lisDataBook = <BookModel>[];
  bool isLoading = false;
  void loadFonts() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      value = _pref.getDouble(prefKey) ?? 25.0;
    });
  }


  getHttp() async {
    var request =
        await http.get(Uri.parse('http://fromproject.ir/00/get-books.php'));

    var response = convert.jsonDecode(request.body);

    if (request.statusCode == 200) {
      for (int i = 0; i < response.length - 1; i++) {
        lisDataBook.add(BookModel(
            id: response['$i']['id'],
            name: response['$i']['name'],
            desciption: response['$i']['desciption'],
            price: response['$i']['price'],
            author: response['$i']['author'],
            imageUrl: response['$i']['imageUrl']));
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    isLoading = true;
    loadFonts();
    getHttp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadFonts();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const InkWell(
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: const Text(
            "Shopping App",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.red,
        ),
        bottomNavigationBar: GNav(tabs: [
          const GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.shopping_basket,
            text: 'Store',
            onPressed: () {
              Navigator.pushNamed(context, '/store');
            },
          ),
          GButton(
            icon: Icons.settings,
            text: 'Settings',
            onPressed: () {
              Navigator.pushNamed(context, '/setting_page');
            },
          ),
        ]),
        body: isLoading == true
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: lisDataBook.length,
                      itemBuilder: (BuildContext context, int index) {
                        final book = lisDataBook[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookDetails(
                                          book: book,
                                        )));
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(25, 8, 25, 8),
                            height: 149,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 10,
                                  color: Color(0x1a5282ff),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child:
                                        Image.network(book.imageUrl.toString()),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          book.name.toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: value,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          book.author.toString(),
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: value - 2),
                                        ), 
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          book.desciption.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(fontSize: value - 2),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "\€${book.price.toString()}",
                                          style: TextStyle(fontSize: value - 5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
