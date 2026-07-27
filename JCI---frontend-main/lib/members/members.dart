import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jci/controllers/sponsorController.dart';
import 'package:jci/utils/String.dart';
import 'package:jci/utils/debounce.dart';
import 'package:jci/utils/responsive.dart';
import 'package:jci/widgets/common.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'package:jci/widgets/sponsorData.dart';
import 'package:jci/widgets/titles.dart';
import 'package:lottie/lottie.dart';

import '../models/membersModel.dart';

class Members extends StatefulWidget {
  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> with SingleTickerProviderStateMixin {
  var appBarTitle = "Members";
  List<String> id = Get.arguments;

  TabController? _tabController;
  final ScrollController _boardScrollController = ScrollController();
  final ScrollController _membersScrollController = ScrollController();
  bool _showScrollDownButton = false;

  List<MembersModel> _memberList = [];
  List<MembersModel> _boardMembersList = [];
  List<MembersModel> _filteredBoardMembersList = [];
  List<MembersModel> _filteredMembersList = [];

  Future<List<MembersModel>> membersInfo = Future.value([]);
  Future<List<MembersModel>> boardMembersInfo = Future.value([]);

  var _searchBoardMemberView = TextEditingController();
  var _searchMemberView = TextEditingController();
  var visibleController = Get.put(SponsorController());

  bool _isBoardSearch = true;
  bool _isMemberSearch = true;
  String _searchText = "";
  final Debouncer _searchDebouncer = Debouncer();

  void _ensureTabController() {
    if (_tabController != null) return;
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(_updateScrollDownButtonVisibility);
  }

  @override
  void initState() {
    super.initState();
    _ensureTabController();
    _boardScrollController.addListener(_updateScrollDownButtonVisibility);
    _membersScrollController.addListener(_updateScrollDownButtonVisibility);
    _searchBoardMemberView.addListener(_onBoardSearchChanged);
    _searchMemberView.addListener(_onMemberSearchChanged);
    membersInfo = _loadMembersInfo(type: 'mem');
    boardMembersInfo = _loadMembersInfo(type: 'bm');
  }

  @override
  void dispose() {
    _tabController?.removeListener(_updateScrollDownButtonVisibility);
    _tabController?.dispose();
    _boardScrollController.dispose();
    _membersScrollController.dispose();
    _searchBoardMemberView.removeListener(_onBoardSearchChanged);
    _searchMemberView.removeListener(_onMemberSearchChanged);
    _searchBoardMemberView.dispose();
    _searchMemberView.dispose();
    super.dispose();
  }

  ScrollController _activeScrollController() {
    return _tabController!.index == 0 ? _boardScrollController : _membersScrollController;
  }

  void _updateScrollDownButtonVisibility() {
    final controller = _activeScrollController();
    if (!controller.hasClients) return;

    final canScrollDown = controller.position.maxScrollExtent > 0 &&
        controller.position.pixels < controller.position.maxScrollExtent - 24;
    if (canScrollDown != _showScrollDownButton) {
      setState(() => _showScrollDownButton = canScrollDown);
    }
  }

  void _scrollListDown() {
    final controller = _activeScrollController();
    if (!controller.hasClients) return;

    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
    );
  }

  String u = dotenv.get("URL");

  void _onBoardSearchChanged() => _handleSearchChanged(type: 'bm', controller: _searchBoardMemberView);

  void _onMemberSearchChanged() => _handleSearchChanged(type: 'mem', controller: _searchMemberView);

  void _handleSearchChanged({required String type, required TextEditingController controller}) {
    final text = controller.text.trim().toLowerCase();
    if (text.isEmpty) {
      if (mounted) {
        setState(() {
          if (type == 'bm') {
            _isBoardSearch = true;
          } else {
            _isMemberSearch = true;
          }
          _searchText = "";
        });
      }
      return;
    }

    _searchDebouncer.call(() {
      if (!mounted) return;
      setState(() {
        if (type == 'bm') {
          _isBoardSearch = false;
        } else {
          _isMemberSearch = false;
        }
        _searchText = text;
        filterMember(_searchText, type: type);
      });
    });
  }

