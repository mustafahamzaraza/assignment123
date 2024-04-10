import 'dart:convert';

import 'package:assignment/expensehistory.dart';
import 'package:assignment/main.dart';
import 'package:flutter/material.dart';


class MyDrawer extends StatefulWidget {


  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {



  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {


    return Drawer(


        child:  Column(children: <Widget>[

              DrawerHeader(
                child:
                Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back_ios,color: Colors.black,))),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.white
                                ),
                              ),
                              child: Image.network('https://5.imimg.com/data5/SELLER/Default/2022/4/IL/TA/IY/11929731/flower-wallpaper-500x500.jpg',fit: BoxFit.cover,),
                            ),
                          ],
                        ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 3,),
                            Row(children: [
                              Text('Welcome!',style: TextStyle(fontSize: 20,color: Colors.white),),
                              SizedBox(width: 2,),
                              //Icon(Icons.circle_sharp,color: Colors.greenAccent,size: 15,),
                              SizedBox(width: 30,),

                            ],),

                            Text('',style: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.w300),)
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://appmaking.co/wp-content/uploads/2021/08/android-drawer-bg.jpeg",
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),


              Divider(color: Colors.white38,),
              SizedBox(height: 30,),


          ListTile(
            title: Text(
              'Expense Summary',
              style: TextStyle(fontSize: 17.0, color: Colors.black,fontWeight: FontWeight.normal),
            ),
            leading: Container(
              height: 40,
              width: 40,
              child: Icon(Icons.note_add),
            ),
            trailing: Wrap(
              spacing: 12, // space between two icons
              children: <Widget>[
                Icon(Icons.arrow_forward,size: 20,color: Colors.white70,),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => ExpenseListPageSum()));
            },
          ),
          SizedBox(height: 10,),

              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(fontSize: 17.0, color: Colors.black,fontWeight: FontWeight.normal),
                ),
                leading: Container(
                  height: 40,
                  width: 40,
                  child: Icon(Icons.logout),
                ),
                trailing: Wrap(
                  spacing: 12, // space between two icons
                  children: <Widget>[
                    Icon(Icons.arrow_forward,size: 20,color: Colors.white70,),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => SignInScreen()));
                },
              ),

              SizedBox(height: 10,),



            ])

    );
  }

}
