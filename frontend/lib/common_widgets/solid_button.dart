import 'package:flutter/material.dart';
import 'package:frontend/constants/app_spacing.dart';

class SolidButton extends StatefulWidget {
  final String text;
  final double leftMargin;
  final double rightMargin;
  final double botMargin;
  final double topMargin;
  final Function()? onPressed;
  final bool isLoading;
  final LinearGradient? gradient;
  final Color? backgroundColor;
  final IconData? icon;
  final double? width;
  final TextStyle? textStyle;

  const SolidButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.width,
      this.textStyle,
      this.gradient,
      this.backgroundColor,
      this.leftMargin = 0,
      this.rightMargin = 0,
      this.botMargin = 0,
      this.topMargin = 0,
      this.icon,
      this.isLoading = false});

  @override
  State<SolidButton> createState() => _SolidButtonState();
}

class _SolidButtonState extends State<SolidButton> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(widget.leftMargin, widget.topMargin,
            widget.rightMargin, widget.botMargin),
        child: widget.isLoading
            ? const CircularProgressIndicator()
            : Container(
                width: widget.width,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 5.0)
                  ],
                  gradient: widget.gradient,
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                    onPressed: widget.onPressed,
                    onHover: (value) {
                      setState(() {
                        value ? hovered = true : hovered = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            0, Spacing.p16, 0, Spacing.p16),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(widget.text,
                              style: widget.textStyle ??
                                  Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: Colors.white)),
                          hovered ? gapW16 : gapW8,
                          if (widget.icon != null)
                            Icon(
                              widget.icon!,
                              size: Spacing.p16,
                              color: Colors.white,
                            )
                        ])))));
  }
}
