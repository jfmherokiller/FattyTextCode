//Keeps track of time////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Keeps track of time//

//Tells you if it's daytime or not
protected function dayTime():Boolean{
	if(hour >= 21 || hour <= 5){return false;}
	else{return true;}
}

//Returns either "sun" or "moon" depending on time of day. Used to better contextualize scenes based on time of day
protected function saySun():String{
	if(dayTime()){return "sun";}
	else{return "moon";}
}

//Returns the section of day, for use in scene descriptions
protected function timeOfDay():String{
	var timeString:String;
	switch(hour){
		case 0:
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 21:
		case 22:
		case 23:
			timeString = "night";
			break;
		case 6:
		case 7:
		case 8:
		case 9:
			timeString = "morning";
			break;
		case 10:
		case 11:
		case 12:
		case 13:
		case 14:
		case 15:
			timeString = "day";
			break;
		case 16:
		case 17:
		case 18:
		case 19:
		case 20:
			timeString = "evening";
			break;
	}
	return timeString;
}


//Moves time forward by the input number of minutes
protected function doTime(theTime:Number):void{
	doDigest(theTime);
	eventTime(theTime);
	
	//Advances minutes
	onesMinute += theTime;
	
	//Advances tens of minutes
	while(onesMinute > 9){
		tensMinute += 1;
		onesMinute -= 10;
		
		//Activates the player's regeneration buff
		if(tmagicREGENbuff > 0){
			doHealth( xdy(tmagicREGENbuffDamage,tmagicREGENbuffRange) + (INT * 0.4) );
			tmagicREGENbuff--;
			if(tmagicREGENbuff <= 0){
				tmagicREGENbuff = 0;
				tmagicREGENbuffDamage = 0;
				tmagicREGENbuffRange = 0;
			}
		}
	}
	
	//Advances hours
	while(tensMinute > 5){
		hour += 1;
		tensMinute -= 6;
		updateBackground();
	}
	
	//Advances days
	while(hour > 23){
		day += 1;
		hour -= 24;
	}
	
	//Updates the displayed hour based on a twelve hour clock
	displayHour = hour;
	while(displayHour > 12){displayHour -= 12;}
	if (displayHour == 0){displayHour = 12;}
	
	//Updates the displayed clock to whether it's in the AM or PM
	AMPM = (hour <= 11) ? "AM": "PM";
}

