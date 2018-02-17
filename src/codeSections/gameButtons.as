//Functions that tell the game which of the main decision making buttons you've pressed
/*Button order as they appear on the screen
[1][2][3]
[4][5][6]
[7][8][9]
[11][12][13]
Note: there is no button 10*/
protected function btn1():void{
	btnchc = 1;
	listen();}
protected function btn2():void{
	btnchc = 2;
	listen();}
protected function btn3():void{
	btnchc = 3;
	listen();}
protected function btn4():void{
	btnchc = 4;
	listen();}
protected function btn5():void{
	btnchc = 5;
	listen();}
protected function btn6():void{
	btnchc = 6;
	listen();}
protected function btn7():void{
	btnchc = 7;
	listen();}
protected function btn8():void{
	btnchc = 8;
	listen();}
protected function btn9():void{
	btnchc = 9;
	listen();}

protected function dec1():void{
	btnchc = 11;
	listen();}
protected function dec2():void{
	btnchc = 12;
	listen();}
protected function dec3():void{
	btnchc = 13;
	listen();}

//Function for the rest/level button
protected function restLvl():void{
	if (LVLup > 0){doLevel();}
	else if (LVLup == 0){doRest();}}

//Variables for the button's text
[Bindable] protected var buttonLabel1:String;
[Bindable] protected var buttonLabel2:String;
[Bindable] protected var buttonLabel3:String;
[Bindable] protected var buttonLabel4:String;
[Bindable] protected var buttonLabel5:String;
[Bindable] protected var buttonLabel6:String;
[Bindable] protected var buttonLabel7:String;
[Bindable] protected var buttonLabel8:String;
[Bindable] protected var buttonLabel9:String;

[Bindable] protected var buttonLabeldec1:String;
[Bindable] protected var buttonLabeldec2:String;
[Bindable] protected var buttonLabeldec3:String;

//Variables for the button's visibility
[Bindable] protected var buttonVisible1:Boolean;
[Bindable] protected var buttonVisible2:Boolean;
[Bindable] protected var buttonVisible3:Boolean;
[Bindable] protected var buttonVisible4:Boolean;
[Bindable] protected var buttonVisible5:Boolean;
[Bindable] protected var buttonVisible6:Boolean;
[Bindable] protected var buttonVisible7:Boolean;
[Bindable] protected var buttonVisible8:Boolean;
[Bindable] protected var buttonVisible9:Boolean;

[Bindable] protected var buttonVisibledec1:Boolean;
[Bindable] protected var buttonVisibledec2:Boolean;
[Bindable] protected var buttonVisibledec3:Boolean;

//Sets the input button # to the input icons
protected function buttonIcons(buttonNumber:int,buttonIcon:Class):void{
	switch(buttonNumber){
		case 1:
			button1.setStyle("icon",buttonIcon);
			break;
		case 2:
			button2.setStyle("icon",buttonIcon);
			break;
		case 3:
			button3.setStyle("icon",buttonIcon);
			break;
		case 4:
			button4.setStyle("icon",buttonIcon);
			break;
		case 5:
			button5.setStyle("icon",buttonIcon);
			break;
		case 6:
			button6.setStyle("icon",buttonIcon);
			break;
		case 7:
			button7.setStyle("icon",buttonIcon);
			break;
		case 8:
			button8.setStyle("icon",buttonIcon);
			break;
		case 9:
			button9.setStyle("icon",buttonIcon);
			break;
		case 11:
			decision1.setStyle("icon",buttonIcon);
			break;
		case 12:
			decision2.setStyle("icon",buttonIcon);
			break;
		case 13:
			decision3.setStyle("icon",buttonIcon);
			break
	}
}

//Clears which button you previously chose
//This function mainly exists to make sure the game doesn't loop through several decisions accidentally
//I'm entirely not sure if this function even needs to exist.
protected function clrchc():void{ btnchc = 0; }

//Clears off the text on the buttons
protected function clrBtnTxt():void{ for(i=1;i<=9;i++){ btntxt(i,""); } }

//Writes the input text on the input button number
protected function btntxt(buttonNumber:int, buttonText:String):void{
	switch(buttonNumber){
		case 1:
			buttonLabel1 = buttonText; 
			buttonVisible1 = true;
			break;
		case 2:
			buttonLabel2 = buttonText; 
			buttonVisible2 = true;
			break;
		case 3:
			buttonLabel3 = buttonText; 
			buttonVisible3 = true;
			break;
		case 4:
			buttonLabel4 = buttonText; 
			buttonVisible4 = true;
			break;
		case 5:
			buttonLabel5 = buttonText; 
			buttonVisible5 = true;
			break;
		case 6:
			buttonLabel6 = buttonText; 
			buttonVisible6 = true;
			break;
		case 7:
			buttonLabel7 = buttonText; 
			buttonVisible7 = true;
			break;
		case 8:
			buttonLabel8 = buttonText; 
			buttonVisible8 = true;
			break;
		case 9:
			buttonLabel9 = buttonText; 
			buttonVisible9 = true;
			break;
		case 11:
			buttonLabeldec1 = buttonText;
			buttonVisibledec1 = true;
			break;
		case 12:
			buttonLabeldec2 = buttonText;
			buttonVisibledec2 = true;
			break;
		case 13:
			buttonLabeldec3 = buttonText;
			buttonVisibledec3 = true;
			break;
	}
}

//Changes the visibility of the miscellaneous action buttons ()rest,inventory,etc.)
//These buttons often need to be turned off to prevent the player from getting stuck by going to a menu that overwrites the buttons
//This is largely relevant in the middle of events
protected function appView(viewAppButtons:int):void{
	if(viewAppButtons == 1){appButtonVisibility = true;}
	else{appButtonVisibility=false;}
}

