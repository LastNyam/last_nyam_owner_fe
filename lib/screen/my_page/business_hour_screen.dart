import 'package:flutter/material.dart';
import 'package:last_nyam_owner/const/colors.dart';

class BusinessHoursScreen extends StatefulWidget {
  @override
  _BusinessHoursScreenState createState() => _BusinessHoursScreenState();
}

class _BusinessHoursScreenState extends State<BusinessHoursScreen> {
  // 요일별 영업 상태 및 시간 데이터
  List<Map<String, dynamic>> businessHours = [
    {"day": "월요일", "status": "영업일", "hours": "09:00 ~ 22:00", "breaks": []},
    {"day": "화요일", "status": "휴무", "hours": "", "breaks": []},
    {"day": "수요일", "status": "영업일", "hours": "09:00 ~ 22:00", "breaks": []},
    {"day": "목요일", "status": "영업일", "hours": "09:00 ~ 22:00", "breaks": []},
    {"day": "금요일", "status": "영업일", "hours": "09:00 ~ 22:00", "breaks": []},
    {"day": "토요일", "status": "영업일", "hours": "09:00 ~ 22:00", "breaks": []},
    {
      "day": "일요일",
      "status": "영업일",
      "hours": "09:00 ~ 22:00",
      "breaks": ["15:00 ~ 16:00"]
    },
  ];

  // 영업 시간 변경 다이얼로그
  void _showEditDialog(int index) {
    final selectedDay = businessHours[index];
    final isHoliday = selectedDay["status"] == "휴무";
    String openingHour = "09:00";
    String closingHour = "22:00";
    List<dynamic> breaks = selectedDay["breaks"];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              backgroundColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio(
                                value: "영업일",
                                groupValue: selectedDay["status"],
                                activeColor: defaultColors['green'],
                                onChanged: (value) {
                                  setState(() {
                                    selectedDay["status"] = value;
                                  });
                                },
                              ),
                              Text("영업일"),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: "휴무",
                                groupValue: selectedDay["status"],
                                activeColor: defaultColors['green'],
                                onChanged: (value) {
                                  setState(() {
                                    selectedDay["status"] = value;
                                  });
                                },
                              ),
                              Text("휴무일"),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          size: 32,
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: defaultColors['lightGreen'],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('영업시간'),
                        SizedBox(width: 25),
                        Transform.scale(
                          scale: 0.6,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: defaultColors['lightGreen']!,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              child: DropdownButton<String>(
                                value: openingHour,
                                onChanged: (value) {
                                  setState(() {
                                    openingHour = value!;
                                  });
                                },
                                items: [
                                  "09:00",
                                  "10:00",
                                  "11:00",
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  );
                                }).toList(),
                                iconEnabledColor: Colors.black,
                                underline: Container(),
                              ),
                            ),
                          ),
                        ),
                        Text("~"),
                        Transform.scale(
                          scale: 0.6,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: defaultColors['lightGreen']!,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              child: DropdownButton<String>(
                                value: closingHour,
                                onChanged: (value) {
                                  setState(() {
                                    closingHour = value!;
                                  });
                                },
                                items: [
                                  "22:00",
                                  "23:00",
                                  "00:00",
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                iconEnabledColor: Colors.black,
                                underline: Container(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(
                    color: defaultColors['lightGreen'],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('휴식시간'),
                      ],
                    ),
                  ),
                  ...breaks.map((breakTime) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(breakTime),
                          Transform.scale(
                            scale: 0.3,
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 60,
                                color: Colors.white,
                                weight: 700.0,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: defaultColors['green'],
                              ),
                              onPressed: () {
                                setState(() {
                                  breaks.remove(breakTime);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            breaks.add("15:00 ~ 16:00");
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: defaultColors['green']!),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5.0), // Border radius 설정
                          ),
                        ),
                        child: Text(
                          "+ 휴식시간 추가",
                          style: TextStyle(color: defaultColors['green']),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: defaultColors['lightGreen'],
                  ),
                  SizedBox(height: 10),
                ],
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (selectedDay["status"] == "영업일") {
                          selectedDay["hours"] = "$openingHour ~ $closingHour";
                          selectedDay["breaks"] = breaks;
                        } else {
                          selectedDay["hours"] = "";
                          selectedDay["breaks"] = [];
                        }
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: defaultColors['green'],
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5.0), // Border radius 설정
                      ),
                    ),
                    child: Text(
                      "수정",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "영업 시간 변경",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.separated(
          itemCount: businessHours.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: Colors.grey[300],
          ),
          itemBuilder: (context, index) {
            final item = businessHours[index];
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(item["day"]),
                  SizedBox(width: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item["status"] == "영업일")
                        Text(
                          item["hours"],
                          style: TextStyle(
                            fontSize: 14,
                            color: defaultColors['black'],
                          ),
                        ),
                      if (item["breaks"].isNotEmpty)
                        Text(
                          "휴식시간: ${item["breaks"].join(", ")}",
                          style: TextStyle(
                            fontSize: 14,
                            color: defaultColors['black'],
                          ),
                        ),
                      if (item["status"] == "휴무")
                        Text(
                          "휴무",
                          style: TextStyle(
                            fontSize: 14,
                            color: defaultColors['black'],
                          ),
                        ),
                    ],
                  )
                ],
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: defaultColors['lightGreen'],
              ),
              onTap: () {
                print(item['day']);
                _showEditDialog(index);
              },
            );
          },
        ),
      ),
    );
  }
}