  Future<List<MembersModel>> _loadMembersInfo({required String type}) async {
    var _routes;
    List<MembersModel> list = [];
    switch (type) {
      case 'bm':
        list = _boardMembersList;
        _routes = "boardmembers";
        break;
      case 'mem':
        list = _memberList;
        _routes = "allmembers";
        break;
      case 'pp':
        _routes = "designation";
        break;
    }

    Uri url = Uri.parse("$u/member/$_routes?app_access=full");

    final _response;
    var _jsonData;
    // if (id[0] == "mem") {
    _response = await http.get(url);
    // } else {
    //   _response = await http.post(url,
    //       headers: {'Content-Type': 'application/json'},
    //       body: jsonEncode({'id': ""}));
    // }

    var _responseData = json.decode(_response.body);
    _jsonData = _responseData['response']['data']['info'];

    list.clear();

    if (_jsonData != "Not Found") {
      for (var members in _jsonData) {
        MembersModel _mem = MembersModel.fromJson(members);
        list.add(_mem);
        // if (id[0] == "mem") {
        //   MembersModel _mem = MembersModel(
        //       id: '${members['id']}',
        //       img: members['profile_pic'],
        //       name: members['user_name'],
        //       title: members['role'],
        //       phone: members['contact']);
        //   _memberList.add(_mem);
        // } else {
        //   MembersModel _mem = MembersModel(
        //       id: '${members['id']}',
        //       img: members['profile_pic'],
        //       name: members['user_name'],
        //       title: members['role'],
        //       phone: members['contact']);
        //   _memberList.add(_mem);
        // }
      }
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    _ensureTabController();
    final tabController = _tabController!;
    // switch (id[0]) {
    //   case 'bm':
    //     appBarTitle = Titles.boardMembers;
    //     break;
    //   case 'mem':
    //     appBarTitle = Titles.members;
    //     break;
    //   case 'pp':
    //     appBarTitle = Titles.pastPresidents;
    //     break;
    // }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CustAppBar(
        Titles.members,
        bottom: TabBar(
          controller: tabController,
          tabs: const [Tab(text: 'Board Members'), Tab(text: 'Members')],
          indicatorColor: const Color(0xFF24B9EC),
          indicatorWeight: 2.5,
          labelColor: const Color(0xFF1F2937),
          unselectedLabelColor: const Color(0xFF6B7280),
          labelStyle: const TextStyle(fontSize: 16, fontFamily: "pop-semibold"),
          unselectedLabelStyle: const TextStyle(fontSize: 16, fontFamily: "pop-med"),
        ),
      ).initAppBar(),
      floatingActionButton: _showScrollDownButton
          ? FloatingActionButton(
              backgroundColor: const Color(0xff24B9EC),
              onPressed: _scrollListDown,
              child: const Icon(Icons.keyboard_arrow_down, size: 32, color: Colors.white),
            )
          : null,
      body: Responsive.body(
        context,
        TabBarView(
        controller: tabController,
        children: [
            Column(
              children: [
                _searchBox(type: 'bm'),
                Expanded(
                  child: FutureBuilder(
                  future: boardMembersInfo,
                  builder: (BuildContext ctx, AsyncSnapshot<List<MembersModel>> snapshot) {
                    if (snapshot.hasError) {
                      return _nodatafound();
                    } else {
                      if (snapshot.data == null &&
                          snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.data == null &&
                          snapshot.connectionState == ConnectionState.done) {
                        return _nodatafound();
                      } else {
                        return snapshot.data?.length == 0
                            ? _nodatafound()
                            : Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      controller: _boardScrollController,
                                      padding: Responsive.listPadding(
                                        context,
                                        bottom: _showScrollDownButton ? 72 : 12,
                                      ),
                                      itemCount: _isBoardSearch
                                          ? snapshot.data?.length
                                          : _filteredBoardMembersList.length,
                                      itemBuilder: (ctx, index) {
                                        if (index == 0) {
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            if (mounted) _updateScrollDownButtonVisibility();
                                          });
                                        }
                                        var mem = _isBoardSearch
                                            ? snapshot.data![index]
                                            : _filteredBoardMembersList[index];
                                        return MemberCard(
                                          compact: true,
                                          onTap: () => Get.toNamed(
                                            '/profile',
                                            arguments: [mem.id],
                                          ),
                                          image: mem.profilePic ?? '',
                                          name: mem.userName ?? '',
                                          phone: mem.contact ?? '',
                                          role: mem.role ?? '',
                                        );
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: visibleController.getMainSponsorVisiblity(),
                                    child: SponsorData.sponserTitle(
                                      "${JciString.powered_by}",
                                    ),
                                  ),
                                  _space(10),
                                  SponsorData.mainSponsor(context),
                                  _space(10),
                                ],
                              );
                      }
                    }
                  },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                _searchBox(type: 'mem'),
                Expanded(
                  child: FutureBuilder(
                  future: membersInfo,
                  builder: (BuildContext ctx, AsyncSnapshot<List<MembersModel>> snapshot) {
                    if (snapshot.hasError) {
                      return _nodatafound();
                    } else {
                      if (snapshot.data == null &&
                          snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.data == null &&
                          snapshot.connectionState == ConnectionState.done) {
                        return _nodatafound();
                      } else {
                        return snapshot.data?.length == 0
                            ? _nodatafound()
                            : Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      controller: _membersScrollController,
                                      padding: Responsive.listPadding(
                                        context,
                                        bottom: _showScrollDownButton ? 72 : 12,
                                      ),
                                      itemCount: _isMemberSearch
                                          ? snapshot.data?.length
                                          : _filteredMembersList.length,
                                      itemBuilder: (ctx, index) {
                                        if (index == 0) {
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            if (mounted) _updateScrollDownButtonVisibility();
                                          });
                                        }
                                        var mem = _isMemberSearch
                                            ? snapshot.data![index]
                                            : _filteredMembersList[index];
                                        return MemberCard(
                                          compact: true,
                                          onTap: () => Get.toNamed(
                                            '/profile',
                                            arguments: [mem.id],
                                          ),
                                          image: mem.profilePic ?? '',
                                          name: mem.userName ?? '',
                                          phone: mem.contact ?? '',
                                          role: mem.role ?? '',
                                        );
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: visibleController.getMainSponsorVisiblity(),
                                    child: SponsorData.sponserTitle(
                                      "${JciString.powered_by}",
                                    ),
                                  ),
                                  _space(10),
                                  SponsorData.mainSponsor(context),
                                  _space(10),
                                ],
                              );
                      }
                    }
                  },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _nodatafound() {
    return Center(
      child: Lottie.asset(
        "assets/lottie/no_data.json",
        height: Get.height * 0.3,
        repeat: true,
      ),
    );
  }

  Widget _searchBox({required String type}) {
    TextEditingController _searchView = type == 'bm' ? _searchBoardMemberView : _searchMemberView;

    return Container(
      margin: EdgeInsets.fromLTRB(
        Responsive.horizontalPadding(context),
        10,
        Responsive.horizontalPadding(context),
        4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: _searchView,
        decoration: InputDecoration(
          hintText: "Search members",
          border: InputBorder.none,
          hintStyle: const TextStyle(
            fontFamily: "pop-med",
            fontSize: 15,
            color: Color(0xFF9CA3AF),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: SvgPicture.asset("assets/icons/search_colored.svg", width: 16, height: 16),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          isDense: true,
        ),
        style: const TextStyle(
          fontFamily: "pop-med",
          fontSize: 14,
          color: Color(0xFF1F2937),
        ),
      ),
    );
  }

  void filterMember(String, {required String type}) {
    List<MembersModel> filteredList = [];
    List<MembersModel> sourceList = [];
    switch (type) {
      case 'bm':
        sourceList = List.from(_boardMembersList);
        _filteredBoardMembersList.clear();
        break;
      case 'mem':
        sourceList = List.from(_memberList);
        _filteredMembersList.clear();
        break;
    }

    for (var _mem in sourceList) {
      if ((_mem.userName?.toLowerCase().contains(_searchText) ?? false) ||
          (_mem.location?.toLowerCase().contains(_searchText) ?? false) ||
          (_mem.job?.toLowerCase().contains(_searchText) ?? false) ||
          (_mem.sector?.toLowerCase().contains(_searchText) ?? false) ||
          (_mem.role?.toLowerCase().contains(_searchText) ?? false)) {
        filteredList.add(
          MembersModel(
              id: _mem.id,
              profilePic: _mem.profilePic,
              userName: _mem.userName,
              role: _mem.role,
              contact: _mem.contact),
        );
      }
      switch (type) {
        case 'bm':
          _filteredBoardMembersList = filteredList;
          break;
        case 'mem':
          _filteredMembersList = filteredList;
          break;
      }
    }
  }

  // sponsor section
  Widget _space(double h) {
    return SizedBox(height: h);
  }
}
