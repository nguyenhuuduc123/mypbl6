import 'package:app_booking/screens/myorder_Screen.dart';
import 'package:app_booking/screens/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
class booknow_Screen extends StatefulWidget {
  const booknow_Screen({required this.documentSnapshot});
  final DocumentSnapshot documentSnapshot;
@override
State<booknow_Screen> createState() => _booknow_ScreenState();
}
late User loggedInUser;
class _booknow_ScreenState extends State<booknow_Screen> {
  final _auth = FirebaseAuth.instance;
  final _booking = FirebaseFirestore.instance;
  final _fromkey = GlobalKey<FormState>();
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print('User: $user');
      }
    } catch (e) {
      print(e);
    }
  }
  int _countPeople = 1;
  void _incrementCount(){
    setState(() {
      _countPeople++;
      print(_countPeople);
    });
  }
  void _decrementCount() {
    if (_countPeople < 2) {
      return;
    }
    setState(() {
      _countPeople--;
    });
  }
  int _countRoom = 1;
  void _incrementCountRoom(){
    setState(() {
      _countRoom++;
      print(_countRoom);
    });
  }
  void _decrementCountRoom() {
    if (_countRoom < 2) {
      return;
    }
    setState(() {
      _countRoom--;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color: Colors.black45,
                child: IconButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    icon: Icon(FontAwesomeIcons.arrowLeft),
                ),
              ),
            ),
            SizedBox(width: 60,),
            Text('ĐƠN ĐẶT PHÒNG', style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width * 0.55,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(widget.documentSnapshot['imageUrl']),
                            fit: BoxFit.cover,
                          )
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        height: MediaQuery.of(context).size.width * 0.2,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(widget.documentSnapshot['nameHotel'], style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Vollkorn',
                              ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Text(widget.documentSnapshot['address'], style: TextStyle(
                                fontSize: 20  ,
                              ),),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.width*0.12,
                              color: Colors.grey.shade400,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 1),
                                    child: Text('Nhận: ' + widget.documentSnapshot['checkIn'],style: TextStyle(
                                      fontSize: 20,
                                    ),),
                                  ),
                                  SizedBox(width: 15,),
                                  Icon(FontAwesomeIcons.hourglassStart, color: Colors.blueGrey,),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 40,),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.width*0.12,
                              color: Colors.grey.shade400,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 1),
                                    child: Text('Trả: ' + widget.documentSnapshot['checkOut'],style: TextStyle(
                                      fontSize: 20,
                                    ),),
                                  ),
                                  SizedBox(width: 15,),
                                  Icon(FontAwesomeIcons.hourglassEnd, color: Colors.blueGrey,),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Text('Chọn ngày: ', style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),),
                      SizedBox(height: 7,),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                                  DateTime? startDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2023),
                                  );
                                  setState(() {
                                    _startDate = startDate;
                                    print(_startDate);
                                  });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.width*0.12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade400,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 1),
                                    child: Text('${_startDate!.month}/${_startDate!.day}/${_startDate!.year}',style: TextStyle(
                                      fontSize: 20,
                                    ),),
                                  ),
                                  SizedBox(width: 15,),
                                  Icon(FontAwesomeIcons.calendarDays, color: Colors.blueGrey,),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 9,),
                          Icon(FontAwesomeIcons.rightLong),
                          SizedBox(width: 9,),
                          GestureDetector(
                            onTap: () async {
                              DateTime? endDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              setState(() {
                                _endDate = endDate;
                                print(_endDate);
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.width*0.12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade400,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 1),
                                    child: Text('${_endDate!.month}/${_endDate!.day}/${_endDate!.year}',style: TextStyle(
                                      fontSize: 20,
                                    ),),
                                  ),
                                  SizedBox(width: 15,),
                                  Icon(FontAwesomeIcons.calendarDays, color: Colors.blueGrey,),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Số lượng người: ', style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),),
                          Text('Số lượng phòng:', style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),),
                        ],
                      ),

                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween
                        ,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width*0.4,
                            height: MediaQuery.of(context).size.width*0.1,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 17,
                                  child: FloatingActionButton(
                                    onPressed: _decrementCount,
                                    child: Icon(Icons.remove),
                                    backgroundColor: Colors.black38,
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Text('$_countPeople', style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                ),),
                                SizedBox(width: 15,),
                                CircleAvatar(
                                  radius: 17,
                                  child: FloatingActionButton(
                                    onPressed: _incrementCount,
                                      child: Icon(Icons.add),
                                    backgroundColor: Colors.black38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width*0.4,
                            height: MediaQuery.of(context).size.width*0.1,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 17,
                                  child: FloatingActionButton(
                                    onPressed: _decrementCountRoom,
                                    child: Icon(Icons.remove),
                                    backgroundColor: Colors.black38,
                                  ),
                                ),
                                SizedBox(width: 15,),
                                Text('$_countRoom', style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                ),),
                                SizedBox(width: 15,),
                                CircleAvatar(
                                  radius: 17,
                                  child: FloatingActionButton(
                                    onPressed: _incrementCountRoom,
                                    child: Icon(Icons.add),
                                    backgroundColor: Colors.black38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tổng giá tiền: ', style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),),
                          Text('\$' + widget.documentSnapshot['price'], style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: booking_Hotel,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height:  MediaQuery.of(context).size.height*0.1,
                    decoration: BoxDecoration(
                      // color: FlutterFlowTheme.of(context).primaryText,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1,
                          color: Colors.blueGrey,
                          offset: Offset(0, 1),
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                      child: Center(
                        child: Text('ĐẶT PHÒNG', style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontFamily: 'Vollkorn',
                        ),),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
  void booking_Hotel(){
    _booking.collection('booking').add({
      "nameHotel" : widget.documentSnapshot['nameHotel'],
      "addressHotel": widget.documentSnapshot['address'],
      "startDate": _startDate,
      "checkIn": widget.documentSnapshot['checkIn'],
      "checkOut": widget.documentSnapshot['checkOut'],
      "endDate" : _endDate,
      "people" : _countPeople,
      'room': _countRoom,
      "price" : widget.documentSnapshot['price'],
      "emailUser":  loggedInUser.email,
      "DateTimebooking" : DateTime.now(),
      "imageUrl": widget.documentSnapshot['imageUrl'],
      }
    );
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) => myorder_Screen(), maintainState: true));
    EasyLoading.showSuccess('Đặt phòng thành công!',
      duration: Duration(milliseconds: 1300),
      maskType: EasyLoadingMaskType.black,
    );
  }
}
