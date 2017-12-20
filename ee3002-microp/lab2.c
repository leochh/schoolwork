/******************************************************************************/
/* newBlinky.c: LED Flasher                                                      */
/******************************************************************************/
/* This file is part of the uVision/ARM development tools.                    */
/* Copyright (c) 2010 Keil - An ARM Company. All rights reserved.             */
/* This software may only be used under the terms of a valid, current,        */
/* end user licence from KEIL for a compatible version of KEIL software       */
/* development tools. Nothing else gives you the right to use this software.  */
/******************************************************************************/

#include <stdio.h>
#include "stm32f10x.h"                  /* STM32F10x.h definitions            */
#include "GLCD.h"
#include "math.h"
#define __FI        1                   /* Font index 16x24                   */

#define LED_NUM     8                   /* Number of user LEDs                */
const unsigned long led_mask[] = { 1UL <<  8, 1UL <<  9, 1UL << 10, 1UL << 11,
                                   1UL << 12, 1UL << 13, 1UL << 14, 1UL << 15};

               char text[40];

/* Import external function from Serial.c file                                */
extern void SER_init (void);

/* Import external variables from IRQ.c file                                  */
extern unsigned short AD_last;
extern unsigned char  AD_done;
extern unsigned char  clock_1s;

int direction=1, mode=0;

float score[5];													/* Array to store five scores         */
float sort_score[5];										/* Array to store five sorted scores  */
int type = 0;													  /* type is used only in task B and C	*/
float diff_level = 1.0;

unsigned char *type_text[6]={"  Diff  ","score[0]","score[1]","score[2]","score[3]","score[4]"};

/* variable to trace in LogicAnalyzer (should not read to often)              */
volatile unsigned short AD_dbg, AD_print;          

/*----------------------------------------------------------------------------
  note: 
  set __USE_LCD in "options for target - C/C++ - Define" to enable Output on LCD
  set __USE_IRQ in "options for target - C/C++ - Define" to enable ADC in IRQ mode
                                                        default is ADC in DMA mode
 *----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
  Function that initializes ADC
 *----------------------------------------------------------------------------*/
void ADC_init (void) {

  RCC->APB2ENR |= ( 1UL <<  4);         /* enable periperal clock for GPIOC   */
  GPIOC->CRL &= ~0x000F0000;            /* Configure PC4 as ADC.14 input      */

#ifndef __USE_IRQ
  /* DMA1 Channel1 configuration ---------------------------------------------*/
  RCC->AHBENR |= ( 1UL <<  0);          /* enable periperal clock for DMA     */

  DMA1_Channel1->CMAR  = (u32)&AD_last;    /* set channel1 memory address     */
  DMA1_Channel1->CPAR  = (u32)&(ADC1->DR); /* set channel1 peripheral address */
  DMA1_Channel1->CNDTR = 1;             /* transmit 1 word                    */
  DMA1_Channel1->CCR   = 0x00002522;    /* configure DMA channel              */
  NVIC_EnableIRQ(DMA1_Channel1_IRQn);   /* enable DMA1 Channel1 Interrupt     */
  DMA1_Channel1->CCR  |= (1 << 0);      /* DMA Channel 1 enable               */
#endif

  /* Setup and initialize ADC converter                                       */
  RCC->APB2ENR |= ( 1UL <<  9);         /* enable periperal clock for ADC1    */

  ADC1->SQR1    =  0;                   /* Regular channel 1 conversion       */
  ADC1->SQR2    =  0;                   /* Clear register                     */
  ADC1->SQR3    = (14UL <<  0);         /* SQ1 = channel 14                   */
  ADC1->SMPR1   = ( 5UL << 12);         /* sample time channel 14 55,5 cycles */
  ADC1->CR1     = ( 1UL <<  8);         /* Scan mode on                       */
  ADC1->CR2     = ( 7UL << 17)|         /* select SWSTART                     */
                  ( 1UL << 20) ;        /* enable ext. Trigger                */

#ifndef __USE_IRQ
  ADC1->CR2    |= ( 1UL <<  8);         /* DMA mode enable                    */
#else
  ADC1->CR1    |= ( 1UL <<  5);         /* enable for EOC Interrupt           */
  NVIC_EnableIRQ(ADC1_2_IRQn);          /* enable ADC Interrupt               */
#endif

  ADC1->CR2    |= ( 1UL <<  0);         /* ADC enable                         */

  ADC1->CR2    |=  1 <<  3;             /* Initialize calibration registers   */
  while (ADC1->CR2 & (1 << 3));         /* Wait for initialization to finish  */
  ADC1->CR2    |=  1 <<  2;             /* Start calibration                  */
  while (ADC1->CR2 & (1 << 2));         /* Wait for calibration to finish     */
}

