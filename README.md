# WOOFcard RFID Card Registration + Attendance Tracking
Simple and spoof-proof attendance tracking with RFID cards!

##  Release 0.5

* Designed for the [Yale Undergraduate Diversified Investments Group](http://yaleudi.com)
* Taking reliable attendance for recurring large group events is challenging. Measures such as QR code scans or requiring time-sensitive passwords can be circumvented by remote spoofers. 

* RFID tags can be very inexpensive if bought in bulk. They have to be brought on-site to check in. If the organization maintains a careful inventory of non-reprogramable cards, using RFID tags to keep track of attendance 

* This program is for use with 9600 baud 125Khz RFID Card Readers. It was tested with the SparkFun ID-12 Reader. It can be compiled and run in the [Processing IDE](https://processing.org).

## Requirements
*  Requires a computer capable of running Processing + USB Ports
*  FTDI Driver for processing the serial data
*  Serial-port based RFID Reader
*  125 KHz EM 4100 or 4001 Cards

## Usage
*  Open the file in processing and click "Run"
*  If you don't have an existing datafile, any new cards will prompt entering a new name.
*  Once the card is in the database, you can check in once per session. (May restrict this to per day.)
*  Type "quit" to save roster (The exit code can be edited in the configuration file).
*  Generated CSV Files can be edited in a Spreadsheet, making integration with 
a non-technical team easy.


## Future
* Push checkins to a Google Spreadsheet via POST requests to a public google form
* Convert program to run headless on a raspberry pi and push data via Node Server
* Implement "dummy mode" that doesn't require an admin to be on site to authorize the addition of new cards
