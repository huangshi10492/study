import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

enum SettingsItemType { titleItem, simpleItem, switchItem, navigationItem }

class SettingsItem extends StatelessWidget {
  SettingsItem({
    required this.startIcon,
    this.value,
    required this.title,
    this.description,
    this.onPressed,
    bool? disvisible,
    super.key,
  }) {
    end = null;
    onChange = null;
    initialValue = false;
    itemType = SettingsItemType.simpleItem;
    this.disvisible = disvisible ?? false;
  }

  SettingsItem.titleItem({
    required this.title,
    this.description,
    bool? disvisible,
    super.key,
  }) {
    value = null;
    onPressed = null;
    itemType = SettingsItemType.titleItem;
    this.disvisible = disvisible ?? false;
  }

  SettingsItem.switchItem({
    required this.initialValue,
    required this.onChange,
    required this.startIcon,
    this.end,
    required this.title,
    this.description,
    bool? disvisible,
    super.key,
  }) {
    value = null;
    onPressed = null;
    itemType = SettingsItemType.switchItem;
    this.disvisible = disvisible ?? false;
  }

  SettingsItem.navigationItem({
    required this.startIcon,
    required this.navigationWidget,
    this.value,
    required this.title,
    this.description,
    bool? disvisible,
    super.key,
  }) {
    end = null;
    onChange = null;
    initialValue = false;
    itemType = SettingsItemType.navigationItem;
    this.disvisible = disvisible ?? false;
  }
  final String title;
  final String? description;
  late final IconData startIcon;
  late final Function(BuildContext context)? onPressed;
  late final Widget? end;
  late final Widget? value;
  late final Function(bool value)? onChange;
  late final SettingsItemType itemType;
  late final bool initialValue;
  late final Widget? navigationWidget;
  late final bool disvisible;

  @override
  Widget build(BuildContext context) {
    if (disvisible) {
      return const SizedBox();
    }
    if (itemType == SettingsItemType.titleItem) {
      return Padding(
        padding: const EdgeInsetsDirectional.only(
          top: 24,
          bottom: 10,
          start: 24,
          end: 24,
        ),
        child: Text(
          title,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      );
    }
    if (itemType == SettingsItemType.navigationItem) {
      return OpenContainer(
        closedBuilder: (context, action) {
          return InkWell(
            onTap: action,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 24),
                  child: Icon(startIcon),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 24,
                      end: 24,
                      bottom: 19,
                      top: 19,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title),
                        if (value != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: value!,
                          )
                        else if (description != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(description!),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        openBuilder: (context, action) {
          return navigationWidget!;
        },
        closedColor: Theme.of(context).colorScheme.background,
        closedElevation: 0.0,
        closedShape: const RoundedRectangleBorder(),
      );
    }
    return InkWell(
      onTap: () {
        if (itemType == SettingsItemType.switchItem) {
          onChange?.call(!initialValue);
        } else {
          onPressed?.call(context);
        }
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 24),
            child: Icon(startIcon),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 24,
                end: 24,
                bottom: 19,
                top: 19,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  if (value != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: value!,
                    )
                  else if (description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(description!),
                    )
                ],
              ),
            ),
          ),
          if (itemType == SettingsItemType.switchItem)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 16, end: 8),
              child: Switch(
                value: initialValue,
                onChanged: onChange,
              ),
            )
          else if (end != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: end!,
            ),
        ],
      ),
    );
  }
}
