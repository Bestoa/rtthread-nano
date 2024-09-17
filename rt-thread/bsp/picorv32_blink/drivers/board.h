#ifndef __BOARD_H__
#define __BOARD_H__

#define  TIMER_IRQ_VECTOR   0
#define  ECALL_IRQ_VECTOR   1
#define  SYSTEM_BUS_VECTOR  2
#define  SYSTEM_CORE_CLOCK 10000000l   //  10 MHZ

#define reg_uart_data (*(volatile rt_uint32_t*)0x02000008)

#endif
