import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:news24x7/Screens/SearchNews.dart';
import 'Screens/all.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String cC = "in";

  void getCC() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String temp = prefs.getString("Country").toLowerCase();
      cC = temp != null ? temp : "IN";
    });
  }

  @override
  Widget build(BuildContext context) {
    getCC();
    return DefaultTabController(
        length: 9,
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "News24x7",
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                bottom: PreferredSize(
                    child: TabBar(
                        isScrollable: true,
                        unselectedLabelColor: Colors.white.withOpacity(0.4),
                        indicatorColor: Colors.white,
                        tabs: [
                          Tab(
                            child: Row(children: <Widget>[
                              Icon(Icons.public),
                              Text(" Global News")
                            ]),
                          ),
                          Tab(
                            child: Row(children: <Widget>[
                              Icon(Icons.trending_up),
                              Text(" Trending")
                            ]),
                          ),
                          Tab(
                            child: Row(children: <Widget>[
                              Icon(Icons.menu_book),
                              Text(" General")
                            ]),
                          ),
                          Tab(
                            child: Row(children: <Widget>[
                              Icon(Icons.movie),
                              Text(" Entertainment")
                            ]),
                          ),
                          Tab(
                            child: Row(children: <Widget>[
                              Icon(Icons.account_balance_wallet),
                              Text(" Business")
                            ]),
                          ),
                          Tab(
                            child: Row(children: <Widget>[
                              Icon(Icons.favorite),
                              Text(" Health")
                            ]),
                          ),
                          Tab(
                            child: Row(children: <Widget>[
                              Icon(Icons.school),
                              Text(" Science")
                            ]),
                          ),
                          Tab(
                            child: Row(children: <Widget>[
                              Icon(Icons.sports_cricket),
                              Text(" Sports")
                            ]),
                          ),
                          Tab(
                            child: Row(children: <Widget>[
                              Icon(Icons.tablet_android),
                              Text(" Technology")
                            ]),
                          ),
                        ]),
                    preferredSize: Size.fromHeight(30.0)),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.search_rounded),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return SearchNews();
                        }));
                      }),
                  IconButton(
                      icon: Image.asset('icons/flags/png/$cC.png',
                          package: 'country_icons'),
                      // icon: Icon(Icons.location_on),
                      onPressed: () {
                        showCountryPicker(
                          context: context,
                          countryFilter: <String>[
                            'AE',
                            'AR',
                            'AT',
                            'AU',
                            'BE',
                            'BG',
                            'BR',
                            'CA',
                            'CH',
                            'CN',
                            'CO',
                            'CU',
                            'CZ',
                            'DE',
                            'EG',
                            'FR',
                            'GB',
                            'GR',
                            'HK',
                            'HU',
                            'ID',
                            'IE',
                            'IL',
                            'IN',
                            'IT',
                            'JP',
                            'KR',
                            'LT',
                            'LV',
                            'MA',
                            'MX',
                            'MY',
                            'NG',
                            'NL',
                            'NO',
                            'NZ',
                            'PH',
                            'PL',
                            'PT',
                            'RO',
                            'RS',
                            'RU',
                            'SA',
                            'SE',
                            'SG',
                            'SI',
                            'SK',
                            'TH',
                            'TR',
                            'TW',
                            'UA',
                            'US',
                            'VE',
                            'ZA'
                          ],
                          showPhoneCode: false,
                          onSelect: (Country country) async {
                            final prefs = await SharedPreferences.getInstance();
                            setState(() {
                              int ind = DefaultTabController.of(context).index;
                              print("Index of Selected Tab is $ind");
                              prefs.setString("Country", country.countryCode);
                              getCC();
                            });
                            print('Select country: ${country.countryCode}');
                          },
                        );
                      })
                ],
              ),
              body: TabBarView(
                children: <Widget>[
                  Container(
                    child: Center(
                      child: GlobalNews(),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: TrendingNews(),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: GeneralNews(),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: EntNews(),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: BusinessNews(),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: HealthNews(),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: ScienceNews(),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: SportsNews(),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: TechNews(),
                    ),
                  ),
                ],
              ));
        }));
  }
}
