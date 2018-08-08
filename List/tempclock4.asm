
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _mah=R5
	.DEF _rooz=R4
	.DEF _day=R7
	.DEF _month=R6
	.DEF _year=R9
	.DEF _sal=R10
	.DEF _hour=R8
	.DEF _miin=R13
	.DEF _sec=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_char0:
	.DB  0x4,0xE,0x1F,0x1F,0x0,0x0,0x0,0x0
_char1:
	.DB  0x0,0x0,0x0,0x1F,0x1F,0xE,0x4,0x0
_char3:
	.DB  0x4,0xA,0x0,0x15,0x1F,0x0,0x0,0x0
_char4:
	.DB  0x0,0x2,0x0,0x5,0x1F,0x0,0x8,0x0
_char5:
	.DB  0x0,0x2,0xE,0xE,0x3,0x0,0x0,0x0
_char6:
	.DB  0x0,0x4,0xA,0x1,0x1F,0x0,0x4,0x0
_char7:
	.DB  0x0,0x0,0x0,0x0,0x1F,0xA,0xE,0x0
_char8:
	.DB  0x0,0x1F,0xE,0x4,0x1F,0x0,0x0,0x0
_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x3:
	.DB  0x0,0x0,0x90,0x41
_0x4:
	.DB  0x0,0x0,0xD8,0x41
_0x5:
	.DB  0x0,0x0,0x70,0x41
_0x6:
	.DB  0x0,0x0,0x20,0x42
_0x7:
	.DB  0x1F,0x1C,0x1F,0x1E,0x1F,0x1E,0x1F,0x1F
	.DB  0x1E,0x1F,0x1E,0x1F
_0x8:
	.DB  0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1E,0x1E
	.DB  0x1E,0x1E,0x1E,0x1D
_0x11D:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_0x189:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0
_0x0:
	.DB  0x25,0x64,0x0,0x73,0x75,0x6E,0x0,0x6D
	.DB  0x6F,0x6E,0x0,0x74,0x75,0x65,0x0,0x77
	.DB  0x65,0x64,0x0,0x74,0x68,0x75,0x0,0x66
	.DB  0x72,0x69,0x0,0x73,0x61,0x74,0x0,0x20
	.DB  0x0,0x20,0x20,0x20,0x3C,0x25,0x30,0x32
	.DB  0x64,0x3E,0x3A,0x20,0x25,0x30,0x32,0x64
	.DB  0x20,0x3A,0x20,0x25,0x30,0x32,0x64,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x25,0x30,0x32
	.DB  0x64,0x20,0x3A,0x3C,0x25,0x30,0x32,0x64
	.DB  0x3E,0x3A,0x20,0x25,0x30,0x32,0x64,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x25,0x30,0x32
	.DB  0x64,0x20,0x3A,0x20,0x25,0x30,0x32,0x64
	.DB  0x20,0x3A,0x3C,0x25,0x30,0x32,0x64,0x3E
	.DB  0x20,0x0,0x3C,0x25,0x30,0x32,0x75,0x3E
	.DB  0x2F,0x20,0x25,0x30,0x32,0x75,0x20,0x2F
	.DB  0x20,0x25,0x30,0x32,0x64,0x20,0x20,0x0
	.DB  0x20,0x25,0x30,0x32,0x75,0x20,0x2F,0x3C
	.DB  0x25,0x30,0x32,0x75,0x3E,0x2F,0x20,0x25
	.DB  0x30,0x32,0x64,0x20,0x20,0x0,0x20,0x25
	.DB  0x30,0x32,0x75,0x20,0x2F,0x20,0x25,0x30
	.DB  0x32,0x75,0x20,0x2F,0x3C,0x25,0x30,0x32
	.DB  0x64,0x3E,0x20,0x0,0x20,0x25,0x30,0x32
	.DB  0x75,0x20,0x2F,0x20,0x25,0x30,0x32,0x75
	.DB  0x20,0x2F,0x20,0x25,0x30,0x32,0x64,0x20
	.DB  0x0,0x3C,0x0,0x3E,0x0,0x31,0x2E,0x54
	.DB  0x69,0x6D,0x65,0x20,0x3C,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x32,0x2E,0x44,0x61,0x74,0x65
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x31,0x2E
	.DB  0x54,0x69,0x6D,0x65,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x32,0x2E,0x44,0x61,0x74,0x65
	.DB  0x20,0x3C,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x33,0x2E
	.DB  0x54,0x65,0x6D,0x70,0x26,0x48,0x75,0x6D
	.DB  0x20,0x3C,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x31,0x2E,0x53,0x65,0x74,0x20
	.DB  0x54,0x69,0x6D,0x65,0x20,0x20,0x3C,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x32
	.DB  0x2E,0x54,0x69,0x6D,0x65,0x20,0x54,0x79
	.DB  0x70,0x65,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x31,0x2E,0x53,0x65,0x74
	.DB  0x20,0x54,0x69,0x6D,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x32
	.DB  0x2E,0x54,0x69,0x6D,0x65,0x20,0x54,0x79
	.DB  0x70,0x65,0x20,0x3C,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x53,0x65,0x74,0x20,0x54,0x69,0x6D
	.DB  0x65,0x20,0x3A,0x20,0x20,0x20,0x20,0x0
	.DB  0x63,0x6C,0x6F,0x63,0x6B,0x20,0x6D,0x6F
	.DB  0x64,0x65,0x3A,0x32,0x34,0x68,0x2F,0x31
	.DB  0x32,0x68,0x3F,0x0,0x20,0x20,0x20,0x20
	.DB  0x3C,0x32,0x34,0x68,0x3E,0x20,0x20,0x20
	.DB  0x31,0x32,0x68,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x32,0x34
	.DB  0x68,0x20,0x20,0x20,0x3C,0x31,0x32,0x68
	.DB  0x3E,0x20,0x20,0x20,0x20,0x0,0x31,0x2E
	.DB  0x44,0x61,0x74,0x65,0x20,0x54,0x79,0x70
	.DB  0x65,0x20,0x3C,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x32,0x2E,0x53,0x65,0x74
	.DB  0x20,0x44,0x61,0x74,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x31
	.DB  0x2E,0x44,0x61,0x74,0x65,0x20,0x54,0x79
	.DB  0x70,0x65,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x32,0x2E,0x53,0x65,0x74
	.DB  0x20,0x44,0x61,0x74,0x65,0x20,0x20,0x3C
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x64,0x61,0x74,0x65,0x20,0x74,0x79,0x70
	.DB  0x65,0x3F,0x0,0x20,0x3C,0x73,0x68,0x61
	.DB  0x6D,0x73,0x69,0x3E,0x20,0x20,0x20,0x20
	.DB  0x6D,0x69,0x6C,0x61,0x64,0x69,0x20,0x0
	.DB  0x20,0x20,0x73,0x68,0x61,0x6D,0x73,0x69
	.DB  0x20,0x20,0x20,0x20,0x3C,0x6D,0x69,0x6C
	.DB  0x61,0x64,0x69,0x3E,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x53,0x65,0x74,0x20,0x44,0x61
	.DB  0x74,0x65,0x20,0x3A,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x25,0x30,0x32,0x75,0x3A,0x25
	.DB  0x30,0x32,0x75,0x3A,0x25,0x30,0x32,0x64
	.DB  0x0,0x20,0x50,0x4D,0x0,0x20,0x41,0x4D
	.DB  0x0,0x25,0x30,0x32,0x75,0x2F,0x25,0x30
	.DB  0x32,0x75,0x2F,0x25,0x30,0x32,0x64,0x20
	.DB  0x0,0x54,0x3A,0x0,0x48,0x3A,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2040003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0C
	.DW  _miladimonth
	.DW  _0x7*2

	.DW  0x0C
	.DW  _shamsimonth
	.DW  _0x8*2

	.DW  0x04
	.DW  _0x12
	.DW  _0x0*2+3

	.DW  0x04
	.DW  _0x12+4
	.DW  _0x0*2+7

	.DW  0x04
	.DW  _0x12+8
	.DW  _0x0*2+11

	.DW  0x04
	.DW  _0x12+12
	.DW  _0x0*2+15

	.DW  0x04
	.DW  _0x12+16
	.DW  _0x0*2+19

	.DW  0x04
	.DW  _0x12+20
	.DW  _0x0*2+23

	.DW  0x04
	.DW  _0x12+24
	.DW  _0x0*2+27

	.DW  0x02
	.DW  _0x19
	.DW  _0x0*2+31

	.DW  0x02
	.DW  _0x19+2
	.DW  _0x0*2+31

	.DW  0x02
	.DW  _0x1A
	.DW  _0x0*2+31

	.DW  0x02
	.DW  _0x1A+2
	.DW  _0x0*2+31

	.DW  0x02
	.DW  _0x22
	.DW  _0x0*2+193

	.DW  0x02
	.DW  _0x22+2
	.DW  _0x0*2+195

	.DW  0x15
	.DW  _0x31
	.DW  _0x0*2+197

	.DW  0x14
	.DW  _0x31+21
	.DW  _0x0*2+218

	.DW  0x14
	.DW  _0x31+41
	.DW  _0x0*2+238

	.DW  0x14
	.DW  _0x31+61
	.DW  _0x0*2+258

	.DW  0x14
	.DW  _0x31+81
	.DW  _0x0*2+278

	.DW  0x15
	.DW  _0x31+101
	.DW  _0x0*2+298

	.DW  0x14
	.DW  _0x31+122
	.DW  _0x0*2+319

	.DW  0x14
	.DW  _0x31+142
	.DW  _0x0*2+339

	.DW  0x15
	.DW  _0x31+162
	.DW  _0x0*2+359

	.DW  0x14
	.DW  _0x31+183
	.DW  _0x0*2+380

	.DW  0x14
	.DW  _0x31+203
	.DW  _0x0*2+400

	.DW  0x15
	.DW  _0x31+223
	.DW  _0x0*2+420

	.DW  0x15
	.DW  _0x31+244
	.DW  _0x0*2+441

	.DW  0x15
	.DW  _0x31+265
	.DW  _0x0*2+462

	.DW  0x14
	.DW  _0x31+286
	.DW  _0x0*2+483

	.DW  0x14
	.DW  _0x31+306
	.DW  _0x0*2+503

	.DW  0x15
	.DW  _0x31+326
	.DW  _0x0*2+523

	.DW  0x0B
	.DW  _0x31+347
	.DW  _0x0*2+544

	.DW  0x15
	.DW  _0x31+358
	.DW  _0x0*2+555

	.DW  0x15
	.DW  _0x31+379
	.DW  _0x0*2+576

	.DW  0x15
	.DW  _0x31+400
	.DW  _0x0*2+597

	.DW  0x04
	.DW  _0x178
	.DW  _0x0*2+633

	.DW  0x04
	.DW  _0x178+4
	.DW  _0x0*2+637

	.DW  0x03
	.DW  _0x178+8
	.DW  _0x0*2+657

	.DW  0x03
	.DW  _0x178+11
	.DW  _0x0*2+660

	.DW  0x09
	.DW  0x04
	.DW  _0x189*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Project :
;Version :
;Date    : 10/23/2017
;Author  : mak
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 1.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;#include <stdlib.h>
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <i2c.h>
;#include <ds1307.h>
;#include <alcd.h>
;#include <delay.h>
;#include <stdio.h>
;#define DHT22_PIN          PINC.1       //œ— «Ì‰Ã« Å«ÌÂ òÂ œ„«”‰Ã »Â «‰ Ê’· ‘œÂ —« „‘Œ’ ò‰Ìœ
;#define DHT22_PORT         PORTC.1
;#define DHT22_DDR          DDRC.1
;#define up  PINC.2==0
;#define down  PINC.3==0
;#define ok  PINC.4==0
;#define set  PIND.2==0
;#define del  PINC.5==0
;#define DHT22_INPUT_MODE   DHT22_DDR=0;
;#define DHT22_OUTPUT_MODE  DHT22_DDR=1;
;#define DHT22_LOW          DHT22_PORT=0;
;#define DHT22_HIGH         DHT22_PORT=1;
;#define DHT22_READ         DHT22_PIN
;
;// Declare your global variables here
;unsigned char mah=0,rooz=0,day=0,month=0,year=0;
;bit resett=0;
;int sal=0;
;char strr[4];
;float minT=18,maxT=27,minH=15,maxH=40;

	.DSEG
