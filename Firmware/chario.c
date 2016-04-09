#include <stdarg.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>

extern int Uart_SendByte(char c);

extern char Image$$RW$$Limit[];
void *mallocPt = Image$$RW$$Limit;    
void eitoa(int number,char *str,int power);
void Uart_GetString(char *string);
int Uart_GetIntNum(void);
extern unsigned char fpga_uart0_getchar(void);
	
//====================================================================
void Uart_SendString(char *pt)
{
	while(*pt)
		Uart_SendByte(*pt++);
}

void Uart_Printf(char *fmt,...)
{
     va_list ap;
     char *p;
     char string[30];
      
     va_start(ap,fmt);

     for(p=fmt;*p;p++)
     {
         if (*p != '%')
         {
            Uart_SendByte(*p);
            continue;
         }
         switch(*(++p))
         {
             case 'x':
             case 'X':
                eitoa(va_arg(ap,int),string,16);                    
                Uart_SendString(string);
                break;
             case 'd':
                eitoa(va_arg(ap,int),string,10);                    
                Uart_SendString(string);
                break;
             case 'c':
                Uart_SendByte(va_arg(ap,int));
                break;                        
             case 's':
                Uart_SendString((char *)va_arg(ap,int));
                break;
             default:
                Uart_SendByte('?');
                break;
         }
     }
     va_end(ap);
}

void eitoa(int number,char *str,int numtype)
{
     char buffer[15];
     int i;
     int firstNumber=1;
     unsigned int temp;
     unsigned int numtemp;

     switch(numtype)
     {
         case 16:
            for(i=0;i<8;i++)
            {
                numtemp=(unsigned int)number;
                numtemp=(numtemp << (i*4)) >> 28;
                if (numtemp >= 10)
                    numtemp+=('A'-10);
                else
                    numtemp+='0';
                if (!firstNumber || numtemp!='0' || i==7)
                {
                    *str++=numtemp;
                    firstNumber=0;
                }
            }
            *str++='\0';
            break;
         case 10:
            if (number < 0)
            {
                *str++='-';
                numtemp=-number;
            }
            else
                numtemp=number;
            for(i=0;i<10;i++)
            {
                temp=(numtemp/10)*10;
                temp=numtemp-temp;
                buffer[i]=temp;
                numtemp=(numtemp-temp)/10;
            }  
            for(i=9;i>=0;i--)
            {
                temp=buffer[i]+'0';
                if (!firstNumber || temp!='0' || i==0)
                {
                    *str++=temp;
                    firstNumber=0;
                }
            }
            *str++='\0';
            break;
        }
}

int Uart_GetIntNum(void)
{
    char str[30];
    char *string = str;
    int base     = 10;
    int minus    = 0;
    int result   = 0;
    int lastIndex;    
    int i;
    
    Uart_GetString(string);
    
    if(string[0]=='-')
    {
        minus = 1;
        string++;
    }
    
    if(string[0]=='0' && (string[1]=='x' || string[1]=='X'))
    {
        base    = 16;
        string += 2;
    }
    
    lastIndex = strlen(string) - 1;
    
    if(lastIndex<0)
        return -1;
    
    if(string[lastIndex]=='h' || string[lastIndex]=='H' )
    {
        base = 16;
        string[lastIndex] = 0;
        lastIndex--;
    }

    if(base==10)
    {
        result = atoi(string);
        result = minus ? (-1*result):result;
    }
    else
    {
        for(i=0;i<=lastIndex;i++)
        {
            if(isalpha(string[i]))
            {
                if(isupper(string[i]))
                    result = (result<<4) + string[i] - 'A' + 10;
                else
                    result = (result<<4) + string[i] - 'a' + 10;
            }
            else
                result = (result<<4) + string[i] - '0';
        }
        result = minus ? (-1*result):result;
    }
    return result;
}

void Uart_GetString(char *string)
{
    char *string2 = string;
    char c;
    while((c = fpga_uart0_getchar())!='\r')
    {
        if(c=='\b')
        {
            if( (int)string2 < (int)string )
            {
                Uart_Printf("\b \b");
                string--;
            }
        }
        else 
        {
            *string++ = c;
            Uart_SendByte(c);
        }
    }
    *string='\0';
    Uart_SendByte('\r');
}