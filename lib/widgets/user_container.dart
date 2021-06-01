import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import '../models/User.dart' as usr;

class UserDetail extends StatefulWidget {
  final usr.User user;

  UserDetail(this.user);

  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(14),
      height: MediaQuery.of(context).size.height / 2.6,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              // spreadRadius: 10,
              color: Theme.of(context).primaryColor,
            ),
          ]),
      child: Column(
        children: [
          widget.user.usrImage.isEmpty
              ? Image(
                  image: AssetImage("lib/assets/images/MainLogo.png"),
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.contain,
                )
              : Expanded(
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(
                        "https://cupidknot.kuldip.dev/document_images/" +
                            widget.user.usrImage![index],
                        fit: BoxFit.contain,
                      );
                    },
                    autoplay: true,
                    itemCount: widget.user.usrImage!.length,
                    pagination:
                        SwiperPagination(builder: SwiperPagination.fraction),
                    control: SwiperControl(),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${widget.user.name}",
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${widget.user.gender}, ${widget.user.dob}",
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  fontSize: 17,
                  // fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