/*----------------------------------------------------------------------------
  Function that initializes User Buttons
 *----------------------------------------------------------------------------*/
void BUT_init(void) {
  RCC->APB2ENR |= (1UL << 8);           /* Enable GPIOG clock                 */

  GPIOG->CRH   &= ~0x0000000F;          /* Configure the GPIO for Button      */
  GPIOG->CRH   |=  0x00000004;
}

/*----------------------------------------------------------------------------
  Function that initializes Joystick
 *----------------------------------------------------------------------------*/
void JOY_init(void) {
  RCC->APB2ENR |= (1UL << 8);           /* Enable GPIOG clock                 */
  RCC->APB2ENR |= (1UL << 5);           /* Enable GPIOD clock                 */

  GPIOG->CRL   &= ~0xF0000000;          /* Configure the GPIO for Joystick    */
  GPIOG->CRL   |=  0x40000000;
  GPIOG->CRH   &= ~0xFFF00000;
  GPIOG->CRH   |=  0x44400000;

  GPIOD->CRL   &= ~0x0000F000;          /* Configure the GPIO for Joystick    */
  GPIOD->CRL   |=  0x00004000;
}

/*----------------------------------------------------------------------------
  Function that initializes LEDs
 *----------------------------------------------------------------------------*/
void LED_init(void) {
  RCC->APB2ENR |= (1UL << 3);           /* Enable GPIOB clock                 */

  GPIOB->ODR   &= ~0x0000FF00;          /* switch off LEDs                    */
  GPIOB->CRH   &= ~0xFFFFFFFF;          /* Configure the GPIO for LEDs        */
  GPIOB->CRH   |=  0x33333333;
}

/*----------------------------------------------------------------------------
  Function that turns on requested LED
 *----------------------------------------------------------------------------*/
void LED_On (unsigned int num) {

  GPIOB->BSRR = led_mask[num];
}

/*----------------------------------------------------------------------------
  Function that turns off requested LED
 *----------------------------------------------------------------------------*/
void LED_Off (unsigned int num) {

  GPIOB->BRR = led_mask[num];
}

/*----------------------------------------------------------------------------
  Function that outputs value to LEDs
 *----------------------------------------------------------------------------*/
void LED_Out(unsigned int value) {
  int i;

  for (i = 0; i < LED_NUM; i++) {
    if (value & (1<<i)) {
      LED_On (i);
    } else {
      LED_Off(i);
    }
  }
}

/*----------------------------------------------------------------------------
  Function that show initial LCD Display
 *----------------------------------------------------------------------------*/
void Display_Init(void) 
{
//#ifdef __USE_LCD
  GLCD_Init();                               /* GLCD Initialization           */
  GLCD_Clear(White);                         /* Clear graphical LCD display   */
  GLCD_SetBackColor(Blue);
  GLCD_SetTextColor(White);
  GLCD_DisplayString(0, 0, __FI, "      Task 2a       ");
  GLCD_DisplayString(1, 0, __FI, "   Dive Scoreboard  ");
  GLCD_SetBackColor(White); 
  GLCD_SetTextColor(Blue);
	GLCD_DisplayString(2, 0, __FI, "Adjust Type:");
	GLCD_DisplayString(3, 0, __FI, "Difficulty :");
	GLCD_DisplayString(4, 0, __FI, "Original Scores");
	GLCD_DisplayString(7, 0, __FI, "Sorted Scores");
	GLCD_DisplayString(9, 0, __FI, "Final Score:      ");
	GLCD_SetTextColor(Red);
//#endif
}

