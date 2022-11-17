
import 'package:app_booking/screens/addHotel_Screen.dart';
import 'package:app_booking/screens/destination_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'editHotel_Screen.dart';

late User loggedInUser;
class allHotel_Screen extends StatefulWidget {
  allHotel_Screen({ required this.documentSnapshot});
  DocumentSnapshot? documentSnapshot;
  @override
  State<allHotel_Screen> createState() => _allHotel_ScreenState();
}

class _allHotel_ScreenState extends State<allHotel_Screen> {
  final String admin = "admin@email.com";
  final _auth = FirebaseAuth.instance;
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
  final CollectionReference _allHotel = FirebaseFirestore.instance.collection('allHotel');
  Future<void> deleteHotel(String hotelID) async {
    await _allHotel.doc(hotelID).delete();
    EasyLoading.showSuccess('Xóa thành công',
      duration: const Duration(milliseconds: 1300),
      maskType: EasyLoadingMaskType.black,
    );
  }
  @override
  Widget build(BuildContext context) {
    var currentuser = loggedInUser.email;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: Text('Khách sạn tại ' + widget.documentSnapshot!['nameCity'], style: TextStyle(
                color: Colors.blueGrey.shade800,
                fontFamily: 'Vollkorn',
              fontSize: 20,
            ),)),
            currentuser == admin ?
            GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          addHotel_Screen(documentSnapshot: widget.documentSnapshot,)));
                },
                child: Icon(FontAwesomeIcons.circlePlus,
                  color: Colors.blueGrey.shade800,
                  size: 30,)): const SizedBox(),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('allCity').
        doc(widget.documentSnapshot!.id).collection('allHotel').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData) return const Text('Erorr');
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index){
                DocumentSnapshot document = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>
                            DestinationScreen(documentSnapshot: document))),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topRight,
                          width: width,
                          height: width*0.5,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                            image: DecorationImage(
                              image: NetworkImage(document['imageUrl']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: width,
                              height: height * 0.05,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  currentuser == admin ?
                                  GestureDetector(
                                    onTap: () => Navigator.push(context,
                                      MaterialPageRoute(builder:(context) =>
                                          editHotel_Screen(document),),),
                                    child: Container(
                                        height: width *0.12,
                                        width: width *0.12,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade600,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(FontAwesomeIcons.edit, color: Colors.white,)),
                                  ): const SizedBox(),
                                  const SizedBox(width: 5,),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: width,
                          height: width*0.2,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade200,
                            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(document['nameHotel'], style: const TextStyle(
                                  fontSize: 27,
                                  fontFamily: 'Vollkorn',
                                ),),
                                Text('VND ' + document['price'],
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
          );
        },
      ),
    );
  }
}
