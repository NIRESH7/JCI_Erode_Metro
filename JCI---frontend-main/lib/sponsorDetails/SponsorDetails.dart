import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jci/utils/String.dart';
import 'package:jci/widgets/custAppBar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsorDetails extends StatefulWidget {
  @override
  _SponsorDetailsState createState() => _SponsorDetailsState();
}

class _SponsorDetailsState extends State<SponsorDetails> {
  var lightBlue = '24B9EC';
  var darkBlue = '23346B';
  var appBarTitle = "Sponsor";

  var id = Get.arguments;

  Future<List<SponsorDetailsModel>> _getSponsorDetails() async {
    String u = dotenv.get("URL");
    Uri url = Uri.parse("$u/member/${id[0]}");
    var _response = await http.post(url,
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(<String, String>{"id": id[1]}));

    var _responseData = json.decode(_response.body);

    List<SponsorDetailsModel> sponsorDetails = [];

    var data = _responseData['response']['data']['info'];
    var _details = SponsorDetailsModel(
        logo: data['sponser_image'],
        name: data['sponser_name'],
        desc: data['sponser_description'],
        mail: data['sponser_email'],
        location: data['sponser_location'],
        phone: data['sponser_contact'],
        website: data['sponser_website']);

    sponsorDetails.add(_details);
    return sponsorDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustAppBar(appBarTitle).initAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: _getSponsorDetails(),
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else {
                  if (snapshot.data == null) {
                    return Container(
                      height: MediaQuery.of(ctx).size.height / 1.2,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _logo(snapshot.data[0].logo),
                          _space(10),
                          _companyDetails(snapshot.data[0].desc ?? 'No Data'),
                          _space(20),
                          _mail(),
                          _space(10),
                          _mailId(snapshot.data[0].mail ?? 'No Data'),
                          _space(20),
                          _locationIcon(),
                          _space(10),
                          _locationText(snapshot.data[0].location ?? 'No Data'),
                          _space(20),
                          _phoneIcon(),
                          _space(10),
                          _phoneNumber(snapshot.data[0].phone ?? 'No Data'),
                          _space(20),
                          _globeIcon(),
                          _space(10),
                          _website(snapshot.data[0].website ?? 'No Data'),
                          _space(20),
                        ],
                      ),
                    );
                  }
                }
              }),
        ),
      ),
    );
  }

  Widget _logo(String url) {
    return Center(
      child: Image.network(
        url,
        width: 200,
        height: 200,
        errorBuilder: (_, obj, err) => Container(),
      ),
    );
  }

  Widget _space(double h) {
    return SizedBox(height: h);
  }

  Widget _companyDetails(String details) {
    return Text(
      caps(details),
      style: TextStyle(
        fontFamily: 'pop-med',
        fontSize: 18,
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _mail() {
    return SvgPicture.asset(
      "assets/icons/mail_colored.svg",
      width: 30,
    );
  }

  Widget _mailId(id) {
    return Text(
      caps(id),
      style: TextStyle(
        fontFamily: 'pop-med',
        fontSize: 18,
      ),
    );
  }

  Widget _locationIcon() {
    return SvgPicture.asset(
      "assets/icons/location.svg",
      width: 30,
    );
  }

  Widget _locationText(id) {
    return Text(
      caps(id),
      style: TextStyle(
        fontFamily: "pop-med",
        fontSize: 18,
      ),
    );
  }

  Widget _phoneIcon() {
    return SvgPicture.asset(
      "assets/icons/phone_colored.svg",
      width: 30,
    );
  }

  Widget _phoneNumber(id) {
    return Text(
      id,
      style: TextStyle(
        fontFamily: "pop-med",
        fontSize: 18,
      ),
    );
  }

  Widget _globeIcon() {
    return SvgPicture.asset(
      "assets/icons/globe_colored.svg",
      width: 28,
    );
  }

  Widget _website(String id) {
    return GestureDetector(
      onTap: () async {
        var url = id.contains("https") || id.contains("http") ? id : "https://$id";
        if (await canLaunch("$url")) {
          await launch('$url');
        } else {
          // print('failed');
        }
      },
      child: Text(
        id,
        style: TextStyle(
          fontFamily: "pop-med",
          fontSize: 18,
        ),
      ),
    );
  }
}

class SponsorDetailsModel {
  String logo, name, desc, location, phone, website, mail;

  SponsorDetailsModel({
    required this.logo,
    required this.name,
    required this.desc,
    required this.mail,
    required this.location,
    required this.phone,
    required this.website,
  });
}
