#include <stdio.h>
#include <math.h>


#define is_stack_empty()  (top < 0)
#define MAX 100

int top; /* ������ ��� */
 
int stack[MAX];  /* �迭 ��� */


void init_stack() 
{
    top = -1;  /* ������ ����� */
}

 

int push(int val)
{
    if(top >= MAX -1)  /* ������ �� �� */
    {
       Uart_Printf("\nOverflow.");
       return -1;
    }
    stack[++top] = val;
    return val;
}

 

int pop()
{
    if(top < 0)  /* ������ �� */
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
   init_stack();   /* �����ʱ�ȭ */
   while(!done)
   {
      while(n > 1)  /* ���� ������ �ƴϸ� */
      {
          push(to);  /* ���� ���� */
          push(by);
          push(from);
          push(n);
          n--;  
          push(to);  /* to �� by �� ��ȯ�� ���� �ӽ÷� ����*/
          to = by;
          by = pop();
      }
      move(from, to);  /* ���� ó�� */
      if(!is_stack_empty())
      {
          n = pop();  
          from = pop();
          by = pop();
          to = pop();
          move(from, to);  
          n--;  
          push(from);  /* from �� by �� ��ȯ�� ���� �ӽ÷� ���� */
          from = by;
          by = pop();
       }
       else
          done = 1;  /* ������ ��� �� */
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
      cnt = pow(2,i) - 1; /* �̵�Ƚ���� 2�� i���� -1 */
      Uart_Printf("\n\r  times : %d\n\r",cnt);
      fpga_uart0_getchar();
      c = fpga_uart0_getchar();
      if (c = 'y') break;
    }
}
