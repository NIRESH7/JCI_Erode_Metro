import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jci/referral/services/api_config.dart';
import 'package:jci/services/notification_model.dart';
import 'package:jci/services/notification_service.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:jci/widgets/titles.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<AppNotification>> _future;

  @override
  void initState() {
    super.initState();
    _future = NotificationApiService.list();
  }

  Future<void> _reload() async {
    setState(() {
      _future = NotificationApiService.list();
    });
    await _future;
  }

  Future<void> _openNotification(AppNotification n) async {
    if (!n.isRead) {
      await NotificationApiService.markRead(ids: [n.id]);
    }
    if (n.referralId != null) {
      await Get.toNamed('/referral-detail', arguments: n.referralId);
      if (mounted) _reload();
      return;
    }
    if (mounted) _reload();
  }

  Future<void> _markAllRead() async {
    await NotificationApiService.markRead();
    if (mounted) _reload();
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'referral_viewed':
        return Icons.notifications_outlined;
      case 'referral_responded':
        return Icons.check_circle_outline_rounded;
      case 'referral_received':
      default:
        return Icons.mail_outline_rounded;
    }
  }

  String _timeLabel(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return '';
    final dt = DateTime.tryParse(createdAt)?.toLocal();
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String _initials(String? name) {
    final trimmed = (name ?? '').trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed.substring(0, trimmed.length >= 2 ? 2 : 1).toUpperCase();
  }

  Widget _personAvatar(AppNotification n) {
    final pic = ApiConfig.resolveMediaUrl(n.actorProfilePic);
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFEAF7FD),
        border: Border.all(color: const Color(0xFFD7F0FA)),
      ),
      clipBehavior: Clip.antiAlias,
      child: pic.isNotEmpty
          ? Image.network(
              pic,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _avatarFallback(n),
            )
          : _avatarFallback(n),
    );
  }

  Widget _avatarFallback(AppNotification n) {
    final name = (n.actorName ?? '').trim();
    if (name.isNotEmpty) {
      return Center(
        child: Text(
          _initials(name),
          style: const TextStyle(
            fontFamily: 'pop-semibold',
            fontSize: 14,
            color: Color(0xFF23346B),
          ),
        ),
      );
    }
    return Icon(_iconFor(n.type), color: const Color(0xFF24B9EC), size: 22);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CustAppBar(
        Titles.notifications,
        showBack: true,
        onBack: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else if (Get.key.currentState?.canPop() ?? false) {
            Get.back();
          } else {
            Get.offAllNamed('/home');
          }
        },
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: const Text(
              'Mark all read',
              style: TextStyle(
                fontFamily: 'pop-med',
                fontSize: 13,
                color: Color(0xFF24B9EC),
              ),
            ),
          ),
        ],
      ).initAppBar(),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<List<AppNotification>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 120),
                  Icon(Icons.notifications_none, size: 56, color: Color(0xFF9CA3AF)),
                  SizedBox(height: 12),
                  Center(
                    child: Text(
                      'No notifications yet',
                      style: TextStyle(
                        fontFamily: 'pop-med',
                        fontSize: 15,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ],
              );
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final n = items[index];
                return Material(
                  color: n.isRead ? Colors.white : const Color(0xFFEFF9FD),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _openNotification(n),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _personAvatar(n),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        n.title,
                                        style: TextStyle(
                                          fontFamily: n.isRead ? 'pop-med' : 'pop-semibold',
                                          fontSize: 15,
                                          color: const Color(0xFF1F2937),
                                        ),
                                      ),
                                    ),
                                    if (!n.isRead)
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF24B9EC),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  n.body,
                                  style: const TextStyle(
                                    fontFamily: 'pop-reg',
                                    fontSize: 13,
                                    color: Color(0xFF4B5563),
                                    height: 1.35,
                                  ),
                                ),
                                if (_timeLabel(n.createdAt).isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    _timeLabel(n.createdAt),
                                    style: const TextStyle(
                                      fontFamily: 'pop-reg',
                                      fontSize: 11,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
