import 'dart:ui';

import 'package:date_time_format/date_time_format.dart';
import 'package:easy_localization/easy_localization.dart';

extension Format on DateTime {
  String toLocalizedDateTime({String? format, Locale? locale}) {
    final _langCode = locale?.languageCode ?? 'en';
    if (format != null) return DateFormat(format, _langCode).format(this);
    return DateFormat("d MMMM y\t\thh:mm aaa", _langCode).format(this);
  }

  String toLocalizedTimeString({Locale? locale}) {
    final _langCode = locale?.languageCode ?? 'ar';
    return DateFormat("hh:mm aaa", _langCode).format(this);
  }

  String toLocalizedDateString({Locale? locale}) {
    final _langCode = locale?.languageCode ?? 'ar';
    return DateFormat("d MMMM y", _langCode).format(this);
  }

  String getPublishingDate({required Locale locale}) {
    return DateTimeFormat.format(this, format: DateTimeFormats.european);
  }
}
