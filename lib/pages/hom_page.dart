
import 'dart:ui';
import 'package:flutter/material.dart';
import '../notification/notification.dart';
import '../serves/helper.dart';
class HomPage extends StatefulWidget {
  const HomPage({Key? key}) : super(key: key);

  @override
  _HomPageState createState() => _HomPageState();
}

class _HomPageState extends State<HomPage> {
  List<Map<String,dynamic>>_groceryItem=[];

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _groceryItem=HiveHelper.getGroceries();
    });
    super.initState();
  }

  final _itemController=TextEditingController();
  final _quantityController=TextEditingController();
  final _dateController=TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor:Colors.white,
        elevation:0,
        centerTitle:true,
        title:const Text("NOTES APP",style:TextStyle(fontSize:22,fontWeight:FontWeight.bold,color:Colors.black),),
      ),
      body:_groceryItem.isEmpty
          ? const Center(
            child:Text(
            "No Grocery Items added yet!",
          style:TextStyle(fontSize:20,fontWeight:FontWeight.bold),),):
      ListView.builder(
        itemCount:_groceryItem.length,
          itemBuilder:(context,index){
            final _item=_groceryItem[index];
            return Container(
              margin: const EdgeInsets.only(left:10,right:10,top:10),
              height:80,
                decoration:BoxDecoration(
                  color:Colors.lightGreen,
                 borderRadius:BorderRadius.circular(20)
                ),
              child: ListTile(
                title:Text(_item['item'],style:const TextStyle(fontSize:18,fontWeight:FontWeight.w800,color:Colors.black,),),
                subtitle:Text(_item['date'],style:const TextStyle(fontSize:15,color:Colors.black),),
                leading:Text(_item['quantity'],style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold,color:Colors.black),),
                trailing:IconButton(
                  icon:const Icon(Icons.delete),
                  onPressed:(){
                    sendNotification("Congratulations","Successfully deleted");
                    HiveHelper.deleteItem(_item['key']);
                    setState(() {
                      _groceryItem=HiveHelper.getGroceries();
                    });
                  },
                ),
                onTap:()=>_groceryModel(context,_item['key']),
              ),
            );
          }
      ),
      floatingActionButton:FloatingActionButton(
        onPressed:()=>_groceryModel(context,null),
        child:const Icon(Icons.add),
      ),
    );
  }
  void _groceryModel(BuildContext context,int?key){
    if(key!=null){
      final _currentItem=
      _groceryItem.firstWhere((item) => item['key']==key);
      _itemController.text=_currentItem['item'];
      _quantityController.text=_currentItem['quantity'];
      _dateController.text=_currentItem['date'];
    }
    showDialog(
        context:context,
        builder:(_){
          return AlertDialog(
            title:key==null?const Text("Add Items"):const Text("Update Items"),
            content:Column(
              mainAxisSize:MainAxisSize.min,
              children: [
                _buildTextField(_itemController,"Item"),
                const SizedBox(height:10,),
                _buildTextField(_quantityController,"Quantity"),
                const SizedBox(height:10,),
                _buildTextField(_dateController,"Date"),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed:(){
                    if(key==null){
                      HiveHelper.addItem({
                        "item":_itemController.text,
                        "quantity":_quantityController.text,
                        "date":_dateController.text,
                      });
                    }else{
                      HiveHelper.updateItem(key,{
                        "item":_itemController.text,
                        "quantity":_quantityController.text,
                        "date":_dateController.text,
                      });
                    }
                    _itemController.clear();
                    _quantityController.clear();
                    _dateController.clear();
                    setState(() {
                      _groceryItem=HiveHelper.getGroceries();
                      Navigator.of(context).pop();
                    });
                  },
                  child:key==null?const Text("Add New"):const Text("Update")
              ),
            ],
          );
        }
    );
  }
  TextField _buildTextField(TextEditingController _controller,String hind){
    return TextField(
      controller:_controller,
      decoration:InputDecoration(
        hintText:hind,
        labelText:hind,
      )
    );
  }
}
