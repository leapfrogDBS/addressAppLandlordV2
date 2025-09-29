import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'article_widget.dart' show ArticleWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ArticleModel extends FlutterFlowModel<ArticleWidget> {
  ///  Local state fields for this page.

  String? title;

  String? imagePath;

  String? content;

  List<String> blogContent = [];
  void addToBlogContent(String item) => blogContent.add(item);
  void removeFromBlogContent(String item) => blogContent.remove(item);
  void removeAtIndexFromBlogContent(int index) => blogContent.removeAt(index);
  void insertAtIndexInBlogContent(int index, String item) =>
      blogContent.insert(index, item);
  void updateBlogContentAtIndex(int index, Function(String) updateFn) =>
      blogContent[index] = updateFn(blogContent[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
