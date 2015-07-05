/* RFID Card System v 1.0
-- Cameron Yick for Yale Undergraduate Diversified Investments Group
-- Scan new cards and enter values for them
-- If card not new, say whose card it is
-- type "quit" to save roster
*/

import processing.serial.*;

/* Processing Data  */
Serial myPort;            // The serial port object
StringDict members;       //
String strTotal = "160";   
Table tableMembers;
Table oldTable;
String FILE_LOCATION = "data/test-data.csv";

/* Visual Parameters */
PFont myFont;
PFont mono;
String inString = "Scanner Ready";   // Input string from serial port
String errorMessage = "";
int lf = 10;                         // The ASCII linefeed 
color bg = color(253, 227, 167);     // yellowish
color fc = color(68,108,179);        // Blueish
color posColor = color(38, 166, 91); // greenish
color negColor = color(210, 77, 87); // reddish

// Dimensions of Screen
int WIDTH = 960;
int HEIGHT = 620;
int YMARGIN = 70;
int sizeHead = 35; // font size
int sizeMono = 25; // font size

/* Positioning  Elements (See Wireframes) */
int LISTXMARGIN = 40;
int LISTYMARGIN = YMARGIN + 60;
int ERRORMARGIN = WIDTH-330;
int NAMEMARGINY = HEIGHT-YMARGIN; 
int NAMEMARGINX = WIDTH-50; 


/* Display Components */
String strCount = "0";                                 // Members so far
String typing = "";                                    // Show what they're typing
String saved = "";                                     // Some value to save
String temp = "";                                      // Value of barcode read in.

/* Check Device Manager to Match Actual Port port */
void setup(){
  
  
  size(WIDTH,HEIGHT);
  myFont = createFont("Montserrat", 30);
  mono = createFont("Courier Prime", 28);
  
  setupTables();
  setupSerial();
}


void draw(){
  render();
  
  /* amazing string comparison problem */
  if(saved.equals("quit")){
    saveMembers();
    saved = "";
  }
}

/* Handles card reading */
void serialEvent(Serial p){
  temp = trim(p.readString());
  if(!members.hasKey(temp)){
    if(saved != ""){
      saved = trim(saved);
      members.set(temp, saved);
      errorMessage = saved + "\nhas been added." ;
      saved = "";
      strCount = str(members.size());
      inString += "\n" + temp; 
    }else{
       errorMessage = "This is a new card!\nPlease type name,\nthen hit enter";
    }

  }else{
    errorMessage = "Welcome, \n" + members.get(temp);
  }
    println(temp);
}

void keyPressed() {

  
   if(key == '\n' ) {
    saved = trim(typing);
    typing = ""; 
    println(saved);

    errorMessage = "Swipe ";
   // saveMembers();
  } else if (key == 9) {
    saveMembers();
  } else {
    if (key == BACKSPACE && typing.length() > 0){
      typing = typing.substring(0,typing.length()-1);
    }else if (key != BACKSPACE){
      typing = typing + key; 
    }
  }
}

void render(){
  background(bg);
  textFont(myFont,sizeHead);
  fill(fc);
  text("YUDI Attendance: " + strCount + "/" + strTotal , LISTXMARGIN, YMARGIN);
  textAlign(RIGHT);
  text(typing, NAMEMARGINX,NAMEMARGINY );
  textAlign(LEFT);
  fill(posColor);
  textFont(mono,sizeMono);
  text(inString, LISTXMARGIN,LISTYMARGIN);
  fill(negColor);
  text(errorMessage, ERRORMARGIN,YMARGIN);
}

/* Move files to disk */
void saveMembers(){
  String[] theKeys = members.keyArray();
  for(int i = 0, len = members.size(); i < len; i++){
    TableRow newRow = tableMembers.addRow();
    String temp2 = theKeys[i];
    newRow.setInt("id", tableMembers.getRowCount() - 1);
    newRow.setString("Num", temp2);
    newRow.setString("Name", members.get(temp2));
  }
  saveTable(tableMembers, FILE_LOCATION,"csv");
  errorMessage = "People Saved!";
}

void setupTables(){
  /* Setup a new table for the new entries */
  tableMembers = new Table();
  tableMembers.addColumn("id");
  tableMembers.addColumn("Num");
  tableMembers.addColumn("Name");
  oldTable = loadTable(FILE_LOCATION, "header, csv");
  strTotal = str(table.getRowCount());
  
   members = new StringDict();
   for (TableRow row : oldTable.rows()) {
    members.set(row.getString("Num"),row.getString("Name"));
   }
}

void setupSerial(){
  int portNum = 1;
  String portName = Serial.list()[portNum];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil(lf); 
}
