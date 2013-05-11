// Tabulatron App
//
// Listens for the data sent to the serial port from the Arduino
// Posts values to Google Doc
//
// written by Tim Ribaric (tim@elibtronic.ca)
// @elibtronic
// updated by David Anez and Don Moses (dmoses@upei.ca)

import processing.serial.*;
Serial port;
PFont f;
String buttonsig;

// A Google Doc Form is required.
// It should only have 1 question on it
// That one question should be a dropdown box with only 4 values on it
// Example: https://docs.google.com/spreadsheet/viewform?formkey=dHdaS1NkdEtHY2Y5YkNjaDVfNGFpSkE6MQ#gid=0
String formkey = "your-public-key-goes-here"; // the public 'key' for the Google document form (found in url of view mode) 
String revformkey = "your-private-key-goes-here"; // the private key for the Google document form (found in the url of edit mode) 
String btn0 = "Reference"; // the text of the first option in the dropdownbox 
String btn1 = "Technical"; // the text of the second option in the dropdownbox 
String btn2 = "Directional"; // the text of the third option in the dropdownbox 
String btn3 = "Special"; // the text of the fourth option in the dropdownbox 
char bsig;

//Clicking on the 'View Form' button will open up the 'edit' mode in a browser
//A login to Google Doc will be needed unless set to public
void mouseReleased(){
    
  if(mouseX > 75  && mouseX < 300 && mouseY > 325  && mouseY < 350)
   link("https://docs.google.com/spreadsheet/ccc?key="+revformkey+"#gid=0");

}

//Branding
void viewform(){
  rect(75,55,225,25);
  rect(75,325,225,25);
  ellipse(350,90,25,25);
  fill(0);
  text("Data",150,345);
  text("Tabulatron",150,75);
  fill(255);
}

//Draw the 4 boxes and labels them according to the form values outlined above
//Once a button is pressed it will be drawn in green, as a form of feedback
void boxmaker(int c, int pos){
  
 //1 draws a green box, everything else is white
 switch(c){
  case 1:
   fill(119,232,105); //Greenish
   break;
  default:
   fill(255);
 }
 
 //Four button, 4 rectangles 
 switch(pos){
   case 0:
     rect(75,110,100,75);
     fill(0);
     text(btn0,90,155);
     break;
   case 1:
     rect(200,110,100,75);
     fill(0);
     text(btn1,215,155);
     break;
   case 2:
     rect(75,225,100,75);
     fill(0);
     text(btn2,83,270);
     break;
   case 3:
     rect(200,225,100,75);
     fill(0);
     text(btn3,220,270);
     break;
 }
  fill(255);
}

//Draws blank boxes
void clearboxes(){
   boxmaker(0,0);
   boxmaker(0,1);
   boxmaker(0,2);
   boxmaker(0,3);
   
 }

//Does the actual sending to Google
//loadStrings clears up the console errors.
//substitute your_form_field_id with what's in your form. 
//View the source of the live form to get the for= value of the select element
// ... should be something like entry.111111111

void tally(int btn){
  
  switch(btn){
    case 0:
      //loadXML("https://docs.google.com/spreadsheet/formResponse?formkey="+formkey+"&amp;ifq&entry.1.single="+btn0);
      loadStrings("https://docs.google.com/forms/d/"+formkey+"/formResponse?entry.your_form_field_id="+btn0);
      break;
    case 1:
      //loadXML("https://docs.google.com/spreadsheet/formResponse?formkey="+formkey+"&amp;ifq&entry.1.single="+btn1);
      loadStrings("https://docs.google.com/forms/d/"+formkey+"/formResponse?entry.your_form_field_id="+btn1);
      break;
    case 2:
      //loadXML("https://docs.google.com/spreadsheet/formResponse?formkey="+formkey+"&amp;ifq&entry.1.single="+btn2);
      loadStrings("https://docs.google.com/forms/d/"+formkey+"/formResponse?entry.your_form_field_id="+btn2);
      break;
    case 3:
      //loadXML("https://docs.google.com/spreadsheet/formResponse?formkey="+formkey+"&amp;ifq&entry.1.single="+btn3);
      loadStrings("https://docs.google.com/forms/d/"+formkey+"/formResponse?entry.your_form_field_id="+btn3);
      break;
    default:
    
  }
}

void setup() {
  f = loadFont("Aharoni-Bold-16.vlw");
  textFont(f);
  size(400,400);
  background(128);
  boxmaker(0,0);
  boxmaker(0,1);
  boxmaker(0,2);
  boxmaker(0,3);
  viewform();
  //At first run you'll have to figure out what COMM port the Arduino is on
  //change the array index to corresponding value 
  println(Serial.list());
  port = new Serial(this,Serial.list()[0],9600);
 } 

//Listens to Serial port defined above and reads until linefeed
//grabs the character and colors the box, sends the tally
//Works fairly well
void draw() {
  while (port.available() > 0){
    buttonsig = port.readStringUntil(char(10));
    try{
      bsig = buttonsig.charAt(0);
    }
    catch (Exception e){
       //Sometimes reading from serial will produce a null value
       //break out and try again
       break;
    } 
      
      switch(bsig){
        case '0':
          clearboxes();
          tally(0);
          boxmaker(1,0);
          break;
        case '1':
          clearboxes();
          tally(1);
          boxmaker(1,1);
          break;
        case '2':
          clearboxes();
          tally(2);
          boxmaker(1,2);
          break;
        case '3':
          clearboxes();
          tally(3);
          boxmaker(1,3);
        default:
        }
    }
}