;unsigned char hour,miin,sec=0,week_day;
;unsigned char miladimonth[12]={31,28,31,30,31,30,31,31,30,31,30,31};
;unsigned char shamsimonth[12]={31,31,31,31,31,31,30,30,30,30,30,29};
;flash unsigned char char0[8]={4,14,31,31,0,0,0};  //òœ ›·‘ »«·«
;flash unsigned char char1[8]={0,0,0,31,31,14,4};   //òœ ›·‘ Å«ÌÌ‰
;//flash unsigned char char2[8]={4,14,31,0,31,14,4};
;
;flash unsigned char char3[8]={4,10,0,21,31,0,0,0};  // òœ ‘
;flash unsigned char char4[8]={0,2,0,5,31,0,8,0};  // òœ ‰»
;flash unsigned char char5[8]={0,2,14,14,3,0,0,0};   // òœ Â
;
;flash unsigned char char6[8]={0,4,10,1,31,0,4,0};   // òœ Ã
;flash unsigned char char7[8]={0,0,0,0,31,10,14,0};     //òœ „
;flash unsigned char char8[8]={0,31,14,4,31,0,0,0};   // òœ ⁄
;////////////////////////////////////////////////////////
;void define_char(unsigned char flash *pc,unsigned char char_code){
; 0000 003D void define_char(unsigned char flash *pc,unsigned char char_code){

	.CSEG
_define_char:
; 0000 003E     unsigned char i,a;
; 0000 003F     a=(char_code<<3)|0x40;
	ST   -Y,R26
	RCALL __SAVELOCR2
;	*pc -> Y+3
;	char_code -> Y+2
;	i -> R17
;	a -> R16
	LDD  R30,Y+2
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,0x40
	MOV  R16,R30
; 0000 0040     for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0xA:
	CPI  R17,8
	BRSH _0xB
; 0000 0041         lcd_write_byte(a++,*pc++);
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	SBIW R30,1
	LPM  R26,Z
	RCALL _lcd_write_byte
	SUBI R17,-1
	RJMP _0xA
_0xB:
; 0000 0042 }
	RJMP _0x2100004
;void weekdayshow(void)
; 0000 0044  {
_weekdayshow:
; 0000 0045   char str_week_day[1];
; 0000 0046 
; 0000 0047   if(rtc_read(0x08) & 0x02){
	SBIW R28,1
;	str_week_day -> Y+0
	RCALL SUBOPT_0x0
	ANDI R30,LOW(0x2)
	BREQ _0xC
; 0000 0048     if(week_day <6){
	RCALL SUBOPT_0x1
	CPI  R26,LOW(0x6)
	BRSH _0xD
; 0000 0049         sprintf(str_week_day,"%d",week_day);
	RCALL SUBOPT_0x2
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
; 0000 004A         lcd_putchar(5);
	RCALL SUBOPT_0x6
; 0000 004B         lcd_putchar(4);
; 0000 004C         lcd_putchar(3);
; 0000 004D         lcd_puts(str_week_day);
	RCALL SUBOPT_0x7
; 0000 004E     }
; 0000 004F     if(week_day==7){  //shande
_0xD:
	RCALL SUBOPT_0x1
	CPI  R26,LOW(0x7)
	BRNE _0xE
; 0000 0050         lcd_putchar(5);
	RCALL SUBOPT_0x6
; 0000 0051         lcd_putchar(4);
; 0000 0052         lcd_putchar(3);
; 0000 0053     }
; 0000 0054     if(week_day==6){     //jome
_0xE:
	RCALL SUBOPT_0x1
	CPI  R26,LOW(0x6)
	BRNE _0xF
; 0000 0055         lcd_putchar(5);
	LDI  R26,LOW(5)
	RCALL _lcd_putchar
; 0000 0056         lcd_putchar(8);
	LDI  R26,LOW(8)
	RCALL _lcd_putchar
; 0000 0057         lcd_putchar(7);
	LDI  R26,LOW(7)
	RCALL _lcd_putchar
; 0000 0058         lcd_putchar(6);
	LDI  R26,LOW(6)
	RCALL _lcd_putchar
; 0000 0059      }
; 0000 005A   }else{
_0xF:
	RJMP _0x10
_0xC:
; 0000 005B         if(week_day==1){
	RCALL SUBOPT_0x1
	CPI  R26,LOW(0x1)
	BRNE _0x11
; 0000 005C             lcd_puts("sun");
	__POINTW2MN _0x12,0
	RCALL _lcd_puts
; 0000 005D         }
; 0000 005E         if(week_day==2){
_0x11:
	RCALL SUBOPT_0x1
	CPI  R26,LOW(0x2)
	BRNE _0x13
; 0000 005F             lcd_puts("mon");
	__POINTW2MN _0x12,4
	RCALL _lcd_puts
; 0000 0060         }
; 0000 0061         if(week_day==3){
_0x13:
	RCALL SUBOPT_0x1
	CPI  R26,LOW(0x3)
	BRNE _0x14
; 0000 0062             lcd_puts("tue");
	__POINTW2MN _0x12,8
	RCALL _lcd_puts
; 0000 0063         }
; 0000 0064         if(week_day==4){lcd_puts("wed");}
_0x14:
	RCALL SUBOPT_0x1
	CPI  R26,LOW(0x4)
	BRNE _0x15
	__POINTW2MN _0x12,12
	RCALL _lcd_puts
; 0000 0065         if(week_day==5){lcd_puts("thu");}
_0x15:
	RCALL SUBOPT_0x1
	CPI  R26,LOW(0x5)
	BRNE _0x16
	__POINTW2MN _0x12,16
	RCALL _lcd_puts
; 0000 0066         if(week_day==6){lcd_puts("fri");}
_0x16:
	RCALL SUBOPT_0x1
	CPI  R26,LOW(0x6)
	BRNE _0x17
	__POINTW2MN _0x12,20
	RCALL _lcd_puts
; 0000 0067         if(week_day==7){lcd_puts("sat");}
_0x17:
	RCALL SUBOPT_0x1
	CPI  R26,LOW(0x7)
	BRNE _0x18
	__POINTW2MN _0x12,24
	RCALL _lcd_puts
; 0000 0068     }
_0x18:
_0x10:
; 0000 0069  }
	RJMP _0x2100005

	.DSEG
_0x12:
	.BYTE 0x1C
;
;void styleup(void){
; 0000 006B void styleup(void){

	.CSEG
_styleup:
; 0000 006C     lcd_gotoxy(19,1);
	RCALL SUBOPT_0x8
; 0000 006D     lcd_puts(" ");
	__POINTW2MN _0x19,0
	RCALL SUBOPT_0x9
; 0000 006E     delay_ms(50);
; 0000 006F     lcd_gotoxy(19,1);
; 0000 0070     lcd_putchar(1);
	RCALL SUBOPT_0xA
; 0000 0071     delay_ms(50);
	RCALL SUBOPT_0xB
; 0000 0072     lcd_gotoxy(19,1);
	RCALL SUBOPT_0x8
; 0000 0073     lcd_puts(" ");
	__POINTW2MN _0x19,2
	RCALL SUBOPT_0x9
; 0000 0074     delay_ms(50);
; 0000 0075     lcd_gotoxy(19,1);
; 0000 0076     lcd_putchar(1);
	LDI  R26,LOW(1)
	RJMP _0x210000C
; 0000 0077     delay_ms(50);
; 0000 0078 }

	.DSEG
_0x19:
	.BYTE 0x4
;void styledown(void){
; 0000 0079 void styledown(void){

	.CSEG
_styledown:
; 0000 007A     lcd_gotoxy(19,0);
	RCALL SUBOPT_0xC
; 0000 007B     lcd_puts(" ");
	__POINTW2MN _0x1A,0
	RCALL _lcd_puts
; 0000 007C     delay_ms(50);
	RCALL SUBOPT_0xB
; 0000 007D     lcd_gotoxy(19,0);
	RCALL SUBOPT_0xC
; 0000 007E     lcd_putchar(0);
	RCALL SUBOPT_0xD
; 0000 007F     delay_ms(50);
	RCALL SUBOPT_0xB
; 0000 0080     lcd_gotoxy(19,0);
	RCALL SUBOPT_0xC
; 0000 0081     lcd_puts(" ");
	__POINTW2MN _0x1A,2
	RCALL _lcd_puts
; 0000 0082     delay_ms(50);
	RCALL SUBOPT_0xB
; 0000 0083     lcd_gotoxy(19,0);
	RCALL SUBOPT_0xC
; 0000 0084     lcd_putchar(0);
	LDI  R26,LOW(0)
_0x210000C:
	RCALL _lcd_putchar
; 0000 0085     delay_ms(50);
	RCALL SUBOPT_0xB
; 0000 0086 }
	RET

	.DSEG
_0x1A:
	.BYTE 0x4
;void timesetshow(char i){
; 0000 0087 void timesetshow(char i){

	.CSEG
_timesetshow:
; 0000 0088 char strrr[4];
; 0000 0089 lcd_gotoxy(0,1);
	RCALL SUBOPT_0xE
;	i -> Y+4
;	strrr -> Y+0
; 0000 008A if(i==0){sprintf(strrr,"   <%02d>: %02d : %02d ",hour,miin,sec);}
	BRNE _0x1B
	RCALL SUBOPT_0x2
	__POINTW1FN _0x0,33
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
; 0000 008B if(i==1){sprintf(strrr,"    %02d :<%02d>: %02d ",hour,miin,sec);}
_0x1B:
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BRNE _0x1C
	RCALL SUBOPT_0x2
	__POINTW1FN _0x0,57
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
; 0000 008C if(i==2){sprintf(strrr,"    %02d : %02d :<%02d> ",hour,miin,sec);}
_0x1C:
	LDD  R26,Y+4
	CPI  R26,LOW(0x2)
	BRNE _0x1D
	RCALL SUBOPT_0x2
	__POINTW1FN _0x0,81
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
; 0000 008D lcd_puts(strrr);
_0x1D:
	RCALL SUBOPT_0x7
; 0000 008E }
	RJMP _0x2100003
;void datesetshow(char i){
; 0000 008F void datesetshow(char i){
_datesetshow:
; 0000 0090 char strrr[4];
; 0000 0091 lcd_gotoxy(0,1);
	RCALL SUBOPT_0xE
;	i -> Y+4
;	strrr -> Y+0
; 0000 0092 if(i==0){
	BRNE _0x1E
; 0000 0093     sprintf(strrr,"<%02u>/ %02u / %02d  ",year,month,day);
	RCALL SUBOPT_0x2
	__POINTW1FN _0x0,106
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x12
; 0000 0094     lcd_puts(strrr);
	RCALL SUBOPT_0x7
; 0000 0095     weekdayshow();
	RCALL _weekdayshow
; 0000 0096     }
; 0000 0097 if(i==1){
_0x1E:
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BRNE _0x1F
; 0000 0098     sprintf(strrr," %02u /<%02u>/ %02d  ",year,month,day);
	RCALL SUBOPT_0x2
	__POINTW1FN _0x0,128
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x12
; 0000 0099     lcd_puts(strrr);
	RCALL SUBOPT_0x7
; 0000 009A     weekdayshow();
	RCALL _weekdayshow
; 0000 009B     }
; 0000 009C if(i==2){
_0x1F:
	LDD  R26,Y+4
	CPI  R26,LOW(0x2)
	BRNE _0x20
; 0000 009D     sprintf(strrr," %02u / %02u /<%02d> ",year,month,day);
	RCALL SUBOPT_0x2
	__POINTW1FN _0x0,150
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x12
; 0000 009E     lcd_puts(strrr);
	RCALL SUBOPT_0x7
; 0000 009F     weekdayshow();
	RCALL _weekdayshow
; 0000 00A0         }
; 0000 00A1 if(i==3){
_0x20:
	LDD  R26,Y+4
	CPI  R26,LOW(0x3)
	BRNE _0x21
; 0000 00A2     sprintf(strrr," %02u / %02u / %02d ",year,month,day);
	RCALL SUBOPT_0x2
	__POINTW1FN _0x0,172
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x12
; 0000 00A3     lcd_puts(strrr);
	RCALL SUBOPT_0x7
; 0000 00A4     lcd_puts("<");
	__POINTW2MN _0x22,0
	RCALL _lcd_puts
; 0000 00A5     weekdayshow();
	RCALL _weekdayshow
; 0000 00A6     lcd_puts(">");
	__POINTW2MN _0x22,2
	RCALL _lcd_puts
; 0000 00A7 }
; 0000 00A8 }
_0x21:
	RJMP _0x2100003

	.DSEG
_0x22:
	.BYTE 0x4
;////////////////////////////////////////////////////////
;char leap(char y){
; 0000 00AA char leap(char y){

	.CSEG
_leap:
; 0000 00AB 	if (((((2000+y)%4)==0)&&(((2000+y)%100)!=0))||((((2000+y)%100)==0)&&(((2000+y)%400)==0)))
	ST   -Y,R26
;	y -> Y+0
	RCALL SUBOPT_0x16
	SUBI R30,LOW(-2000)
	SBCI R31,HIGH(-2000)
	MOVW R22,R30
	MOVW R26,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x17
	BRNE _0x24
	RCALL SUBOPT_0x18
	BRNE _0x26
_0x24:
	RCALL SUBOPT_0x18
	BRNE _0x27
	MOVW R26,R22
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	RCALL SUBOPT_0x17
	BREQ _0x26
_0x27:
	RJMP _0x23
_0x26:
; 0000 00AC 	return 1;
	LDI  R30,LOW(1)
	RJMP _0x2100005
; 0000 00AD }
_0x23:
	RJMP _0x2100005
;//////////////////////////////////////////////////////////////
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 00B1 {
_ext_int0_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00B2     char i=0,strr[4];
; 0000 00B3     bit choice=0,choice2=0;
; 0000 00B4     char page=0;
; 0000 00B5     while(set);
	SBIW R28,4
	RCALL __SAVELOCR2
;	i -> R17
;	strr -> Y+2
;	choice -> R15.0
;	choice2 -> R15.1
;	page -> R16
	CLR  R15
	LDI  R17,0
	LDI  R16,0
_0x2A:
	SBIS 0x10,2
	RJMP _0x2A
; 0000 00B6     resett=0;
	CLT
	BLD  R2,0
; 0000 00B7     #asm("cli")
	cli
; 0000 00B8     /*
; 0000 00B9     lcd_clear();
; 0000 00BA     lcd_gotoxy(0,0);
; 0000 00BB     lcd_puts("setting.");
; 0000 00BC     delay_ms(350);
; 0000 00BD     lcd_puts(".");
; 0000 00BE     delay_ms(350);
; 0000 00BF     lcd_puts(".");
; 0000 00C0     delay_ms(350);
; 0000 00C1     lcd_puts(".");
; 0000 00C2     delay_ms(300);
; 0000 00C3     lcd_clear();
; 0000 00C4     */
; 0000 00C5     define_char(char0,0);   //›·‘ »«·«
	LDI  R30,LOW(_char0*2)
	LDI  R31,HIGH(_char0*2)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(0)
	RCALL _define_char
; 0000 00C6     define_char(char1,1);   //›·‘ Å«ÌÌ‰
	LDI  R30,LOW(_char1*2)
	LDI  R31,HIGH(_char1*2)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(1)
	RCALL _define_char
; 0000 00C7     while(!set){
_0x2D:
	SBIS 0x10,2
	RJMP _0x2F
; 0000 00C8     //choice 0=time/ 1=date / 2=reminder / 3=temp&hum
; 0000 00C9     //page 1&2
; 0000 00CA         lcd_clear();
	RCALL _lcd_clear
; 0000 00CB         delay_ms(30);
	LDI  R26,LOW(30)
	RCALL SUBOPT_0x19
; 0000 00CC         lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1A
; 0000 00CD             if(page==0){
	CPI  R16,0
	BRNE _0x30
; 0000 00CE                 lcd_puts("1.Time <            ");
	__POINTW2MN _0x31,0
	RCALL _lcd_puts
; 0000 00CF                 lcd_puts("2.Date             ");
	__POINTW2MN _0x31,21
	RCALL SUBOPT_0x1B
; 0000 00D0                 lcd_putchar(1);
; 0000 00D1                 }
; 0000 00D2             if(page==1){
_0x30:
	CPI  R16,1
	BRNE _0x32
; 0000 00D3                 lcd_puts("1.Time             ");
	__POINTW2MN _0x31,41
	RCALL SUBOPT_0x1C
; 0000 00D4                 lcd_putchar(0);
; 0000 00D5                 lcd_puts("2.Date <           ");
	__POINTW2MN _0x31,61
	RCALL SUBOPT_0x1B
; 0000 00D6                 lcd_putchar(1);
; 0000 00D7                 }
; 0000 00D8             if(page==2){
_0x32:
	CPI  R16,2
	BRNE _0x33
; 0000 00D9                 lcd_puts("3.Temp&Hum <       ");
	__POINTW2MN _0x31,81
	RCALL SUBOPT_0x1C
; 0000 00DA                 lcd_putchar(0);
; 0000 00DB                 }
; 0000 00DC 
; 0000 00DD         while(!up && !down && !ok && !set);
_0x33:
_0x34:
	RCALL SUBOPT_0x1D
	BRNE _0x37
	RCALL SUBOPT_0x1E
	BRNE _0x37
	RCALL SUBOPT_0x1F
	BRNE _0x37
	RCALL SUBOPT_0x20
	BREQ _0x38
_0x37:
	RJMP _0x36
_0x38:
	RJMP _0x34
_0x36:
; 0000 00DE         if(down){
	SBIC 0x13,3
	RJMP _0x39
; 0000 00DF             while(down);
_0x3A:
	SBIS 0x13,3
	RJMP _0x3A
; 0000 00E0             page+=1;
	SUBI R16,-LOW(1)
; 0000 00E1             if(page==3){
	CPI  R16,3
	BRNE _0x3D
; 0000 00E2                 styledown();
	RCALL _styledown
; 0000 00E3                 page=2;
	LDI  R16,LOW(2)
; 0000 00E4             }
; 0000 00E5         }
_0x3D:
; 0000 00E6 
; 0000 00E7         if(up){
_0x39:
	SBIC 0x13,2
	RJMP _0x3E
; 0000 00E8             while(up);
_0x3F:
	SBIS 0x13,2
	RJMP _0x3F
; 0000 00E9             page-=1;
	SUBI R16,LOW(1)
; 0000 00EA             if(page == 255){
	CPI  R16,255
	BRNE _0x42
; 0000 00EB                 styleup();
	RCALL _styleup
; 0000 00EC                 page=0;
	LDI  R16,LOW(0)
; 0000 00ED             }
; 0000 00EE         }
_0x42:
; 0000 00EF 
; 0000 00F0         if(ok){
_0x3E:
	SBIC 0x13,4
	RJMP _0x43
; 0000 00F1             while(ok);
_0x44:
	SBIS 0x13,4
	RJMP _0x44
; 0000 00F2             if(page==0){ // ‰ŸÌ„ ”«⁄  Ê ‰Ê⁄
	CPI  R16,0
	BREQ PC+2
	RJMP _0x47
; 0000 00F3                 delay_ms(50);
	RCALL SUBOPT_0xB
; 0000 00F4                 choice=0;
	RCALL SUBOPT_0x21
; 0000 00F5                 while(!set){
_0x48:
	SBIS 0x10,2
	RJMP _0x4A
; 0000 00F6                     lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1A
; 0000 00F7                     if(choice==0){
	SBRC R15,0
	RJMP _0x4B
; 0000 00F8                         lcd_puts("1.Set Time  <       ");
	__POINTW2MN _0x31,101
	RCALL _lcd_puts
; 0000 00F9                         lcd_puts("2.Time Type        ");
	__POINTW2MN _0x31,122
	RCALL SUBOPT_0x1B
; 0000 00FA                         lcd_putchar(1);
; 0000 00FB                     }else{
	RJMP _0x4C
_0x4B:
; 0000 00FC                         lcd_puts("1.Set Time         ");
	__POINTW2MN _0x31,142
	RCALL SUBOPT_0x1C
; 0000 00FD                         lcd_putchar(0);
; 0000 00FE                         lcd_puts("2.Time Type <       ");
	__POINTW2MN _0x31,162
	RCALL _lcd_puts
; 0000 00FF                     }
_0x4C:
; 0000 0100                     while(!ok && !up && !down && !set);
_0x4D:
	RCALL SUBOPT_0x1F
	BRNE _0x50
	RCALL SUBOPT_0x1D
	BRNE _0x50
	RCALL SUBOPT_0x1E
	BRNE _0x50
	RCALL SUBOPT_0x20
	BREQ _0x51
_0x50:
	RJMP _0x4F
_0x51:
	RJMP _0x4D
_0x4F:
; 0000 0101                     if(up){
	SBIC 0x13,2
	RJMP _0x52
; 0000 0102                         while(up);
_0x53:
	SBIS 0x13,2
	RJMP _0x53
; 0000 0103                         if(choice==0)
	SBRC R15,0
	RJMP _0x56
; 0000 0104                             styleup();
	RCALL _styleup
; 0000 0105                         else
	RJMP _0x57
_0x56:
; 0000 0106                            choice=0;
	RCALL SUBOPT_0x21
; 0000 0107                     }
_0x57:
; 0000 0108 
; 0000 0109                     if(down){
_0x52:
	SBIC 0x13,3
	RJMP _0x58
; 0000 010A                         while(down);
_0x59:
	SBIS 0x13,3
	RJMP _0x59
; 0000 010B                         if(choice==1)
	SBRS R15,0
	RJMP _0x5C
; 0000 010C                             styledown();
	RCALL _styledown
; 0000 010D                         else
	RJMP _0x5D
_0x5C:
; 0000 010E                             choice=1;
	SET
	BLD  R15,0
; 0000 010F                     }
_0x5D:
; 0000 0110                     if(ok){
_0x58:
	SBIC 0x13,4
	RJMP _0x5E
; 0000 0111                         while(ok);
_0x5F:
	SBIS 0x13,4
	RJMP _0x5F
; 0000 0112                         if(choice==0){// ‰ŸÌ„ “„«‰
	SBRC R15,0
	RJMP _0x62
; 0000 0113                             rtc_get_time(&hour,&miin,&sec);
	RCALL SUBOPT_0x22
; 0000 0114                             i=0;
	LDI  R17,LOW(0)
; 0000 0115                             lcd_clear();
	RCALL _lcd_clear
; 0000 0116                             lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1A
; 0000 0117                             lcd_puts("     Set Time :    ");
	__POINTW2MN _0x31,183
	RCALL _lcd_puts
; 0000 0118                             while(!ok){
_0x63:
	SBIS 0x13,4
	RJMP _0x65
; 0000 0119                                 timesetshow(i);
	RCALL SUBOPT_0x23
; 0000 011A                                 while(!up && !down && !set && !ok);
_0x66:
	RCALL SUBOPT_0x1D
	BRNE _0x69
	RCALL SUBOPT_0x1E
	BRNE _0x69
	RCALL SUBOPT_0x20
	BRNE _0x69
	RCALL SUBOPT_0x1F
	BREQ _0x6A
_0x69:
	RJMP _0x68
_0x6A:
	RJMP _0x66
_0x68:
; 0000 011B                                 if(up){
	SBIC 0x13,2
	RJMP _0x6B
; 0000 011C                                     switch (i) {
	RCALL SUBOPT_0x24
; 0000 011D                                         case 0:   // »« „ €Ì— ¬Ì ‰‘«‰ „Ì œÂÌ„ òœ«„ Ìò «“ „Ê·›Â Â«Ì “„«‰  €ÌÌ— ŒÊ«Âœ ò—œ
	BRNE _0x6F
; 0000 011E                                           hour++;
	INC  R8
; 0000 011F                                           if(hour==24)
	LDI  R30,LOW(24)
	CP   R30,R8
	BRNE _0x70
; 0000 0120                                              hour=0;
	CLR  R8
; 0000 0121                                           timesetshow(i);
_0x70:
	RCALL SUBOPT_0x23
; 0000 0122                                           delay_ms(700);
	RCALL SUBOPT_0x25
; 0000 0123                                           while(up){
_0x71:
	SBIC 0x13,2
	RJMP _0x73
; 0000 0124                                             hour++;
	INC  R8
; 0000 0125                                             if(hour==24)
	LDI  R30,LOW(24)
	CP   R30,R8
	BRNE _0x74
; 0000 0126                                                hour=0;
	CLR  R8
; 0000 0127                                             timesetshow(i);
_0x74:
	RCALL SUBOPT_0x23
; 0000 0128                                             delay_ms(130);
	RCALL SUBOPT_0x26
; 0000 0129                                           }
	RJMP _0x71
_0x73:
; 0000 012A                                           break;
	RJMP _0x6E
; 0000 012B 
; 0000 012C                                         case 1:
_0x6F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x75
; 0000 012D                                           miin++;
	INC  R13
; 0000 012E                                           if(miin==60)
	LDI  R30,LOW(60)
	CP   R30,R13
	BRNE _0x76
; 0000 012F                                             miin=0;
	CLR  R13
; 0000 0130                                           timesetshow(i);
_0x76:
	RCALL SUBOPT_0x23
; 0000 0131                                           delay_ms(700);
	RCALL SUBOPT_0x25
; 0000 0132                                           while(up){
_0x77:
	SBIC 0x13,2
	RJMP _0x79
; 0000 0133                                             miin++;
	INC  R13
; 0000 0134                                             if(miin==60)
	LDI  R30,LOW(60)
	CP   R30,R13
	BRNE _0x7A
; 0000 0135                                                 miin=0;
	CLR  R13
; 0000 0136                                             timesetshow(i);
_0x7A:
	RCALL SUBOPT_0x23
; 0000 0137                                             delay_ms(130);
	RCALL SUBOPT_0x26
; 0000 0138                                           }
	RJMP _0x77
_0x79:
; 0000 0139                                           break;
	RJMP _0x6E
; 0000 013A                                         case 2:
_0x75:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6E
; 0000 013B                                           sec++;
	INC  R12
; 0000 013C                                           if(sec==60)
	LDI  R30,LOW(60)
	CP   R30,R12
	BRNE _0x7C
; 0000 013D                                             sec=0;
	CLR  R12
; 0000 013E                                           timesetshow(i);
_0x7C:
	RCALL SUBOPT_0x23
; 0000 013F                                           delay_ms(700);
	RCALL SUBOPT_0x25
; 0000 0140                                           while(up){
_0x7D:
	SBIC 0x13,2
	RJMP _0x7F
; 0000 0141                                             sec++;
	INC  R12
; 0000 0142                                             if(sec==60)
	LDI  R30,LOW(60)
	CP   R30,R12
	BRNE _0x80
; 0000 0143                                                 sec=0;
	CLR  R12
; 0000 0144                                             timesetshow(i);
_0x80:
	RCALL SUBOPT_0x23
; 0000 0145                                             delay_ms(130);
	RCALL SUBOPT_0x26
; 0000 0146                                           }
	RJMP _0x7D
_0x7F:
; 0000 0147                                           break;
; 0000 0148                                     };
_0x6E:
; 0000 0149 
; 0000 014A                                 }
; 0000 014B 
; 0000 014C                                 if(down){
_0x6B:
	SBIC 0x13,3
	RJMP _0x81
; 0000 014D 
; 0000 014E                                     switch (i) {
	RCALL SUBOPT_0x24
; 0000 014F                                         case 0:
	BRNE _0x85
; 0000 0150                                             hour--;
	DEC  R8
; 0000 0151                                             if(hour==255)
	LDI  R30,LOW(255)
	CP   R30,R8
	BRNE _0x86
; 0000 0152                                                 hour=23;
	LDI  R30,LOW(23)
	MOV  R8,R30
; 0000 0153                                             timesetshow(i);
_0x86:
	RCALL SUBOPT_0x23
; 0000 0154                                             delay_ms(700);
	RCALL SUBOPT_0x25
; 0000 0155                                             while(down){
_0x87:
	SBIC 0x13,3
	RJMP _0x89
; 0000 0156                                                 hour--;
	DEC  R8
; 0000 0157                                                 if(hour==255)
	LDI  R30,LOW(255)
	CP   R30,R8
	BRNE _0x8A
; 0000 0158                                                     hour=23;
	LDI  R30,LOW(23)
	MOV  R8,R30
; 0000 0159                                                 timesetshow(i);
_0x8A:
	RCALL SUBOPT_0x23
; 0000 015A                                                 delay_ms(130);
	RCALL SUBOPT_0x26
; 0000 015B                                             }
	RJMP _0x87
_0x89:
; 0000 015C                                             break;
	RJMP _0x84
; 0000 015D                                         case 1:
_0x85:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x8B
; 0000 015E                                             miin--;
	DEC  R13
; 0000 015F                                             if(miin==255)
	LDI  R30,LOW(255)
	CP   R30,R13
	BRNE _0x8C
; 0000 0160                                                 miin=59;
	LDI  R30,LOW(59)
	MOV  R13,R30
; 0000 0161                                             timesetshow(i);
_0x8C:
	RCALL SUBOPT_0x23
; 0000 0162                                             delay_ms(700);
	RCALL SUBOPT_0x25
; 0000 0163                                             while(down){
_0x8D:
	SBIC 0x13,3
	RJMP _0x8F
; 0000 0164                                                 miin--;
	DEC  R13
; 0000 0165                                                 if(miin==255)
	LDI  R30,LOW(255)
	CP   R30,R13
	BRNE _0x90
; 0000 0166                                                     miin=59;
	LDI  R30,LOW(59)
	MOV  R13,R30
; 0000 0167                                                 timesetshow(i);
_0x90:
	RCALL SUBOPT_0x23
; 0000 0168                                                 delay_ms(130);
	RCALL SUBOPT_0x26
; 0000 0169                                             }
	RJMP _0x8D
_0x8F:
; 0000 016A                                             break;
	RJMP _0x84
; 0000 016B                                         case 2:
_0x8B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x84
; 0000 016C                                             sec--;
	DEC  R12
; 0000 016D                                             if(sec==255)
	LDI  R30,LOW(255)
	CP   R30,R12
	BRNE _0x92
; 0000 016E                                                 sec=59;
	LDI  R30,LOW(59)
	MOV  R12,R30
; 0000 016F                                             timesetshow(i);
_0x92:
	RCALL SUBOPT_0x23
; 0000 0170                                             delay_ms(700);
	RCALL SUBOPT_0x25
; 0000 0171                                             while(down){
_0x93:
	SBIC 0x13,3
	RJMP _0x95
; 0000 0172                                                 sec--;
	DEC  R12
; 0000 0173                                                 if(sec==255)
	LDI  R30,LOW(255)
	CP   R30,R12
	BRNE _0x96
; 0000 0174                                                     sec=59;
	LDI  R30,LOW(59)
	MOV  R12,R30
; 0000 0175                                                 timesetshow(i);
_0x96:
	RCALL SUBOPT_0x23
; 0000 0176                                                 delay_ms(130);
	RCALL SUBOPT_0x26
; 0000 0177                                             }
	RJMP _0x93
_0x95:
; 0000 0178                                             break;
; 0000 0179                                     };
_0x84:
; 0000 017A 
; 0000 017B                                 }
; 0000 017C 
; 0000 017D                                 if(set){
_0x81:
	SBIC 0x10,2
	RJMP _0x97
; 0000 017E                                     while(set);
_0x98:
	SBIS 0x10,2
	RJMP _0x98
; 0000 017F                                     i++;
	SUBI R17,-1
; 0000 0180                                     if(i==3)
	CPI  R17,3
	BRNE _0x9B
; 0000 0181                                         i=0;
	LDI  R17,LOW(0)
; 0000 0182                                 }
_0x9B:
; 0000 0183                             }
_0x97:
	RJMP _0x63
_0x65:
; 0000 0184                             while(ok);
_0x9C:
	SBIS 0x13,4
	RJMP _0x9C
; 0000 0185                             rtc_set_time(hour,miin,sec);
	ST   -Y,R8
	ST   -Y,R13
	MOV  R26,R12
	RCALL _rtc_set_time
; 0000 0186                         }else{// ‰ŸÌ„ ‰Ê⁄ “„«‰ 24/12
	RJMP _0x9F
_0x62:
; 0000 0187                             choice2=0;
	CLT
	BLD  R15,1
; 0000 0188                             while(!ok){
_0xA0:
	SBIS 0x13,4
	RJMP _0xA2
; 0000 0189                                 lcd_clear();
	RCALL _lcd_clear
; 0000 018A                                 lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1A
; 0000 018B                                 lcd_puts("clock mode:24h/12h?");
	__POINTW2MN _0x31,203
	RCALL SUBOPT_0x27
; 0000 018C                                 lcd_gotoxy(0,1);
; 0000 018D                                 if(rtc_read(0x08) & 0x01)
	ANDI R30,LOW(0x1)
	BREQ _0xA3
; 0000 018E                                     lcd_puts("    <24h>   12h     ");
	__POINTW2MN _0x31,223
	RJMP _0x180
; 0000 018F                                 else
_0xA3:
; 0000 0190                                     lcd_puts("     24h   <12h>    ");
	__POINTW2MN _0x31,244
_0x180:
	RCALL _lcd_puts
; 0000 0191                                 while(!ok & !set);
_0xA5:
	LDI  R26,0
	SBIS 0x13,4
	LDI  R26,1
	LDI  R30,LOW(0)
	RCALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBIS 0x10,2
	LDI  R26,1
	LDI  R30,LOW(0)
	RCALL __EQB12
	AND  R30,R0
	BRNE _0xA5
; 0000 0192                                 if(set){
	SBIC 0x10,2
	RJMP _0xA8
; 0000 0193                                     while(set);
_0xA9:
	SBIS 0x10,2
	RJMP _0xA9
; 0000 0194                                     if(rtc_read(0x08) & 0x01)
	RCALL SUBOPT_0x0
	ANDI R30,LOW(0x1)
	BREQ _0xAC
; 0000 0195                                         rtc_write(0x08,rtc_read(0x08) & 0xFE);
	RCALL SUBOPT_0x28
	ANDI R30,0xFE
	RJMP _0x181
; 0000 0196                                     else
_0xAC:
; 0000 0197                                         rtc_write(0x08,rtc_read(0x08) | 0x01);
	RCALL SUBOPT_0x28
	ORI  R30,1
_0x181:
	MOV  R26,R30
	RCALL _rtc_write
; 0000 0198                                 }
; 0000 0199                             }
_0xA8:
	RJMP _0xA0
_0xA2:
; 0000 019A                             while(ok);
_0xAE:
	SBIS 0x13,4
	RJMP _0xAE
; 0000 019B                         }
_0x9F:
; 0000 019C                     }
; 0000 019D                 }
_0x5E:
	RJMP _0x48
_0x4A:
; 0000 019E                 while(set);
_0xB1:
	SBIS 0x10,2
	RJMP _0xB1
; 0000 019F             }
; 0000 01A0             if(page==1){//set date & type
_0x47:
	CPI  R16,1
	BREQ PC+2
	RJMP _0xB4
; 0000 01A1                 lcd_clear();
	RCALL _lcd_clear
; 0000 01A2                 choice=0;
	RCALL SUBOPT_0x21
; 0000 01A3                 delay_ms(50);
	RCALL SUBOPT_0xB
; 0000 01A4                 while (!set){
_0xB5:
	SBIS 0x10,2
	RJMP _0xB7
; 0000 01A5                     lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1A
; 0000 01A6                     if(choice==0){
	SBRC R15,0
	RJMP _0xB8
; 0000 01A7                         lcd_puts("1.Date Type <       ");
	__POINTW2MN _0x31,265
	RCALL _lcd_puts
; 0000 01A8                         lcd_puts("2.Set Date         ");
	__POINTW2MN _0x31,286
	RCALL SUBOPT_0x1B
; 0000 01A9                         lcd_putchar(1);
; 0000 01AA                     }else{
	RJMP _0xB9
_0xB8:
; 0000 01AB                         lcd_puts("1.Date Type        ");
	__POINTW2MN _0x31,306
	RCALL SUBOPT_0x1C
; 0000 01AC                         lcd_putchar(0);
; 0000 01AD                         lcd_puts("2.Set Date  <       ");
	__POINTW2MN _0x31,326
	RCALL _lcd_puts
; 0000 01AE                     }
_0xB9:
; 0000 01AF                     while(!ok && !up && !down && !set);
_0xBA:
	RCALL SUBOPT_0x1F
	BRNE _0xBD
	RCALL SUBOPT_0x1D
	BRNE _0xBD
	RCALL SUBOPT_0x1E
	BRNE _0xBD
	RCALL SUBOPT_0x20
	BREQ _0xBE
_0xBD:
	RJMP _0xBC
_0xBE:
	RJMP _0xBA
_0xBC:
; 0000 01B0                     if(up){
	SBIC 0x13,2
	RJMP _0xBF
; 0000 01B1                         while(up);
_0xC0:
	SBIS 0x13,2
	RJMP _0xC0
; 0000 01B2                         if(choice==0)
	SBRC R15,0
	RJMP _0xC3
; 0000 01B3                             styleup();
	RCALL _styleup
; 0000 01B4                         else
	RJMP _0xC4
_0xC3:
; 0000 01B5                            choice=0;
	RCALL SUBOPT_0x21
; 0000 01B6                     }
_0xC4:
; 0000 01B7 
; 0000 01B8                     if(down){
_0xBF:
	SBIC 0x13,3
	RJMP _0xC5
; 0000 01B9                         while(down);
_0xC6:
	SBIS 0x13,3
	RJMP _0xC6
; 0000 01BA                         if(choice==1)
	SBRS R15,0
	RJMP _0xC9
; 0000 01BB                             styledown();
	RCALL _styledown
; 0000 01BC                         else
	RJMP _0xCA
_0xC9:
; 0000 01BD                             choice=1;
	SET
	BLD  R15,0
; 0000 01BE                     }
_0xCA:
; 0000 01BF                     if(ok){
_0xC5:
	SBIC 0x13,4
	RJMP _0xCB
; 0000 01C0                         while(ok);
_0xCC:
	SBIS 0x13,4
	RJMP _0xCC
; 0000 01C1                         if(choice==0){  // date type
	SBRC R15,0
	RJMP _0xCF
; 0000 01C2                             while(!ok){
_0xD0:
	SBIS 0x13,4
	RJMP _0xD2
; 0000 01C3                                 lcd_clear();
	RCALL _lcd_clear
; 0000 01C4                                 lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x29
; 0000 01C5                                 lcd_puts("date type?");
	__POINTW2MN _0x31,347
	RCALL SUBOPT_0x27
; 0000 01C6                                 lcd_gotoxy(0,1);
; 0000 01C7                                 if(rtc_read(0x08) & 0x02)
	ANDI R30,LOW(0x2)
	BREQ _0xD3
; 0000 01C8                                     lcd_puts(" <shamsi>    miladi ");
	__POINTW2MN _0x31,358
	RJMP _0x182
; 0000 01C9                                 else
_0xD3:
; 0000 01CA                                     lcd_puts("  shamsi    <miladi>");
	__POINTW2MN _0x31,379
_0x182:
	RCALL _lcd_puts
; 0000 01CB                                 while(!ok && !set);
_0xD5:
	RCALL SUBOPT_0x1F
	BRNE _0xD8
	RCALL SUBOPT_0x20
	BREQ _0xD9
_0xD8:
	RJMP _0xD7
_0xD9:
	RJMP _0xD5
_0xD7:
; 0000 01CC                                 if(set){
	SBIC 0x10,2
	RJMP _0xDA
; 0000 01CD                                     while(set);
_0xDB:
	SBIS 0x10,2
	RJMP _0xDB
; 0000 01CE                                     if(rtc_read(0x08) & 0x02)
	RCALL SUBOPT_0x0
	ANDI R30,LOW(0x2)
	BREQ _0xDE
; 0000 01CF                                         rtc_write(0x08,rtc_read(0x08) & 0xFD);
	RCALL SUBOPT_0x28
	ANDI R30,0xFD
	RJMP _0x183
; 0000 01D0                                     else
_0xDE:
; 0000 01D1                                         rtc_write(0x08,rtc_read(0x08) | 0x02);
	RCALL SUBOPT_0x28
	ORI  R30,2
_0x183:
	MOV  R26,R30
	RCALL _rtc_write
; 0000 01D2                                 }
; 0000 01D3                             }
_0xDA:
	RJMP _0xD0
_0xD2:
; 0000 01D4                             while(ok);
_0xE0:
	SBIS 0x13,4
	RJMP _0xE0
; 0000 01D5                         }else{      // set date
	RJMP _0xE3
_0xCF:
; 0000 01D6 						    rtc_get_date (&week_day,&day,&month,&year);
	RCALL SUBOPT_0x2A
; 0000 01D7 							i=0;
	LDI  R17,LOW(0)
; 0000 01D8 							if(rtc_read(0x08) & 0x02){
	RCALL SUBOPT_0x0
	ANDI R30,LOW(0x2)
	BREQ _0xE4
; 0000 01D9 										//parsi set date
; 0000 01DA 							}else{
	RJMP _0xE5
_0xE4:
; 0000 01DB 							    //english set date
; 0000 01DC                                 lcd_clear();
	RCALL _lcd_clear
; 0000 01DD                                 lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1A
; 0000 01DE                                 lcd_puts("     Set Date :     ");
	__POINTW2MN _0x31,400
	RCALL _lcd_puts
; 0000 01DF 								while(!ok){
_0xE6:
	SBIS 0x13,4
	RJMP _0xE8
; 0000 01E0 
; 0000 01E1                                     datesetshow(i);
	RCALL SUBOPT_0x2B
; 0000 01E2                                     while(!ok && !set && !up && !down);
_0xE9:
	RCALL SUBOPT_0x1F
	BRNE _0xEC
	RCALL SUBOPT_0x20
	BRNE _0xEC
	RCALL SUBOPT_0x1D
	BRNE _0xEC
	RCALL SUBOPT_0x1E
	BREQ _0xED
_0xEC:
	RJMP _0xEB
_0xED:
	RJMP _0xE9
_0xEB:
; 0000 01E3                                     if(set){
	SBIC 0x10,2
	RJMP _0xEE
; 0000 01E4                                         while(set);
_0xEF:
	SBIS 0x10,2
	RJMP _0xEF
; 0000 01E5                                         i++;
	SUBI R17,-1
; 0000 01E6                                         if(i==4)
	CPI  R17,4
	BRNE _0xF2
; 0000 01E7                                             i=0;
	LDI  R17,LOW(0)
; 0000 01E8                                     }
_0xF2:
; 0000 01E9                                     if(up){
_0xEE:
	SBIC 0x13,2
	RJMP _0xF3
; 0000 01EA                                         if(i==0){
	CPI  R17,0
	BRNE _0xF4
; 0000 01EB                                             year++;
	INC  R9
; 0000 01EC                                             if(year==100)
	LDI  R30,LOW(100)
	CP   R30,R9
	BRNE _0xF5
; 0000 01ED                                                 year=0;
	CLR  R9
; 0000 01EE                                             datesetshow(i);
_0xF5:
	RCALL SUBOPT_0x2B
; 0000 01EF                                             delay_ms(500);
	RCALL SUBOPT_0x2C
; 0000 01F0                                             while(up){
_0xF6:
	SBIC 0x13,2
	RJMP _0xF8
; 0000 01F1                                                 year++;
	INC  R9
; 0000 01F2                                                 if(year==100)
	LDI  R30,LOW(100)
	CP   R30,R9
	BRNE _0xF9
; 0000 01F3                                                     year=0;
	CLR  R9
; 0000 01F4                                                 datesetshow(i);
_0xF9:
	RCALL SUBOPT_0x2B
; 0000 01F5                                                 delay_ms(100);
	RCALL SUBOPT_0x2D
; 0000 01F6                                             }
	RJMP _0xF6
_0xF8:
; 0000 01F7                                             if(leap(year))
	MOV  R26,R9
	RCALL _leap
	CPI  R30,0
	BREQ _0xFA
; 0000 01F8                                                 miladimonth[1]=29;
	LDI  R30,LOW(29)
	RJMP _0x184
; 0000 01F9                                             else
_0xFA:
; 0000 01FA                                                 miladimonth[1]=28;
	LDI  R30,LOW(28)
_0x184:
	__PUTB1MN _miladimonth,1
; 0000 01FB                                         }
; 0000 01FC                                         if(i==1){
_0xF4:
	CPI  R17,1
	BRNE _0xFC
; 0000 01FD                                             month++;
	INC  R6
; 0000 01FE                                             if(month==13)
	LDI  R30,LOW(13)
	CP   R30,R6
	BRNE _0xFD
; 0000 01FF                                                 month=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0200                                             datesetshow(i);
_0xFD:
	RCALL SUBOPT_0x2B
; 0000 0201                                             delay_ms(500);
	RCALL SUBOPT_0x2C
; 0000 0202                                             while(up){
_0xFE:
	SBIC 0x13,2
	RJMP _0x100
; 0000 0203                                                 month++;
	INC  R6
; 0000 0204                                                 if(month==13)
	LDI  R30,LOW(13)
	CP   R30,R6
	BRNE _0x101
; 0000 0205                                                     month=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0206                                                 datesetshow(i);
_0x101:
	RCALL SUBOPT_0x2B
; 0000 0207                                                 delay_ms(100);
	RCALL SUBOPT_0x2D
; 0000 0208                                             }
	RJMP _0xFE
_0x100:
; 0000 0209                                         }
; 0000 020A                                         if(i==2){
_0xFC:
	CPI  R17,2
	BRNE _0x102
; 0000 020B                                             day++;
	RCALL SUBOPT_0x2E
; 0000 020C                                             if(day>miladimonth[month])
	BRSH _0x103
; 0000 020D                                                 day=1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 020E                                             datesetshow(i);
_0x103:
	RCALL SUBOPT_0x2B
; 0000 020F                                             delay_ms(500);
	RCALL SUBOPT_0x2C
; 0000 0210                                             while(up){
_0x104:
	SBIC 0x13,2
	RJMP _0x106
; 0000 0211                                                 day++;
	RCALL SUBOPT_0x2E
; 0000 0212                                                 if(day>miladimonth[month])
	BRSH _0x107
; 0000 0213                                                     day=1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0214                                                 datesetshow(i);
_0x107:
	RCALL SUBOPT_0x2B
; 0000 0215                                                 delay_ms(100);
	RCALL SUBOPT_0x2D
; 0000 0216                                             }
	RJMP _0x104
_0x106:
; 0000 0217                                         }
; 0000 0218                                         if(i==3){
_0x102:
	CPI  R17,3
	BRNE _0x108
; 0000 0219                                             week_day++;
	RCALL SUBOPT_0x2F
; 0000 021A                                             if(week_day==8)
	BRNE _0x109
; 0000 021B                                                 week_day=1;
	LDI  R30,LOW(1)
	STS  _week_day,R30
; 0000 021C                                             datesetshow(i);
_0x109:
	RCALL SUBOPT_0x2B
; 0000 021D                                             delay_ms(500);
	RCALL SUBOPT_0x2C
; 0000 021E                                             while(up){
_0x10A:
	SBIC 0x13,2
	RJMP _0x10C
; 0000 021F                                                 week_day++;
	RCALL SUBOPT_0x2F
; 0000 0220                                                 if(week_day==8)
	BRNE _0x10D
; 0000 0221                                                     week_day=1;
	LDI  R30,LOW(1)
	STS  _week_day,R30
; 0000 0222                                                 datesetshow(i);
_0x10D:
	RCALL SUBOPT_0x2B
; 0000 0223                                                 delay_ms(100);
	RCALL SUBOPT_0x2D
; 0000 0224                                             }
	RJMP _0x10A
_0x10C:
; 0000 0225                                         }
; 0000 0226                                     }
_0x108:
; 0000 0227                                     if(down){
_0xF3:
; 0000 0228                                         if(i==0){}
; 0000 0229                                         if(i==1){}
; 0000 022A                                         if(i==2){}
; 0000 022B                                         if(i==3){}
; 0000 022C                                     }
; 0000 022D 								}
	RJMP _0xE6
_0xE8:
; 0000 022E                                 rtc_set_date(week_day,day,month,year);
	RCALL SUBOPT_0x4
	ST   -Y,R30
	ST   -Y,R7
	ST   -Y,R6
	MOV  R26,R9
	RCALL _rtc_set_date
; 0000 022F 							}
_0xE5:
; 0000 0230                             while(ok);
_0x113:
	SBIS 0x13,4
	RJMP _0x113
; 0000 0231                         }
_0xE3:
; 0000 0232                     }
; 0000 0233                 }
_0xCB:
	RJMP _0xB5
_0xB7:
; 0000 0234                 while(set);
_0x116:
	SBIS 0x10,2
	RJMP _0x116
; 0000 0235             }
; 0000 0236             if(page==2){ // ‰ŸÌ„ œ„« Ê —ÿÊ» 
_0xB4:
; 0000 0237             }
; 0000 0238         }
; 0000 0239     }
_0x43:
	RJMP _0x2D
_0x2F:
; 0000 023A     while(set);
_0x11A:
	SBIS 0x10,2
	RJMP _0x11A
; 0000 023B #asm("sei")
	sei
; 0000 023C }
	RCALL __LOADLOCR2
	ADIW R28,6
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI

	.DSEG
_0x31:
	.BYTE 0x1A5
;
;///////////////////////////////////////////////////
;char dht22(float *temp,float *humi)
; 0000 0240 {

	.CSEG
_dht22:
; 0000 0241 int Temp=0,Humi=0;
; 0000 0242 char check=0;
; 0000 0243 unsigned char temppart1,temppart2,humipart1,humipart2,count=0;
; 0000 0244 int data[40];
; 0000 0245 char i=0;
; 0000 0246 DDRC.0=0;
	RCALL SUBOPT_0x30
	SBIW R28,63
	SBIW R28,22
	LDI  R24,82
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x11D*2)
	LDI  R31,HIGH(_0x11D*2)
	RCALL __INITLOCB
	RCALL __SAVELOCR6
;	*temp -> Y+93
;	*humi -> Y+91
;	Temp -> R16,R17
;	Humi -> R18,R19
;	check -> R21
;	temppart1 -> R20
;	temppart2 -> Y+90
;	humipart1 -> Y+89
;	humipart2 -> Y+88
;	count -> Y+87
;	data -> Y+7
;	i -> Y+6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	LDI  R21,0
	CBI  0x14,0
; 0000 0247 PORTC.0=0;
	CBI  0x15,0
; 0000 0248  for (i=0;i<41;i++){
	RCALL SUBOPT_0x31
_0x123:
	LDD  R26,Y+6
	CPI  R26,LOW(0x29)
	BRSH _0x124
; 0000 0249     data[i]=0;
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x34
; 0000 024A  }
	RCALL SUBOPT_0x35
	RJMP _0x123
_0x124:
; 0000 024B DHT22_INPUT_MODE
	CBI  0x14,1
; 0000 024C count=0;
	RCALL SUBOPT_0x36
; 0000 024D DHT22_LOW // ”Ìê‰«· ‘—Ê⁄ »—«Ì Ì„ „Ì·Ì À«‰ÌÂ
	CBI  0x15,1
; 0000 024E DHT22_OUTPUT_MODE
	SBI  0x14,1
; 0000 024F delay_us(1100);
	__DELAY_USW 2200
; 0000 0250 //DHT22_HIGH
; 0000 0251 lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x29
; 0000 0252 DHT22_INPUT_MODE
	CBI  0x14,1
; 0000 0253 // »Ì”  Ê ‘‘ „Ìò—ÊÀ«‰ÌÂ »—«Ì ¬“«œ ‘œ‰ »«”
; 0000 0254  do{
_0x12E:
; 0000 0255     if(count>20)
	RCALL SUBOPT_0x37
	CPI  R26,LOW(0x15)
	BRLO _0x130
; 0000 0256         return 0;
	RJMP _0x210000B
; 0000 0257     count++;
_0x130:
	RCALL SUBOPT_0x38
; 0000 0258     delay_us(2);
; 0000 0259  }while(DHT22_READ);
	SBIC 0x13,1
	RJMP _0x12E
; 0000 025A count=0;
	RCALL SUBOPT_0x36
; 0000 025B // Â‘ «œ „Ìò—ÊÀ«‰ÌÂ ”Ìê‰«· Å«”Œ «“ ÿ—› ”‰”Ê— »Â ”ÿÕ Ìò „‰ÿﬁÌ
; 0000 025C  do{
_0x132:
; 0000 025D     if(count>45)
	RCALL SUBOPT_0x37
	CPI  R26,LOW(0x2E)
	BRLO _0x134
; 0000 025E         return 0;
	RJMP _0x210000B
; 0000 025F     count++;
_0x134:
	RCALL SUBOPT_0x38
; 0000 0260     delay_us(2);
; 0000 0261  }while(!DHT22_READ);
	SBIS 0x13,1
	RJMP _0x132
; 0000 0262 count=0;
	RCALL SUBOPT_0x36
; 0000 0263 // Â‘ «œ „Ìò—ÊÀ«‰ÌÂ ”Ìê‰«· Å«”Œ ”‰”Ê— »« ”ÿÕ ’›—
; 0000 0264  do{
_0x136:
; 0000 0265     if(count>45)
	RCALL SUBOPT_0x37
	CPI  R26,LOW(0x2E)
	BRLO _0x138
; 0000 0266         return 0;
	RJMP _0x210000B
; 0000 0267     count++;
_0x138:
	RCALL SUBOPT_0x38
; 0000 0268     delay_us(2);
; 0000 0269  }while(DHT22_READ);
	SBIC 0x13,1
	RJMP _0x136
; 0000 026A  count=0;
	RCALL SUBOPT_0x36
; 0000 026B // ŒÊ«‰œ‰ »Ì  Â«Ì œ«œÂ
; 0000 026C // Õ·ﬁÂ «Ê· »—«Ì Å‰Ã«Â „Ìò—ÊÀ«‰ÌÂ ”ÿÕ „‰ÿﬁÌ ’›—
; 0000 026D // òÂ œ— »Ì‰ ”ÿÕ Â«Ì „‰ÿﬁÌ Ìò òÂ œ—Ê«ﬁ⁄ »Ì  Â«Ì
; 0000 026E // œ«œÂ «‰œ
; 0000 026F // Õ·ﬁÂ œÊ„ –ŒÌ—Â »Ì  Â«Ì œ«œÂ
; 0000 0270 // «ê— 70 À«‰ÌÂ ÿÊ· »ò‘Â Ì⁄‰Ì Ìò Ê 26 „Ìò—ÊÀ«‰ÌÂ Â„ ’›—
; 0000 0271 for(i=0; i<40; i++)
	RCALL SUBOPT_0x31
_0x13A:
	LDD  R26,Y+6
	CPI  R26,LOW(0x28)
	BRSH _0x13B
; 0000 0272     {
; 0000 0273      do{
_0x13D:
; 0000 0274         if(count>33)
	RCALL SUBOPT_0x37
	CPI  R26,LOW(0x22)
	BRLO _0x13F
; 0000 0275             return 0;
	RJMP _0x210000B
; 0000 0276         count++;
_0x13F:
	MOVW R26,R28
	SUBI R26,LOW(-(87))
	SBCI R27,HIGH(-(87))
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0000 0277         //delay_us(1);
; 0000 0278      }while(!DHT22_READ);
	SBIS 0x13,1
	RJMP _0x13D
; 0000 0279 
; 0000 027A      count=0;
	RCALL SUBOPT_0x36
; 0000 027B      do{
_0x141:
; 0000 027C         if(count>40)
	RCALL SUBOPT_0x37
	CPI  R26,LOW(0x29)
	BRLO _0x143
; 0000 027D             return 0;
	RJMP _0x210000B
; 0000 027E         count++;
_0x143:
	RCALL SUBOPT_0x38
; 0000 027F         delay_us(2);
; 0000 0280      }while(DHT22_READ);
	SBIC 0x13,1
	RJMP _0x141
; 0000 0281      data[i]=count;
	RCALL SUBOPT_0x32
	ADD  R26,R30
	ADC  R27,R31
	__GETB1SX 87
	RCALL SUBOPT_0x39
	ST   X+,R30
	ST   X,R31
; 0000 0282      count=0;
	RCALL SUBOPT_0x36
; 0000 0283     }
	RCALL SUBOPT_0x35
	RJMP _0x13A
_0x13B:
; 0000 0284 /// çÊ‰ ”‰”Ê— «» œ« »““ê —Ì‰ »Ì  —« „Ì ›—” œ
; 0000 0285 // ¬‰ Â« —« »—⁄ò” „Ì ò‰Ì„  « »Â ’Ê—  ⁄«œÌ Ì« ‰—„«· œ— ¬Ì‰œ
; 0000 0286  for(i=0;i<16;i++){  // for humidity
	RCALL SUBOPT_0x31
_0x145:
	LDD  R26,Y+6
	CPI  R26,LOW(0x10)
	BRSH _0x146
; 0000 0287     if(data[i]>6){
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x3A
	BRLT _0x147
; 0000 0288         Humi |= (1<<(15-i));// »—⁄ò” ò—œ‰ »Ì  Â«
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x3C
	__ORWRR 18,19,30,31
; 0000 0289     }
; 0000 028A  }
_0x147:
	RCALL SUBOPT_0x35
	RJMP _0x145
_0x146:
; 0000 028B  for (i=0;i<16;i++){    // for temperature
	RCALL SUBOPT_0x31
_0x149:
	LDD  R26,Y+6
	CPI  R26,LOW(0x10)
	BRSH _0x14A
; 0000 028C     if(data[16+i]>6){
	RCALL SUBOPT_0x3B
	ADIW R30,16
	RCALL SUBOPT_0x3D
	BRLT _0x14B
; 0000 028D         Temp |= (1<<(15-i));
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x3C
	__ORWRR 16,17,30,31
; 0000 028E     }
; 0000 028F  }
_0x14B:
	RCALL SUBOPT_0x35
	RJMP _0x149
_0x14A:
; 0000 0290  for (i=0;i<8;i++){    // for check bit
	RCALL SUBOPT_0x31
_0x14D:
	LDD  R26,Y+6
	CPI  R26,LOW(0x8)
	BRSH _0x14E
; 0000 0291     if(data[32+i]>6){
	RCALL SUBOPT_0x3B
	ADIW R30,32
	RCALL SUBOPT_0x3D
	BRLT _0x14F
; 0000 0292         check |= (1<<(7-i));
	LDD  R26,Y+6
	LDI  R30,LOW(7)
	SUB  R30,R26
	LDI  R26,LOW(1)
	RCALL __LSLB12
	OR   R21,R30
; 0000 0293     }
; 0000 0294  }
_0x14F:
	RCALL SUBOPT_0x35
	RJMP _0x14D
_0x14E:
; 0000 0295 temppart1=Temp>>8;
	MOVW R30,R16
	RCALL __ASRW8
	MOV  R20,R30
; 0000 0296 temppart2=Temp & 0xFF;
	MOV  R30,R16
	__PUTB1SX 90
; 0000 0297 humipart1=Humi>>8;
	MOVW R30,R18
	RCALL __ASRW8
	__PUTB1SX 89
; 0000 0298 humipart2=Humi & 0xFF;
	MOV  R30,R18
	__PUTB1SX 88
; 0000 0299 *humi=(((float)Humi)/10.0);
	MOVW R30,R18
	RCALL SUBOPT_0x3E
	__GETW2SX 91
	RCALL __PUTDP1
; 0000 029A  if(Temp & 0x8000){
	SBRS R17,7
	RJMP _0x150
; 0000 029B     Temp=(Temp&0x7FFF);
	ANDI R17,HIGH(32767)
; 0000 029C     *temp=(((float)Temp)/10.0*(-1));
	MOVW R30,R16
	RCALL SUBOPT_0x3E
	__GETD2N 0xBF800000
	RCALL __MULF12
	RJMP _0x185
; 0000 029D  }else{
_0x150:
; 0000 029E     *temp=(((float)Temp)/10.0);
	MOVW R30,R16
	RCALL SUBOPT_0x3E
_0x185:
	__GETW2SX 93
	RCALL __PUTDP1
; 0000 029F  }
; 0000 02A0 if(((temppart1+temppart2+humipart1+humipart2)&0xFF) == check)
	MOV  R26,R20
	CLR  R27
	__GETB1SX 90
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x33
	__GETB1SX 89
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x33
	__GETB1SX 88
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x33
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	AND  R30,R26
	AND  R31,R27
	MOVW R26,R30
	MOV  R30,R21
	RCALL SUBOPT_0x39
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x152
; 0000 02A1     return 1;
	LDI  R30,LOW(1)
	RJMP _0x210000A
; 0000 02A2 return 0;
_0x152:
_0x210000B:
	LDI  R30,LOW(0)
_0x210000A:
	RCALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,32
	RET
; 0000 02A3 }
;//////////////////////////////////////////////////
;
;void miladitoshamsi(unsigned char dm,unsigned char mm,unsigned char ym){
; 0000 02A6 void miladitoshamsi(unsigned char dm,unsigned char mm,unsigned char ym){
_miladitoshamsi:
; 0000 02A7 
; 0000 02A8     unsigned char i=0;
; 0000 02A9     int sumdaymiladi=0,sumdayshamsi=0;
; 0000 02AA     sal=0,rooz=0;mah=1;
	ST   -Y,R26
	RCALL __SAVELOCR6
;	dm -> Y+8
;	mm -> Y+7
;	ym -> Y+6
;	i -> R17
;	sumdaymiladi -> R18,R19
;	sumdayshamsi -> R20,R21
	LDI  R17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	CLR  R10
	CLR  R11
	CLR  R4
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 02AB     if (leap(ym))
	LDD  R26,Y+6
	RCALL _leap
	CPI  R30,0
	BREQ _0x153
; 0000 02AC         miladimonth[1]=29; /// the year is leep
	LDI  R30,LOW(29)
	RJMP _0x186
; 0000 02AD     else
_0x153:
; 0000 02AE         miladimonth[1]=28;  /// the year is not leap
	LDI  R30,LOW(28)
_0x186:
	__PUTB1MN _miladimonth,1
; 0000 02AF     for (i=0;i<mm-1;i++){
	LDI  R17,LOW(0)
_0x156:
	LDD  R30,Y+7
	RCALL SUBOPT_0x39
	SBIW R30,1
	MOV  R26,R17
	RCALL SUBOPT_0x3F
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x157
; 0000 02B0         sumdaymiladi += miladimonth[i];
	MOV  R30,R17
	RCALL SUBOPT_0x39
	SUBI R30,LOW(-_miladimonth)
	SBCI R31,HIGH(-_miladimonth)
	LD   R30,Z
	RCALL SUBOPT_0x39
	__ADDWRR 18,19,30,31
; 0000 02B1     }
	SUBI R17,-1
	RJMP _0x156
_0x157:
; 0000 02B2     i=0;
	LDI  R17,LOW(0)
; 0000 02B3     sumdaymiladi += dm;
	LDD  R30,Y+8
	RCALL SUBOPT_0x39
	__ADDWRR 18,19,30,31
; 0000 02B4     if(sumdaymiladi<=79){
	__CPWRN 18,19,80
	BRGE _0x158
; 0000 02B5         sal=(ym+2000)-622;
	RCALL SUBOPT_0x3B
	SUBI R30,LOW(-2000)
	SBCI R31,HIGH(-2000)
	SUBI R30,LOW(622)
	SBCI R31,HIGH(622)
	MOVW R10,R30
; 0000 02B6         if (leap(ym-1))
	LDD  R26,Y+6
	SUBI R26,LOW(1)
	RCALL _leap
	CPI  R30,0
	BREQ _0x159
; 0000 02B7         {
; 0000 02B8             sumdayshamsi=sumdaymiladi+287;
	MOVW R30,R18
	SUBI R30,LOW(-287)
	SBCI R31,HIGH(-287)
	MOVW R20,R30
; 0000 02B9             shamsimonth[11]=30;
	LDI  R30,LOW(30)
	RJMP _0x187
; 0000 02BA         }
; 0000 02BB         else
_0x159:
; 0000 02BC         {
; 0000 02BD             sumdayshamsi=sumdaymiladi+286;
	MOVW R30,R18
	SUBI R30,LOW(-286)
	SBCI R31,HIGH(-286)
	MOVW R20,R30
; 0000 02BE             shamsimonth[11]=29;
	LDI  R30,LOW(29)
_0x187:
	__PUTB1MN _shamsimonth,11
; 0000 02BF         }
; 0000 02C0     }else{
	RJMP _0x15B
_0x158:
; 0000 02C1         sal=(ym+2000)-621;
	RCALL SUBOPT_0x3B
	SUBI R30,LOW(-2000)
	SBCI R31,HIGH(-2000)
	SUBI R30,LOW(621)
	SBCI R31,HIGH(621)
	MOVW R10,R30
; 0000 02C2         sumdayshamsi=sumdaymiladi-79;
	MOVW R30,R18
	SUBI R30,LOW(79)
	SBCI R31,HIGH(79)
	MOVW R20,R30
; 0000 02C3     }
_0x15B:
; 0000 02C4     if (sumdayshamsi<=186 && sumdayshamsi>31){
	__CPWRN 20,21,187
	BRGE _0x15D
	__CPWRN 20,21,32
	BRGE _0x15E
_0x15D:
	RJMP _0x15C
_0x15E:
; 0000 02C5         while(sumdayshamsi>31){
_0x15F:
	__CPWRN 20,21,32
	BRLT _0x161
; 0000 02C6             sumdayshamsi-=shamsimonth[i];
	RCALL SUBOPT_0x40
; 0000 02C7             mah++;
; 0000 02C8             i++;
; 0000 02C9         }
	RJMP _0x15F
_0x161:
; 0000 02CA     }else{
	RJMP _0x162
_0x15C:
; 0000 02CB         while(sumdayshamsi>30){
_0x163:
	__CPWRN 20,21,31
	BRLT _0x165
; 0000 02CC             sumdayshamsi-=shamsimonth[i];
	RCALL SUBOPT_0x40
; 0000 02CD             mah++;
; 0000 02CE             i++;
; 0000 02CF         }
	RJMP _0x163
_0x165:
; 0000 02D0     }
_0x162:
; 0000 02D1 	rooz=sumdayshamsi;
	MOV  R4,R20
; 0000 02D2 }
	RCALL __LOADLOCR6
	ADIW R28,9
	RET
;////////////////////////////////////////////////
;/*
;void shamsitomiladi(unsigned char dsh,unsigned char msh,int ysh){
;    unsigned char i=0;
;    int sumdaymiladi=0,sumdayshamsi=0,ym;
;    //sal=0,rooz=0;mah=1;
;	for (i=0; i<msh-1;i++){
;		sumdayshamsi+=shamsimonth[i];
;	}
;	sumdayshamsi+=dsh;
;    if(sumdayshamsi<=286){
;        ym=ysh+621;
;        if(((((ysh+622)%4)==0)&&(((ysh+622)%100)!=0))||((((ysh+622)%100)==0)&&(((ysh+622)%400)==0)) ||((((ysh+621)%4)==0)&&(((ysh+621)%100)!=0))||((((ysh+621)%100)==0)&&(((ysh+621)%400)==0))){
;		    sumdaymiladi=sumdayshamsi+80; ///chert
;        }else{
;            sumdaymiladi=sumdayshamsi+79;
;        }
;
;    }
;	if(sumdayshamsi>=289){
;        ym=ysh+622;
;        if(((((ysh+621)%4)==0)&&(((ysh+621)%100)!=0))||((((ysh+621)%100)==0)&&(((ysh+621)%400)==0))){
;            sumdaymiladi=sumdayshamsi-287;
;        }else{
;            sumdaymiladi=sumdayshamsi-286;
;        }   /////
;    }
;
;    if(sumdayshamsi==287){
;		if (((((ysh+621)%4)==0)&&(((ysh+621)%100)!=0))||((((ysh+621)%100)==0)&&(((ysh+621)%400)==0))){
;			ym=ysh+621;
;			sumdaymiladi=sumdayshamsi+79;
;		}else{
;			ym=ysh+622;
;			sumdaymiladi=sumdayshamsi-286;
;		}
;	}
;    if(sumdayshamsi==288){
;		if (((((ysh+621)%4)==0)&&(((ysh+621)%100)!=0))||((((ysh+621)%100)==0)&&(((ysh+621)%400)==0))){
;			ym=ysh+622;
;			sumdaymiladi=sumdayshamsi-287;
;		}else{
;			ym=ysh+622;
;			sumdaymiladi=sumdayshamsi-286;
;		}
;	}
;
;	if ((((ym%4)==0)&&((ym%100)!=0))||(((ym%100)==0)&&((ym%400)==0))){
;		miladimonth[1]=29;
;	}else{
;		miladimonth[1]=28;
;	}
;	i=0;
;	month=1;
;	while(sumdaymiladi>31){
;        sumdaymiladi-=miladimonth[i];
;        month++;
;        i++;
;    }
;
;	if ((((ym%4)==0)&&((ym%100)!=0))||(((ym%100)==0)&&((ym%400)==0))){
;		if (i==1 && sumdaymiladi>29){
;			month++;
;			sumdaymiladi-=miladimonth[1];
;		}
;	}else{
;		if ((i==1 && sumdaymiladi>28)|| ((i==3 || i==5 || i==8 || i==10) && sumdaymiladi>30)){
;			if(i==1){
;				month++;
;				sumdaymiladi-=miladimonth[1];
;			}
;			if(i==3 || i==5 || i==8 || i==10){
;				month++;
;				sumdaymiladi-=miladimonth[3];
;			}
;		}
;	}
;	day=sumdaymiladi;
;    year=(ym%10)+(((ym/10)%10)*10);
;}
;////////////////////////////////////////////////
;*/
;
;void main(void)
; 0000 0327 {
_main:
; 0000 0328 char humidity[4],temperature[4],str_date[4];//str_week_day[1];
; 0000 0329 char controlbyte;
; 0000 032A bit pmam;
; 0000 032B float temp,humi;
; 0000 032C {
	SBIW R28,20
;	humidity -> Y+16
;	temperature -> Y+12
;	str_date -> Y+8
;	controlbyte -> R17
;	pmam -> R15.0
;	temp -> Y+4
;	humi -> Y+0
; 0000 032D 
; 0000 032E 
; 0000 032F PORTD=0x38;
	LDI  R30,LOW(56)
	OUT  0x12,R30
; 0000 0330 DDRD.2=0;
	CBI  0x11,2
; 0000 0331 //DDRD.3=0;DDRD.4=0;
; 0000 0332 
; 0000 0333 // Timer/Counter 0 initialization
; 0000 0334 // Clock source: System Clock
; 0000 0335 // Clock value: Timer 0 Stopped
; 0000 0336 // External Interrupt(s) initialization
; 0000 0337 // INT0: On
; 0000 0338 // INT0 Mode: Any change
; 0000 0339 // INT1: Off
; 0000 033A GICR|=0x40;
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 033B MCUCR=0x01;
	LDI  R30,LOW(1)
	OUT  0x35,R30
; 0000 033C GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 033D 
; 0000 033E // Analog Comparator initialization
; 0000 033F // Analog Comparator: Off
; 0000 0340 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0341 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0342 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0343 
; 0000 0344 // ADC initialization
; 0000 0345 // ADC disabled
; 0000 0346 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0347 // I2C Bus initialization
; 0000 0348 // I2C Port: PORTD
; 0000 0349 // I2C SDA bit: 1
; 0000 034A // I2C SCL bit: 0
; 0000 034B // Bit Rate: 100 kHz
; 0000 034C // Note: I2C settings are specified in the
; 0000 034D // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 034E i2c_init();
	RCALL _i2c_init
; 0000 034F 
; 0000 0350 // DS1307 Real Time Clock initialization
; 0000 0351 // Square wave output on pin SQW/OUT: Off
; 0000 0352 // SQW/OUT pin state: 0
; 0000 0353 rtc_init(0,0,0);
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x41
	LDI  R26,LOW(0)
	RCALL _rtc_init
; 0000 0354 
; 0000 0355 // Alphanumeric LCD initialization
; 0000 0356 // Connections are specified in the
; 0000 0357 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0358 // RS - PORTB Bit 0
; 0000 0359 // RD - PORTB Bit 1
; 0000 035A // EN - PORTB Bit 2
; 0000 035B // D4 - PORTB Bit 4
; 0000 035C // D5 - PORTB Bit 5
; 0000 035D // D6 - PORTB Bit 6
; 0000 035E // D7 - PORTB Bit 7
; 0000 035F // Characters/line: 20
; 0000 0360 
; 0000 0361   #asm("sei")
	sei
; 0000 0362 }
; 0000 0363   lcd_init(20);
	LDI  R26,LOW(20)
	RCALL _lcd_init
; 0000 0364   rtc_get_time(&hour,&miin,&sec);
	RCALL SUBOPT_0x22
; 0000 0365   if (sec>61){
	LDI  R30,LOW(61)
	CP   R30,R12
	BRSH _0x168
; 0000 0366     rtc_set_time(8,0,0);
	LDI  R30,LOW(8)
	ST   -Y,R30
	RCALL SUBOPT_0x41
	LDI  R26,LOW(0)
	RCALL _rtc_set_time
; 0000 0367     rtc_set_date(2,12,12,2017);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(12)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(225)
	RCALL _rtc_set_date
; 0000 0368     rtc_write(0x08,0x00);
	RCALL SUBOPT_0x42
; 0000 0369   }
; 0000 036A   rtc_write(0x08,0x00);
_0x168:
	RCALL SUBOPT_0x42
; 0000 036B     define_char(char3,3);
	LDI  R30,LOW(_char3*2)
	LDI  R31,HIGH(_char3*2)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(3)
	RCALL _define_char
; 0000 036C     define_char(char4,4);
	LDI  R30,LOW(_char4*2)
	LDI  R31,HIGH(_char4*2)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(4)
	RCALL _define_char
; 0000 036D     define_char(char5,5);
	LDI  R30,LOW(_char5*2)
	LDI  R31,HIGH(_char5*2)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(5)
	RCALL _define_char
; 0000 036E     define_char(char6,6);
	LDI  R30,LOW(_char6*2)
	LDI  R31,HIGH(_char6*2)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(6)
	RCALL _define_char
; 0000 036F     define_char(char7,7);
	LDI  R30,LOW(_char7*2)
	LDI  R31,HIGH(_char7*2)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(7)
	RCALL _define_char
; 0000 0370     define_char(char8,8);
	LDI  R30,LOW(_char8*2)
	LDI  R31,HIGH(_char8*2)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(8)
	RCALL _define_char
; 0000 0371     controlbyte=rtc_read(0x08);
	RCALL SUBOPT_0x0
	MOV  R17,R30
; 0000 0372 
; 0000 0373 while(1)
_0x169:
; 0000 0374  {
; 0000 0375 
; 0000 0376     while(resett){
_0x16C:
	SBRS R2,0
	RJMP _0x16E
; 0000 0377         if(sec==30 || sec==0)
	LDI  R30,LOW(30)
	CP   R30,R12
	BREQ _0x170
	LDI  R30,LOW(0)
	CP   R30,R12
	BRNE _0x16F
_0x170:
; 0000 0378             resett=0;
	CLT
	BLD  R2,0
; 0000 0379         rtc_get_time(&hour,&miin,&sec);
_0x16F:
	RCALL SUBOPT_0x22
; 0000 037A         if((controlbyte & 0x01)==0){
	SBRC R17,0
	RJMP _0x172
; 0000 037B             if(hour>12){
	LDI  R30,LOW(12)
	CP   R30,R8
	BRSH _0x173
; 0000 037C                 pmam=1;
	SET
	BLD  R15,0
; 0000 037D                 hour-=12;
	SUB  R8,R30
; 0000 037E             }else{
	RJMP _0x174
_0x173:
; 0000 037F                 pmam=0;
	RCALL SUBOPT_0x21
; 0000 0380             }
_0x174:
; 0000 0381         }
; 0000 0382         sprintf(strr,"%02u:%02u:%02d",hour,miin,sec);
_0x172:
	LDI  R30,LOW(_strr)
	LDI  R31,HIGH(_strr)
	RCALL SUBOPT_0x3
	__POINTW1FN _0x0,618
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
; 0000 0383         lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1A
; 0000 0384         lcd_puts(strr);
	LDI  R26,LOW(_strr)
	LDI  R27,HIGH(_strr)
	RCALL _lcd_puts
; 0000 0385         if(pmam && (controlbyte & 0x01)==0 )
	SBRS R15,0
	RJMP _0x176
	SBRS R17,0
	RJMP _0x177
_0x176:
	RJMP _0x175
_0x177:
; 0000 0386             lcd_puts(" PM");
	__POINTW2MN _0x178,0
	RCALL _lcd_puts
; 0000 0387         if(!pmam && (controlbyte & 0x01)==0 )
_0x175:
	SBRC R15,0
	RJMP _0x17A
	SBRS R17,0
	RJMP _0x17B
_0x17A:
	RJMP _0x179
_0x17B:
; 0000 0388             lcd_puts(" AM");
	__POINTW2MN _0x178,4
	RCALL _lcd_puts
; 0000 0389 
; 0000 038A         delay_ms(900);
_0x179:
	LDI  R26,LOW(900)
	LDI  R27,HIGH(900)
	RCALL _delay_ms
; 0000 038B     }
	RJMP _0x16C
_0x16E:
; 0000 038C     resett=1;
	SET
	BLD  R2,0
; 0000 038D     lcd_clear();
	RCALL _lcd_clear
; 0000 038E     controlbyte=rtc_read(0x08);
	RCALL SUBOPT_0x0
	MOV  R17,R30
; 0000 038F     rtc_get_date (&week_day,&day,&month,&year);
	RCALL SUBOPT_0x2A
; 0000 0390     year%=100;
	MOV  R26,R9
	CLR  R27
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __MODW21
	MOV  R9,R30
; 0000 0391     if(controlbyte & 0x02){
	SBRS R17,1
	RJMP _0x17C
; 0000 0392 		miladitoshamsi(day,month,year);
	ST   -Y,R7
	ST   -Y,R6
	MOV  R26,R9
	RCALL _miladitoshamsi
; 0000 0393         sal%=100;
	MOVW R26,R10
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __MODW21
	MOVW R10,R30
; 0000 0394         sprintf(str_date,"%02u/%02u/%02d ",sal,mah,rooz);
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x3
	MOVW R30,R10
	RCALL __CWD1
	RCALL __PUTPARD1
	MOV  R30,R5
	RCALL SUBOPT_0x5
	MOV  R30,R4
	RJMP _0x188
; 0000 0395     }else{
_0x17C:
; 0000 0396         sprintf(str_date,"%02u/%02u/%02d ",year,month,day);
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
	MOV  R30,R7
_0x188:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RCALL SUBOPT_0x12
; 0000 0397     }
; 0000 0398     lcd_gotoxy(0,1);
	RCALL SUBOPT_0x41
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0399     lcd_puts(str_date);
	MOVW R26,R28
	ADIW R26,8
	RCALL _lcd_puts
; 0000 039A     weekdayshow();
	RCALL _weekdayshow
; 0000 039B 
; 0000 039C     if(dht22(&temp,&humi))
	MOVW R30,R28
	ADIW R30,4
	RCALL SUBOPT_0x3
	MOVW R26,R28
	ADIW R26,2
	RCALL _dht22
	CPI  R30,0
	BREQ _0x17E
; 0000 039D     {
; 0000 039E         ftoa(temp,1,temperature);
	__GETD1S 4
	RCALL __PUTPARD1
	LDI  R30,LOW(1)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,17
	RCALL _ftoa
; 0000 039F         lcd_gotoxy(14,0);
	LDI  R30,LOW(14)
	RCALL SUBOPT_0x29
; 0000 03A0         lcd_puts("T:");
	__POINTW2MN _0x178,8
	RCALL _lcd_puts
; 0000 03A1         lcd_puts(temperature);
	MOVW R26,R28
	ADIW R26,12
	RCALL _lcd_puts
; 0000 03A2         ftoa(humi,1,humidity);
	RCALL SUBOPT_0x44
	RCALL __PUTPARD1
	LDI  R30,LOW(1)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,21
	RCALL _ftoa
; 0000 03A3         lcd_gotoxy(14,1);
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 03A4         lcd_puts("H:");
	__POINTW2MN _0x178,11
	RCALL _lcd_puts
; 0000 03A5         lcd_puts(humidity);
	MOVW R26,R28
	ADIW R26,16
	RCALL _lcd_puts
; 0000 03A6     }/*
; 0000 03A7     else
; 0000 03A8     {
; 0000 03A9         lcd_clear();
; 0000 03AA         lcd_gotoxy(0,0);
; 0000 03AB         lcd_putsf("errorA");
; 0000 03AC         delay_ms(1000);
; 0000 03AD     } */
; 0000 03AE  }
_0x17E:
	RJMP _0x169
; 0000 03AF }
_0x17F:
	RJMP _0x17F

	.DSEG
_0x178:
	.BYTE 0xE

	.CSEG
_ftoa:
	RCALL SUBOPT_0x30
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	RCALL __SAVELOCR2
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x200000D
	RCALL SUBOPT_0x45
	__POINTW2FN _0x2000000,0
	RCALL _strcpyf
	RJMP _0x2100009
_0x200000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x200000C
	RCALL SUBOPT_0x45
	__POINTW2FN _0x2000000,1
	RCALL _strcpyf
	RJMP _0x2100009
_0x200000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x200000F
	RCALL SUBOPT_0x46
	RCALL __ANEGF1
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x48
	LDI  R30,LOW(45)
	ST   X,R30
_0x200000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2000010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2000010:
	LDD  R17,Y+8
_0x2000011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000013
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x4B
	RJMP _0x2000011
_0x2000013:
	RCALL SUBOPT_0x4C
	RCALL __ADDF12
	RCALL SUBOPT_0x47
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x4B
_0x2000014:
	RCALL SUBOPT_0x4C
	RCALL __CMPF12
	BRLO _0x2000016
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x4D
	RCALL SUBOPT_0x4B
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2000017
	RCALL SUBOPT_0x45
	__POINTW2FN _0x2000000,5
	RCALL _strcpyf
	RJMP _0x2100009
_0x2000017:
	RJMP _0x2000014
_0x2000016:
	CPI  R17,0
	BRNE _0x2000018
	RCALL SUBOPT_0x48
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2000019
_0x2000018:
_0x200001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001C
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x4A
	__GETD2N 0x3F000000
	RCALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL _floor
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x4C
	RCALL __DIVF21
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x48
	RCALL SUBOPT_0x4E
	RCALL SUBOPT_0x49
	RCALL __CWD1
	RCALL __CDF1
	RCALL __MULF12
	RCALL SUBOPT_0x4F
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x47
	RJMP _0x200001A
_0x200001C:
_0x2000019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x2100008
	RCALL SUBOPT_0x48
	LDI  R30,LOW(46)
	ST   X,R30
_0x200001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2000020
	RCALL SUBOPT_0x4F
	RCALL SUBOPT_0x4D
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x46
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x48
	RCALL SUBOPT_0x4E
	RCALL SUBOPT_0x4F
	RCALL __CWD1
	RCALL __CDF1
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x47
	RJMP _0x200001E
_0x2000020:
_0x2100008:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2100009:
	RCALL __LOADLOCR2
	ADIW R28,13
	RET

	.DSEG

	.CSEG

	.CSEG
_rtc_read:
	ST   -Y,R26
	ST   -Y,R17
	RCALL SUBOPT_0x50
	RCALL SUBOPT_0x51
	LDI  R26,LOW(0)
	RCALL _i2c_read
	MOV  R17,R30
	RCALL _i2c_stop
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x2100007
_rtc_write:
	ST   -Y,R26
	RCALL SUBOPT_0x50
	LD   R26,Y
	RCALL SUBOPT_0x52
	RJMP _0x2100007
_rtc_init:
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2020003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2020003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2020004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2020004:
	RCALL SUBOPT_0x53
	LDI  R26,LOW(7)
	RCALL _i2c_write
	LDD  R26,Y+2
	RCALL SUBOPT_0x52
	RJMP _0x2100006
_rtc_get_time:
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x53
	LDI  R26,LOW(0)
	RCALL _i2c_write
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x54
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x55
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	RCALL _i2c_stop
	ADIW R28,6
	RET
_rtc_set_time:
	ST   -Y,R26
	RCALL SUBOPT_0x53
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x56
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x58
	RCALL SUBOPT_0x52
	RJMP _0x2100006
_rtc_get_date:
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x53
	LDI  R26,LOW(3)
	RCALL _i2c_write
	RCALL SUBOPT_0x51
	LDI  R26,LOW(1)
	RCALL _i2c_read
	RCALL SUBOPT_0x59
	ST   X,R30
	RCALL SUBOPT_0x54
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x55
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RCALL _i2c_stop
	ADIW R28,8
	RET
_rtc_set_date:
	ST   -Y,R26
	RCALL SUBOPT_0x53
	LDI  R26,LOW(3)
	RCALL _i2c_write
	LDD  R26,Y+3
	RCALL SUBOPT_0x58
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x56
	RCALL SUBOPT_0x52
	RJMP _0x2100001
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G102:
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2040004
	SBI  0x18,1
	RJMP _0x2040005
_0x2040004:
	CBI  0x18,1
_0x2040005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2040006
	SBI  0x18,2
	RJMP _0x2040007
_0x2040006:
	CBI  0x18,2
_0x2040007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2040008
	SBI  0x18,3
	RJMP _0x2040009
_0x2040008:
	CBI  0x18,3
_0x2040009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x204000A
	SBI  0x18,4
	RJMP _0x204000B
_0x204000A:
	CBI  0x18,4
_0x204000B:
	__DELAY_USB 5
	SBI  0x18,5
	__DELAY_USB 13
	CBI  0x18,5
	__DELAY_USB 13
	RJMP _0x2100005
__lcd_write_data:
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
	__DELAY_USB 133
	RJMP _0x2100005
_lcd_write_byte:
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL __lcd_write_data
	RCALL SUBOPT_0x5A
	RJMP _0x2100007
_lcd_gotoxy:
	ST   -Y,R26
	RCALL SUBOPT_0x16
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2100007:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x19
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x19
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2040010
_0x2040011:
	RCALL SUBOPT_0x41
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2040013
	RJMP _0x2100005
_0x2040013:
_0x2040010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	RCALL SUBOPT_0x5A
	RJMP _0x2100005
_lcd_puts:
	RCALL SUBOPT_0x30
	ST   -Y,R17
_0x2040014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2040014
_0x2040016:
	LDD  R17,Y+0
_0x2100006:
	ADIW R28,3
	RET
_lcd_init:
	ST   -Y,R26
	SBI  0x17,1
	SBI  0x17,2
	SBI  0x17,3
	SBI  0x17,4
	SBI  0x17,5
	SBI  0x17,7
	SBI  0x17,6
	CBI  0x18,5
	CBI  0x18,7
	CBI  0x18,6
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	LDI  R26,LOW(20)
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x5B
	RCALL SUBOPT_0x5B
	RCALL SUBOPT_0x5B
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2100005:
	ADIW R28,1
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G103:
	RCALL SUBOPT_0x30
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x5C
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2060010
	RCALL SUBOPT_0x5C
	RCALL SUBOPT_0x5D
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2060012
	__CPWRN 16,17,2
	BRLO _0x2060013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2060012:
	RCALL SUBOPT_0x5C
	ADIW R26,2
	RCALL SUBOPT_0x5E
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	RCALL SUBOPT_0x5C
	RCALL __GETW1P
	TST  R31
	BRMI _0x2060014
	RCALL SUBOPT_0x5C
	RCALL SUBOPT_0x5E
_0x2060014:
_0x2060013:
	RJMP _0x2060015
_0x2060010:
	RCALL SUBOPT_0x5C
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2060015:
_0x2100004:
	RCALL __LOADLOCR2
_0x2100003:
	ADIW R28,5
	RET
__print_G103:
	RCALL SUBOPT_0x30
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL SUBOPT_0x34
_0x2060016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2060018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x206001C
	CPI  R18,37
	BRNE _0x206001D
	LDI  R17,LOW(1)
	RJMP _0x206001E
_0x206001D:
	RCALL SUBOPT_0x5F
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	RCALL SUBOPT_0x5F
	RJMP _0x20600C9
_0x2060020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2060021
	LDI  R16,LOW(1)
	RJMP _0x206001B
_0x2060021:
	CPI  R18,43
	BRNE _0x2060022
	LDI  R20,LOW(43)
	RJMP _0x206001B
_0x2060022:
	CPI  R18,32
	BRNE _0x2060023
	LDI  R20,LOW(32)
	RJMP _0x206001B
_0x2060023:
	RJMP _0x2060024
_0x206001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2060025
_0x2060024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2060026
	ORI  R16,LOW(128)
	RJMP _0x206001B
_0x2060026:
	RJMP _0x2060027
_0x2060025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x206001B
_0x2060027:
	CPI  R18,48
	BRLO _0x206002A
	CPI  R18,58
	BRLO _0x206002B
_0x206002A:
	RJMP _0x2060029
_0x206002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x206001B
_0x2060029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x206002F
	RCALL SUBOPT_0x60
	RCALL SUBOPT_0x61
	RCALL SUBOPT_0x60
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x62
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	RCALL SUBOPT_0x63
	RCALL SUBOPT_0x64
	STD  Y+6,R30
	STD  Y+6+1,R31
	RCALL SUBOPT_0x59
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	RCALL SUBOPT_0x63
	RCALL SUBOPT_0x64
	RCALL SUBOPT_0x65
	RCALL SUBOPT_0x59
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2060033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2060036
_0x2060035:
	CPI  R30,LOW(0x64)
	BREQ _0x2060039
	CPI  R30,LOW(0x69)
	BRNE _0x206003A
_0x2060039:
	ORI  R16,LOW(4)
	RJMP _0x206003B
_0x206003A:
	CPI  R30,LOW(0x75)
	BRNE _0x206003C
_0x206003B:
	LDI  R30,LOW(_tbl10_G103*2)
	LDI  R31,HIGH(_tbl10_G103*2)
	RCALL SUBOPT_0x65
	LDI  R17,LOW(5)
	RJMP _0x206003D
_0x206003C:
	CPI  R30,LOW(0x58)
	BRNE _0x206003F
	ORI  R16,LOW(8)
	RJMP _0x2060040
_0x206003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2060071
_0x2060040:
	LDI  R30,LOW(_tbl16_G103*2)
	LDI  R31,HIGH(_tbl16_G103*2)
	RCALL SUBOPT_0x65
	LDI  R17,LOW(4)
_0x206003D:
	SBRS R16,2
	RJMP _0x2060042
	RCALL SUBOPT_0x63
	RCALL SUBOPT_0x64
	RCALL SUBOPT_0x66
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2060043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x66
	LDI  R20,LOW(45)
_0x2060043:
	CPI  R20,0
	BREQ _0x2060044
	SUBI R17,-LOW(1)
	RJMP _0x2060045
_0x2060044:
	ANDI R16,LOW(251)
_0x2060045:
	RJMP _0x2060046
_0x2060042:
	RCALL SUBOPT_0x63
	RCALL SUBOPT_0x64
	RCALL SUBOPT_0x66
_0x2060046:
_0x2060036:
	SBRC R16,0
	RJMP _0x2060047
_0x2060048:
	CP   R17,R21
	BRSH _0x206004A
	SBRS R16,7
	RJMP _0x206004B
	SBRS R16,2
	RJMP _0x206004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x206004D
_0x206004C:
	LDI  R18,LOW(48)
_0x206004D:
	RJMP _0x206004E
_0x206004B:
	LDI  R18,LOW(32)
_0x206004E:
	RCALL SUBOPT_0x5F
	SUBI R21,LOW(1)
	RJMP _0x2060048
_0x206004A:
_0x2060047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x206004F
_0x2060050:
	CPI  R19,0
	BREQ _0x2060052
	SBRS R16,3
	RJMP _0x2060053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x65
	RJMP _0x2060054
_0x2060053:
	RCALL SUBOPT_0x59
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2060054:
	RCALL SUBOPT_0x5F
	CPI  R21,0
	BREQ _0x2060055
	SUBI R21,LOW(1)
_0x2060055:
	SUBI R19,LOW(1)
	RJMP _0x2060050
_0x2060052:
	RJMP _0x2060056
_0x206004F:
_0x2060058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x65
_0x206005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x206005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x66
	RJMP _0x206005A
_0x206005C:
	CPI  R18,58
	BRLO _0x206005D
	SBRS R16,3
	RJMP _0x206005E
	SUBI R18,-LOW(7)
	RJMP _0x206005F
_0x206005E:
	SUBI R18,-LOW(39)
_0x206005F:
_0x206005D:
	SBRC R16,4
	RJMP _0x2060061
	CPI  R18,49
	BRSH _0x2060063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2060062
_0x2060063:
	RJMP _0x20600CA
_0x2060062:
	CP   R21,R19
	BRLO _0x2060067
	SBRS R16,0
	RJMP _0x2060068
_0x2060067:
	RJMP _0x2060066
_0x2060068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2060069
	LDI  R18,LOW(48)
_0x20600CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x206006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x62
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	RCALL SUBOPT_0x5F
	CPI  R21,0
	BREQ _0x206006C
	SUBI R21,LOW(1)
_0x206006C:
_0x2060066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2060059
	RJMP _0x2060058
_0x2060059:
_0x2060056:
	SBRS R16,0
	RJMP _0x206006D
_0x206006E:
	CPI  R21,0
	BREQ _0x2060070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x62
	RJMP _0x206006E
_0x2060070:
_0x206006D:
_0x2060071:
_0x2060030:
_0x20600C9:
	LDI  R17,LOW(0)
_0x206001B:
	RJMP _0x2060016
_0x2060018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x67
	SBIW R30,0
	BRNE _0x2060072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2100002
_0x2060072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x67
	RCALL SUBOPT_0x65
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x3
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G103)
	LDI  R31,HIGH(_put_buff_G103)
	RCALL SUBOPT_0x3
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G103
	MOVW R18,R30
	RCALL SUBOPT_0x59
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2100002:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG

	.CSEG
_ftrunc:
	RCALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	RCALL __PUTPARD2
	RCALL __GETD2S0
	RCALL _ftrunc
	RCALL __PUTD1S0
    brne __floor1
__floor0:
	RCALL SUBOPT_0x44
	RJMP _0x2100001
__floor1:
    brtc __floor0
	RCALL SUBOPT_0x44
	__GETD2N 0x3F800000
	RCALL __SUBF12
_0x2100001:
	ADIW R28,4
	RET

	.CSEG
_strcpyf:
	RCALL SUBOPT_0x30
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
_strlen:
	RCALL SUBOPT_0x30
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
	RCALL SUBOPT_0x30
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG
_bcd2bin:
	ST   -Y,R26
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
_bin2bcd:
	ST   -Y,R26
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret

	.DSEG
_strr:
	.BYTE 0x4
_week_day:
	.BYTE 0x1
_miladimonth:
	.BYTE 0xC
_shamsimonth:
	.BYTE 0xC
__seed_G100:
	.BYTE 0x4
__base_y_G102:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(8)
	RJMP _rtc_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	LDS  R26,_week_day
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x2:
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDS  R30,_week_day
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:79 WORDS
SUBOPT_0x5:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(5)
	RCALL _lcd_putchar
	LDI  R26,LOW(4)
	RCALL _lcd_putchar
	LDI  R26,LOW(3)
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x7:
	MOVW R26,R28
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	RCALL _lcd_puts
	LDI  R26,LOW(50)
	LDI  R27,0
	RCALL _delay_ms
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(1)
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(50)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(0)
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
	LDD  R30,Y+4
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	RCALL SUBOPT_0x3
	MOV  R30,R8
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	MOV  R30,R13
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	MOV  R30,R12
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x12:
	LDI  R24,12
	RCALL _sprintf
	ADIW R28,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0x3
	MOV  R30,R9
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	MOV  R30,R6
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	MOV  R30,R7
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	RCALL __MODW21
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	MOVW R26,R22
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x19:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	RCALL _lcd_puts
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	RCALL _lcd_puts
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1D:
	LDI  R26,0
	SBIS 0x13,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1E:
	LDI  R26,0
	SBIS 0x13,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1F:
	LDI  R26,0
	SBIS 0x13,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x20:
	LDI  R26,0
	SBIS 0x10,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	CLT
	BLD  R15,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL SUBOPT_0x3
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(12)
	LDI  R27,HIGH(12)
	RJMP _rtc_get_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x23:
	MOV  R26,R17
	RJMP _timesetshow

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x24:
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x25:
	LDI  R26,LOW(700)
	LDI  R27,HIGH(700)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	LDI  R26,LOW(130)
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	RCALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(8)
	ST   -Y,R30
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
	LDI  R30,LOW(_week_day)
	LDI  R31,HIGH(_week_day)
	RCALL SUBOPT_0x3
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RCALL SUBOPT_0x3
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	RJMP _rtc_get_date

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2B:
	MOV  R26,R17
	RJMP _datesetshow

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2C:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	LDI  R26,LOW(100)
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2E:
	INC  R7
	MOV  R30,R6
	LDI  R31,0
	SUBI R30,LOW(-_miladimonth)
	SBCI R31,HIGH(-_miladimonth)
	LD   R30,Z
	CP   R30,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	RCALL SUBOPT_0x4
	SUBI R30,-LOW(1)
	STS  _week_day,R30
	RCALL SUBOPT_0x1
	CPI  R26,LOW(0x8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x30:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(0)
	STD  Y+6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x32:
	LDD  R30,Y+6
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,7
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x33:
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x35:
	LDD  R30,Y+6
	SUBI R30,-LOW(1)
	STD  Y+6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(0)
	__PUTB1SX 87
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x37:
	__GETB2SX 87
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x38:
	MOVW R26,R28
	SUBI R26,LOW(-(87))
	SBCI R27,HIGH(-(87))
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
	__DELAY_USB 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x39:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3A:
	RCALL SUBOPT_0x33
	RCALL __GETW1P
	SBIW R30,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	LDD  R30,Y+6
	RJMP SUBOPT_0x39

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3C:
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL __LSLW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3D:
	MOVW R26,R28
	ADIW R26,7
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0x3A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x3E:
	RCALL __CWD1
	RCALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41200000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3F:
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x40:
	MOV  R30,R17
	RCALL SUBOPT_0x39
	SUBI R30,LOW(-_shamsimonth)
	SBCI R31,HIGH(-_shamsimonth)
	LD   R26,Z
	RCALL SUBOPT_0x3F
	__SUBWRR 20,21,26,27
	INC  R5
	SUBI R17,-1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x41:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _rtc_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x43:
	MOVW R30,R28
	ADIW R30,8
	RCALL SUBOPT_0x3
	__POINTW1FN _0x0,641
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x44:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x45:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	__GETD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x47:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x48:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x49:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4A:
	__GETD1N 0x3DCCCCCD
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4B:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x4C:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4D:
	__GETD1N 0x41200000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4E:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RJMP SUBOPT_0x39

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4F:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x50:
	RCALL _i2c_start
	LDI  R26,LOW(208)
	RCALL _i2c_write
	LDD  R26,Y+1
	RJMP _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x51:
	RCALL _i2c_stop
	RCALL _i2c_start
	LDI  R26,LOW(209)
	RJMP _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x52:
	RCALL _i2c_write
	RJMP _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x53:
	RCALL _i2c_start
	LDI  R26,LOW(208)
	RJMP _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x54:
	LDI  R26,LOW(1)
	RCALL _i2c_read
	MOV  R26,R30
	RJMP _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x55:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	RCALL _i2c_read
	MOV  R26,R30
	RJMP _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x56:
	RCALL _i2c_write
	LD   R26,Y
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x57:
	RCALL _i2c_write
	LDD  R26,Y+1
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x58:
	RCALL _i2c_write
	LDD  R26,Y+2
	RCALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x59:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5A:
	SBI  0x18,7
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x5B:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5C:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5D:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5E:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x5F:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x60:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x61:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x62:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	RCALL SUBOPT_0x60
	RJMP SUBOPT_0x61

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x64:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x5D

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x65:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x66:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x67:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET


	.CSEG
	.equ __sda_bit=1
	.equ __scl_bit=0
	.equ __i2c_port=0x12 ;PORTD
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
