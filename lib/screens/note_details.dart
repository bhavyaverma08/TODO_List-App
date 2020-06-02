import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../Note.dart';
import '../database_helper.dart';
import 'package:intl/intl.dart';


class NoteDetail extends StatefulWidget {

  final String appBarTitle ;
  final Note note ;

  NoteDetail(this.note,this.appBarTitle);

  @override
  State<StatefulWidget>createState(){
    return NoteDetailState(this.note , this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _priorities = ['High','Low'];
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Note note;
  
  NoteDetailState(this.note,this.appBarTitle);

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  //TextEditingController priorityController = TextEditingController();
 // TextSelection get Priority=> TextSelectionGestureDetector;



  
  

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    titleController.text = note.title;
    descriptionController.text = note.description;
   // priorityController.text = note.priority;

    return WillPopScope(
      onWillPop: (){
        moveToLastScreen();
      },
      child: Scaffold(
        backgroundColor: Colors.orangeAccent,
        appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: Colors.deepPurple,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){moveToLastScreen();},
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListView(
              children: <Widget>[
                // Padding(
                //   padding: EdgeInsets.only(top: 15.0,bottom: 5.0),
                //   //drop down menu
                //   child: new ListTile(
                //     leading: const Icon(Icons.low_priority),
                //     title: DropdownButton(
                //       items: _priorities.map((String dropDownStringItem){
                //         return DropdownMenuItem<String>(
                //           value: dropDownStringItem,
                //           child: Text(dropDownStringItem,
                //           style: TextStyle(
                //             fontSize: 20.0,
                //             fontWeight:FontWeight.bold,
                //             color: Colors.red)),
                //         );
                //       }).toList(),
                //       value: getPriorityAsString(note.priority),
                //       onChanged: (valueSelectedByUser){
                //         setState(() {
                //           updatePriorityAsInt(valueSelectedByUser);
                //         });
                //       }
                //     ),
                //   ),
                // ),
                //second element
                Padding(
                  padding: EdgeInsets.only(top:15.0,bottom:15.0,left:15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value){
                      updateTitle();
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: textStyle,
                      icon: Icon(Icons.title),
                    ),
                  ),
                ),
                //Third Element
                Padding(
                  padding: EdgeInsets.only(top:15.0, bottom:15.0, left:15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value){
                      updateDescription();
                    },
                    decoration: InputDecoration(
                      labelText: 'Details',
                      icon: Icon(Icons.details),
                    ),
                  ),
                ),
                //fourth element 
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                          ),
                          textColor: Colors.white,
                          splashColor: Colors.limeAccent,
                          color: Colors.green[400],
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: (){
                            setState(() {
                              debugPrint("Save Button Clicked");
                              _save();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                          ),
                          textColor: Colors.white,
                          color: Colors.red[800],
                          splashColor: Colors.pink[300],
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,                            
                          ),
                          onPressed: (){
                            setState(() {
                              debugPrint("Deleted");
                              _delete();                              
                            });
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );



  }

  void updateTitle(){
    note.title = titleController.text;
  }

  void updateDescription(){
    note.description = descriptionController.text;
  }

  // void updatePriority(){
  //   note.priority = priorityController.text;
  // }



  void _save() async{
    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result ;
    if(note.id!= null){
      result=await helper.updateNote(note);
    }
    else{
      result = await helper.insertNote(note);
    }

    if(result!=0){
      _showAlterDialog('status', 'Note Saved Successfully');
    }
    else{
      _showAlterDialog('status', 'Problem Saving Note');
    }


  }

  void _delete() async{
    moveToLastScreen();

    if(note.id==null){
      _showAlterDialog('status', 'First Add a Note');
      return;
    }

    int result = await helper.deleteNote(note.id);
    if(result!=0){
      _showAlterDialog('status', 'Note Deleted Successfully');
    }
    else{
      _showAlterDialog('status', 'Error');
    }


  }


  //convert to int to save to database
  void updatePriorityAsInt(String value){
    switch (value) {
      case 'High':
       note.priority=1;
        
        break;
      case 'Low':
       note.priority=2;
      
        
        break;
      case ' ':
       note.priority=3;
       break;
      
      //default:
    }
  }

  //convert int to string to show user
  String getPriorityAsString(int value){
    String priority;
    switch (value) {
      case 1:
       priority=_priorities[0];
        
        break;
      case 2:
       priority=_priorities[1];
      
        
        break;
      case 3:
       priority=_priorities[2];
      
        
        break;
      //default:
    }
    return priority;
  }




  moveToLastScreen(){
    Navigator.pop(context,true);
  }


  void _showAlterDialog(String title , String message){
    AlertDialog alertDialog =AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context,builder: (_)=> alertDialog);
  }






  

}




