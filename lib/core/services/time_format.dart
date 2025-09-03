String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays == 0) {
    return 'Today at ${formatTime(dateTime)}';
  } else if (difference.inDays == 1) {
    return 'Yesterday at ${formatTime(dateTime)}';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

String formatTime(DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

// Extension to capitalize strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