/*----------------------------------------------------------------------------
  Sort the Five-Judge Scores in descending order
 *----------------------------------------------------------------------------*/
void sort(void)  
{  
	// your sorting codes here
	int t;
	float temp;
	int i=0,j=0;
	
	for(t=0;t<5;t++){
	sort_score[t] = score[t];
	}	

	while (i < 5){
		j = i+1;
		while(j < 5) {
			if (sort_score[i] < sort_score[j]) {
				temp = sort_score[i];
				sort_score[i] = sort_score[j];
				sort_score[j] = temp;
			}
			j++;
		}
		i++;
	}
	
}

/*----------------------------------------------------------------------------
  Update the display of all data 
 *----------------------------------------------------------------------------*/
void update_display(void)
{
	int i = 0, col = 0;
	float final_score;
	
			/* Display updated Adjustment Mode                                   		*/
			GLCD_DisplayString(2, 12, __FI, type_text[type]);
			
			/* Display updated difficulty level	*/
			if (type == 0) {
					GLCD_SetTextColor(Blue);
				}
			sprintf(text, "%.2f", diff_level);
			GLCD_DisplayString(3, 14, __FI,  (unsigned char *)text);
			GLCD_SetTextColor(Red);
				
			/* Display the  five judges' score                            					*/
			for(i=0, col=0; i<5; i++)
			{
				if (i == type-1 && type != 0) {
					GLCD_SetTextColor(Blue);
				}
				sprintf(text, "%.1f ", score[i]);
				GLCD_DisplayString(5,  col, __FI,  (unsigned char *)text);
				GLCD_SetTextColor(Red);
				col +=4;
			}
			sort();
		
			/* Display the sorted five judges' score                             		*/ 
			for(i=0, col=0; i<5; i++)
			{
				sprintf(text, "%.1f ", sort_score[i]);
				GLCD_DisplayString(8,  col, __FI,  (unsigned char *)text);
				 
				col +=4;
			}
			
			/* Compute final score based on 3 middle scores											 		*/
			for(i=1;i<4;i++){
				final_score += sort_score[i];
			}
			final_score = final_score * diff_level;
			
			/* Display the final score*/	
			sprintf(text, "%.1f ", final_score);
			GLCD_DisplayString(9,  14 , __FI,  (unsigned char *)text);
}

