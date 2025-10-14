import 'package:flutter/foundation.dart';
import 'package:hcms_revived2/models/localdbmodel/localdbmodel.dart';
import './/helpers/dbhelper.dart';

import 'package:intl/intl.dart';

class NewsAndArticlesProvider extends ChangeNotifier {
  static var newdate = DateTime.now();
  static var formatDate = DateFormat('MMM d, y');
  String formattedDat = formatDate.format(newdate);

  List<NewsAndArticles> _newsArticlesLists = [];

  List<NewsAndArticles> get newsArticlesLists {
    return [..._newsArticlesLists];
  }

  NewsAndArticles findById(String id) {
    return _newsArticlesLists
        .firstWhere((newsarticles) => newsarticles.naId == id);
  }

  void addNewsArticles(
    String caughtTitle,
    String caughtContent,
  ) {
    final newNewsArticlesList = NewsAndArticles(
      naId: DateTime.now().toString(),
      naTimeDisplay: formattedDat,
      naTitle: caughtTitle,
      naContent: caughtContent,
    );
    // _newsArticlesLists.add(newNewsArticlesList);
    _newsArticlesLists.insert(0, newNewsArticlesList);
    notifyListeners();

    DBHelper.insert('news_and_articles', {
      'id': newNewsArticlesList.naId,
      'naTimeDisplay': newNewsArticlesList.naTimeDisplay,
      'naTitle': newNewsArticlesList.naTitle,
      'naContent': newNewsArticlesList.naContent,
    });
  }

  Future<void> fetchAndSetNewsAndArticles() async {
    final dataList = await DBHelper.fetchData('news_and_articles');
    _newsArticlesLists = dataList
        .map((newsArticlesLists) => NewsAndArticles(
              naId: newsArticlesLists['id'],
              naTimeDisplay: newsArticlesLists['naTimeDisplay'],
              naTitle: newsArticlesLists['naTitle'],
              naContent: newsArticlesLists['naContent'],
            ))
        .toList();
    notifyListeners();
  }
}
