// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/actions/scroll_to_widget_key.dart';

class ScrollAnchor extends StatefulWidget {
  const ScrollAnchor({
    super.key,
    this.width,
    this.height,
    required this.anchorName,
  });

  final double? width;
  final double? height;
  final String anchorName;

  @override
  State<ScrollAnchor> createState() => _ScrollAnchorState();
}

class _ScrollAnchorState extends State<ScrollAnchor> {
  final GlobalKey _key = GlobalKey();
  @override
  void initState() {
    super.initState();
    scrollAnchors[widget.anchorName] = _key;
  }

  @override
  void dispose() {
    if (scrollAnchors[widget.anchorName] == _key) {
      scrollAnchors.remove(widget.anchorName);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _key,
      width: widget.width ?? 1,
      height: widget.height ?? 1,
    );
  }
}
