# EWoz 1.0

by fsafstrom » Mar Wed 14, 2007 12:23 pm
http://www.brielcomputers.com/phpBB3/viewtopic.php?f=9&t=197#p888
via http://jefftranter.blogspot.co.uk/2012/05/woz-mon.html

The EWoz 1.0 is just the good old Woz mon with a few improvements and extensions so to say.

It's using ACIA @ 19200 Baud.
It prints a small welcome message when started.
All key strokes are converted to uppercase.
The backspace works so the _ is no longer needed.
When you run a program, it's called with an JSR so if the program ends with an RTS, you will be taken back to the monitor.
You can load Intel HEX format files and it keeps track of the checksum.
To load an Intel Hex file, just type L and hit return.
Now just send a Text file that is in the Intel HEX Format just as you would send a text file for the Woz mon.
You can abort the transfer by hitting ESC.

The reason for implementing a loader for HEX files is the 6502 Assembler @ http://home.pacbell.net/michal_k/6502.html
This assembler saves the code as Intel HEX format.

In the future I might implement XModem, that is if anyone would have any use for it...

Enjoy...

```txt
7000: D8 58 A9 1F 8D 03 C0 A9 0B 8D 02 C0 A9 0D 20 2A
7010: 71 A9 2F 85 2C A9 72 85 2D 20 39 71 A9 0D 20 2A
7020: 71 A9 9B C9 88 F0 13 C9 9B F0 03 C8 10 19 A9 DC
7030: 20 2A 71 A9 8D 20 2A 71 A0 01 88 30 F6 A9 A0 20
7040: 2A 71 A9 88 20 2A 71 AD 01 C0 29 08 F0 F9 AD 00
7050: C0 C9 60 30 02 29 5F 09 80 99 00 02 20 2A 71 C9
7060: 8D D0 C0 A0 FF A9 00 AA 0A 85 2B C8 B9 00 02 C9
7070: 8D F0 C0 C9 AE 90 F4 F0 F0 C9 BA F0 EB C9 D2 F0
7080: 31 C9 CC F0 36 86 28 86 29 84 2A B9 00 02 49 B0
7090: C9 0A 90 06 69 88 C9 FA 90 11 0A 0A 0A 0A A2 04
70A0: 0A 26 28 26 29 CA D0 F8 C8 D0 E0 C4 2A D0 12 4C
70B0: 2E 70 20 B8 70 4C 21 70 6C 24 00 20 46 71 4C 21
70C0: 70 24 2B 50 0D A5 28 81 26 E6 26 D0 9F E6 27 4C
70D0: 6C 70 30 2B A2 02 B5 27 95 25 95 23 CA D0 F7 D0
70E0: 14 A9 8D 20 2A 71 A5 25 20 17 71 A5 24 20 17 71
70F0: A9 BA 20 2A 71 A9 A0 20 2A 71 A1 24 20 17 71 86
7100: 2B A5 24 C5 28 A5 25 E5 29 B0 C4 E6 24 D0 02 E6
7110: 25 A5 24 29 0F 10 C8 48 4A 4A 4A 4A 20 20 71 68
7120: 29 0F 09 B0 C9 BA 90 02 69 06 48 29 7F 8D 00 C0
7130: AD 01 C0 29 10 F0 F9 68 60 A0 00 B1 2C F0 06 20
7140: 2A 71 C8 D0 F6 60 A9 0D 20 2A 71 A9 44 85 2C A9
7150: 72 85 2D 20 39 71 A9 0D 20 2A 71 A0 00 84 30 20
7160: 24 72 99 00 02 C8 C9 1B F0 67 C9 0D D0 F1 A0 FF
7170: C8 B9 00 02 C9 3A D0 F8 C8 A2 00 86 2F 20 01 72
7180: 85 2E 18 65 2F 85 2F 20 01 72 85 27 18 65 2F 85
7190: 2F 20 01 72 85 26 18 65 2F 85 2F A9 2E 20 2A 71
71A0: 20 01 72 C9 01 F0 2A 18 65 2F 85 2F 20 01 72 81
71B0: 26 18 65 2F 85 2F E6 26 D0 02 E6 27 C6 2E D0 EC
71C0: 20 01 72 A0 00 18 65 2F F0 95 A9 01 85 30 4C 5F
71D0: 71 A5 30 F0 16 A9 0D 20 2A 71 A9 7A 85 2C A9 72
71E0: 85 2D 20 39 71 A9 0D 20 2A 71 60 A9 0D 20 2A 71
71F0: A9 63 85 2C A9 72 85 2D 20 39 71 A9 0D 20 2A 71
7200: 60 B9 00 02 49 30 C9 0A 90 02 69 08 0A 0A 0A 0A
7210: 85 28 C8 B9 00 02 49 30 C9 0A 90 02 69 08 29 0F
7220: 05 28 C8 60 AD 01 C0 29 08 F0 F9 AD 00 C0 60 57
7230: 65 6C 63 6F 6D 65 20 74 6F 20 45 57 4F 5A 20 31
7240: 2E 30 2E 00 53 74 61 72 74 20 49 6E 74 65 6C 20
7250: 48 65 78 20 63 6F 64 65 20 54 72 61 6E 73 66 65
7260: 72 2E 00 49 6E 74 65 6C 20 48 65 78 20 49 6D 70
7270: 6F 72 74 65 64 20 4F 4B 2E 00 49 6E 74 65 6C 20
7280: 48 65 78 20 49 6D 70 6F 72 74 65 64 20 77 69 74
7290: 68 20 63 68 65 63 6B 73 75 6D 20 65 72 72 6F 72
72A0: 2E 00
```
