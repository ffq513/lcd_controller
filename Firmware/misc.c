#include "console.h"
#include "config.h"

extern void Uart_Printf(char *fmt,...);

void logo_display(char *ver){	
  Uart_Printf("\r\n===========================================================");
  Uart_Printf("\r\n   ***   ***   ***   ***   *****    ***    ***      ***    ");
  Uart_Printf("\r\n    *     *     *     *      *       **     *      *   *   ");
  Uart_Printf("\r\n    *     *     *     *      *       * *    *     *        ");
  Uart_Printf("\r\n    *******     *     *      *       *  *   *      *****   ");
  Uart_Printf("\r\n    *     *     *     *      *       *   *  *           *  ");
  Uart_Printf("\r\n    *     *     *     *      *       *    * *      *    *  ");
  Uart_Printf("\r\n   ***   ***     *****     *****    ***    ***      ***    ");
  Uart_Printf("\r\n  HUINS R&D CENTOR : 2005.6                       ");
  Uart_Printf("\r\n  SMART MONITOR Ver "); 
  Uart_Printf("\r\n  TARGET PLATFORM : SoCMaster-3 + CT926EJ-S");
  Uart_Printf("\r\n  H-Engines making, All Rights Are Yours!! "); 
  Uart_Printf("\r\n============== Monitor Now Go !! ==========================");
}
