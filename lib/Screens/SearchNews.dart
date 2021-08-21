import 'package:flutter/material.dart';
import 'NewsDetails.dart';
import 'NewsArticle.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SearchNews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GetTextFieldValue(),
    );
  }
}

class GetTextFieldValue extends StatefulWidget {
  _TextFieldValueState createState() => _TextFieldValueState();
}

class _TextFieldValueState extends State<GetTextFieldValue> {
  // String apiKey = 'e452f52f81984a5f82e6645572903d4d';
  String apiKey = 'c8fdb18f039e4c12a7fa4cede6bd7d87';
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search Keywords";
  String newQuery = "";
  var response;
  NewsDetails nsd;

  openWebview(index) async {
    String url = NewsDetails.fromJson(response["articles"][index]).url;
    if (await canLaunch(url)) {
      launch(url);
      print("Inside Open Web View");
    } else
      throw 'Can not launch';
  }

  Future<void> fetchNews() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("Country") == null) {
      prefs.setString("Country", "IN");
    }
    response = await http.get(Uri.parse(
        ("https://newsapi.org/v2/everything?q=" +
            newQuery +
            "&language=en&apiKey=" +
            apiKey)));
    var data = jsonDecode(response.body);
    response = data;
    if (data['status'] == "ok") {
      if (mounted)
        setState(() {
          print(prefs.getString("Country"));
          print(searchQuery);
          print("Inside FetchNews setstate");
        });
    } else {
      throw Exception();
    }
  }

  Widget _buildSearchField() {
    return TextField(
      showCursor: true,
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          if (_searchQueryController == null ||
              _searchQueryController.text.isEmpty) {
            return;
          }
          _searchQuery();
        },
      ),
    ];
  }

  void updateSearchQuery(String newQuery) {
    searchQuery = newQuery;
  }

  void _searchQuery() {
    setState(() {
      _isSearching = true;
      var a = searchQuery.split(" ");
      var st = a.join(" OR ");
      newQuery = st;
      fetchNews();
    });
  }

  openNewPage(index) {
    print("Opening New Page");
    NewsDetails nwd = NewsDetails.fromJson(response["articles"][index]);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewsArticle(nwd);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        title: _buildSearchField(),
        actions: _buildActions(),
      ),
      body: !_isSearching
          ? Container()
          : RefreshIndicator(
              child: response != null
                  ? response["articles"].length != 0
                      ? ListView.builder(
                          itemCount: response["articles"].length,
                          itemBuilder: (context, index) {
                            nsd = NewsDetails.fromJson(
                                response["articles"][index]);
                            return InkWell(
                                onTap: () {
                                  openNewPage(index);
                                },
                                child: Card(
                                    child: nsd.urlToImage != null &&
                                            nsd.title != null
                                        ? Container(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Image.network(
                                                      "${nsd.urlToImage}"),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(10),
                                                ),
                                                Text(
                                                  "${nsd.title}",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(5),
                                                ),
                                                Text("${nsd.description}"),
                                                Padding(
                                                  padding: EdgeInsets.all(10),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container()));
                          },
                        )
                      : Center(
                          child: ListView(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
                              child: Icon(
                                Icons.speaker_notes_off,
                                size: 170,
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Center(
                              child: Text(
                                "Sorry.. No Articles Found",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 23.0,
                                    fontFamily: 'Robosto',
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              ),
                            )
                          ],
                        ))
                  : Center(child: CircularProgressIndicator()),
              onRefresh: () {
                return Future.delayed(Duration(milliseconds: 500), () {
                  setState(() {
                    fetchNews();
                    print("Inside Refresh");
                  });
                });
              },
            ),
    );
  }
}
