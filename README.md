
# Z80 CP/M
Computer Z80 CPU running CP/M 


## Config
Z80 - 1.8432 Mhz or 4Mhz
RAM - 64Kb
ROM - 16Kb


## MEMORY MAPS

**INITIAL BOOT**

0000-3FFF ROM
   -  0000 Boot monitor
   - 2000 Microsoft BASIC interpreter
   
4000-FFFF RAM

**Once CP/M is loaded**
0000-FFFF RAM
- 0100 Transient program area (applications)
- D000 CP/M System
- E600 BIOS

Partições 128Mb - Compact flash
A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P

## DISK DETAILS

64MB Compact Flash 
A: to G: - 8MByte
H: - 5MByte

128MB Compact Flash, the full sixteen CP/M drives are available.
A: to O: - 8MByte
P: - 2MByte


## Projeto original - by Grant Searle
http://searle.x10host.com/cpm/index.html


## Links:
Manual - http://www.cpm.z80.de/manuals/cpm22-m.pdf
Manual - http://www.gaby.de/cpm/manuals/archive/cpm22htm/ch1.htm#Section_1.1
Software CP/M - http://www.retroarchive.org/cpm/
ASM - http://www.shaels.net/index.php/cpm80-22-documents/using-cpm/9-asm-utility
HI-TECH C Compiler (video install) - https://www.youtube.com/watch?v=0QvuoRbig6U

Testes - https://github.com/diego123cruz/z80-apps


## Info:

Terminal serial - SecureCRT ou YAT (para transferir os programas precisa de delay entre os caracteres)
