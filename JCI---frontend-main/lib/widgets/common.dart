import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jci/referral/services/api_config.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Color darkBlue = Color(0xff23346B);
}

class ImageNotFound extends StatelessWidget {
  const ImageNotFound({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(
        Icons.photo_camera_outlined,
      ),
    );
  }
}

class MemberCardSubTitle extends StatelessWidget {
  const MemberCardSubTitle({
    Key? key,
    required this.title,
    this.fontSize = 14,
  }) : super(key: key);
  final String title;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.capitalizeFirst!,
      style: TextStyle(
        fontFamily: "pop-med",
        fontSize: fontSize,
      ),
    );
  }
}

class MemberCardTitle extends StatelessWidget {
  const MemberCardTitle({
    Key? key,
    required this.title,
    this.fontSize = 20,
  }) : super(key: key);

  final String title;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: "pop-semibold",
        fontSize: fontSize,
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  const MemberCard({
    Key? key,
    required this.onTap,
    required this.image,
    required this.name,
    required this.phone,
    required this.role,
    this.compact = false,
  }) : super(key: key);

  final VoidCallback onTap;
  final String image;
  final String name;
  final String role;
  final String phone;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final resolvedImage = ApiConfig.resolveMediaUrl(image);
    final hasImage = resolvedImage.isNotEmpty;
    final avatarSize = compact ? 40.0 : 44.0;
    final nameSize = compact ? 14.0 : 16.0;
    final subSize = compact ? 11.0 : 12.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: compact ? 6 : 8),
        margin: EdgeInsets.only(top: compact ? 5 : 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE9EDF3)),
          boxShadow: [
            BoxShadow(
              color: const Color(0x1423346B),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEEF5FC),
                border: Border.all(color: const Color(0xFFD9EAF8)),
              ),
              child: ClipOval(
                child: hasImage
                    ? CachedNetworkImage(
                        imageUrl: resolvedImage,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person_outline_rounded,
                          size: 24,
                          color: Color(0xFF8AA8C4),
                        ),
                      )
                    : const Icon(
                        Icons.person_outline_rounded,
                        size: 24,
                        color: Color(0xFF8AA8C4),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.capitalizeFirst ?? name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "pop-semibold",
                      fontSize: nameSize,
                      color: Color(0xFF1F2A44),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    role.capitalizeFirst ?? role,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "pop-med",
                      fontSize: subSize,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    phone,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "pop-reg",
                      fontSize: subSize,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: compact ? 20 : 24,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}

class CallButton extends StatelessWidget {
  const CallButton({
    Key? key,
    required this.profilePhone,
    required this.context,
  }) : super(key: key);

  final BuildContext context;
  final String? profilePhone;

  @override
  Widget build(BuildContext context) {
    return profilePhone == null
        ? SizedBox.shrink()
        : Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff24B9EC), padding: EdgeInsets.all(10)),
              onPressed: () {
                if (profilePhone == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("User not provide contact details"),
                    padding: EdgeInsets.all(10),
                    duration: Duration(seconds: 2),
                  ));
                } else {
                  launchUrl(Uri.parse("tel://$profilePhone"));
                }
              },
              child: Text(
                'Call Now',
                style: TextStyle(fontFamily: 'pop-bold', fontSize: 14),
              ),
            ),
          );
  }
}

class EventButton extends StatelessWidget {
  const EventButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
          BoxShadow(
            color: Color(0xff1A000000),
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
          BoxShadow(
            color: Color(0xffffffff),
            blurRadius: 1,
            offset: Offset(0, 0),
          ),
        ]),
        child: ListTile(
          onTap: () {
            Get.toNamed("/events");
          },
          tileColor: Colors.white,
          leading: SvgPicture.asset(
            "assets/icons/event_colored.svg",
            width: 28,
          ),
          title: Center(
            child: Text(
              "Events",
              style: TextStyle(
                fontFamily: "pop-semibold",
                fontSize: 18,
              ),
            ),
          ),
          trailing: SvgPicture.asset(
            "assets/icons/next.svg",
            width: 13,
          ),
        ),
      ),
    );
  }
}
