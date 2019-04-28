import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:test_proj/feed_source.dart';

class MainPageviewScreen extends StatefulWidget {
  @override
  _MainPageviewScreenState createState() => _MainPageviewScreenState();
}

class _MainPageviewScreenState extends State<MainPageviewScreen>
    with AutomaticKeepAliveClientMixin {
  Future<List> _future;
  ScrollController controller;
  String mainUrl = 'https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.nasa.gov%2Frss%2Fdyn%2Fbreaking_news.rss';
  

  Future<List<Items>> _getMainFeed() async {
    return await http.get(mainUrl).then((res) {
      FeedSource mainf = FeedSource.fromJson(json.decode(res.body.toString()));
      return mainf.items;
    });
  }


  @override
  void initState() {
    super.initState();
    _future = _getMainFeed();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: <Widget>[
        FutureBuilder<List>(
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<Items> items = snapshot.data;
              return PageView(
                children: items.map(
                  (mainMap) {
                    return Material(
                      color: Colors.grey,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: 800.0,
                            height: 1000.0,
                            child: Image.network(mainMap.enclosure.link),  //-- I want to do this with precaching
                            // Builder(builder: (BuildContext context) {
                            //   precacheImage(
                            //       AdvancedNetworkImage(
                            //         mainMap.enclosure.link,
                            //         useDiskCache: true,
                            //         fallbackAssetImage: 'assets/launch_image.png',
                            //         cacheRule: CacheRule(
                            //           storeDirectory: StoreDirectoryType.temporary,
                            //           maxAge: const Duration(days: 7),
                            //         ),
                            //       ),
                            //       context);
                            //       return SizedBox();
                            // }),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
              );
            }
          },
          future: _future,
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
