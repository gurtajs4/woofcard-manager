/* RFID Card System v 1.0
 July 5th 2015
-- Cameron Yick for Yale Undergraduate Diversified Investments Group
-- Remember to set the PORT NUMBER 
*/

import processing.serial.*;
/* Logic Control Objects */
Serial myPort;            // The Serial Port for RFID reader
StringDict members;       // List of total YUDI Roster, including old + new
StringList hereToday;     // List of members who checked in today 
Table tableMembers;       // Table of new additions
Table oldTable;           // Table of existing members

/* Variables to Configure */
String FILE_LOCATION = "data/test-data.csv";     // Where to store your roster.
String EXIT_CODE = "quit";                       // Code to trigger export member list
Integer portNum = 1;                             // Where to find your code reader

/* Visual Parameters */
PFont headFont;                      // Pick a good header font on your system.
PFont monoFont;                      // Pick a monospaced font tfor debugging serial codes.
String strHeaderFont = "Montserrat";
String strMonoFont =  "Courier Prime";

String inString = "Latest Additions";   // Input string from serial port
String statusMessage = "";
int lf = 10;                         // The ASCII linefeed 
color bg = color(253, 227, 167);     // Background Color  (yellowish)
color fc = color(68,108,179);        // Foreground color  (Blueish)
color posColor = color(38, 166, 91); // Good status news  (greenish)
color negColor = color(210, 77, 87); // Bad status news   (reddish)

// Dimensioning (in Pixels)
int WIDTH = 960;
int HEIGHT = 620;
int YMARGIN = 70;
int sizeHead = 34; // header font size
int sizeMono = 25; // body font size

/* Positioning  Elements (See Wireframes) */
int LISTXMARGIN = 40;
int LISTYMARGIN = YMARGIN + 60;
int ERRORMARGIN = WIDTH-50;
int NAMEMARGINY = HEIGHT-YMARGIN; 
int NAMEMARGINX = WIDTH-50; 

/* Display Components */
String strTotal;                      // Total Members
Integer intCount = 0;                 // Members so far
String typing = "";                   // Show what they're typing
String saved = "";                    // Some value to save
String temp = "";                     // Value of barcode read in.

void setup(){
  setupGraphics();
  setupTables();
  setupSerial();
}

/* Main Application Loop */
void draw(){
  render();
  checkCode(saved);
}

/* Handles Card Reading */
void serialEvent(Serial p){
  temp = trim(p.readString());
  if(!members.hasKey(temp)){
    if(saved != ""){
      saved= trim(saved);
      members.set(temp,saved); 
      checkIn(temp);
      statusMessage = saved + "\nhas been added." ;
      saved = "";
      inString += "\n" + temp; 
    }else{
       statusMessage = "This is a new card!\nPlease type name,\nthen hit enter";
    }
  }else{
    if(!hereToday.hasValue(temp)){
      checkIn(temp);
      statusMessage = "Welcome\n" + members.get(temp);
    } else{
      statusMessage = "Oops " + members.get(temp) + "\nsigned in already!";
    }
  }
}

/* Helper function for valid checkins */
void checkIn(String temp){
    intCount++;
    hereToday.set(hereToday.size(),temp);
}

/* Use Enter to save text */
void keyPressed() {
   if(key == '\n' ) {
    saved = trim(typing);
    typing = ""; 
    statusMessage = "Swipe To Join ";
  } else {
    if (key == BACKSPACE && typing.length() > 0){
      typing = typing.substring(0,typing.length()-1);
    }else if (key != BACKSPACE){
      typing = typing + key; 
    }
  }
}

/* Drawing function that displays the admin panel */
void render(){
  background(bg);
  textAlign(LEFT);
  fill(posColor);
  textFont(monoFont,sizeMono);
  /* !!!Wishlist: Replace with scrollable list item */
  text(inString, LISTXMARGIN,LISTYMARGIN);
  textFont(headFont,sizeHead);
  fill(fc);
  text("YUDI Attendance: " + str(hereToday.size()) + "/" + str(members.size()) , LISTXMARGIN, YMARGIN);
  textAlign(RIGHT);
  text(typing, NAMEMARGINX,NAMEMARGINY );
  fill(negColor);
  text(statusMessage, ERRORMARGIN,YMARGIN);
  
}

/* When EXIT_CODE is saved, persist member data to disk. */
void saveMembers(){
  String[] theKeys = members.keyArray();
  for(int i = 0, len = members.size(); i < len; i++){
    TableRow newRow = tableMembers.addRow();
    String temp2 = theKeys[i];
    newRow.setInt("id", tableMembers.getRowCount() - 1);
    newRow.setString("Num", temp2);
    newRow.setString("Name", members.get(temp2));
  }
  try{
    saveTable(tableMembers, FILE_LOCATION,"csv");
    statusMessage = "Roster Saved!";
    println("Total people saved: " + members.size());
  } catch(Exception e){
    statusMessage = "Oops file is open \nsomewhere else!";
  }
  //!!! Add function to send attendance data somewhere too.
  println("Total Attendance Today: " + intCount);
}


/* Check to see valid code has been entered. 
Can be extended with more codes- Use case select and careful string comparison. */
void checkCode(String code){
  if(code.equals(EXIT_CODE)){
    saveMembers();
    saved = "";
  }
}

/* ================
  Setup Functions 
==================*/
void setupTables(){
  tableMembers = new Table();                          // Prepare for New Members
  tableMembers.addColumn("id");
  tableMembers.addColumn("Num");
  tableMembers.addColumn("Name");
  members = new StringDict();                          // List of all YUDI members
  hereToday =  new StringList();                       // List of today's attendees
  
  try{
    oldTable = loadTable(FILE_LOCATION, "header, csv");  // Get data on old members
    strTotal = str(oldTable.getRowCount());              // # of former members
    for (TableRow row : oldTable.rows()) {               // Combine the two directories
      members.set(row.getString("Num"),row.getString("Name")); 
    }
  } catch(Exception e){
    println("First time loading, no previous file");
  }

}

void setupSerial(){
  String portName = Serial.list()[portNum];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil(lf); 
}

void setupGraphics(){
  size(WIDTH,HEIGHT);
  headFont = createFont(strHeaderFont, 30);
  monoFont = createFont(strMonoFont, 28);
}
