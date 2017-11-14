/*
 * Audio Bypass Project
 */

#include <usbstk5515.h>
#include <usbstk5515_i2c.h>
#include <usbstk5515_led.h>
#include <AIC_func.h>
#include <stdio.h>
#include <Dsplib.h>
#include <usbstk5515_interrupts.h>
#include "sar.h"
#include "led.h"
#include "LCD_FCN.h"
#include "lcd_disp.h"

#define TAPS	256

const char *band_gain_db[9] = {"-12dB", "-9dB", "-6dB", "-3dB", "0dB", "3dB", "6dB", "9dB", "12dB"};
// Compute hex of gain (linear gain is normalized by a factor of 4)
Int16 band_gain_hex[9] = {0x080A, 0x0B5B, 0x100A, 0x16A7, 0x2000, 0x2D34, 0x3FD9, 0x5A30, 0x7F65};
Int16 band_selection=0;

Int16 BAND1_COEF[TAPS] = {
	#include "band1_coef.dat"
};
Int16 band1_gain_selection=4; 
Int16 band1_coef_changed[TAPS];

Int16 BAND2_COEF[TAPS] = {
	#include "band2_coef.dat"
};
Int16 band2_gain_selection=4; 
Int16 band2_coef_changed[TAPS];

Int16 BAND3_COEF[TAPS] = {
	#include "band3_coef.dat"
};
Int16 band3_gain_selection=4; 
Int16 band3_coef_changed[TAPS];

Int16 band_coef_mixed[TAPS];

Int16 dbuffer_left[TAPS+2] = {0};
Int16 dbuffer_right[TAPS+2] = {0};

void band_mix();
void check_btn_push(Uint16 value);
void calculate_new_coef();
void filter_init();

Int16 led0 = 0; 
Int16 led1 = 0; 
Int16 led2 = 0; 
Int16 led3 = 0;

Int16 time_offset = 0x0000;

Int16 b1_speed = 0x0000 + 4 * 16;
Int16 b2_speed = 0x0000 + 4 * 16;
Int16 b3_speed = 0x0000 + 4 * 16;

void Reset();
interrupt void Timer_Handler()
{
	if (band_selection == 1){
		if (led1 == 0){
			USBSTK5515_ULED_on(1);
			led1 = 1;
		} else {
			USBSTK5515_ULED_off(1);
			led1 = 0;
		}
	}
	if (band_selection == 2){
		if (led2 == 0){
			USBSTK5515_ULED_on(2);
			led2 = 1;
		} else {
			USBSTK5515_ULED_off(2);
			led2 = 0;
		}
	}
	if (band_selection == 3){
		if (led3 == 0){
			USBSTK5515_ULED_on(3);
			led3 = 1;
		} else {
			USBSTK5515_ULED_off(3);
			led3 = 0;
		}
	}
	//printf("timer on %d\n", TIAFR);
}

Uint16 time_set;
Uint32 reset_loc = (Uint32)Reset;

void Timer_setup()
{

	//Set up Interrupt Vector Pointer Table
	IVPD = reset_loc >> 8;
	IVPH = reset_loc >> 8;

	*((Uint32*)((reset_loc + TINT)>>1)) = (Uint32)Timer_Handler; //Table points to our handler


	IER0 |= (1 << TINT_BIT);//enable interrupt
	IFR0 &= (1 << TINT_BIT);//clear the flag

	TCR0 = TIME_STOP;
	// Set total period 
	TPR0_1 = 0xFFFF; 
	TPR0_2 = time_offset + 4 * 16;
	// Set count down rate
	TCR0_1 = 0x0001;
	TCR0_2 = 0x0000;

	// Clear Timer Interrupt Flag
	TIAFR = 0x0001;
	TCR0 = TIME_START_AUTOLOAD;
}


void main(void)
{
	Int16 x_right[1], x_left[1]; //AIC inputs
	Int16 r_right[1], r_left[1]; //AIC outputs
	Uint16 btn_value;

	USBSTK5515_init(); 	//Initializing the Processor
	AIC_init(); 		//Initializing the Audio Codec
	Init_SAR();
	LCD_init();
	//My_LED_init();
	USBSTK5515_ULED_init();
	LCD_Clear();
	LCD_disp_init();
	filter_init();

	//Initialize Display
	LCD_disp_update(band_selection, band1_gain_selection, band2_gain_selection, band3_gain_selection);
	USBSTK5515_ULED_on(0);
	led0 = 1;
	
	// Timer Interrupt Setup
	Timer_setup();
	_enable_interrupts();

	while(1)
	{
		btn_value = Get_Key_Human();
		if (btn_value != NoKey){
			check_btn_push(btn_value);
		}
		
		if (TIAFR == 0x0001) TIAFR = 0x0001; // Reset Timer Flag
		//printf("main %d\n", TIAFR);
		
		// Read Audio Input
		AIC_read2(&x_right[0], &x_left[0]);		
		if (band_selection != 0){
			fir(&x_right[0],&band_coef_mixed[0],&r_right[0],&dbuffer_right[0],1,TAPS);
			fir(&x_left[0],&band_coef_mixed[0],&r_left[0],&dbuffer_left[0],1,TAPS);
			AIC_write2(r_right[0],r_left[0]);
		} else {

			AIC_write2(x_right[0],x_left[0]);
		}
		
	}
}

