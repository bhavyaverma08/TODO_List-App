import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import '../database_helper.dart';
import '../Note.dart';
import 'note_details.dart';
import 'package:sqflite/sqflite.dart';


class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  
  

  @override
  Widget build(BuildContext context) {
    if(noteList == null){
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar : AppBar(
        title:Text('My TODO List'),
        backgroundColor : Colors.blue[700],
      ),
      body: getNoteListView(),
      floatingActionButton: new FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),        
        backgroundColor :Colors.purple,
        icon: Icon(Icons.add),
        label: Text('Add Note'),
        splashColor: Colors.orangeAccent,
        onPressed:(){
          navigateToDetail(Note('', '', 2), 'Add Note');
                    
        }
        

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      
    );
  }


  ListView getNoteListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context,position){
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          color: Colors.deepPurple,
          elevation: 4.0,
          child: ListTile(
            leading:CircleAvatar(
              backgroundImage: AssetImage("images/2.png"),                
            ),
            title: Text(this.noteList[position].title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
            ),
            subtitle: Text(this.noteList[position].date,
            style: TextStyle(
              color: Colors.white,              
            ),),
            trailing: GestureDetector(
              child: Icon(Icons.open_in_new,color: Colors.white),
              onTap:(){ 
                navigateToDetail(this.noteList[position], 'Edit TODO');
              },
            ),
          ),
        );

      }
      
    );
  }



  void navigateToDetail(Note note , String title) async {
    bool result = await Navigator.push(context,
    MaterialPageRoute(builder: (context){
      return NoteDetail(note, title);
    }));
    

    if(result == true){
      updateListView();
    }

  }

  void updateListView(){
    final Future<Database> dbFuture= databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
        
      
    });
    
  });
  
  }


}