PROCESSOR 16F887 
#include <xc.inc> 
;configuration word 1
    CONFIG FOSC=INTRC_NOCLKOUT //OSCILADOR INTERNO SIN SALIDAS
    CONFIG WDTE=OFF // WDT DISABLE (REINICIO REPETITIVO DE PIC)
    CONFIG PWRTE=OFF // PWRT ENABLE (ESPERA DE 72MS AL INICIAR)
    CONFIG MCLRE=OFF //EL PIN DE MCLR SE USA COMO I/O
    CONFIG CP=OFF //SIN PROTECCIÓN DE CÓDIGO
    CONFIG CPD=OFF //SIN PROTECCIÓN DE DATOS
    
    CONFIG BOREN=OFF //SIN REINICIO CUANDO EL V DE ALIMENTACIÓN BAJA A 4V
    CONFIG IESO=OFF // REINICIO SIN CAMBIO DE RELOJ INTERNO A EXTERNO
    CONFIG FCMEN=OFF // CAMBBIO DE RELOJ EXTERNO A INTERNO EN CASO DE FALLO
    CONFIG LVP=OFF //PROGRAMACIÓN EN BAJO VOLTAJE PERMITIDA 
     ;CONFIGURATION WORD 2
    CONFIG WRT=OFF //PROTECCIÓN DE AUTOESCRITURA POR EL PROGRAMA DESACTIVADA
    CONFIG BOR4V=BOR40V //REINICIO ABAJO DE 4, (BOR21V=2.1V)
    PSECT udata_bank0 ;common memory
	cont_small: DS 1 ;1 byte
	counter: DS 1
	contTimer: DS 1
 
 PSECT resVect, class=CODE, abs, delta=2 
    ;--------------vector reset==========-------
    ORG 00h	;posición 0000h para el reset
    resetVec:
	PAGESEL main
	goto main
	
    PSECT code, delta=2, abs
    ORG 100h ; posición para el código
    
     ;-------------COnfiguración=--===--------
    main:
	call	config_io  // CONFIGURAR ENTRADAS Y SALIDAS
	call	config_reloj // CONFIGURAR RELOJ
	call	timer0 
	;------loop principal------------
	loop: 
	movlw 1
	movwf contTimer 
	btfss INTCON, 2 
	incf PORTA 
	bcf INTCON, 2 
	banksel TMR0 
	movlw 0x3C
	decfsz contTimer  
	decf PORTA 
	  incf PORTB,1
	call delayc ;llama al delay, este va a marcar la frecuencia a la que cambie la onda. 
	decf PORTB,1
	call delayc   
	goto loop 
	
    config_io: 
    banksel ANSEL 
    clrf ANSEL ;pines digitales 
    clrf ANSELH 
    banksel TRISA 
    movlw 0b00000000
    movwf TRISA ;configurar PORTA como salida  
    movlw 0b01111111
    movwf TRISB 
    banksel PORTA 
    clrf PORTA 
	
     config_reloj:
	banksel OSCCON
	movlw 0b01100001
	movwf OSCCON
	return 

	 timer0:
	banksel OPTION_REG
	bcf OPTION_REG, 5
	bcf OPTION_REG, 3
	bsf OPTION_REG, 2
	bsf OPTION_REG, 1
	bsf OPTION_REG, 0
	banksel TMR0
	MOVLW 0x3C
	MOVWF TMR0 
	BCF INTCON, 2
	RETURN 
	
	delayc: 
	 NOP 
	 NOP
	 NOP
	 NOP
	 NOP
	 NOP
	 NOP
	 NOP
	 NOP
	 NOP
	 NOP
	 NOP
	 NOP
	 NOP
	 NOP
	 NOP
	 NOP
	 NOP
	 NOP
	 NOP
	return 
END 
	