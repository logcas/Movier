import 'package:flutter/material.dart';
import 'views/index.dart';
import 'views/movie-detail.dart';

Map<String, WidgetBuilder> routes = {
  '/': (context) => IndexScaffold(),
  'detail': (context) => MovieDetailPage()
};