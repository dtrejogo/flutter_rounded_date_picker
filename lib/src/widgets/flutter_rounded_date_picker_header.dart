import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/src/era_mode.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_date_picker_style.dart';

class FlutterRoundedDatePickerHeader extends StatelessWidget {
  const FlutterRoundedDatePickerHeader(
      {Key? key,
      required this.selectedDate,
      required this.mode,
      required this.onModeChanged,
      required this.orientation,
      required this.era,
      required this.borderRadius,
      this.imageHeader,
      this.description = "",
      this.fontFamily,
      this.style})
      : super(key: key);

  final DateTime selectedDate;
  final DatePickerMode mode;
  final ValueChanged<DatePickerMode> onModeChanged;
  final Orientation orientation;
  final MaterialRoundedDatePickerStyle? style;

  /// Era custom
  final EraMode era;

  /// Border
  final double borderRadius;

  ///  Header
  final ImageProvider? imageHeader;

  /// Header description
  final String description;

  /// Font
  final String? fontFamily;

  void _handleChangeMode(DatePickerMode value) {
    if (value != mode) onModeChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final ThemeData themeData = Theme.of(context);
    final TextTheme headerTextTheme = themeData.primaryTextTheme;
    Color? dayColor;
    Color? yearColor;
    switch (themeData.primaryColorBrightness) {
      case Brightness.light:
        dayColor = mode == DatePickerMode.day ? Colors.black87 : Colors.black54;
        yearColor =
            mode == DatePickerMode.year ? Colors.black87 : Colors.black54;
        break;
      case Brightness.dark:
        dayColor = mode == DatePickerMode.day ? Colors.white : Colors.white70;
        yearColor = mode == DatePickerMode.year ? Colors.white : Colors.white70;
        break;
    }

    if (style?.textStyleDayButton?.color != null) {
      style?.textStyleDayButton =
          style?.textStyleDayButton?.copyWith(color: dayColor);
    }

    if (style?.textStyleDayButton?.fontFamily != null) {
      style?.textStyleDayButton =
          style?.textStyleDayButton?.copyWith(fontFamily: fontFamily);
    }

    final TextStyle dayStyle = style?.textStyleDayButton ??
        headerTextTheme.headline4!
            .copyWith(color: dayColor, fontFamily: fontFamily);
    final TextStyle yearStyle = style?.textStyleYearButton ??
        headerTextTheme.subtitle1!
            .copyWith(color: yearColor, fontFamily: fontFamily);

    Color? backgroundColor;
    if (style?.backgroundHeader != null) {
      backgroundColor = style?.backgroundHeader;
    } else {
      switch (themeData.brightness) {
        case Brightness.dark:
          backgroundColor = themeData.backgroundColor;
          break;
        case Brightness.light:
          backgroundColor = themeData.primaryColor;
          break;
      }
    }

    EdgeInsets padding;
    MainAxisAlignment mainAxisAlignment;
    switch (orientation) {
      case Orientation.landscape:
        padding = style?.paddingDateYearHeader ?? EdgeInsets.all(8.0);
        mainAxisAlignment = MainAxisAlignment.start;
        break;
      case Orientation.portrait:
      default:
        padding = style?.paddingDateYearHeader ?? EdgeInsets.all(16.0);
        mainAxisAlignment = MainAxisAlignment.center;
        break;
    }

    final Widget yearButton = IgnorePointer(
      ignoring: mode != DatePickerMode.day,
      ignoringSemantics: false,
      child: _DateHeaderButton(
        color: Colors.transparent,
        onTap: Feedback.wrapForTap(
          () => _handleChangeMode(DatePickerMode.year),
          context,
        ),
        child: Semantics(
          selected: mode == DatePickerMode.year,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF7FB7E2).withOpacity(0.15),
              borderRadius: BorderRadius.circular(90),
              boxShadow: [
                BoxShadow(color: Colors.transparent, spreadRadius: 2),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
              child: Text(
                "${calculateYearEra(era, selectedDate.year)}",
                style: yearStyle,
              ),
            ),
          ),
        ),
      ),
    );

    final Widget dayButton = IgnorePointer(
      ignoring: mode == DatePickerMode.day,
      ignoringSemantics: false,
      child: _DateHeaderButton(
        color: Colors.transparent,
        onTap: Feedback.wrapForTap(
          () => _handleChangeMode(DatePickerMode.day),
          context,
        ),
        child: Semantics(
          selected: mode == DatePickerMode.day,
          child: Text(
            localizations.formatMediumDate(selectedDate),
            textScaleFactor: 1,
            style: dayStyle,
          ),
        ),
      ),
    );

    BorderRadius borderRadiusData = BorderRadius.only(
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
    );

    if (orientation == Orientation.landscape) {
      borderRadiusData = BorderRadius.only(
        topLeft: Radius.circular(borderRadius),
        bottomLeft: Radius.circular(borderRadius),
      );
    }

    return Container(
      padding: padding,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 33,
          ),
          yearButton,
          SizedBox(
            height: 7,
          ),
        ],
      ),
    );
  }
}

class _DateHeaderButton extends StatelessWidget {
  const _DateHeaderButton({
    Key? key,
    this.onTap,
    this.color,
    this.child,
  }) : super(key: key);

  final VoidCallback? onTap;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      type: MaterialType.button,
      color: color,
      child: InkWell(
        borderRadius: kMaterialEdges[MaterialType.button],
        highlightColor: theme.highlightColor,
        splashColor: theme.splashColor,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: child,
        ),
      ),
    );
  }
}
