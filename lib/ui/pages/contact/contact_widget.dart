import 'package:flutter/material.dart';
import 'package:restorder/logic/bloc/contact_bloc.dart';
import 'package:restorder/models/contact/contact_response.dart';

class ContactWidget extends StatefulWidget {
  ContactWidget({Key key}) : super(key: key);

  @override
  ContactWidgetState createState() {
    return new ContactWidgetState();
  }
}

class ContactWidgetState extends State<ContactWidget> {
  Size deviceSize;

  addressCard(ContactResponse contactResponse) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Card(
          //RoundedRectangleBorder, BeveledRectangleBorder, StadiumBorder
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10.0), top: Radius.circular(2.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  contactResponse.name,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.orange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Address',
                  style: TextStyle(fontSize: 15.0, color: Colors.black38),
                ),
                SizedBox(
                  height: 3.0,
                ),
                Text(
                  contactResponse.address,
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 10.0,
                ),
                contactResponse.mobile.isEmpty? Container() :
                GestureDetector(
                  onTap: () {

                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Icon(Icons.call, size: 20.0, color: Colors.black54),
                        new Text(contactResponse.mobile,
                            style: new TextStyle(
                                fontSize: 15.0, color: Colors.black54)),
                      ]),
                ),
              ],
            ),
          ),
        ),
      );

  bodyData() {
    ContactBloc contactBloc = ContactBloc();
    return StreamBuilder<List<ContactResponse>>(
        stream: contactBloc.contactItems,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? bodyList(snapshot.data)
              : Center(child: CircularProgressIndicator());
        });
  }

  bodyList(List<ContactResponse> listContact) =>
      ListView.builder(
        //shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: listContact.length,
        itemBuilder: (context, i) {
          ContactResponse contactResponse = listContact[i];
          return addressCard(contactResponse);
        },
      );

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return  new Container(
      child: bodyData()
    );
  }
}