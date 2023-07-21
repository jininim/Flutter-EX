class WebtoonFavoriteModel {
  final String title, thumb;

  WebtoonFavoriteModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'];
}