//Keeps track of timed events
protected function eventTime(theTime:int):void{
	
	//Stomach stretching from overfullness
	if(FUL > 100){
		statusStomachStretch += theTime;
		if (statusStomachStretch >= 120){
			scene("\n<i>You've spent so much time being full that your stomach has stretched out.</i> ",false);
			chgStats(0,0,0,0,1);
			statusStomachStretch -= 500;
		}
	}
	
	//Well fed bonus
	if(statusWellFed > 0){
		statusWellFed -= theTime;
		if(statusWellFed <= 0){
			statusWellFedPower = 0;
			statusWellFed = 0;
		}
	}
	
	
	//Stomach size buff
	if(statusSTOBuff > 0){
		statusSTOBuff -= theTime;
		if(statusSTOBuff <= 0){
			if(statusSTOBuffPower > 0){scene("<i>You suddenly feel less hungry.</i> ",false);}
			if(statusSTOBuffPower < 0){scene("<i>You suddenly feel more hungry.</i> ",false);}
			statusSTOBuff = 0;
			statusSTOBuffPower = 0;
			updateStats();
			//Tests you should explode from the buff wearing off or not and updates the buff accordingly
			if (FUL > maxFUL){
				if(maximumFullness() < ATE && ATE - maximumFullness() < 30){statusSTOBuffPower = ATE - maximumFullness();}
				if(maximumFullness() < ATE && ATE - maximumFullness() > 30){statusSTOBuffPower = 30};
				statusSTOBuff = 40;
				updateStats();
				if(eventText.htmlText.match("Fortunately the shrinking eventually stops before you explode") == null){
					scene("\n\tYou hear an ominous gurgling sound emanating from your stomach. " +
						"You look down as you're struck by the all too familiar sensation of growing fuller and fuller. " +
						"You quickly realize that the powers affecting your stomach are wearing off in spite of you exceeding your normal limits. " +
						"Fortunately the shrinking eventually stops before you explode, although you're stomach is still stretched to its absolute limit. " +
						"It seems the effects haven't completely worn off... yet. ",false);
				}
			}
		}
	}
	
	//Bloat venom
	if(statusBloatVenomPower > 0){
		statusBloatVenom += theTime;
		if(statusBloatVenom >= 30){
			if(ATE + statusBloatVenomPower < maximumFullness()+1){
				doInflate(statusBloatVenomPower,0);
				statusBloatVenomPower -= 0.5;
				statusBloatVenom %= 30;
				if(eventText.htmlText.match("You suddenly feel slightly more full due to the bloat venom") == null){
					scene("<i>You suddenly feel slightly more full due to the bloat venom</i> ",false);
				}
				if(statusBloatVenomPower <= 0){
					statusBloatVenomPower = 0;
					statusBloatVenom = 0;
					scene("<i>Fortunately, your head no longer feels fuzzy and it seems you're finally over the effect's of the bloat venom</i> ",false);
				}
			}
			else{
				doInflate(remainingCapacity(),0);
				statusBloatVenomPower -= 0.5;
				statusBloatVenom %= 30;
				if(eventText.htmlText.match("Your stomach creaks ominously as it grows ever more distended from the venom coursing through your veins. ") == null){
					scene("Your stomach creaks ominously as it grows ever more distended from the venom coursing through your veins. " +
						"Your stomach is stretched to the absolute bursting point and it's a miracle it hasn't exploded already. ",false);
				}
			}
		}
	}
	
	//Strength buffs
	if(statusSTRBuff > 0){
		statusSTRBuff -= theTime;
		if(statusSTRBuff <= 0){
			if(statusSTRBuffPower > 0){scene("<i>You no longer feel as strong.</i> ",false);}			
			if(statusSTRBuffPower < 0){scene("<i>You no longer feel as weak!</i> ",false);}	
			statusSTRBuff = 0;
			statusSTRBuffPower = 0;
		}
	}
	
	//Agility buffs
	if(statusAGIBuff > 0){
		statusAGIBuff -= theTime;
		if(statusAGIBuff <= 0){
			if(statusAGIBuffPower > 0){scene("<i>You no longer feel as fast.</i> ",false);}			
			if(statusAGIBuffPower < 0){scene("<i>You no longer feel as slow!</i> ",false);}			
			statusAGIBuff = 0;
			statusAGIBuffPower = 0;
		}
	}
	
	//Intelligence buffs
	if(statusINTBuff > 0){
		statusINTBuff -= theTime;
		if(statusINTBuff <= 0){
			if(statusINTBuffPower > 0){scene("<i>You no longer feel as smart.</i> ",false);}			
			if(statusINTBuffPower < 0){scene("<i>You no longer feel as stupid!</i> ",false);}			
			statusINTBuff = 0;
			statusINTBuffPower = 0;
		}
	}
	
	//Endurance buffs
	if(statusENDBuff > 0){
		statusENDBuff -= theTime;
		if(statusENDBuff <= 0){
			if(statusENDBuffPower > 0){scene("<i>You no longer feel as tough.</i> ",false);}
			if(statusENDBuffPower < 0){scene("<i>You no longer feel as sickly!</i> ",false);}
			statusENDBuff = 0;
			statusENDBuffPower = 0;
		}
	}
	
	//Mana buffs
	if(statusMANABuff > 0){
		statusMANABuff -= theTime;
		if(statusMANABuff <= 0){
			if(statusMANABuffPower > 0){scene("<i>You no longer feel as empowered.</i> ",false);}
			if(statusMANABuffPower < 0){scene("<i>You no longer feel as disempowered!</i> ",false);}
			statusMANABuff = 0;
			statusMANABuffPower = 0;
		}
	}
	
}

//Returns how much stamina an action would cost based on your stats
protected function staminaCost(ID:Number):Number{ return (ID * Math.pow(0.8,END/40)); }

//Gain/spend input amount of stamina based on stats
protected function doStamina(resting:Number):void{
	if (resting > 0){
		doArrow("STAup");
		STA += resting;
	}
	if (resting < 0){
		doArrow("STAdown");
		STA += resting * Math.pow(0.8,END/40);
	}
	if (STA < 0){STA = 0;}
	if (STA > 100){STA = 100;}
}

//Does travel time, digestion, and exhaustion
protected function doWalk(walkFor:Number):void{
	//Calculates what plateau yours tats are on
	var strengthLevel:Number = ( (ATE/2) + (FAT/5) ) / STR;
	var agilityLevel:Number = (AGI/40) - strengthLevel;
	
	//Expends amount of stamina based on how strong you are
	if(strengthLevel > 20){strengthLevel = 20;}
	doStamina((-walkFor) * Math.pow(1.25,strengthLevel));
	
	//Expends time based on how fast you are
	if(agilityLevel < -20){agilityLevel = -20;}
	if(agilityLevel > 20){agilityLevel = 20;}
	var timeTraveled:Number = walkFor * Math.pow(0.8,agilityLevel);
	//Makes sure traveling always takes at least some amount of time
	if(timeTraveled <= 1){timeTraveled = 1;}
	doTime(timeTraveled);
}

