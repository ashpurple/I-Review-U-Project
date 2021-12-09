// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:i_review_u/repository/contents_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';



Future<List<Post>> getData() async {
  var slug = Get.arguments;
  final response = await http.get(
    //Uri.parse("http://192.168.55.233:8000/api/buildingdata/"),//세훈
      Uri.parse("http://192.168.55.233:8000/api/buildingdata/" + slug + "/"),
      headers: {"Access-Control-Allow-Origin": "*"});
  if (response.statusCode == 200) {
    List list = (json.decode(utf8.decode(response.bodyBytes)));
    var postList = list.map((element) => Post.fromJson(element)).toList();
    return postList;
  } else {
    throw Exception('Failed to load post');
  }
}

class Post {
  final String buildingName;
  final String review;
  final String star;

  Post({this.buildingName, this.review, this.star});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        buildingName: json["building_name"],
        review: json["review_content"],
        star: json["star_num"].toString());
  }
}

class Review extends StatefulWidget {
  Review({Key key}) : super(key: key);

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  Future<List<Post>> postList;
  String currentLocation;
  ContentsRepository contentsRepository;
  final Map<String, String> locationTypeToString = {
    "seongnam": "성남시 스터디카페",
    "songpa": "송파구 스터디카페",
    "gangnam": "강남구 스터디카페",
  };

  @override
  void initState() {
    super.initState();
    postList = getData();
    currentLocation = "seongnam";
    //contentsRepository = ContentsRepository();
  }

  // 앱 바
  AppBar _appbarWidget() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          // 탭
          print("tap");
        },
        onLongPress: () {
          // 길게 클릭
          print("long press");
        }, // 추후 다른 이벤트 추가
        child: PopupMenuButton<String>(
          offset: Offset(0, 25), // 평행이동
          shape: ShapeBorder.lerp(
              // 원처리
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              1),
          onSelected: (String location) {
            // 클릭 이벤트
            setState(() {
              currentLocation = location;
            });
          },
          itemBuilder: (BuildContext context) {
            // 지역 리스트
            return [
              PopupMenuItem(value: "seongnam", child: Text("성남시")),
              PopupMenuItem(value: "songpa", child: Text("송파구")),
              PopupMenuItem(value: "gangnam", child: Text("강남구")),
            ];
          },
          child: Row(
            children: [
              // 지역 선택
              Text(locationTypeToString[currentLocation].toString()),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.pink,
      elevation: 1,
      actions: [
        // 상단 아이콘
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
        ), // 검색
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.tune),
        ), // 기타
        IconButton(
            // 알림
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/svg/bell.svg",
              width: 22,
            )),
      ],
    );
  }

  _makeDataList(List<Post> datas) {
    // 매장 데이터

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (BuildContext _context, int index) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                // 화면 확장
                child: Container(
                  // 매장 정보
                  height: 100,
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                    children: [
                      Text(
                        datas[index].star.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 5),
                      Text(
                        datas[index].review.toString(),
                        style: TextStyle(
                            fontSize: 10, color: Colors.black.withOpacity(0.3)),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext _context, int index) {
        // 분할선
        return Container(height: 1, color: Colors.pink.withOpacity(0.4));
      },
      itemCount: datas.length,
    );
  }

  // 바디 (리스트)
  Widget _bodyWidget() {
    return FutureBuilder(
        future: postList,
        builder: (BuildContext context, dynamic snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            // 데이터 없을 때 로딩 처리
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("데이터 로드 오류"),
            );
          }
          if (snapshot.hasData) {
            // 데이터 있을 때만
            return _makeDataList(snapshot.data);
          }
          return Center(child: Text("해당 지역에 데이터가 없습니다"));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}
