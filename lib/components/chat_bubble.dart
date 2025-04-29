import 'package:chat_application/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final bool? isRead;
  final DateTime timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    this.isRead,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    String formattedTime = DateFormat('h:mm a').format(timestamp);

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? (isDarkMode ? Colors.teal.shade700 : Colors.green.shade400)
              : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft:
            isCurrentUser ? const Radius.circular(12) : const Radius.circular(0),
            bottomRight:
            isCurrentUser ? const Radius.circular(0) : const Radius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end, // ✅ Align items to the bottom
          children: [
            // ✅ Message Text
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  color: isCurrentUser
                      ? Colors.white
                      : (isDarkMode ? Colors.white : Colors.black87),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // ✅ Timestamp and Read Receipt
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✅ Timestamp
                Text(
                  formattedTime,
                  style: TextStyle(
                    color: isCurrentUser ? Colors.white70 : Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(width: 2),

                // ✅ Read Receipt Icon
                if (isCurrentUser && isRead != null)
                  Icon(
                    isRead! ? Icons.done_all : Icons.check,
                    size: 16,
                    color: isRead! ? Colors.blueAccent : Colors.grey,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
