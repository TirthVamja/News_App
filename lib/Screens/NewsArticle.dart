import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'NewsDetails.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';

class NewsArticle extends StatefulWidget {
  final NewsDetails nd;
  NewsArticle(this.nd);
  @override
  _NewsArticleState createState() => _NewsArticleState(nd);
}

class _NewsArticleState extends State<NewsArticle> {
  final NewsDetails nd;
  _NewsArticleState(this.nd);

  openWebview(url) async {
    if (await canLaunch(url)) {
      launch(url);
      print("Inside Open Web View");
    } else
      throw 'Can not launch';
  }

  String _truncateChars(s) {
    var c = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (s[i] != "[") {
        c = c + 1;
      } else {
        c = c + 1;
        break;
      }
    }
    String result = s.substring(0, s.length - c);
    return result;
  }

  playAudio() async {
    final FlutterTts flutterTts = FlutterTts();
    print(await flutterTts.getLanguages);
    await flutterTts.setSpeechRate(1);
    await flutterTts.setPitch(1);
    await flutterTts
        .speak(nd.description + "        " + _truncateChars(nd.content));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  nd.title,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network("${nd.urlToImage}"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  nd.description,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _truncateChars(nd.content),
                  style: TextStyle(
                    wordSpacing: 2,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  openWebview(nd.url);
                },
                child: Text(
                  'View Full Article', //title
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center, //aligment
                ),
              ),
              // Divider(color: Colors.black),/
              Container(
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Share.share('View Complete Article at ${nd.url}',
                            subject: 'Hey Just Go Through the Article !!');
                        print("Whatsapp Clicked");
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          width: (MediaQuery.of(context).size.width / 2) - 40,
                          child: Row(
                            children: [
                              Text("Share this \nArticle",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(
                                Icons.share,
                                color: Colors.white,
                                size: 35,
                              )
                            ],
                          )),
                    ),
                    Container(
                        height: 60,
                        child: VerticalDivider(
                          color: Colors.black,
                          thickness: 1,
                        )),
                    InkWell(
                      onTap: () {
                        print("Microphone Selected");
                        playAudio();
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.mic,
                              size: 40,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Listen To the\n News",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
