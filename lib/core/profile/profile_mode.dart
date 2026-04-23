import 'package:flutter/foundation.dart';

enum ProfileMode { locataire, bailleur }

final ValueNotifier<ProfileMode> profileModeNotifier =
    ValueNotifier<ProfileMode>(ProfileMode.locataire);
