import 'package:flutter/material.dart';
import 'package:simplecalc/button_value.dart';

class MyCalcScreen extends StatefulWidget {
  const MyCalcScreen({super.key});

  @override
  State<MyCalcScreen> createState() => _MyCalcScreenState();
}

class _MyCalcScreenState extends State<MyCalcScreen> {
  String number1 = ""; // . and 0-9
  String operand = ""; // + - * /
  String number2 = ""; // . and 0-9
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size; // Get the screen size
    return Scaffold( // Keeps the code inside the operating UI
        body: SafeArea(
          child: Column( // Column will enable us to have multiple widgets inside one widget
            children: [
              // Output
              Expanded( 
                child: SingleChildScrollView(
                  reverse: true, // Reverse the scroll direction (makes the text appear at the bottom)
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.all(16),
                    child: Text("$number1 $operand $number2".isEmpty ? "0" :
                     "$number1 $operand $number2",
                    // If the string is empty, show 0, else show the string
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),
          
              // Input(Buttons)

              Wrap(
                children: 
                  Btn.buttonValues.map((value) =>
                   SizedBox(
                    width:value == Btn.n0? screenSize.width /2 : // Makes the 0 button twice as wide
                     (screenSize.width / 4), // Divide the screen width by 4 for equal button sizes
                    height: screenSize.width / 5, // Make the height equal to the width for square buttons
                    child: buildButton(value)),).toList(),
                
              )
            ],
          ),
        ),
      );
  } 

  Widget buildButton(value) {
    return Padding(  // Padding around each button for better spacing
      padding: const EdgeInsets.all(4.0),
      child: Material(     // Gives the button a material design look and splash effect
        color: getBtnColor(value), // Gives the button a colour based on its value
        clipBehavior: Clip.hardEdge,    // Keeps the splash effect within the button bounds
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(100)),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            )
            ),
        ),
      ),
    );
  } 

  void onBtnTap(String value) {

    if (value!=Btn.dot&&int.tryParse(value)== null) {

      if (operand.isNotEmpty&&number2.isNotEmpty) {
        // Calculate the equation before assigning a new operand
      }
      operand = value; // Assign the operand
    } else if (number1.isEmpty ||operand.isEmpty){
      // number1 = "1.2"
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
        // Prevent multiple dots in the first number
      if (value == Btn.dot && (number1.isEmpty || number1==Btn.dot)) {
        //number1 = "" or "0" 
        value = "0."; // If the first number is empty or just a dot, make it "0."
      }
      number1 += value; // Append the value to number1
    } else if (number2.isEmpty ||operand.isNotEmpty){
      // number1 = "1.2"
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
        // Prevent multiple dots in the first number
      if (value == Btn.dot && (number2.isEmpty || number2==Btn.dot)) {
        //number1 = "" or "0" 
        value = "0."; // If the first number is empty or just a dot, make it "0."
      }
      number2 += value; // Append the value to number1
    }

    
    setState(() {});
  }

// Color logic for the buttons
  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value) ? Colors.blueGrey :
          [Btn.per,
          Btn.multiply,
          Btn.add,
          Btn.subtract,
          Btn.divide,
          Btn.calculate ].contains(value) ? Colors.orange :
          Colors.black87;
  }
}