//Changes the visibility of the inventory buttons
protected function invView(buttonsOn:int):void{
	if(buttonsOn == 1){inventoryPanel.visible = true;}
	else{inventoryPanel.visible = false;}
}

//Clears out a specific input button
protected function clearButton(ID:int):void{
	switch(ID){
		case 1:
			buttonLabel1 = ""; 
			buttonVisible1 = false;
			button1.setStyle("icon",null);
			break;
		case 2:
			buttonLabel2 = ""; 
			buttonVisible2 = false;
			button2.setStyle("icon",null);
			break;
		case 3:
			buttonLabel3 = ""; 
			buttonVisible3 = false;
			button3.setStyle("icon",null);
			break;
		case 4:
			buttonLabel4 = ""; 
			buttonVisible4 = false;
			button4.setStyle("icon",null);
			break;
		case 5:
			buttonLabel5 = ""; 
			buttonVisible5 = false;
			button5.setStyle("icon",null);
			break;
		case 6:
			buttonLabel6 = ""; 
			buttonVisible6 = false;
			button6.setStyle("icon",null);
			break;
		case 7:
			buttonLabel7 = ""; 
			buttonVisible7 = false;
			button7.setStyle("icon",null);
			break;
		case 8:
			buttonLabel8 = ""; 
			buttonVisible8 = false;
			button8.setStyle("icon",null);
			break;
		case 9:
			buttonLabel9 = ""; 
			buttonVisible9 = false;
			button9.setStyle("icon",null);
			break;
		case 11:
			buttonLabeldec1 = "";
			buttonVisibledec1 = false;
			decision1.setStyle("icon",null);
			break;
		case 12:
			buttonLabeldec2 = "";
			buttonVisibledec2 = false;
			decision2.setStyle("icon",null);
			break;
		case 13:
			buttonLabeldec3 = "";
			buttonVisibledec3 = false;
			decision3.setStyle("icon",null);
			break;		
	}
}

//Clears all 9 actions buttons
protected function clearTextView():void{
	buttonVisible1 = false;
	buttonVisible2 = false;
	buttonVisible3 = false;
	buttonVisible4 = false;
	buttonVisible5 = false;
	buttonVisible6 = false;
	buttonVisible7 = false;
	buttonVisible8 = false;
	buttonVisible9 = false;
	button1.setStyle("icon",null);
	button2.setStyle("icon",null);
	button3.setStyle("icon",null);
	button4.setStyle("icon",null);
	button5.setStyle("icon",null);
	button6.setStyle("icon",null);
	button7.setStyle("icon",null);
	button8.setStyle("icon",null);
	button9.setStyle("icon",null);
}

//Clears all 3 decision buttons
protected function clearDecisionView():void{
	buttonVisibledec1 = false;
	buttonVisibledec2 = false;
	buttonVisibledec3 = false;
	decision1.setStyle("icon",null);
	decision2.setStyle("icon",null);
	decision3.setStyle("icon",null);
}

//clears all buttons and the decision variable
protected function clearView():void{
	clearTextView();
	clearDecisionView();
	clrchc();
}

//Displays "Next" button
protected function nextView():void{
	clearView();
	appView(0);
	btntxt(12,"Next");
}

//Displays next button and sets the default "Next" function
protected function nextButton():void{
	nextView();
	listen = function():void{ if(btnchc == 12){doNext();} }
}

//Displays "Yes" button on the input button #
protected function yesView(ID:int):void{
	btntxt(ID,"Yes");
}

//Displays "No" button on the input button #
protected function noView(ID:int):void{
	btntxt(ID,"No");
}

//Displays Yes/No buttons
protected function choiceButton():void{
	clearView();
	appView(0);
	yesView(11);
	noView(13);
}

//Displays return button on the input button #
protected function returnView(ID:int):void{
	btntxt(ID,"Return");
}

//Displays "Up" button for inventory/spell pages
protected function upView():void{
	btntxt(11,"Page up");
}

//Displays "Down" button for inventory/spell pages
protected function downView():void{
	btntxt(13,"Page down");
}

//Displays "Up"/"Down" button
protected function pageView():void{
	upView();
	downView();
}

//Sets a "leave" button to the input button #
protected function leaveButton(buttonNumber:int):void{
	btntxt(buttonNumber,"Leave");
}

//Sets a "Buy" button to the input button #
protected function tradeButton(buttonNumber:int):void{
	btntxt(buttonNumber,"Trade");
}

//The default function for the "Next" button for general purpose use
protected function doNext():void{
	switch(currentState){
		case "inventory":
			doInventory();
			break;
		case "combat":
			doBattle();
			break;
		case "default":
			general();
			break;
		case "defeated":
			doDefeat();
			break;
	}
}

//Leaves the various other states and returns to the default state in a way that prevents errors
protected function leaveMisc():void{
	switch(currentState){
		case "combatInventory":
			currentState = "combat";
			doBattle();
			break;
		case "storage":
			doEvent(YourHouse);
			depositing = true;
			depositLabel = "Depositing";
			currentState = "default";
			break;
		case "inventory":
			general();
			discarding = false;
			keyItems = false;
			discardLabel = "Using";
			currentState = "default";
			break;
		case "spells":
			general();
			currentState = "default";
			break;
		case "combatSpells":
			currentState = "combat";
			doBattle();
			break;
		case "options":
			currentState = "default";
			if(newGame == true){introduction();}
			else{
				if(location == YourHouse){
					specialEvent = 1;
					subEvent = "";
					locationUpdate(YourHouse);
					doEvent(YourHouse);
				}
				else{general();}
			}
			break;
		default:
			currentState = "default";
			break;
	}
	invPage = 1;
}