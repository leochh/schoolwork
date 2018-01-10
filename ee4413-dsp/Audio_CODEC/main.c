/*
 * FIR Implementation in C Project
 */

#include <usbstk5515.h>
#include <usbstk5515_i2c.h>
#include <AIC_func.h>
#include <stdio.h>
#include "firc.h"
#include "Dsplib.h"


void main(void)
{
	Uint16 i=0;
	Int16 right[1], left[1]; //AIC inputs
	Int16 out[1]; //AIC output
	Int16 coef[TAPS] = {
		#include "lpf.dat"
	};
	Int16 db[TAPS+2]={0};
	
	USBSTK5515_init(); 	//Initializing the Processor
	AIC_init(); 		//Initializing the Audio Codec
	while(1)
	{
		if(i>=TAPS) i=0;
		AIC_read2(right, left);
		fir(
		right, 
		coef,
		out, 
		db, 
		1, 
		TAPS);
		//r_right[0]=x_right[0]; //Audio Bypass
		// POSTFILTER:
		AIC_write2(out[0],out[0]);
		i++;
	}
}
