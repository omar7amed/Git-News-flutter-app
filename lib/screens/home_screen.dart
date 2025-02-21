import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:git_news/newscode/repos.dart';
import 'package:git_news/screens/catogries_screen.dart';
import 'package:git_news/screens/details_screen.dart';
import 'package:git_news/view_model/news_view_model.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum Filterlist { sabq, abcnews, bbcNews, cbcNews, cnn, alJazeeraEnglish }

class _HomeScreenState extends State<HomeScreen> {
  final NewsViewModel _newsViewModel = NewsViewModel();
  String selectedSource = '';
  Filterlist? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoryScreen()),
            );
          },
          icon: Image.asset('images/box.png', height: 25, width: 25),
        ),
        centerTitle: true,
        title: Text(
          'News',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        actions: [
          PopupMenuButton<Filterlist>(
            initialValue: selectedMenu,
            icon: Icon(Icons.more_vert),
            onSelected: (Filterlist item) {
              setState(() {
                selectedMenu = item;

                switch (item) {
                  case Filterlist.sabq:
                    selectedSource = 'sabq';
                    break;
                  case Filterlist.bbcNews:
                    selectedSource = 'BBC-News';
                    break;
                  case Filterlist.abcnews:
                    selectedSource = 'ABC-News';
                    break;
                  case Filterlist.cbcNews:
                    selectedSource = 'CBC-news';
                    break;
                  case Filterlist.cnn:
                    selectedSource = 'CNN';
                    break;
                  case Filterlist.alJazeeraEnglish:
                    selectedSource = 'al-jazeera-english';
                    break;
                }
              });
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<Filterlist>>[
                  PopupMenuItem<Filterlist>(
                    value: Filterlist.bbcNews,
                    child: Text('BBC News'),
                  ),
                  PopupMenuItem<Filterlist>(
                    value: Filterlist.abcnews,
                    child: Text('ABC-News'),
                  ),
                  PopupMenuItem<Filterlist>(
                    value: Filterlist.cnn,
                    child: Text('CNN'),
                  ),
                  PopupMenuItem<Filterlist>(
                    value: Filterlist.alJazeeraEnglish,
                    child: Text('Al Jazeera English'),
                  ),
                  PopupMenuItem<Filterlist>(
                    value: Filterlist.cbcNews,
                    child: Text('CBC News'),
                  ),
                ],
          ),
        ],
      ),
      body: ListView(
        children: [
          // Existing Headlines Section
          SizedBox(
            height: 350,
            width: 20,
            child: FutureBuilder<repos>(
              future: _newsViewModel.fetchnews(source: selectedSource),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(size: 50, color: Colors.black),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    snapshot.data?.articles == null) {
                  return Center(child: Text('No data available'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data?.articles?.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 350,
                              width: 250,
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      snapshot
                                                  .data
                                                  ?.articles?[index]
                                                  .urlToImage
                                                  ?.isNotEmpty ==
                                              true
                                          ? snapshot
                                              .data!
                                              .articles![index]
                                              .urlToImage!
                                          : '',
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) =>
                                          Container(child: spinkit2),
                                  errorWidget:
                                      (context, url, error) => Image.asset(
                                        'images/default_news.jpg',
                                        fit: BoxFit.contain,
                                        width: 3,
                                        height: 20,
                                      ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              child: Card(
                                elevation: 5,
                                color: Colors.white.withOpacity(0.9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  width: 240,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              snapshot
                                                      .data!
                                                      .articles![index]
                                                      .source
                                                      ?.name ??
                                                  'Unknown',
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                color: Colors.blue.shade900,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            _formatDate(
                                              snapshot
                                                      .data!
                                                      .articles![index]
                                                      .publishedAt ??
                                                  '',
                                            ),
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        snapshot.data!.articles![index].title
                                                ?.toString() ??
                                            'No title',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          height: 1.3,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (
                                                        context,
                                                      ) => DetailsScreen(
                                                        newsImage:
                                                            snapshot
                                                                .data!
                                                                .articles![index]
                                                                .urlToImage
                                                                .toString(),
                                                        newsTitle:
                                                            snapshot
                                                                .data!
                                                                .articles![index]
                                                                .title
                                                                .toString(),
                                                        newsData:
                                                            snapshot
                                                                .data!
                                                                .articles![index]
                                                                .publishedAt
                                                                .toString(),
                                                        author:
                                                            snapshot
                                                                .data!
                                                                .articles![index]
                                                                .author
                                                                .toString(),
                                                        description:
                                                            snapshot
                                                                .data!
                                                                .articles![index]
                                                                .description
                                                                .toString(),
                                                        content:
                                                            snapshot
                                                                .data!
                                                                .articles![index]
                                                                .content
                                                                .toString(),
                                                        source:
                                                            snapshot
                                                                .data!
                                                                .articles![index]
                                                                .source!
                                                                .name
                                                                .toString(),
                                                      ),
                                                ),
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: Size(60, 30),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Read More',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: Colors.blue.shade700,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  size: 14,
                                                  color: Colors.blue.shade700,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),

          FutureBuilder<repos>(
            future: _newsViewModel.fetchnews(category: 'technology'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SpinKitFadingCircle(size: 50, color: Colors.black),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data?.articles == null) {
                return Center(child: Text('No data available'));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data?.articles?.length ?? 0,
                itemBuilder: (context, index) {
                  final article = snapshot.data!.articles![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: article.urlToImage ?? '',
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => Container(
                                    height: 100,
                                    width: 100,
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) => Container(
                                    height: 100,
                                    width: 100,
                                    color: Colors.grey[200],
                                    child: Icon(Icons.error),
                                  ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article.title ?? 'No title',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      article.source?.name ?? 'Unknown',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      _formatDate(article.publishedAt ?? ''),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

String _formatDate(String dateString) {
  try {
    final DateTime date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  } catch (e) {
    return 'Date unavailable';
  }
}

const spinkit2 = SpinKitChasingDots(color: Colors.black, size: 50);
