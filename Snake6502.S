.org $8000

.define nextpos $00          
.define savehead $01 
.define headspace $02 
.define nextinstruct $03 
.define backhead $04
.define randomvalue $05
.define randomapple $06
.define inputval $07         


.define startingpos $0200        
.define bodypos $0300        

.define 0val #00
.define applecolor #05    
.define add16 #16
.define add1 #01


compare:
LDY inputval
JMP dwn

move:
STA nextpos
TAY
LDA 0val
CMP startingpos,Y
BNE changeapple
LDY 0val
JSR readcommand
JSR draw
JMP bodymove

start:
LDX #$FF
TXS
LDX 0val

loop:
JSR random
LDY randomapple
LDA applecolor
STA startingpos,Y
LDY $4000
CPY 0val
BEQ compare
STY inputval
 
dwn:
CPY #02
BNE up 
JSR nextcomand
CLC
ADC add16
JMP move

up: 
CPY add1
BNE lft
JSR nextcomand
SBC add16
JMP move

lft: 
CPY #04
BNE rgt
JSR nextcomand
SBC add1
JMP move

rgt:
CPY #08
BNE loop
JSR nextcomand
CLC
ADC add1
JMP move

changeapple:
LDA add1                             
CMP startingpos , Y
BEQ end
LDA add1
STA startingpos , Y
LDA applecolor
LDY randomvalue
STA startingpos , Y
STY randomapple
JMP loop

end:
JMP end

eatapple:
TAY
LDA applecolor
CMP startingpos,Y
BEQ changeapple
LDY 0val

draw:
LDA add1
LDX nextpos
STA startingpos, X
JSR clear
RTS

clear:
LDA 0val
LDY backhead
STA startingpos,Y
LDY 0val
RTS

nextcomand:
LDX savehead
TYA 
STA bodypos , X
LDA nextpos
INX
STX savehead
RTS

readcommand:
LDX headspace
LDA bodypos , X
STA nextinstruct
LDA 0val
STA bodypos , X
INX                                  
STX headspace
RTS

bodymove:
LDX nextinstruct
CPX #08
BEQ RIGHT
CPX #04
BEQ LEFT
CPX #02
BEQ DOWN
CPX add1
BEQ UP
JMP loop

RIGHT:
LDA backhead
CLC
ADC add1
STA backhead
JMP loop

LEFT:
LDA backhead
SBC add1
STA backhead
JMP loop

DOWN:
LDA backhead
CLC
ADC add16
STA backhead
JMP loop

UP:
LDA backhead
SBC add16
STA backhead
JMP loop

random:
LDA randomvalue
CLC
ADC nextinstruct
ADC savehead
ADC headspace
STA randomvalue
RTS

.goto $FFFA
.dw start 
.dw start 
.DW start 