import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
class editHotel_Screen extends StatefulWidget {
  editHotel_Screen(this.documentSnapshot, {Key? key}) : super(key: key);
  DocumentSnapshot? documentSnapshot;
  @override
  State<editHotel_Screen> createState() => _editHotel_ScreenState();
}
class _editHotel_ScreenState extends State<editHotel_Screen> {
  final TextEditingController _imageUrlEdittingController = TextEditingController();
  final TextEditingController _nameHotelEdittingController = TextEditingController();
  final TextEditingController _priceEdittingController = TextEditingController();
  final TextEditingController _cityNameEdittingController = TextEditingController();
  final TextEditingController _checkInEdittingController = TextEditingController();
  final TextEditingController _checkOutEdittingController = TextEditingController();
  final TextEditingController _addressEdittingController = TextEditingController();
  final TextEditingController _descriptionEdittingController = TextEditingController();
  final CollectionReference _allCity = FirebaseFirestore.instance.collection('allHotel');
  String? imageHotelUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _allCity.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> documentSnapshot){
          // DocumentSnapshot document = snapshot.data!.docs[index];
          if(documentSnapshot.hasData){
            _imageUrlEdittingController.text = widget.documentSnapshot!['imageUrl'];
            _nameHotelEdittingController.text = widget.documentSnapshot!['nameHotel'];
            _priceEdittingController.text = widget.documentSnapshot!['price'];
            _cityNameEdittingController.text = widget.documentSnapshot!['nameCity'];
            _checkInEdittingController.text = widget.documentSnapshot!['checkIn'];
            _checkOutEdittingController.text = widget.documentSnapshot!['checkOut'];
            _addressEdittingController.text = widget.documentSnapshot!['address'];
            _descriptionEdittingController.text = widget.documentSnapshot!['description'];
             return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageHotelUrl == null ?
                    GestureDetector(
                      onTap: uploadImage,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 1,
                                blurRadius: 0.5,
                                color: Colors.black.withOpacity(0.1),
                              )
                            ],
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                              image: NetworkImage(widget.documentSnapshot!['imageUrl']),
                              fit: BoxFit.cover,
                            )
                        ),
                      ),
                    ) :
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                            image: NetworkImage(imageHotelUrl!),
                            fit: BoxFit.cover,
                          )
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextField(
                      controller: _nameHotelEdittingController,
                      decoration: const InputDecoration(
                        labelText: 'T??n kh??ch s???n',
                        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        border: OutlineInputBorder(
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextField(
                      // keyboardType:
                      // const TextInputType.numberWithOptions(decimal: true),
                      controller: _priceEdittingController,
                      decoration: const InputDecoration(
                        labelText: 'Gi?? kh??ch s???n',
                        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        border: OutlineInputBorder(
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextField(
                      // keyboardType:
                      // const TextInputType.numberWithOptions(decimal: true),
                      controller: _cityNameEdittingController,
                      decoration: const InputDecoration(
                        labelText: 'T??n th??nh ph???',
                        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        border: OutlineInputBorder(
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextField(
                      // keyboardType:
                      // const TextInputType.numberWithOptions(decimal: true),
                      controller: _checkInEdittingController,
                      decoration: const InputDecoration(
                        labelText: 'Th???i gian nh???n ph??ng',
                        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        border: OutlineInputBorder(
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextField(
                      // keyboardType:
                      // const TextInputType.numberWithOptions(decimal: true),
                      controller: _checkOutEdittingController,
                      decoration: const InputDecoration(
                        labelText: 'Th???i gian tr??? ph??ng',
                        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        border: OutlineInputBorder(
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextField(
                      // keyboardType:
                      // const TextInputType.numberWithOptions(decimal: true),
                      controller: _addressEdittingController,
                      decoration: const InputDecoration(
                        labelText: '?????a ch??? kh??ch s???n',
                        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        border: OutlineInputBorder(
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    TextField(
                      maxLines: 3,
                      // keyboardType:
                      // const TextInputType.numberWithOptions(decimal: true),
                      controller: _descriptionEdittingController,
                      decoration: const InputDecoration(
                        labelText: 'M?? t???',
                        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                        border: OutlineInputBorder(
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: MaterialButton(
                            height: 50,
                            minWidth: 300,
                            hoverColor: Colors.blueGrey,
                            color: Colors.grey,
                            child: const Text( 'C???P NH???T KH??CH S???N', style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20
                            ),),
                            onPressed: () async {
                              final String _imageUrl = _imageUrlEdittingController.text;
                              final String _nameHotel = _nameHotelEdittingController.text;
                              final String _price = _priceEdittingController.text;
                              final String _cityName = _cityNameEdittingController.text;
                              final String _checkIn = _checkInEdittingController.text;
                              final String _checkOut = _checkOutEdittingController.text;
                              final String _address = _addressEdittingController.text;
                              final String _description = _descriptionEdittingController.text;
                              if (imageHotelUrl != null) {
                                await widget.documentSnapshot!.reference
                                    .update({
                                  "imageUrl": imageHotelUrl,
                                  "nameHotel": _nameHotel,
                                  "price": _price,
                                  "nameCity": _cityName,
                                  "checkIn": _checkIn,
                                  "checkOut": _checkOut,
                                  "address" : _address,
                                  "description": _description,
                                });
                                Navigator.of(context).pop();
                                EasyLoading.showSuccess('C???p nh???t th??nh c??ng!',
                                  duration: Duration(milliseconds: 1300),
                                  maskType: EasyLoadingMaskType.black,
                                );
                              }
                              else{
                                await widget.documentSnapshot!.reference
                                    .update({
                                  "imageUrl": widget.documentSnapshot!['imageUrl'],
                                  "nameHotel": _nameHotel,
                                  "price": _price,
                                  "nameCity": _cityName,
                                  "checkIn": _checkIn,
                                  "checkOut": _checkOut,
                                  "address" : _address,
                                  "description": _description,
                                });
                                Navigator.of(context).pop();
                                EasyLoading.showSuccess('C???p nh???t th??nh c??ng!',
                                  duration: Duration(milliseconds: 1300),
                                  maskType: EasyLoadingMaskType.black,
                                );
                              }
                              print(widget.documentSnapshot!.id);
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            widget.documentSnapshot!.reference.delete();
                            EasyLoading.showSuccess('X??a th??nh c??ng!',
                              duration: Duration(milliseconds: 1300),
                              maskType: EasyLoadingMaskType.black,
                            );
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.12,
                            height: MediaQuery.of(context).size.width *0.12,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(FontAwesomeIcons.trash),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          return Center(child: Text('Erorr'));
        },
      ),
    );
  }
  uploadImage() async {
    final imagePicker = ImagePicker();
    PickedFile? image;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      image = await imagePicker.getImage(source: ImageSource.gallery);
      var file = File(image!.path);
      if (image != null) {
        var snapshot = await FirebaseStorage.instance
            .ref()
            .child('hotelImage/${image.path.split('/').last}')
            .putFile(file)
            .whenComplete(() => print('success'));
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageHotelUrl = downloadUrl;
        });
      } else {
        print('No image path received');
      }
    } else {
      print('Permission not granted. Try again with permission access');
    }
  }
}
