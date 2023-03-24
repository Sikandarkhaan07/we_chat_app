import 'package:flutter/material.dart';
import 'package:we_chat_app/apis/messages_apis.dart';

class DateUtility {
  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;

    if (i == -1) {
      return 'Last seen not available';
    }

    final DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    final DateTime now = DateTime.now();

    final formattedTime = TimeOfDay.fromDateTime(time).format(context);

    if (now.day == time.day &&
        now.month == time.month &&
        now.year == time.year) {
      return 'Last seen today at $formattedTime';
    }

    if (now.difference(time).inHours / 24.round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }
    String month = MessagesAPIs.getMonth(time);
    return 'Last seen on ${time.day} $month on $formattedTime';
  }

  static String getDate({required BuildContext context, required String time}) {
    final date = DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }
}
