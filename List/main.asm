
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 10.000000 MHz
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
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _lcd_enabled=R4
	.DEF _rc=R6
	.DEF _i=R8
	.DEF _motorSpeed=R10
	.DEF _motorSpeed1=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x1
_0x4:
	.DB  0x1
_0x66:
	.DB  0x0,0x0
_0x0:
	.DB  0x25,0x64,0x0,0x42,0x55,0x47,0x20,0x6F
	.DB  0x6E,0x3A,0x20,0x0,0x64,0x6F,0x6E,0x65
	.DB  0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2040003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _workingSensors
	.DW  _0x3*2

	.DW  0x01
	.DW  _sensors
	.DW  _0x4*2

	.DW  0x09
	.DW  _0x1C
	.DW  _0x0*2+3

	.DW  0x02
	.DW  0x04
	.DW  _0x66*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;Project : AMOS Robocup Junior Soccer 2013
;Version : 3
;Date    : 3/17/2013
;Author  : Miro Markarian and AMOS team
;Company : AMOS
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 10.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;// I2C Bus functions
;#asm
   .equ __i2c_port=0x18 ;PORTB
   .equ __sda_bit=0
   .equ __scl_bit=1
; 0000 0019 #endasm
;#include <i2c.h>
;#include <delay.h>
;#include <stdlib.h>
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;
;// Declare your global variables here
;
;#define cmpbus 0xC0
;#define RDC_FOR_MAXON 0.6
;
;/* MUX ADDRESS */
;#define MUXA PORTA.6
;#define MUXB PORTA.7
;#define MUXC PORTD.6
;#define MUXD PORTD.7
;
;/* MUX OUT */
;#define MUXOA PINA.4
;#define MUXOB PINA.5
;
;
;/* MUX PINS*/
;#define LCD 9
;#define STRICT 10
;
;/* Switches varibles */
;int lcd_enabled = 0;
;//int strict_set = 0;
;
;/* Define function prototypes so we can use this functions globally */
;int init_robot();
;void write_int(int x, int y, int value);
;int init_sensors();
;void init_switches();
;void bug(int error);
;void checksensors();
;float getMovement();
;void set_muxs(int pin);
;void goforIt(int m1, int m2, int m3);
;void spinSpeed(int devidedValue, int addedValue, int correction);
;void init_compass();
;int calc_degree(int a);
;void compass_calib();
;unsigned char readcmp();
;void motor(int a, int b, int c);
;
;/* Define global variables */
;
;int rc; // Return Condition
;int workingSensors[18] = {1}; // Working Sensors Array

	.DSEG
