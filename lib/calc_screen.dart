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
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      clearAll();
      return;
    }
    if (value == Btn.per) {
      convertToPercentage();
      return;
    }
    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  } 

  // Calculates the result based on the current input
void calculate() {
  if (number1.isEmpty) return; // No input to calculate
  if (operand.isEmpty) return;
  if (number2.isEmpty) return;

  double num1 = double.parse(number1);
  double num2 = double.parse(number2);

  var result = 0.0;
  switch (operand) {
    case Btn.add:
    result = num1 + num2;
      break;
      case Btn.subtract:
    result = num1 - num2;
      break;
      case Btn.multiply:
    result = num1 * num2;
      break;
      case Btn.divide:
    result = num1 / num2;
      break;
    default:
  }
  setState(() {
    number1 = "$result"; // Update number1 with the result
  
    if (number1.endsWith('.0')) {
      number1 = number1.substring(0, number1.length - 2); // Remove trailing .0
    }
    operand = ""; // Clear the operand
    number2 = ""; // Clear number2
  });

}
  // Converts output to percentage
  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty ) {
      // calculate before conversion 
      calculate(); // Calculate the result before converting to percentage

    }
    if (operand.isNotEmpty) {
      // Cannot be converted
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = ""; // Clear the operand
      number2 = ""; // Clear number2
    });
    
  }

  // Clear all functionality
  void clearAll() {
    setState(() {
      number1 = ""; // Clear number1
      operand = ""; // Clear operand
      number2 = ""; // Clear number2  
    });
  }

  // Delete functionality
  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1); // Remove last character from number2
    } else if (operand.isNotEmpty) {
      operand = ""; // Clear the operand if number2 is empty
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1); // Remove last character from number1
    }
    setState(() {}); // Update the UI
  }

   // Appends value to the end
  void appendValue(String value) {
    // if its operand and not a dot 
    if (value!=Btn.dot&&int.tryParse(value)== null) {
    // Operand or special button pressed
      if (operand.isNotEmpty&&number2.isNotEmpty) {
        // Calculate the equation before assigning a new operand
        calculate(); // Calculate the result before assigning a new operand
      }
      operand = value; // Assign the operand
    }
    // Assign value to number1 variable
     else if (number1.isEmpty ||operand.isEmpty){
      //check if tha value is a decimal eg, number1 = "1.2"
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
        // Prevent multiple dots in the first number
      if (value == Btn.dot && (number1.isEmpty || number1==Btn.dot)) {
        //number1 = "" or "0" 
        value = "0."; // If the first number is empty or just a dot, make it "0."
      }
      number1 += value; // Append the value to number1
    }
    // Assign value to number2 variable
     else if (number2.isEmpty ||operand.isNotEmpty){
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