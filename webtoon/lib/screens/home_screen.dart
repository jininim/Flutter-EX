import 'package:flutter/material.dart';
import 'package:webtoon/model/webtoon_Model.dart';
import 'package:webtoon/services/api_services.dart';
import 'package:webtoon/widgets/webtoon_widget.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService().getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: const Text(
          "오늘의 웹툰",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        foregroundColor: Colors.green,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, futuerResult) {
          if (futuerResult.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(child: makeList(futuerResult)),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> futuerResult) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: futuerResult.data!.length,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      itemBuilder: (context, index) {
        var webtoon = futuerResult.data![index];
        return Webtoon(
            title: webtoon.title, thumb: webtoon.thumb, id: webtoon.id);
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 40,
      ),
    );
  }
}
