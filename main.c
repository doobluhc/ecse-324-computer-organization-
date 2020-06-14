#include <stdio.h>
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switch.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/HPS.TIM.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/address_map_arm.h"

//convert to ascii
int toAscii(int input){
	if (input< 10) { 
		input = input + 48;
	} else { 
		input = input + 55;
	}

	return input;

}

int main(){


//--------------------------------Q1 basic i/o--------------------------
/*
	while (true) {
		write_LEDs_ASM(read_slider_switches_ASM());
		if(read_slider_switches_ASM() & 0x200){              
			HEX_clear_ASM(HEX0|HEX2|HEX1|HEX3|HEX4|HEX5);    

		}
		else{                                               
			HEX_flood_ASM(HEX4|HEX5);
			char value = (0xF & read_slider_switches_ASM()); 
			int pushbutton = (0xF & read_PB_data_ASM());     
			HEX_write_ASM(pushbutton, toAscii(value));       
		}                                                   
	}
*/

//******************************question 3 timer********************************
/*
// TIM0 is used to trigger the HEX display 
	HPS_TIM_config_t hps_tim;
	hps_tim.tim = TIM0;
	hps_tim.timeout = 1000000; //Timer 0 has a frequency of 100Mhz
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 0;
	hps_tim.enable = 1;
	HPS_TIM_config_ASM(&hps_tim); 


// TIM1 is used to poll the button
	HPS_TIM_config_t hps_tim_pb;
	hps_tim_pb.tim = TIM1;
	hps_tim_pb.timeout = 5000;
	hps_tim_timerStatus.LD_en = 1;
	hps_tim_pb.INT_en = 0;
	hps_tim_pb.enable = 1;
	HPS_TIM_config_ASM(&hps_tim_pb);

	int pb = 0;

// Initialize variables of the stop watch
	int centiSecond = 0; 
	int second = 0;
	int minute = 0;
	int timerStatus = 0;

	while(true) {
		if (HPS_TIM_read_INT_ASM(TIM0) && timerStatus) {  
			HPS_TIM_clear_INT_ASM(TIM0);            
			centiSecond += 1;                        

			if (centiSecond >= 100) {                
				centiSecond = centiSecond - 100; 
				second++;

				if (second >= 60) {
					second = second - 60;
					minute++;

					if (minute >= 60) {
						minute = 0;
					}
				}
			}


			//Write the time value into the LED
			HEX_write_ASM(HEX0, toAscii (centiSecond % 10));
			HEX_write_ASM(HEX1, toAscii (centiSecond / 10));
			HEX_write_ASM(HEX2, toAscii (second % 10) );
			HEX_write_ASM(HEX3, toAscii (second / 10));
			HEX_write_ASM(HEX4, toAscii (minute % 10) );
			HEX_write_ASM(HEX5, toAscii (minute / 10) );
		}

		// Poll from  the pushButton
		if (HPS_TIM_read_INT_ASM(TIM1)) {              
			HPS_TIM_clear_INT_ASM(TIM1);               
			int pb = 0xF & read_PB_edgecap_ASM();     
		
			if ((pb & 1) && (!timerStatus)) {               
				timerStatus = 1;                            
				PB_clear_edgecap_ASM(PB2|PB1);		   
				                                       


			} else if ((pb & 2) && (timerStatus)) {         // stop is pressed
				timerStatus = 0;                            
				PB_clear_edgecap_ASM(PB0);             


			} else if (pb & 4) {                       // restart is pressed
				centiSecond = 0;                       
				second = 0;
				minute = 0;
				timerStatus = 0; 	                       
				PB_clear_edgecap_ASM(PB0|PB1);		   
				HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, toAscii(0) ); // display "000000" on the LED
				
			}
		}
	}
*/
//----------------------------------------------------------------------------	




	int_setup(2, (int[]) {73, 199 });
	HPS_TIM_config_t hps_tim;
	hps_tim.tim = TIM0;
	hps_tim.timeout = 1000000;
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 0;
	hps_tim.enable = 1;
	HPS_TIM_config_ASM(&hps_tim);
	int isStarted=0;
	int centis = 0;
	int seconds = 0;
	int minutes = 0;

	enable_PB_INT_ASM(PB0 | PB1 | PB2);

	while (1) {
		
		if (hps_tim0_int_flag && isStarted) {
			hps_tim0_int_flag = 0;
			centis += 1; 
			if (centis >= 100) {
				centis -= 100;
				seconds++;
				
				if (seconds >= 60) {
					seconds -= 60;
					minutes++;
					
					if (minutes >= 60) {
						minutes = 0;
					}
				}
			}

			HEX_write_ASM(HEX0, toAscii(centis % 10));
			HEX_write_ASM(HEX1, toAscii(centis / 10));
			HEX_write_ASM(HEX2, toAscii(seconds % 10));
			HEX_write_ASM(HEX3, toAscii(seconds / 10));
			HEX_write_ASM(HEX4, toAscii(minutes % 10));
			HEX_write_ASM(HEX5, toAscii(minutes / 10));
		}

		//interuption generated when pb pressed
		if (pbIntFlag != 0){//start
			if(pbIntFlag == 1) 
				isStarted = 1;

			else if(pbIntFlag == 2) //stop
				isStarted = 0;

			else if(pbIntFlag == 4 ){ // reset
				centis = 0;
				seconds = 0;
				minutes = 0;

				HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, toAscii(0) ); // display "000000" on LED

				isStarted = 0;
			}
			pbIntFlag = 0;   
		}
	}

		return 0; // finish the program
}

