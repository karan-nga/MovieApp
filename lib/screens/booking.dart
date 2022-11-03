import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MovieBooking extends StatefulWidget {
  final String movieName;

  MovieBooking(this.movieName);

  @override
  State<MovieBooking> createState() => _MovieBookingState(movieName);
}

class _MovieBookingState extends State<MovieBooking> {
  final timeList = [
    "9:30AM-11:30AM",
    "12:30PM-2:30PM",
    "3PM-5PM",
    "6:30PM-8:30PM",
    "9:30PM-11:30PM"
  ];

  DateTime dt = DateTime(2022, 11, 04);
  final formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String contact = '';
  String ticketNo = '';
  String dropdownvalue = "9:30AM-11:30AM";
  String movieName;
  late DatabaseReference dbRef;

  _MovieBookingState(this.movieName);

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child("Booking Details");
  }

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
              const SizedBox(
                height: 15,
              ),
              timeSelector(),
              SizedBox(height: 10),
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
          } else if (value.isEmpty) {
            return 'Please enter 10 digit phone number';
          } else {
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
             fireBaseBookingData();

          }
        },
        child: Text("Book Ticket",style: TextStyle(fontSize: 17),),

      );

  Widget datePicker() => Container(
        child: Expanded(
          child: Row(
            children: [
              IconButton(
                  onPressed: () async {
                    DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(Duration(days: 1)),
                        lastDate: DateTime(2100));
                    if (newDate == null) return;
                    setState(() => dt = newDate);
                  },
                  icon: Icon(
                    Icons.calendar_month,
                    color: Colors.black,
                  )),
              SizedBox(
                width: 10,
              ),
              TextFormField(
                  initialValue:
                      '${dt.day.toString()}/${dt.month.toString()}/${dt.year.toString()}')
            ],
          ),
        ),
      );

  Widget dateOnly() =>
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        IconButton(
            onPressed: () async {
              DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(Duration(days: 1)),
                  lastDate: DateTime(2100));
              if (newDate == null) return;
              setState(() => dt = newDate);
            },
            icon: Icon(
              Icons.calendar_month,
              color: Colors.blueAccent,
            )),
        SizedBox(width: 20),
        Text(
          '${dt.day}/${dt.month}/${dt.year}',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black
          ),
        )
      ]);

  Widget timeSelector() =>
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(
          "Choose timing",
          style: TextStyle(
              fontSize: 18,  color: Colors.black),
        ),
        SizedBox(width: 20),
        DropdownButton(
          borderRadius: BorderRadius.circular(10),

          dropdownColor: Colors.white,
          style: TextStyle(
              fontSize: 16,  color: Colors.black,letterSpacing: 0.5),
          // Initial Value
          value: dropdownvalue,

          // Down Arrow Icon
          icon: const Icon(Icons.keyboard_arrow_down),

          // Array list of items
          items: timeList.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) {
            setState(() {
              dropdownvalue = newValue!;
            });
          },
        ),
      ]);

  void fireBaseBookingData() {
    Map<String, String> book = {
      "Movies Name": movieName.trim(),
      "Customer Name": name.trim(),
      "Customer Email": email.trim(),
      "Customer Contact Number": contact.trim(),
      "Number of Tickets": ticketNo.trim(),
      "Booking Data":
          '${dt.day.toString()}/${dt.month.toString()}/${dt.year.toString()}',
      "Booking Time": dropdownvalue.toString()
    };
    dbRef.push().set(book);
    print(dbRef.onChildAdded.hashCode.toString());
  }
}
