import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webtoon/model/webtoon_detail_model.dart';
import 'package:webtoon/model/webtoon_episode_model.dart';
import 'package:webtoon/services/api_services.dart';

import '../widgets/episode_widget.dart';

class DatailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DatailScreen(
      {super.key, required this.title, required this.thumb, required this.id});

  @override
  State<DatailScreen> createState() => _DatailScreenState();
}

class _DatailScreenState extends State<DatailScreen> {
  late Future<WebToonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likeToons = prefs.getStringList('likedToons');
    if (likeToons != null) {
      if (likeToons.contains(widget.id) == true) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      await prefs.setStringList('likedToons', []);
    }
  }

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }

  onHeartTap() async {
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }
      await prefs.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        foregroundColor: Colors.green,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_outline_outlined),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: widget.id,
                child: Container(
                  width: 250,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 15,
                            offset: const Offset(10, 10),
                            color: Colors.black.withOpacity(0.5))
                      ]),
                  child: Image.network(
                    widget.thumb,
                    headers: const {
                      "User-Agent":
                          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          FutureBuilder(
            future: webtoon,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Text(
                      snapshot.data!.about,
                      style: const TextStyle(fontSize: 16),
                      maxLines: 7,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${snapshot.data!.genre} / ${snapshot.data!.age}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                );
              }
              return const Text("...");
            },
          ),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder(
            future: episodes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                    child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var episode = snapshot.data![index];
                    return Episode(episode: episode, webtoonId: widget.id);
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 15,
                  ),
                ));
              }
              return Container();
            },
          )
        ]),
      ),
    );
  }
}
