import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

import '../../themes/light_mode_theme.dart';
import '../../themes/typography_theme.dart';

class TabFilter extends StatelessWidget {
  const TabFilter({super.key, required List<String> choices, required String active, required Function(String) onSelect }):
    _choices = choices,
    _active = active,
    _onSelect = onSelect;

  final List<String> _choices;
  final String _active;
  final Function(String) _onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      decoration: BoxDecoration(
        color: LightModeTheme().secondaryBackground,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
          _choices.map((choice) {
            return Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  _onSelect(choice);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: LightModeTheme().secondaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          toBeginningOfSentenceCase(choice),
                          textAlign: TextAlign.center,
                          style: TypographyTheme().bodyMedium.override(
                            fontFamily: 'Roboto',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 3.0,
                        decoration: BoxDecoration(
                          gradient: _active == choice ? LinearGradient(
                            colors: [
                              LightModeTheme().orangePeel,
                              LightModeTheme().orangePeel
                            ],
                            stops: const [0.0, 1.0],
                            begin: const AlignmentDirectional(0.0, -1.0),
                            end: const AlignmentDirectional(0, 1.0),
                          ) : null,
                          borderRadius: BorderRadius.circular(16.0),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList()

      ),
    );
  }
}