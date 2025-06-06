import 'package:flutter/material.dart';
import 'package:simplecalc/button_value.dart';

class MyCalcScreen extends StatefulWidget {
  const MyCalcScreen({super.key});

  @override
  State<MyCalcScreen> createState() => _MyCalcScreenState();
}

class _MyCalcScreenState extends State<MyCalcScreen> {
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
                    child: Text("0",
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
          onTap: () {},
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