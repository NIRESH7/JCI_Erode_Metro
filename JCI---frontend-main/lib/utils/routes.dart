import 'package:get/route_manager.dart';
import 'package:jci/blood_request/blood_request.dart';
import 'package:jci/blood_request/blood_request_list.dart';
import 'package:jci/dashboard/view_pdf.dart';
import 'package:jci/referral/forgot_password.dart';
import 'package:jci/referral/logged_in_members.dart';
import 'package:jci/referral/member_login.dart';
import 'package:jci/referral/member_setup.dart';
import 'package:jci/referral/referral_detail.dart';
import 'package:jci/referral/referral_page.dart';
import 'package:jci/fitness_club/fitness_club_page.dart';
import 'package:jci/utils/app_navigation.dart';
import 'package:jci/utils/screens.dart';

class Routes {
  static List<GetPage> list = [
    AppNavigation.page(
      name: '/splash',
      page: () => SplashScreen(),
      transition: AppNavigation.fadeTransition,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    AppNavigation.page(name: '/', page: () => Main()),
    AppNavigation.page(
      name: '/home',
      page: () => Home(),
      transition: AppNavigation.sharedAxisTransition,
      customTransition: AppNavigation.fadeThrough,
    ),
    AppNavigation.page(name: '/about', page: () => About()),
    AppNavigation.page(name: '/privacy-policy', page: () => const PrivacyPolicyScreen()),
    AppNavigation.page(name: '/sponsor', page: () => SponsorDetails()),
    AppNavigation.page(
      name: '/events',
      page: () => Events(),
      transition: AppNavigation.sharedAxisTransition,
      customTransition: AppNavigation.sharedAxisHorizontal,
    ),
    AppNavigation.page(
      name: '/eventsdetails',
      page: () => EventsDetails(),
      transition: AppNavigation.sharedAxisTransition,
      customTransition: AppNavigation.sharedAxisHorizontal,
    ),
    AppNavigation.page(
      name: '/members',
      page: () => Members(),
      transition: AppNavigation.sharedAxisTransition,
      customTransition: AppNavigation.sharedAxisHorizontal,
    ),
    AppNavigation.page(
      name: '/blood',
      page: () => BloodDonors(),
      transition: AppNavigation.sharedAxisTransition,
      customTransition: AppNavigation.sharedAxisHorizontal,
    ),
    AppNavigation.page(name: '/blood-request', page: () => BloodRequest()),
    AppNavigation.page(name: '/blood-request-list', page: () => BloodRequestList()),
    AppNavigation.page(name: '/roh', page: () => RollOfHonour()),
    AppNavigation.page(name: '/roh_details', page: () => RohDetails()),
    AppNavigation.page(name: '/view_pdf', page: () => ViewPdf()),
    AppNavigation.page(name: '/birthday', page: () => Birthday()),
    AppNavigation.page(name: '/profile', page: () => Profile()),
    AppNavigation.page(name: '/imgView', page: () => ImageViewer()),
    AppNavigation.page(name: '/dashboard', page: () => Dashboard()),
    AppNavigation.page(
      name: '/member-login',
      page: () => const MemberLoginScreen(),
      transition: AppNavigation.fadeTransition,
    ),
    AppNavigation.page(
      name: '/member-setup',
      page: () => const MemberSetupScreen(),
      transition: AppNavigation.modalTransition,
    ),
    AppNavigation.page(
      name: '/my-profile',
      page: () => const MemberSetupScreen(),
      transition: AppNavigation.modalTransition,
    ),
    AppNavigation.page(
      name: '/forgot-password',
      page: () => const ForgotPasswordScreen(),
      transition: AppNavigation.modalTransition,
    ),
    AppNavigation.page(name: '/referral', page: () => const ReferralPage()),
    AppNavigation.page(
      name: '/referral-detail',
      page: () => ReferralDetailScreen(referralId: int.parse('${Get.arguments}')),
    ),
    AppNavigation.page(
      name: '/logged-in-members',
      page: () => const LoggedInMembersScreen(),
    ),
    AppNavigation.page(name: '/fitness-club', page: () => const FitnessClubPage()),
  ];
}
