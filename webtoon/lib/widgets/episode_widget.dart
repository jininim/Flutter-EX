import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webtoon/model/webtoon_episode_model.dart';

class Episode extends StatelessWidget {
  const Episode({
    super.key,
    required this.episode,
    // ignore: non_constant_identifier_names
    required this.webtoonId,
  });
  // ignore: non_constant_identifier_names
  final String webtoonId;
  final WebtoonEpisodeModel episode;

  onButtonTap() async {
    await launchUrlString(
        "https://comic.naver.com/webtoon/detail?titleId=$webtoonId&no=${int.parse(episode.id) + 1}");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  blurRadius: 5,
                  offset: const Offset(8, 6),
                  color: Colors.green.withOpacity(0.4))
            ],
            color: Colors.green),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              episode.title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white,
            ),
          ]),
        ),
      ),
    );
  }
}
