import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MovieBooking extends StatefulWidget {
  @override
  State<MovieBooking> createState() => _MovieBookingState();
}

class _MovieBookingState extends State<MovieBooking> {
  DateTime dt=DateTime(2022,11,04);
  final formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String contact = '';
  String ticketNo = '';
  String date='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ticket Booking"),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              nameTextField("Name"),
              const SizedBox(
                height: 15,
              ),
              emailTexField("Email"),
              const SizedBox(
                height: 15,
              ),
              contactTextFild("Contact Number"),
              const SizedBox(
                height: 15,
              ),
              ticketText("No of Tickets"),
              const SizedBox(
                height: 15,
              ),
              dateOnly(),
              buildSubmit()

            ],
          ),
        ));
  }

  Widget nameTextField(String label) => TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.length < 4)
            return 'Enter at least 4 characters';
          else
            return null;
        },
        keyboardType: TextInputType.text,
        onSaved: (value) => setState(() => name = value!),
      );

  Widget emailTexField(String label) => TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value!))
            return 'Please enter a valid email id';
          else
            return null;
        },
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) => setState(() => email = value!),
      );

  Widget contactTextFild(String label) => TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.length > 10) {
            return 'Please enter only 10 digit number';
          } else if(value.isEmpty){
            return 'Please enter 10 digit phone number';
          }
          else {
            return null;
          }
        },
        keyboardType: TextInputType.phone,
        onSaved: (value) => setState(() => contact = value!),
      );

  Widget ticketText(String label) => TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        onSaved: (value) => setState(() => ticketNo = value!),
      );

  Widget buildSubmit() => ElevatedButton(
        onPressed: () {
          final isValid = formKey.currentState!.validate();
          if (isValid) {
            formKey.currentState!.save();
          }
        },
        child: Text("Submit"),
      );
  Widget datePicker()=>Container(
    child: Expanded(
      child: Row(
        children: [
          IconButton(onPressed: ()async{
              DateTime? newDate=await showDatePicker(context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(Duration(days: 1)),
                  lastDate:DateTime(2100));
              if(newDate==null)return;
              setState(()=>dt=newDate);
          }, icon: Icon(Icons.calendar_month,color: Colors.black,)),
          SizedBox(width: 10,),

          TextFormField(initialValue: '${dt.day.toString()}/${dt.month.toString()}/${dt.year.toString()}')
        ],
      ),
    ),
  );
  Widget dateOnly() =>IconButton(onPressed: ()async{
  DateTime? newDate=await showDatePicker(context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime.now().subtract(Duration(days: 1)),
  lastDate:DateTime(2100));
  if(newDate==null)return;
  setState(()=>dt=newDate);
}, icon: Icon(Icons.calendar_month,color: Colors.black,));
}

