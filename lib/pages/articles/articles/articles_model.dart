import '/backend/backend.dart';
import '/components/main_header_widget.dart';
import '/components/subscribe_block_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/nav/slide_navigation/slide_navigation_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'articles_widget.dart' show ArticlesWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class ArticlesModel extends FlutterFlowModel<ArticlesWidget> {
  ///  Local state fields for this page.

  List<dynamic> articleList1 = [];
  void addToArticleList1(dynamic item) => articleList1.add(item);
  void removeFromArticleList1(dynamic item) => articleList1.remove(item);
  void removeAtIndexFromArticleList1(int index) => articleList1.removeAt(index);
  void insertAtIndexInArticleList1(int index, dynamic item) =>
      articleList1.insert(index, item);
  void updateArticleList1AtIndex(int index, Function(dynamic) updateFn) =>
      articleList1[index] = updateFn(articleList1[index]);

  ///  State fields for stateful widgets in this page.

  // Model for SlideNavigation component.
  late SlideNavigationModel slideNavigationModel;
  // Model for mainHeader component.
  late MainHeaderModel mainHeaderModel;
  // Model for subscribeBlock component.
  late SubscribeBlockModel subscribeBlockModel;

  @override
  void initState(BuildContext context) {
    slideNavigationModel = createModel(context, () => SlideNavigationModel());
    mainHeaderModel = createModel(context, () => MainHeaderModel());
    subscribeBlockModel = createModel(context, () => SubscribeBlockModel());
  }

  @override
  void dispose() {
    slideNavigationModel.dispose();
    mainHeaderModel.dispose();
    subscribeBlockModel.dispose();
  }
}
