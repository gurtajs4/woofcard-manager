# WOOFcard Rfid Tag Attendance System
An affordable way to get secure and accurate attendance counts!

##  System 1.0
*July 5th 2015
* Cameron Yick for the [Yale Undergraduate Diversified Investments Group](http://yaleudi.com)
* Taking reliable attendance for recurring large group events is challenging. Measures such as QR code scans or requiring time-sensitive passwords can be circumvented by remote spoofers. 

* RFID tags can be very inexpensive if bought in bulk. They have to be brought on-site to check in. If the organization maintains a careful inventory of non-reprogramable cards, using RFID tags to keep track of attendance 

* This program is for use with 9600 baud 125Khz RFID Card Readers. It was tested with the SparkFun ID-12 Reader. It can be compiled and run in the [Processing IDE](https://processing.org).

## USAGE
*  Scan new cards, and assign them to new people.
*  If card has been recognized, increment the attendance count.
*  If someone tries to scan twice, don't do anything.
*  Type "Quit" to save roster
*  Generated CSV Files can be edited in excel.


## Ideas for extension / ToDos
* Push checkins to a Google Spreadsheet via POST requests to a public google form
* Convert program to run headless on a raspberry pi and push data via Node Server
* Implement "dummy mode" that doesn't require an admin to be on site to authorize the addition of new cards