//Food and digestion///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Food and digestion//
//Digests food for the input amount of time
protected function doDigest(digestFor:Number):void{
	fixFull();
	
	//Stores what your stats start out at to be referenced later in this function
	var digested:Number = ATE;
	var fatness:Number = FAT;
	
	//Calculates the rate at which you should digest food based on the size of your stomach
	var digestionRate:Number = (STO * .75)/1440;
	var tempInt:int;
	
	//Removes an amount of food/drink based on how fast you digest such that food/drink remains at the same ratio to each other
	if(Eaten < Drank){
		tempInt = Eaten / Drank;
		Eaten -= (digestFor * digestionRate) * tempInt;
		Drank -= (digestFor * digestionRate) * (1 - tempInt);
	}
	else if(Eaten > Drank){
		tempInt = Drank / Eaten;
		Eaten -= (digestFor * digestionRate) * (1 - tempInt);
		Drank -= (digestFor * digestionRate) * tempInt;
	}
	else if(Eaten == Drank){
		Eaten -= (digestFor * digestionRate * .5);
		Drank -= (digestFor * digestionRate * .5);
	}
	
	//Deflates the player
	var deflationRate:Number = digestFor * 0.1;
	var deflatedAmount:Number = Inflated;
	Inflated -= deflationRate;
	if(Inflated <= 0){
		Inflated = 0;
		InflatedMass = 0;
	}
	if(deflatedAmount != 0){InflatedMass *= Inflated/deflatedAmount;}
	
	//Prevents the amount you've eaten/drank from going negative
	if(Eaten <= 0){Eaten = 0}
	if(Drank <= 0){Drank = 0}
	
	doArrow("FULdown");
	updateStats();
	
	//Burns fat
	doFat(-0.004 * digestFor);
	
	//Restores mana
	var startMana:Number = MANA;
	doMana(maxMANA * .00417 * digestFor);
	FAT -=  (MANA - startMana) * 0.25;
	
	//Gains fat based on how much of what you've consumed you've digested and how many calories you had stored up
	digested = (digested - ATE) / digested;
	if(digested > 0){doWeight(digested);}
	
	//Displays the relevant arrows based on wether you've gained or lost weight since the beginning of this function
	if(fatness < FAT){doArrow("FATup")}
	if(fatness > FAT){doArrow("FATdown")}
	
	//Prevents fat or calories from going negative
	if(FAT <= 0){FAT = 0;}
	if(Calories <= 0){Calories = 0;}
}

//Converts stored calories into fat based on how much of your stomach contents you just digested
protected function doWeight(digested:Number):void{
	var caloriesDigesting:Number = digested * Calories;
	Calories -= caloriesDigesting;
	doFat(caloriesDigesting);
}

//Consumes food/drink and add calories
protected function doConsume(ate:Number,drink:Number,calory:Number):void{
	Eaten += ate;
	Drank += drink;
	Calories += calory;
	updateStats();
	
	//Displays warnings for being overstuffed
	if ((maxFUL - FUL) < 10 && eventText.htmlText.match("You feel like you'll explode if you get any fuller") == null){scene("<i>(You feel like you'll explode if you get any fuller.)</i> ",false)};
	if ((maxFUL - FUL) < 20 && (maxFUL - FUL) >= 10 && eventText.htmlText.match("Your stomach feels painfully distended") == null){scene("<i>(Your stomach feels painfully distended.)</i> ",false)};
	if ((maxFUL - FUL) > 20 && FUL > 100 && eventText.htmlText.match("You're so full it hurts") == null){scene("<i>(You're so full it hurts.)</i> ",false)};
	
	//Displays appropriate arrows
	if(ate + drink > 0){doArrow("FULup")}
	if(ate + drink < 0){doArrow("FULdown")}
}

//Consumes food without displaying notices
protected function doConsumeQuiet(ate:Number,drink:Number,calory:Number):void{
	Eaten += ate;
	Drank += drink;
	Calories += calory;
	updateStats();
	
	if(ate + drink > 0){doArrow("FULup")}
	if(ate + drink < 0){doArrow("FULdown")}
}

//Get inflated by the input volume and input weight
protected function doInflate(inflate:Number,weight:Number):void{
	Inflated += inflate;
	InflatedMass += weight;
	updateStats();
	
	//Displays warnings for being overinflated
	if ((maxFUL - FUL) < 10 && eventText.htmlText.match("You feel like you'll explode if you get any fuller") == null){scene("<i>(You feel like you'll explode if you get any fuller.)</i> ",false)};
	if ((maxFUL - FUL) < 20 && (maxFUL - FUL) >= 10 && eventText.htmlText.match("Your stomach feels painfully distended") == null){scene("<i>(Your stomach feels painfully distended.)</i> ",false)};
	if ((maxFUL - FUL) > 20 && FUL > 100 && eventText.htmlText.match("You're so full it hurts") == null){scene("<i>(You're so full it hurts.)</i> ",false)};
	
	//Displays appropriate arrows
	if(inflate > 0){doArrow("FULup")}
	if(inflate < 0){doArrow("FULdown")}
}