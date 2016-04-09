
; pjk in huins : 050714
;
	PRESERVE8
SDRAMTop        EQU     0x4003fff0    ; top address of SDRAM address 
;SDRAMTop        EQU     0x5001fff0    ; top address of SDRAM address 

; Interrupt control bits of PSR
IRQDisable      EQU     0x00000080
FIQDisable      EQU     0x00000040
InterruptMask   EQU     0x000000C0

Ibit            EQU     0x00000080
Fbit            EQU     0x00000040

; State control bit of PSR(Thumb or Arm)
Tbit            EQU     0x00000020

; Mode control bits of PSR
ModeMask        EQU     0x0000001F
USRmode	        EQU     0x00000010
SYSmode	        EQU     0x0000001F
SVCmode	        EQU     0x00000013
IRQmode	        EQU     0x00000012
FIQmode         EQU     0x00000011
ABTmode         EQU     0x00000017
UNDmode         EQU     0x0000001B

SVCStackSize    EQU     1024*5
FIQStackSize    EQU     1024
IRQStackSize    EQU     1024
UNDStackSize    EQU     1024 
ABTStackSize    EQU     1024
USRStackSize    EQU     1024

NumOfInt                EQU     32

CombinedStackSize       EQU     (FIQStackSize+IRQStackSize+SVCStackSize+UNDStackSize+ABTStackSize)
StackBase		        EQU     (SDRAMTop - CombinedStackSize-(NumOfInt<<2))  	;SDRAM area

;All offsets are from StackBase
SVCStackLimitOffset     EQU     StackBase
SVCStackOffset          EQU     (SVCStackLimitOffset + SVCStackSize)

FIQStackLimitOffset     EQU     SVCStackOffset
FIQStackOffset          EQU     (FIQStackLimitOffset + FIQStackSize)

IRQStackLimitOffset     EQU     FIQStackOffset
IRQStackOffset          EQU     (IRQStackLimitOffset + IRQStackSize) 

UNDStackLimitOffset     EQU     IRQStackOffset
UNDStackOffset          EQU     (UNDStackLimitOffset + UNDStackSize)

ABTStackLimitOffset     EQU     UNDStackOffset
ABTStackOffset          EQU     (ABTStackLimitOffset + ABTStackSize)

USRStackLimitOffset     EQU     ABTStackOffset
USRStackOffset          EQU     (USRStackLimitOffset + USRStackSize)



;====================================   
; MMU Cache/TLB/etc on/off functions    
;====================================   
R1_I	EQU	(1<<12)                 
R1_C	EQU	(1<<2)                  
R1_A	EQU	(1<<1)                  
R1_M    EQU	(1)                     
R1_iA	EQU	(1<<31)                 
R1_nF   EQU	(1<<30)                     
		


        GBLL    VECTOR
VECTOR  SETL    {TRUE}

        AREA	Init, CODE, READONLY  

	ENTRY

;-------------------------------------------------------------------------------
;	Exception Hanlder Routine
;-------------------------------------------------------------------------------
        B     RESETHandler         
        B     UNDEFHandler                ; Undefined instruction
        B     SWIHandler                  ; SWI
        B     pABORTHandler               ; Prefetch abort
        B     dABORTHandler               ; Data abort
        NOP											
        B     IRQHandler                  ; IRQ

UNDEFHandler
				B UNDEFHandler
				
SWIHandler
				B SWIHandler	
				
pABORTHandler
				B pABORTHandler		
				
dABORTHandler
				B dABORTHandler				
									
IRQHandler
				B IRQHandler
				        
FIQHandler
				B FIQHandler		

UnFIQSource
				B UnFIQSource

RESETHandler
        IMPORT  |Image$$ZI$$Base|
        IMPORT  |Image$$ZI$$Limit|
        IMPORT  |Image$$RW$$Base|
        IMPORT  |Image$$RO$$Base|
        IMPORT  |Image$$RO$$Limit|

;************************************************************************
; This routine is configuration to system registers 
;************************************************************************
SystemConfig

; pjk : 050708 data cache,instruction cache,mmu,write buf disable
;void MMU_DisableMMU(void)

MMU_DisableMMU
      mrc p15,0,r0,c1,c0,0
      bic r0,r0,#R1_M
      mcr p15,0,r0,c1,c0,0
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
      
   
;void MMU_DisableICache(void)
     
MMU_DisableICache	
      mrc p15,0,r0,c1,c0,0
      bic r0,r0,#R1_I
;      orr r0, r0, #0x00001000
      mcr p15,0,r0,c1,c0,0
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
     
      
;void MMU_DisableDCache(void)
      
MMU_DisableDCache	
      mrc p15,0,r0,c1,c0,0
      bic r0,r0,#R1_C
;      orr r0, r0, #0x0000004      
      mcr p15,0,r0,c1,c0,0
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
      

SysInitStacks
; pjk 050720
        LDR   sp, =SVCStackOffset     ; SVC mode stack
        LDR   sl, =StackBase          ; No APCS_STACKGUARD space

     
        
        ; We have to set up the other privileged mode regs right now.
       
        MOV   r0, #(InterruptMask :OR: FIQmode)
        MSR   cpsr_cf,r0
        LDR   sp, =FIQStackOffset     ; FIQ mode stack
        MOV   r0, #(InterruptMask :OR: IRQmode)
        MSR   cpsr_cf,r0
        LDR   sp, =IRQStackOffset     ; IRQ mode stack

        MOV   r0, #(InterruptMask :OR: UNDmode)
        MSR   cpsr_cf,r0
        LDR   sp, =UNDStackOffset     ; Undefined instruction mode stack
        
        MOV   r0, #(InterruptMask :OR: ABTmode)
        MSR   cpsr_cf,r0
        LDR   sp, =ABTStackOffset     ; Abort mode stack
		
        ; Supervisior mode to processor mode                                               
        MOV   r0, #SVCmode
        MSR   cpsr_cf,r0
        
	b go_main 
	ldr r13, Test_base_addr    
    mov r10, #0xff	
    mov r0, #0
    mov r1, #1
    mov r2, #2
    mov r3, #3
    mov r4, #4
    mov r5, #5
    mov r6, #6
    mov r7, #7
    mov r8, #8
    mov r9, #9
    mov r11, #11
    mov r12, #12
    mov r14, #14
stack_test    
    stmfd r13!, {r4-r8,r14}
    sub	r10, r10, #1
    cmp r10, r0
    beq	go_main
    b	stack_test
Test_base_addr
    dcd 0x0802fff0
go_main
   
      NOP
      NOP
         
      NOP
      NOP
         
      NOP
      NOP
      
;loop b loop



	IMPORT arm926ejs_main
	B arm926ejs_main
	
		

	END