/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/
int main (void) {
  int ad_val   =  0, ad_avg   = 0, ad_val_  = 0xFFFF;
  int joy      =  0, joy_     = -1;
  int but      =  0, but_     = -1;
	int i;
	extern unsigned int time_count;
	
	/* Initialize the five judges scores                                        */
	score[0] = 6.0; score[1] = 7.0; score[2] = 6.5; score[3] = 5.5; score[4] = 3.0;

  SysTick_Config(SystemCoreClock/100);  /* Generate interrupt each 10 ms      */

  LED_init();                           /* LED Initialization                 */
  BUT_init();                           /* User Button Initialization         */
  JOY_init();                           /* Joystick Initialization            */
  ADC_init();                           /* ADC Initialization                 */
	Display_Init();												/* Show initial LCD static Display		*/
	
	
	
  
  while (1) {                           /* Loop forever                       */
    /* Collect all input signals                                              */

    /* AD converter input                                                     */
    if (AD_done) {                      /* If conversion has finished         */
      AD_done = 0;
                                        /* Ad value is read via IRQ or DMA    */
      ad_avg += AD_last << 8;           /* Add AD value to averaging          */
      ad_avg ++;
      if ((ad_avg & 0xFF) == 0x10) {
        ad_val = ad_avg >> 12;
        ad_avg = 0;
      }
    }

    /* Joystick input                                                         */
    joy = 0;
    if (GPIOG->IDR & (1 << 14)) joy |= (1 << 0);  /* Joystick left            */
    if (GPIOG->IDR & (1 << 13)) joy |= (1 << 1);  /* Joystick right           */
    if (GPIOG->IDR & (1 << 15)) joy |= (1 << 2);  /* Joystick up              */
    if (GPIOD->IDR & (1 <<  3)) joy |= (1 << 3);  /* Joystick down            */
    if (GPIOG->IDR & (1 <<  7)) joy |= (1 << 4);  /* Joystick select          */
    joy ^= 0x1F;

    /* Button inputs                                                          */
    but = 0;
    if (GPIOG->IDR & (1 <<  8)) but |= (1 << 0);  /* Button User (User)       */
    but ^= 0x01;

		
    /* Show all signals                                                       */
    if (ad_val ^ ad_val_) {             /* Show AD value bargraph             */
//      sprintf(text, "0x%04X", ad_val);
//			sprintf(text, "%08X", time_count);
//      GLCD_SetTextColor(Red);
//			GLCD_DisplayString(4,  9, __FI,  (unsigned char *)text);
//      GLCD_DisplayString(4,  11, __FI,  (unsigned char *)text);
//			GLCD_Bargraph (144, 3*24, 176, 20, (ad_val>>2));

//      AD_print = ad_val;                /* Get unscaled value for printout  */
//      AD_dbg   = ad_val;

      ad_val_ = ad_val;
    }
		
    /* Button inputs                                                          */
    but = 0;
    if (GPIOG->IDR & (1 <<  8)) but |= (1 << 0);  /* Button User (User)       */
    but ^= 0x01;

    if (but ^ but_) {                        /* Show buttons status           */

      if (but & (1 << 0)) {
        
      }
      but_ = but;
    }
 
    if (joy ^ joy_) {                    	/* Show joystick status             */
      if (joy & (1 << 0)) { 				/* check  "Left" Key */
        if (type > 0) type--;
      }
      if (joy & (1 << 1)) {           		/* check "Right" Key */
        if (type < 5) type++;
      }
      if (joy & (1 << 2)) {             	/* check "Up" Key */
				switch (type){
					case 0: {
						if (diff_level < 2.0) diff_level += 0.1;
					}
					break;
					case 1: {
						if (score[type-1] < 10.0) score[type-1] += 0.5;
					}
					break;
					case 2: {
						if (score[type-1] < 10.0) score[type-1] += 0.5;
					}
					break;
					case 3: {
						if (score[type-1] < 10.0) score[type-1] += 0.5;
					}
					break;
					case 4: {
						if (score[type-1] < 10.0) score[type-1] += 0.5;
					}
					break;
					case 5: {
						if (score[type-1] < 10.0) score[type-1] += 0.5;
					}
					break;
				}
        
      }
      if (joy & (1 << 3)) {             	/* check "Down" Key */
        switch (type){
					case 0: {
						if (diff_level > 0.1) {
							diff_level -= 0.1;
						}else { diff_level = 0;}
					}
					break;
					case 1: {
						if (score[type-1] > 0) score[type-1] -= 0.5;
					}
					break;
					case 2: {
						if (score[type-1] > 0) score[type-1] -= 0.5;
					}
					break;
					case 3: {
						if (score[type-1] > 0) score[type-1] -= 0.5;
					}
					break;
					case 4: {
						if (score[type-1] > 0) score[type-1] -= 0.5;
					}
					break;
					case 5: {
						if (score[type-1] > 0) score[type-1] -= 0.5;
					}
					break;
				}
      }
      if (joy & (1 << 4)) {            		/* check "Sel" Key */

      }

      joy_ = joy;
    }
 
		// Display LED patterns according to the mode
			
			switch (mode){
				case 0: {			
							i = 1 << (time_count %8);
							LED_Out(i);			/* Turn LED[i] on */
				}		
				break;
				case 1: {
						
				}
				break; 
				case 2: {
						
				}
				break;		   
				case 3: {
						
					}
				break;	 
				case 4: {

				}          
			}
			update_display();			/* Update data on the LCD display */
}
}
