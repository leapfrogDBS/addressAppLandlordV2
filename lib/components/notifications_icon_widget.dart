import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notifications_icon_model.dart';
export 'notifications_icon_model.dart';

class NotificationsIconWidget extends StatefulWidget {
  const NotificationsIconWidget({
    super.key,
    required this.noOfNotifications,
  });

  final int? noOfNotifications;

  @override
  State<NotificationsIconWidget> createState() =>
      _NotificationsIconWidgetState();
}

class _NotificationsIconWidgetState extends State<NotificationsIconWidget> {
  late NotificationsIconModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationsIconModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 20.0, 0.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          context.goNamed(NotificationsWidget.routeName);
        },
        child: badges.Badge(
          badgeContent: Text(
            valueOrDefault<String>(
              widget!.noOfNotifications.toString(),
              '18',
            ),
            style: FlutterFlowTheme.of(context).titleSmall.override(
                  font: GoogleFonts.figtree(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleSmall.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleSmall.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).tertiary,
                  fontSize: 11.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleSmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                ),
          ),
          showBadge: widget!.noOfNotifications! > 0,
          shape: badges.BadgeShape.circle,
          badgeColor: FlutterFlowTheme.of(context).primaryBackground,
          elevation: 4.0,
          padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
          position: badges.BadgePosition.topEnd(),
          animationType: badges.BadgeAnimationType.scale,
          toAnimate: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
            child: Icon(
              Icons.notifications_sharp,
              color: FlutterFlowTheme.of(context).primaryBackground,
              size: 24.0,
            ),
          ),
        ),
      ),
    );
  }
}
