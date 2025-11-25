import '/components/main_header_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
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

  ///  State fields for stateful widgets in this page.

  // Model for mainHeader component.
  late MainHeaderModel mainHeaderModel;

  @override
  void initState(BuildContext context) {
    mainHeaderModel = createModel(context, () => MainHeaderModel());
  }

  @override
  void dispose() {
    mainHeaderModel.dispose();
  }
}
