import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:carg/styles/theme/enums.dart';
import 'package:carg/styles/theme/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ThemePickerWidget extends StatefulWidget {
  const ThemePickerWidget({super.key});

  @override
  State<ThemePickerWidget> createState() => _ThemePickerWidgetState();
}

// The State class is responsible for two things: holding some data you can
// update and building the UI using that data.
class _ThemePickerWidgetState extends State<ThemePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: Provider.of<ThemeService>(context).showContrastPicker()
          ? MainAxisAlignment.spaceEvenly
          : MainAxisAlignment.center,
      children: [
        AnimatedToggleSwitch<ThemeValue>.size(
          current: Provider.of<ThemeService>(context).currentThemeValue,
          values: const [ThemeValue.light, ThemeValue.system, ThemeValue.dark],
          style: ToggleStyle(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            indicatorColor: Theme.of(context).colorScheme.surface,
          ),
          customIconBuilder: (context, local, global) {
            final color = global.current == local.value
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSecondary;
            return Icon(local.value.icon, color: color);
          },
          onChanged: (ThemeValue value) => {
            HapticFeedback.lightImpact(),
            Provider.of<ThemeService>(
              context,
              listen: false,
            ).currentThemeValue = value,
          },
        ),
        AnimatedOpacity(
          opacity: Provider.of<ThemeService>(context).showContrastPicker()
              ? 1.0
              : 0.0,
          duration: const Duration(milliseconds: 500),
          child: AnimatedSize(
            curve: Curves.ease,
            duration: const Duration(milliseconds: 500),
            child: Provider.of<ThemeService>(context).showContrastPicker()
                ? AnimatedToggleSwitch<ContrastValue>.size(
                    current: Provider.of<ThemeService>(
                      context,
                    ).currentContrastValue,
                    values: const [ContrastValue.none, ContrastValue.high],
                    customStyleBuilder: (context, local, global) {
                      return ToggleStyle(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondary,
                        indicatorColor: Theme.of(context).colorScheme.surface,
                      );
                    },
                    customIconBuilder: (context, local, global) {
                      final color = global.current == local.value
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSecondary;
                      return Icon(local.value.icon, color: color);
                    },
                    onChanged: (ContrastValue value) => {
                      HapticFeedback.lightImpact(),
                      Provider.of<ThemeService>(
                        context,
                        listen: false,
                      ).currentContrastValue = value,
                    },
                  )
                : SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
