import 'package:app_booking/screens/editCity.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'addCityAll.dart';
import 'allHotel_Screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class all_City extends StatefulWidget {
  const all_City({Key? key}) : super(key: key);

  @override
  State<all_City> createState() => _all_CityState();
}

class _all_CityState extends State<all_City> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
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
      }
    } catch (e) {
      print('e');
    }
  }
  final CollectionReference _allCity = FirebaseFirestore.instance.collection('allCity');
  String admin = "admin@email.com";
  Future<void> delete(String cityID) async {
    await _allCity.doc(cityID).delete();
    EasyLoading.showSuccess('Xóa thành công!',
      duration: const Duration(milliseconds: 1300),
      maskType: EasyLoadingMaskType.black,
    );
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: Text('TẤT CẢ ĐỊA ĐIỂM', style: TextStyle(
              color: Colors.blueGrey.shade800,
              fontFamily: 'Vollkorn'
            ),)),
            loggedInUser.email == admin ?
            GestureDetector(
              onTap: () => Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => const addCity_Screen())),
                child: const Icon(FontAwesomeIcons.circlePlus,
                  color: Colors.grey,
                  size: 35,)) : const SizedBox(),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _allCity.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData)
            return const SpinKitSquareCircle(
            color: Colors.white,
            size: 50.0,
             duration: Duration(milliseconds: 1400),
          );
          return GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: width * 0.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, int index){
              DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
              return Stack(
                alignment: Alignment.bottomLeft,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                allHotel_Screen(documentSnapshot: documentSnapshot,)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: NetworkImage(documentSnapshot['imageUrl']),
                              fit: BoxFit.cover,
                              colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.darken),
                            ),
                        ),
                      ),
                    ),
                    loggedInUser.email == admin ?
                    Positioned(
                      top: 5, right: 50,
                      child: GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => editCity_Screen(documentSnapshot))),
                        child: Container(
                          width: width * 0.1,
                          height: width * 0.1,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(FontAwesomeIcons.edit),
                        ),
                      ),): const SizedBox(),
                    loggedInUser.email == admin ?
                    Positioned(
                      top: 5, right: 5,
                      child: GestureDetector(
                        onTap: (){
                          delete(documentSnapshot.id);
                        },
                        child: Container(
                          width: width * 0.1,
                          height: width * 0.1,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(FontAwesomeIcons.trashCan),
                        ),
                      ),): const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 5,),
                          Text(documentSnapshot['nameCity'],
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontFamily: 'Vollkorn',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
              );
            },
          );
        },
      )
    );
  }
}