void filter_init(){	
	int i;
	for(i=0;i<TAPS;i++){
		band1_coef_changed[i]=(Int16)(((Int32)BAND1_COEF[i]*(Int32)band_gain_hex[band1_gain_selection])>>15);
		band2_coef_changed[i]=(Int16)(((Int32)BAND2_COEF[i]*(Int32)band_gain_hex[band2_gain_selection])>>15);
		band3_coef_changed[i]=(Int16)(((Int32)BAND3_COEF[i]*(Int32)band_gain_hex[band3_gain_selection])>>15);
	}
	band_mix();
}

void check_btn_push(Uint16 value){
	if (value == SW2){
		if (band_selection == 1){
			band1_gain_selection++;
			band1_gain_selection = band1_gain_selection % 9;
			calculate_new_coef();
			// Change Timer Period. the Larger the period, the slower the blinking frequency
			b1_speed = time_offset + (8 - band1_gain_selection) * 16;
			TPR0_2 = b1_speed;
			//printf("Band 1 gain is %s.\n", band_gain_db[band1_gain_selection]);
		} else if (band_selection == 2){
			band2_gain_selection++;
			band2_gain_selection = band2_gain_selection % 9;
			calculate_new_coef();
			b2_speed = time_offset + (8 - band2_gain_selection) * 16;
			TPR0_2 = b2_speed;
			//printf("Band 2 gain is %s.\n", band_gain_db[band2_gain_selection]);
		} else if (band_selection == 3){
			band3_gain_selection++;
			band3_gain_selection = band3_gain_selection % 9;
			calculate_new_coef();
			b3_speed = time_offset + (8 - band3_gain_selection) * 16;
			TPR0_2 = b3_speed;
			//printf("Band 3 gain is %s.\n", band_gain_db[band3_gain_selection]);
		}		
		band_mix();
	} else if (value == SW1){
		band_selection++;
		band_selection = band_selection % 4;
		
		if (band_selection == 0){
			USBSTK5515_ULED_off(1);
			USBSTK5515_ULED_off(2);
			USBSTK5515_ULED_off(3);
			USBSTK5515_ULED_on(0);
		} 
		if (band_selection == 1){
			USBSTK5515_ULED_off(0);
			USBSTK5515_ULED_off(2);
			USBSTK5515_ULED_off(3);
			TPR0_2 = b1_speed;
			//USBSTK5515_ULED_on(1);
		} 
		if (band_selection == 2){
			USBSTK5515_ULED_off(1);
			USBSTK5515_ULED_off(0);
			USBSTK5515_ULED_off(3);
			TPR0_2 = b2_speed;
			//USBSTK5515_ULED_on(2);
		} 
		if (band_selection == 3){
			USBSTK5515_ULED_off(1);
			USBSTK5515_ULED_off(2);
			USBSTK5515_ULED_off(0);
			TPR0_2 = b3_speed;
			//USBSTK5515_ULED_on(3);
		} 
	}
	
	LCD_disp_update(band_selection, band1_gain_selection, band2_gain_selection, band3_gain_selection);
	
	if (value == SW1 && band_selection == 0){
		USBSTK5515_ULED_on(0);
	}
}

void calculate_new_coef(){
	int i;
	if (band_selection == 1){
		for(i=0;i<TAPS;i++)
			band1_coef_changed[i]=(Int16)(((Int32)BAND1_COEF[i]*(Int32)band_gain_hex[band1_gain_selection])>>15);
	} else if (band_selection == 2){
		for(i=0;i<TAPS;i++)
			band2_coef_changed[i]=(Int16)(((Int32)BAND2_COEF[i]*(Int32)band_gain_hex[band2_gain_selection])>>15);
	} else if (band_selection == 3){
		for(i=0;i<TAPS;i++)
			band3_coef_changed[i]=(Int16)(((Int32)BAND3_COEF[i]*(Int32)band_gain_hex[band3_gain_selection])>>15);
	}
}

void band_mix(){
	int i;
	for(i=0;i<TAPS;i++)
		band_coef_mixed[i] = band1_coef_changed[i] + band2_coef_changed[i] + band3_coef_changed[i];
}