;int sensors[18] = {1}; // Sensor Values Array
;int i; // For loop iterator
;char str[4];
;float move,sss;
;int motorSpeed;
;int motorSpeed1;
;int motorSpeed2;
;int motorSpeed3;
;int compass;
;eeprom int start_point;
;
;void main(void)
; 0000 0059 {

	.CSEG
_main:
; 0000 005A // Declare your local variables here
; 0000 005B 
; 0000 005C // Input/Output Ports initialization
; 0000 005D // Port A initialization
; 0000 005E // Func7=Out Func6=Out Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 005F // State7=0 State6=0 State5=P State4=P State3=T State2=T State1=T State0=T
; 0000 0060 PORTA=0x30;
	LDI  R30,LOW(48)
	OUT  0x1B,R30
; 0000 0061 DDRA=0xC0;
	LDI  R30,LOW(192)
	OUT  0x1A,R30
; 0000 0062 
; 0000 0063 // Port B initialization
; 0000 0064 // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=In Func0=In
; 0000 0065 // State7=T State6=T State5=T State4=T State3=0 State2=0 State1=T State0=T
; 0000 0066 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0067 DDRB=0x0C;
	LDI  R30,LOW(12)
	OUT  0x17,R30
; 0000 0068 
; 0000 0069 // Port C initialization
; 0000 006A // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=In Func1=In Func0=In
; 0000 006B // State7=T State6=T State5=T State4=T State3=1 State2=T State1=T State0=T
; 0000 006C PORTC=0x08;
	LDI  R30,LOW(8)
	OUT  0x15,R30
; 0000 006D DDRC=0x08;
	OUT  0x14,R30
; 0000 006E 
; 0000 006F // Port D initialization
; 0000 0070 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In
; 0000 0071 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=T State0=T
; 0000 0072 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0073 DDRD=0xFC;
	LDI  R30,LOW(252)
	OUT  0x11,R30
; 0000 0074 
; 0000 0075 // Timer/Counter 0 initialization
; 0000 0076 // Clock source: System Clock
; 0000 0077 // Clock value: 1250.000 kHz
; 0000 0078 // Mode: Fast PWM top=0xFF
; 0000 0079 // OC0 output: Non-Inverted PWM
; 0000 007A TCCR0=0x6A;
	LDI  R30,LOW(106)
	OUT  0x33,R30
; 0000 007B TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 007C OCR0=0x00;
	OUT  0x3C,R30
; 0000 007D 
; 0000 007E // Timer/Counter 1 initialization
; 0000 007F // Clock source: System Clock
; 0000 0080 // Clock value: 1250.000 kHz
; 0000 0081 // Mode: Fast PWM top=0x00FF
; 0000 0082 // OC1A output: Non-Inv.
; 0000 0083 // OC1B output: Non-Inv.
; 0000 0084 // Noise Canceler: Off
; 0000 0085 // Input Capture on Falling Edge
; 0000 0086 // Timer1 Overflow Interrupt: Off
; 0000 0087 // Input Capture Interrupt: Off
; 0000 0088 // Compare A Match Interrupt: Off
; 0000 0089 // Compare B Match Interrupt: Off
; 0000 008A TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 008B TCCR1B=0x0A;
	LDI  R30,LOW(10)
	OUT  0x2E,R30
; 0000 008C TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 008D TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 008E ICR1H=0x00;
	OUT  0x27,R30
; 0000 008F ICR1L=0x00;
	OUT  0x26,R30
; 0000 0090 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0091 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0092 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0093 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0094 
; 0000 0095 // Timer/Counter 2 initialization
; 0000 0096 // Clock source: System Clock
; 0000 0097 // Clock value: Timer2 Stopped
; 0000 0098 // Mode: Normal top=0xFF
; 0000 0099 // OC2 output: Disconnected
; 0000 009A ASSR=0x00;
	OUT  0x22,R30
; 0000 009B TCCR2=0x00;
	OUT  0x25,R30
; 0000 009C TCNT2=0x00;
	OUT  0x24,R30
; 0000 009D OCR2=0x00;
	OUT  0x23,R30
; 0000 009E 
; 0000 009F // External Interrupt(s) initialization
; 0000 00A0 // INT0: Off
; 0000 00A1 // INT1: Off
; 0000 00A2 // INT2: Off
; 0000 00A3 MCUCR=0x00;
	OUT  0x35,R30
; 0000 00A4 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 00A5 
; 0000 00A6 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00A7 TIMSK=0x00;
	OUT  0x39,R30
; 0000 00A8 
; 0000 00A9 // USART initialization
; 0000 00AA // USART disabled
; 0000 00AB UCSRB=0x00;
	OUT  0xA,R30
; 0000 00AC 
; 0000 00AD // Analog Comparator initialization
; 0000 00AE // Analog Comparator: Off
; 0000 00AF // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00B0 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00B1 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00B2 
; 0000 00B3 // ADC initialization
; 0000 00B4 // ADC disabled
; 0000 00B5 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 00B6 
; 0000 00B7 // SPI initialization
; 0000 00B8 // SPI disabled
; 0000 00B9 SPCR=0x00;
	OUT  0xD,R30
; 0000 00BA 
; 0000 00BB // TWI initialization
; 0000 00BC // TWI disabled
; 0000 00BD TWCR=0x00;
	OUT  0x36,R30
; 0000 00BE 
; 0000 00BF // I2C Bus initialization
; 0000 00C0 i2c_init();
	CALL _i2c_init
; 0000 00C1 
; 0000 00C2 // Alphanumeric LCD initialization
; 0000 00C3 // Connections specified in the
; 0000 00C4 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00C5 // RS - PORTC Bit 0
; 0000 00C6 // RD - PORTC Bit 1
; 0000 00C7 // EN - PORTC Bit 2
; 0000 00C8 // D4 - PORTC Bit 4
; 0000 00C9 // D5 - PORTC Bit 5
; 0000 00CA // D6 - PORTC Bit 6
; 0000 00CB // D7 - PORTC Bit 7
; 0000 00CC // Characters/line: 16
; 0000 00CD rc = init_robot();
	RCALL _init_robot
	MOVW R6,R30
; 0000 00CE if(rc) bug(rc);
	MOV  R0,R6
	OR   R0,R7
	BREQ _0x5
	ST   -Y,R7
	ST   -Y,R6
	CALL _bug
; 0000 00CF lcd_init(16);
_0x5:
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 00D0 for(i=0;i<18;i++) sensors[i] = 1;
	CLR  R8
	CLR  R9
_0x7:
	CALL SUBOPT_0x0
	BRGE _0x8
	CALL SUBOPT_0x1
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x7
_0x8:
; 0000 00D1 for(i=0;i<18;i++) workingSensors[i] = 1;
	CLR  R8
	CLR  R9
_0xA:
	CALL SUBOPT_0x0
	BRGE _0xB
	CALL SUBOPT_0x2
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0xA
_0xB:
; 0000 00D2 while (1)
_0xC:
; 0000 00D3       {
; 0000 00D4         //set_muxs(15);
; 0000 00D5         //delay_us(1);
; 0000 00D6         //if(MUXOB == 0) compass_calib();
; 0000 00D7         //init_compass();
; 0000 00D8         checksensors();
	CALL _checksensors
; 0000 00D9 //        move = getMovement();
; 0000 00DA //        if(move == 0) goforIt(-255,0,255); else
; 0000 00DB //        if(move == 0.5) goforIt(-208,-46,255); else
; 0000 00DC //        if(move == 1) goforIt(-165,-88,255); else
; 0000 00DD //        if(move == 1.5) goforIt(-127,-127,255); else
; 0000 00DE //        if(move == 2) goforIt(-88,-165,255); else
; 0000 00DF //        if(move == 2.5) goforIt(-46,-208,255); else
; 0000 00E0 //        if(move == 3) goforIt(0,-255,255); else
; 0000 00E1 //        if(move == 3.5) goforIt(46,-255,208); else
; 0000 00E2 //        if(move == 4) goforIt(88,-255,165); else
; 0000 00E3 //        if(move == 4.5) goforIt(127,-255,127); else
; 0000 00E4 //        if(move == 5) goforIt(165,-255,88); else
; 0000 00E5 //        if(move == 5.5) goforIt(208,-255,46); else
; 0000 00E6 //        if(move == 6) goforIt(255,-255,0); else
; 0000 00E7 //        if(move == 6.5) goforIt(255,-208,-46); else
; 0000 00E8 //        if(move == 7) goforIt(255,-165,-88); else
; 0000 00E9 //        if(move == 7.5) goforIt(255,-127,-127); else
; 0000 00EA //        if(move == 8) goforIt(255,-88,-165); else
; 0000 00EB //        if(move == 8.5) goforIt(255,-46,-208); else
; 0000 00EC //        if(move == 9) goforIt(255,0,-255); else
; 0000 00ED //        if(move == 9.5) goforIt(208,46,-255); else
; 0000 00EE //        if(move == 10) goforIt(165,88,-255); else
; 0000 00EF //        if(move == 10.5) goforIt(127,127,-255); else
; 0000 00F0 //        if(move == 11) goforIt(88,165,-255); else
; 0000 00F1 //        if(move == 11.5) goforIt(46,208,-255); else
; 0000 00F2 //        if(move == 12) goforIt(0,255,-255); else
; 0000 00F3 //        if(move == 12.5) goforIt(-46,255,-208); else
; 0000 00F4 //        if(move == 13) goforIt(-88,255,-165); else
; 0000 00F5 //        if(move == 13.5) goforIt(-127,255,-127); else
; 0000 00F6 //        if(move == 14) goforIt(-165,255,-88); else
; 0000 00F7 //        if(move == 14.5) goforIt(-208,255,-46); else
; 0000 00F8 //        if(move == 15) goforIt(-255,255,0); else
; 0000 00F9 //        if(move == 15.5) goforIt(-255,208,46); else
; 0000 00FA //        if(move == 16) goforIt(-255,165,88); else
; 0000 00FB //        if(move == 16.5) goforIt(-255,127,127); else
; 0000 00FC //        if(move == 17) goforIt(-255,88,165); else
; 0000 00FD //        if(move == 17.5) goforIt(-255,46,208);
; 0000 00FE //        motor(-motorSpeed1,-motorSpeed2,-motorSpeed3);
; 0000 00FF       }
	RJMP _0xC
; 0000 0100 }
_0xF:
	RJMP _0xF
