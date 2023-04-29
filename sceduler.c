#include "stm32f746xx.h"
#include <stdint.h>
void SysCall(void);

#define STACK_SIZE 256

typedef struct {
  
  unsigned int sp;
  unsigned int stack[STACK_SIZE];
  
} test_st;



volatile test_st *sched_current_task;
volatile test_st *sched_next_task;
volatile test_st *last_task;
volatile test_st *running_task;

volatile test_st task1;
volatile test_st task2;
volatile test_st task3;

int cnt1;
int cnt2;
int cnt3;

void Task1(void) {
  
  while(1) {
    
    cnt1++;
    SysCall();
    
  }
  
}

void Task2(void) {
  
  while(1) {
    
    cnt2++;
    SysCall();
    
  }
  
}

void Task3(void) {
  
  while(1) {
    
    cnt3++;
    SysCall();
    
  }
  
}

void ChangeRunningTask(void) {
  
    running_task = sched_next_task;

    test_st *tmp1 = sched_current_task;
    test_st *tmp2 = sched_next_task;
    test_st *tmp3 = last_task;

    sched_current_task = tmp2;
    sched_next_task = tmp3 ;
    last_task = tmp1;

}

int main(void) {

  task1.stack[STACK_SIZE-1] = 0x01000000UL;
  task2.stack[STACK_SIZE-1] = 0x01000000UL;
  task3.stack[STACK_SIZE-1] = 0x01000000UL;

  task1.stack[STACK_SIZE-2] = (unsigned int)Task1 | 1;
  task2.stack[STACK_SIZE-2] = (unsigned int)Task2 | 1;
  task3.stack[STACK_SIZE-2] = (unsigned int)Task3 | 1;

  task1.sp = &task1.stack[STACK_SIZE-16];
  task2.sp = &task2.stack[STACK_SIZE-16];
  task3.sp = &task3.stack[STACK_SIZE-16];

  sched_next_task = &task2;
  sched_current_task = &task1;
  last_task = &task3;


  __NVIC_EnableIRQ(SVCall_IRQn);
  __set_PSP((uint32_t)(&(taskA.stack[STACK_SIZE-16])));
  __set_CONTROL(0x03);

  Task1();

  while(1);

}
