class StoryTime {
  static String ago(DateTime? dateTime) {
    if (dateTime == null) return '';
    final dt = dateTime.toLocal();
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  static String uploadedLabel(DateTime? dateTime) {
    final agoText = ago(dateTime);
    if (agoText.isEmpty) return '';
    return 'Posted $agoText';
  }

  static String expiresLabel(DateTime? dateTime) {
    if (dateTime == null) return '';
    final dt = dateTime.toLocal();
    final remaining = dt.difference(DateTime.now());
    if (remaining.isNegative) return 'Expired';
    if (remaining.inMinutes < 60) return 'Expires in ${remaining.inMinutes}m';
    if (remaining.inHours < 24) return 'Expires in ${remaining.inHours}h';
    return 'Expires in ${remaining.inDays}d';
  }

  static String listTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final dt = dateTime.toLocal();
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 30) return 'Just now';
    if (diff.inMinutes < 1) return '1 min ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final storyDay = DateTime(dt.year, dt.month, dt.day);
    if (storyDay == today.subtract(const Duration(days: 1))) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';

    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.day}/${dt.month}/${dt.year}, $hour:$minute $period';
  }
}
