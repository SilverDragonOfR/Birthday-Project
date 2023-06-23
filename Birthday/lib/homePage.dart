import 'package:birthday/boxes/boxes.dart';
import 'package:birthday/models/person.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyHomePage extends StatefulWidget
{
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
  final nameController = TextEditingController();
  final bdayController = TextEditingController();

  var search = "";

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: Row
        (
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:
          [
            Text("Birthday",style: TextStyle(fontSize: 30)),
            Container
            (
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.white),
              child:
              Container
              (
                width: MediaQuery.of(context).size.width*0.5,
                height: 30,
                child: TextField
                (
                  onChanged: (value)
                  {
                    setState(()
                    {
                      search = value;
                    });
                  },
                  decoration: InputDecoration
                  (
                    contentPadding: EdgeInsets.only(left: 20),
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search Person"
                  ),
                )
              ),
            )
          ],
        ),
      ),
      body:
      Scaffold
      (
        body:
        ValueListenableBuilder<Box<PersonModel>>
        (
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, child)
          {
            var data = box.values.toList().cast<PersonModel>();
            var searched_data = data.where((val)
            {
              return val.name.toString().toLowerCase().startsWith(search.toLowerCase());
              // print("${val.name.toString().toLowerCase().startsWith(search.toLowerCase())}");
              // return true;
            }).toList();
            return ListView.builder
            (
              itemCount: searched_data.length,
              itemBuilder: (context,index)
              {
                return Card
                (
                  child:
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child:
                    Row
                    (
                      children:
                      [
                        Column
                        (
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                          [
                            Text(searched_data[index].name.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                            Text(DateFormat('d MMMM').format(searched_data[index].birthDate),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300),)
                          ]
                        ),
                        Spacer(),
                        Row
                        (
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:
                          [
                            InkWell
                            (
                              onTap: ()
                              {
                                _editDialogue(searched_data[index],searched_data[index].name.toString(),searched_data[index].birthDate.toString());
                              },
                              child: Icon(Icons.edit),
                            ),

                            Container
                            (
                              width: 20,
                            ),
                            InkWell
                            (
                              onTap: ()
                              {
                                delete(searched_data[index]);
                              },
                              child: Icon(Icons.delete),
                            )
                          ],
                        )
                      ],
                    )
                  )
                );
              }
            );
          },
        )
      ),



      floatingActionButton:
      FloatingActionButton
      (
        onPressed: () async{ _showMyDialogue(); },
        child: const Icon(Icons.add),
      ),
    );
  }

  void delete(PersonModel personModel) async
  {
    personModel.delete();
  }

  Future<void> _editDialogue(PersonModel personModel, String name, String birthDate) async
  {
    nameController.text = name;
    bdayController.text = "";

    return
    showDialog
    (
      context: context,
      builder:
      (context)
      {
        return
        AlertDialog
        (
          title: Text("Edit Birthday"),
          content:
          Container
          (
            child:
            ListView
            (
              children:
              [
                TextFormField
                (
                  controller: nameController,
                  decoration:
                  InputDecoration
                  (
                    hintText: "Enter Name",
                    border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
                Center
                ( 
                  child:
                  TextFormField
                  (
                    controller: bdayController,
                    decoration:
                    InputDecoration
                    ( 
                      hintText: "Enter Birthdate",
                      icon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async
                    {
                      DateTime? pickedDate = await showDatePicker
                      (
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1970),
                          lastDate: DateTime.now()
                      );
                      
                      if(pickedDate != null )
                      {
                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

                          setState(()
                          {
                            bdayController.text = formattedDate;
                          });
                      }
                    },
                  )
                )
              ],
            ),
            height: 130,
            width: double.maxFinite,
          ),

          actions:
          [
            TextButton
            (
              onPressed: ()
              {
                nameController.clear();
                bdayController.clear();
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton
            (
              onPressed:() async
              { 
                personModel.name = nameController.text;
                personModel.birthDate = DateTime.parse(bdayController.text);
                nameController.clear();
                bdayController.clear();
                await personModel.save();
                Navigator.pop(context);
              }
            ,child: Text("Save"),
            )
          ]
        );


      }
    );
  }

  Future<void> _showMyDialogue() async
  {
    nameController.clear();
    bdayController.clear();
    return
    showDialog
    (
      context: context,
      builder:
      (context)
      {
        return
        AlertDialog
        (
          title: Text("Add Birthday"),
          content:
          Container
          (
            child:
            ListView
            (
              children:
              [
                TextFormField
                (
                  controller: nameController,
                  decoration:
                  InputDecoration
                  (
                    hintText: "Enter Name",
                    border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
                Center
                ( 
                  child:
                  TextFormField
                  (
                    controller: bdayController,
                    decoration:
                    InputDecoration
                    ( 
                      hintText: "Enter Birthdate",
                      icon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async
                    {
                      DateTime? pickedDate = await showDatePicker
                      (
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1970),
                          lastDate: DateTime.now()
                      );
                      
                      if(pickedDate != null )
                      {
                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

                          setState(()
                          {
                            bdayController.text = formattedDate;
                          });
                      }
                    },
                  )
                )
              ],
            ),
            height: 130,
            width: double.maxFinite,
          ),

          actions:
          [
            TextButton
            (
              onPressed: ()
              {

                nameController.clear();
                bdayController.clear();
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton
            (
              onPressed:()
              {
                final data = PersonModel(-1,nameController.text,DateTime.parse(bdayController.text));
                final box = Boxes.getData();
                box.add(data);
                data.save();

                nameController.clear();
                bdayController.clear();

                Navigator.pop(context);
              }
            ,child: Text("Save"),
            )
          ]
        );


      }
    );
  }


}