;void write_int(int x, int y, int value) {
; 0000 0101 void write_int(int x, int y, int value) {
; 0000 0102     char s[4];
; 0000 0103     lcd_gotoxy(x,y);
;	x -> Y+8
;	y -> Y+6
;	value -> Y+4
;	s -> Y+0
; 0000 0104     sprintf(s, "%d", value);
; 0000 0105     lcd_puts(s);
; 0000 0106 }
;int init_robot() {
; 0000 0107 int init_robot() {
_init_robot:
; 0000 0108     init_switches();
	CALL _init_switches
; 0000 0109     if(lcd_enabled) lcd_init(16);
	MOV  R0,R4
	OR   R0,R5
	BREQ _0x10
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 010A     rc = init_sensors();
_0x10:
	CALL _init_sensors
	MOVW R6,R30
; 0000 010B     if(rc) return rc;
	MOV  R0,R6
	OR   R0,R7
	BREQ _0x11
	MOVW R30,R6
	RET
; 0000 010C     return 0;
_0x11:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET
; 0000 010D }
;void set_muxs(int pin) {
; 0000 010E void set_muxs(int pin) {
_set_muxs:
; 0000 010F     #asm
;	pin -> Y+0
; 0000 0110     LD R30,y
    LD R30,y
; 0000 0111     LD R31,Y
    LD R31,Y
; 0000 0112     ROR R30
    ROR R30
; 0000 0113     ROR R30
    ROR R30
; 0000 0114     ROR R30
    ROR R30
; 0000 0115     EOR R30,R31
    EOR R30,R31
; 0000 0116     ROR R30
    ROR R30
; 0000 0117     BRCS first
    BRCS first
; 0000 0118     ; 0000 006D PORTA.6=0;
    ; 0000 006D PORTA.6=0;
; 0000 0119         CBI  0x1B,6
        CBI  0x1B,6
; 0000 011A         JMP next
        JMP next
; 0000 011B     first:
    first:
; 0000 011C     ; 0000 006D PORTA.6=1;
    ; 0000 006D PORTA.6=1;
; 0000 011D         SBI  0x1B,6
        SBI  0x1B,6
; 0000 011E     next:
    next:
; 0000 011F     MOV R30,R31
    MOV R30,R31
; 0000 0120     ROR R30
    ROR R30
; 0000 0121     ROR R30
    ROR R30
; 0000 0122     EOR R30,R31
    EOR R30,R31
; 0000 0123     ROR R30
    ROR R30
; 0000 0124     ROR R30
    ROR R30
; 0000 0125     BRCS second
    BRCS second
; 0000 0126     ; 0000 006D PORTA.7=0;
    ; 0000 006D PORTA.7=0;
; 0000 0127         CBI  0x1B,7
        CBI  0x1B,7
; 0000 0128         JMP nextt
        JMP nextt
; 0000 0129     second:
    second:
; 0000 012A     ; 0000 006D PORTA.7=1;
    ; 0000 006D PORTA.7=1;
; 0000 012B         SBI  0x1B,7
        SBI  0x1B,7
; 0000 012C     nextt:
    nextt:
; 0000 012D     MOV R30,R31
    MOV R30,R31
; 0000 012E     ROR R30
    ROR R30
; 0000 012F     EOR R30,R31
    EOR R30,R31
; 0000 0130     ROR R30
    ROR R30
; 0000 0131     ROR R30
    ROR R30
; 0000 0132     ROR R30
    ROR R30
; 0000 0133     BRCS third
    BRCS third
; 0000 0134     ; 0000 006D PORTD.6=0;
    ; 0000 006D PORTD.6=0;
; 0000 0135         CBI  0x12,6
        CBI  0x12,6
; 0000 0136         JMP nexttt
        JMP nexttt
; 0000 0137     third:
    third:
; 0000 0138     ; 0000 006D PORTD.6=1;
    ; 0000 006D PORTD.6=1;
; 0000 0139         SBI  0x12,6
        SBI  0x12,6
; 0000 013A     nexttt:
    nexttt:
; 0000 013B     MOV R30,R31
    MOV R30,R31
; 0000 013C     ROR R30
    ROR R30
; 0000 013D     ROR R30
    ROR R30
; 0000 013E     ROR R30
    ROR R30
; 0000 013F     ROR R30
    ROR R30
; 0000 0140     BRCS fourth
    BRCS fourth
; 0000 0141     ; 0000 006D PORTD.7=0;
    ; 0000 006D PORTD.7=0;
; 0000 0142         CBI  0x12,7
        CBI  0x12,7
; 0000 0143         JMP endzz
        JMP endzz
; 0000 0144     fourth:
    fourth:
; 0000 0145     ; 0000 006D PORTD.7=1;
    ; 0000 006D PORTD.7=1;
; 0000 0146         SBI  0x12,7
        SBI  0x12,7
; 0000 0147     endzz:
    endzz:
; 0000 0148     #endasm
; 0000 0149 
; 0000 014A }
	JMP  _0x20C0002
;void init_switches(){
; 0000 014B void init_switches(){
_init_switches:
; 0000 014C     set_muxs(LCD);
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL SUBOPT_0x3
; 0000 014D     lcd_enabled = MUXOB;
	LDI  R30,0
	SBIC 0x19,5
	LDI  R30,1
	MOV  R4,R30
	CLR  R5
; 0000 014E     //set_mux(STRICT);
; 0000 014F     //strict_set = MUXOB;
; 0000 0150 }
	RET
;int init_sensors() {
; 0000 0151 int init_sensors() {
_init_sensors:
; 0000 0152     char sensorHolder;
; 0000 0153     char swtch;
; 0000 0154     for(i=0;i<18;i++) {
	ST   -Y,R17
	ST   -Y,R16
;	sensorHolder -> R17
;	swtch -> R16
	CLR  R8
	CLR  R9
_0x13:
	CALL SUBOPT_0x0
	BRGE _0x14
; 0000 0155         sensorHolder = i;
	MOV  R17,R8
; 0000 0156         if(i>15) {swtch = 1; sensorHolder = sensorHolder-16;} else {swtch = 0;}
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x15
	CALL SUBOPT_0x4
	RJMP _0x16
_0x15:
	LDI  R16,LOW(0)
_0x16:
; 0000 0157         set_muxs(sensorHolder);
	CALL SUBOPT_0x5
; 0000 0158         if((swtch ? MUXOB : MUXOA) == 0) workingSensors[i] = 1;
	CPI  R16,0
	BREQ _0x18
	LDI  R30,0
	SBIC 0x19,5
	LDI  R30,1
	RJMP _0x19
_0x18:
	LDI  R30,0
	SBIC 0x19,4
	LDI  R30,1
_0x19:
	CPI  R30,0
	BRNE _0x17
	CALL SUBOPT_0x2
; 0000 0159     }
_0x17:
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x13
_0x14:
; 0000 015A     return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x20C0003
; 0000 015B }
;void bug(int error) {
; 0000 015C void bug(int error) {
_bug:
; 0000 015D     if(lcd_enabled) {
;	error -> Y+0
	MOV  R0,R4
	OR   R0,R5
	BREQ _0x1B
; 0000 015E         lcd_puts("BUG on: ");
	__POINTW1MN _0x1C,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 015F         lcd_putchar('0' + error);
	LD   R30,Y
	SUBI R30,-LOW(48)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0160     } else {
	RJMP _0x1D
_0x1B:
; 0000 0161         while(1);}
_0x1E:
	RJMP _0x1E
_0x1D:
; 0000 0162 }
	JMP  _0x20C0002

	.DSEG
_0x1C:
	.BYTE 0x9
;void checksensors() {
; 0000 0163 void checksensors() {

	.CSEG
_checksensors:
; 0000 0164     char sensorHolder;
; 0000 0165     char swtch;
; 0000 0166     lcd_gotoxy(0,0);
	ST   -Y,R17
	ST   -Y,R16
;	sensorHolder -> R17
;	swtch -> R16
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0167     for(i=0;i<18;i++) {
	CLR  R8
	CLR  R9
_0x22:
	CALL SUBOPT_0x0
	BRGE _0x23
; 0000 0168         if(workingSensors[i] == 0) sensors[i] = 1; else {
	MOVW R30,R8
	LDI  R26,LOW(_workingSensors)
	LDI  R27,HIGH(_workingSensors)
	CALL SUBOPT_0x6
	CALL __GETW1P
	SBIW R30,0
	BRNE _0x24
	CALL SUBOPT_0x1
	RJMP _0x25
_0x24:
; 0000 0169             sensorHolder = i;
	MOV  R17,R8
; 0000 016A             if(i>15) {swtch = 1; sensorHolder = sensorHolder-16;} else {swtch = 0;}
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x26
	CALL SUBOPT_0x4
	RJMP _0x27
_0x26:
	LDI  R16,LOW(0)
_0x27:
; 0000 016B             set_muxs(sensorHolder);
	CALL SUBOPT_0x5
; 0000 016C             sensors[i] = (swtch ? MUXOB : MUXOA);
	MOVW R30,R8
	LDI  R26,LOW(_sensors)
	LDI  R27,HIGH(_sensors)
	CALL SUBOPT_0x6
	MOV  R30,R16
	LDI  R31,0
	SBIW R30,0
	BREQ _0x28
	LDI  R30,0
	SBIC 0x19,5
	LDI  R30,1
	RJMP _0x60
_0x28:
	LDI  R30,0
	SBIC 0x19,4
	LDI  R30,1
_0x60:
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 016D             lcd_putchar('0' + sensors[i]);
	MOVW R30,R8
	LDI  R26,LOW(_sensors)
	LDI  R27,HIGH(_sensors)
	CALL SUBOPT_0x6
	LD   R30,X
	SUBI R30,-LOW(48)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 016E         }
_0x25:
; 0000 016F     }
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x22
_0x23:
; 0000 0170 
; 0000 0171 }
_0x20C0003:
	LD   R16,Y+
	LD   R17,Y+
	RET
;float getMovement() {
; 0000 0172 float getMovement() {
; 0000 0173     unsigned char left = 0, right = 0, sum = 0, n = 0;
; 0000 0174     float ret = 0.0;
; 0000 0175     for(i=0;i<18;i++) {
;	left -> R17
;	right -> R16
;	sum -> R19
;	n -> R18
;	ret -> Y+4
; 0000 0176         if(sensors[i] == 0) {
; 0000 0177             sum+= i;
; 0000 0178             n++;
; 0000 0179             if(i<5) left++;
; 0000 017A             if(i>13) right++;
; 0000 017B         }
; 0000 017C     }
; 0000 017D     if(left>0 && right >0) sum += (left * 18);
; 0000 017E     if (n)
; 0000 017F         ret = (float) sum/n;
; 0000 0180     else ret = 100.0;
; 0000 0181 
; 0000 0182     if(ret>=18) ret -= 18.0;
; 0000 0183     sss = 10;
; 0000 0184     ftoa (ret,1,str);
; 0000 0185     lcd_gotoxy(5,1);
; 0000 0186     lcd_puts(str);
; 0000 0187     return ret;
; 0000 0188 }
;void goforIt(int m1, int m2, int m3) {
; 0000 0189 void goforIt(int m1, int m2, int m3) {
; 0000 018A     int motors[3];
; 0000 018B     int maxmotor;
; 0000 018C     float maxvalue;
; 0000 018D     motors[0] = m1;
;	m1 -> Y+16
;	m2 -> Y+14
;	m3 -> Y+12
;	motors -> Y+6
;	maxmotor -> R16,R17
;	maxvalue -> Y+2
; 0000 018E     motors[1] = m2;
; 0000 018F     motors[2] = m3;
; 0000 0190     spinSpeed(3,15,10);
; 0000 0191     motors[0] = motors[0] + motorSpeed;
; 0000 0192     motors[1] = motors[1] + motorSpeed;
; 0000 0193     motors[2] = motors[2] + motorSpeed;
; 0000 0194     maxmotor=0;
; 0000 0195     if(abs(motors[maxmotor])<abs(motors[1]))maxmotor=1;
; 0000 0196     if(abs(motors[maxmotor])<abs(motors[2]))maxmotor=2;
; 0000 0197     maxvalue = (float)255/abs(motors[maxmotor]);
; 0000 0198     motors[0] = motors[0] * maxvalue ;
; 0000 0199     motors[1] = motors[1] * maxvalue;
; 0000 019A     motors[2] = motors[2] * maxvalue;
; 0000 019B     motorSpeed1 = motors[0];
; 0000 019C     motorSpeed2 = motors[1];
; 0000 019D     motorSpeed3 = motors[2];
; 0000 019E }
;void spinSpeed(int devidedValue, int addedValue, int correction) {
; 0000 019F void spinSpeed(int devidedValue, int addedValue, int correction) {
; 0000 01A0     if(compass<correction && compass>-correction) {
;	devidedValue -> Y+4
;	addedValue -> Y+2
;	correction -> Y+0
; 0000 01A1         motorSpeed = 0;
; 0000 01A2     } else {
; 0000 01A3         if(compass > 0) {
; 0000 01A4             motorSpeed = (((compass)/(devidedValue) + (addedValue)));
; 0000 01A5         } else {
; 0000 01A6             motorSpeed = (((compass)/(devidedValue) - (addedValue)));
; 0000 01A7         }
; 0000 01A8     }
; 0000 01A9 }
;void init_compass() {
; 0000 01AA void init_compass() {
; 0000 01AB     compass = readcmp();
; 0000 01AC     compass = calc_degree(compass);
; 0000 01AD }
;int calc_degree(int a) {
; 0000 01AE int calc_degree(int a) {
; 0000 01AF    // write_int(0,1,a);
; 0000 01B0     a = a-start_point;
;	a -> Y+0
; 0000 01B1     if(a > 128) {
; 0000 01B2         a = a - 256;
; 0000 01B3     } else if(a < -128) {
; 0000 01B4        a = a + 256;
; 0000 01B5     }
; 0000 01B6     return a;
; 0000 01B7 }
;unsigned char readcmp() {
; 0000 01B8 unsigned char readcmp() {
; 0000 01B9     unsigned char data;
; 0000 01BA     i2c_start();
;	data -> R17
; 0000 01BB     i2c_write(cmpbus);
; 0000 01BC     i2c_write(1);
; 0000 01BD     i2c_start();
; 0000 01BE     i2c_write(cmpbus | 1);
; 0000 01BF     data=i2c_read(0);
; 0000 01C0     i2c_stop();
; 0000 01C1     return data;
; 0000 01C2 }
;void compass_calib(void){
; 0000 01C3 void compass_calib(void){
; 0000 01C4     set_muxs(15);
; 0000 01C5     while (MUXOB == 1);
; 0000 01C6     delay_ms(100);
; 0000 01C7     i2c_start();
; 0000 01C8     i2c_write(cmpbus);
; 0000 01C9     i2c_write(15);
; 0000 01CA     i2c_write(0xff);
; 0000 01CB     i2c_stop();
; 0000 01CC     lcd_clear();
; 0000 01CD     lcd_putsf("done");
; 0000 01CE     delay_ms(500);
; 0000 01CF     lcd_clear();
; 0000 01D0     set_muxs(15);
; 0000 01D1     while (MUXOB == 1);
; 0000 01D2     delay_ms(100);
; 0000 01D3     i2c_start();
; 0000 01D4     i2c_write(cmpbus);
; 0000 01D5     i2c_write(15);
; 0000 01D6     i2c_write(0xff);
; 0000 01D7     i2c_stop();
; 0000 01D8     lcd_clear();
; 0000 01D9     lcd_putsf("done");
; 0000 01DA     delay_ms(500);
; 0000 01DB     lcd_clear();
; 0000 01DC     set_muxs(15);
; 0000 01DD     while (MUXOB == 1);
; 0000 01DE     delay_ms(100);
; 0000 01DF     i2c_start();
; 0000 01E0     i2c_write(cmpbus);
; 0000 01E1     i2c_write(15);
; 0000 01E2     i2c_write(0xff);
; 0000 01E3     i2c_stop();
; 0000 01E4     lcd_clear();
; 0000 01E5     lcd_putsf("done");
; 0000 01E6     delay_ms(500);
; 0000 01E7     lcd_clear();
; 0000 01E8     set_muxs(15);
; 0000 01E9     while (MUXOB == 1);
; 0000 01EA     delay_ms(100);
; 0000 01EB     i2c_start();
; 0000 01EC     i2c_write(cmpbus);
; 0000 01ED     i2c_write(15);
; 0000 01EE     i2c_write(0xff);
; 0000 01EF     i2c_stop();
; 0000 01F0     lcd_clear();
; 0000 01F1     lcd_putsf("done");
; 0000 01F2     delay_ms(500);
; 0000 01F3     lcd_clear();
; 0000 01F4 }
;///////////--------------------------- Motor Function ------------------------------///////////
;void motor(int a, int b, int c) {
; 0000 01F6 void motor(int a, int b, int c) {
; 0000 01F7     a = a*RDC_FOR_MAXON;
;	a -> Y+4
;	b -> Y+2
;	c -> Y+0
; 0000 01F8     b = b*RDC_FOR_MAXON;
; 0000 01F9     c = c*RDC_FOR_MAXON;
; 0000 01FA     if(a>0) {
; 0000 01FB         PORTB.2 = 0;
; 0000 01FC         OCR0 = a;
; 0000 01FD     } else {
; 0000 01FE         PORTB.2 = 1;
; 0000 01FF         a = a + 255;
; 0000 0200         OCR0 = a;
; 0000 0201     }
; 0000 0202     if(c>0) {
; 0000 0203         PORTD.2 = 0;
; 0000 0204         OCR1B = c;
; 0000 0205     } else {
; 0000 0206         PORTD.2 = 1;
; 0000 0207         c = c + 255;
; 0000 0208         OCR1B = c;
; 0000 0209     }
; 0000 020A     if(b>0) {
; 0000 020B         PORTD.3 = 0;
; 0000 020C         OCR1A = b;
; 0000 020D     } else {
; 0000 020E         PORTD.3 = 1;
; 0000 020F         b = b + 255;
; 0000 0210         OCR1A = b;
; 0000 0211     }
; 0000 0212 }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G102:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2040004
	SBI  0x15,4
	RJMP _0x2040005
_0x2040004:
	CBI  0x15,4
_0x2040005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2040006
	SBI  0x15,5
	RJMP _0x2040007
_0x2040006:
	CBI  0x15,5
_0x2040007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2040008
	SBI  0x15,6
	RJMP _0x2040009
_0x2040008:
	CBI  0x15,6
_0x2040009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x204000A
	SBI  0x15,7
	RJMP _0x204000B
_0x204000A:
	CBI  0x15,7
_0x204000B:
	__DELAY_USB 7
	SBI  0x15,2
	__DELAY_USB 17
	CBI  0x15,2
	__DELAY_USB 17
	RJMP _0x20C0001
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G102
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G102
	__DELAY_USB 167
	RJMP _0x20C0001
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x20C0002:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0x7
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x7
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2040010
_0x2040011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2040013
	RJMP _0x20C0001
_0x2040013:
_0x2040010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x20C0001
_lcd_puts:
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
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2040014
_0x2040016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x14,4
	SBI  0x14,5
	SBI  0x14,6
	SBI  0x14,7
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CALL SUBOPT_0x8
	CALL SUBOPT_0x8
	CALL SUBOPT_0x8
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 250
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_workingSensors:
	.BYTE 0x24
_sensors:
	.BYTE 0x24
_str:
	.BYTE 0x4
_sss:
	.BYTE 0x4
_motorSpeed2:
	.BYTE 0x2
_motorSpeed3:
	.BYTE 0x2
_compass:
	.BYTE 0x2

	.ESEG
_start_point:
	.BYTE 0x2

	.DSEG
__seed_G101:
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
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CP   R8,R30
	CPC  R9,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	MOVW R30,R8
	LDI  R26,LOW(_sensors)
	LDI  R27,HIGH(_sensors)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	MOVW R30,R8
	LDI  R26,LOW(_workingSensors)
	LDI  R27,HIGH(_workingSensors)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _set_muxs

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDI  R16,LOW(1)
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,16
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	MOV  R30,R17
	LDI  R31,0
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G102
	__DELAY_USW 250
	RET


	.CSEG
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
	ldi  r22,17
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,33
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
	ld   r23,y+
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
	ld   r30,y+
	ldi  r23,8
__i2c_write0:
	lsl  r30
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
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x9C4
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

;END OF CODE MARKER
__END_OF_CODE:
