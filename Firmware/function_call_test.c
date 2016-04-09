#include <stdio.h>
#include <math.h>


#define is_stack_empty()  (top < 0)
#define MAX 100

int top; /* 스택의 상단 */
 
int stack[MAX];  /* 배열 사용 */


void init_stack() 
{
    top = -1;  /* 스택이 비워짐 */
}

 

int push(int val)
{
    if(top >= MAX -1)  /* 스택이 꽉 참 */
    {
       Uart_Printf("\nOverflow.");
       return -1;
    }
    stack[++top] = val;
    return val;
}

 

int pop()
{
    if(top < 0)  /* 스택이 빔 */
    {
       Uart_Printf("\nUnderflow.");
       return -1;
    }
    return stack[top--];
}

 

void move(int from, int to)
{
       Uart_Printf("\nMove from %d to %d",from, to);
}

 

void nr_hanoi(int n, int from, int by, int to)
{
   int done = 0; 
   init_stack();   /* 스택초기화 */
   while(!done)
   {
      while(n > 1)  /* 종료 조건이 아니면 */
      {
          push(to);  /* 인자 삽입 */
          push(by);
          push(from);
          push(n);
          n--;  
          push(to);  /* to 와 by 의 교환을 위해 임시로 저장*/
          to = by;
          by = pop();
      }
      move(from, to);  /* 종료 처리 */
      if(!is_stack_empty())
      {
          n = pop();  
          from = pop();
          by = pop();
          to = pop();
          move(from, to);  
          n--;  
          push(from);  /* from 과 by 의 교환을 위해 임시로 저장 */
          from = by;
          by = pop();
       }
       else
          done = 1;  /* 스택이 비면 끝 */
   }
}

 

void function_call()
{
   int i = 0 , cnt = 0;
   char c;
   
   while(1)
   {
      i = 10;

      Uart_Printf("\n\rnumber -> %d ",i);
      
//      scanf("%d",&i);

      if(i <= 0) break;
      nr_hanoi(i, 1, 2, 3);
      cnt = pow(2,i) - 1; /* 이동횟수는 2의 i제곱 -1 */
      Uart_Printf("\n\r  times : %d\n\r",cnt);
      fpga_uart0_getchar();
      c = fpga_uart0_getchar();
      if (c = 'y') break;
    }
}
