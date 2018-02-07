import flash.display.Scene;

import flashx.textLayout.events.StatusChangeEvent;

import valueObjects.Items;
import valueObjects.Species;
import valueObjects.Spells;
import valueObjects.Vendors;


//Executes an items effect and displays the relevant event text based on the input item
protected function doUseItem(ID:Items):void{
	
	//Differentiates how the scene is displayed between being in combat or not
	if(currentState != "combatInventory"){scene("",true);}
	if(currentState == "combatInventory"){
		combatDialogue();
		scene("<li><b>Item</b></li>",false);
	}
	
	//Executes the standard healing/eating components of the input item
	if(ID.Heal != 0){doHealth(ID.Heal);}
	if(ID.Mana != 0){doMana(ID.Mana);}
	if(ID.Stamina != 0){doStamina(ID.Stamina);}
	if(ID.eat != 0 || ID.drink != 0){doConsume(ID.eat,ID.drink,ID.Calories);}
	
	//Displays the text associated with using the item
	switch(ID.itemUse){
		case "You used the item! ":
			//Better contextualizes items with only the default itemUse scene set
			if (ID.Food == true){scene("You ate the "+ID.Name+"! ",false);}
			if (ID.Drink == true){scene("You drank the "+ID.Name+"! ",false);}
			if (ID.Weapon == true || ID.Armor == true || ID.Top == true || ID.Bottom == true){scene("You equipped the "+ID.Name+"! ",false);}
			break;
		default:
			//Displays scene for items that have custom itemUse descriptions
			switch(ID.eat > 0 || ID.drink > 0){
				case true:
					//Differntiate scenes on if you overate and exploded or not
					if(!alive() && !inCombat()){
						scene("\n\t"+ID.overfilled,false);
					}
					else{ scene(ID.itemUse,false); }
					break;
				default:
					//Displays scene for any item not already covered
					scene(ID.itemUse,false);
					break;
			}		
			break;
	}
	
		
	//Executes function for equipping items and displays any further relevant scenes. Also returns unequipped items if anything was previously equipped
	if(ID.Weapon == true){
		if(WEA.Name != "fists"){getItem(WEA);}
		WEA = ObjectUtil.copy(ID) as Items;
	}
	
	if(ID.Armor == true){
		if(ARM.Name != "unarmored"){getItem(ARM);}
		ARM = ObjectUtil.copy(ID) as Items;
	}
	
	if(ID.Top == true){
		if (ID.Expand <= waistDiameter() && ID.Expand > 0){
			scene(ID.Toosmall,true);
			getItem(ID);
		}
		else{
			if(TOP.Name != "naked chest"){getItem(TOP);}
			TOP = ObjectUtil.copy(ID) as Items;
		}
	}
	
	if(ID.Bottom == true){
		if (ID.Expand <=  waistDiameter() && ID.Expand > 0){
			scene(ID.Toosmall,true);
			getItem(ID);
		}
		else{
			if(BTM.Name != "naked legs"){getItem(BTM);}
			BTM = ObjectUtil.copy(ID) as Items;
		}
	}
	
	
	//If you've overeaten to the point of hitting 0 health, sends you to the defeat event
	if(ID.eat > 0 || ID.drink > 0){ if(!alive() && !inCombat()){ defeatEvent(overeating); } }
	
	//update stats to reflect whatever effect the items had
	updateStats();
	
	//Sets up what's supposed to happen after you used an item depending on what state you're in and if using the item caused you to be defeated
	if (currentState != "combatInventory" && currentState != "defeated"){doNext();}
	if (currentState == "defeated"){nextButton();}
	if (currentState == "combatInventory"){
		currentState = "combat";
		scene("\n",false);
		enemyAttack();
		if (eHEA > 0 && inCombat()){nextButton();}
	}
}

//Displays an items description when you view an item
protected function itemDescribe(ID:Items):void{
	
	//Name
	scene("<b>"+capFirst(ID.Name)+":</b><i>",false);
	
	//Physical description
	if(ID.Top || ID.Bottom){
		switch(ID.Popped){
			case true:
				scene("\n\t"+ID.PoppedDescription,false);
				break;
			default:
				scene("\n\t"+ID.Description,false);
				break;
		}
	}
	if(!ID.Top && !ID.Bottom){ scene("\n\t"+ID.Description,false); }
	
	//Item categories
	scene("\n\t"+buyValue(ID)+" gold",false);
	if(ID.type != "" && ID.type != "other"){scene(", "+ID.type,false);} 
	if(ID.Consume){
		if(ID.Weapon || ID.Armor || ID.Top || ID.Bottom){scene(", equippable",false);}
		else{scene(", consumable",false);}
	}
	
	//Weapon stats
	if(ID.WEAd > 0){
		scene("\n\tDeals "+ID.WEAd+"d"+ID.WEAr+" +"+int(ID.damageScaling*100)+"% "+ID.damageStat+" "+ID.damageType.name+" damage. ",false);
		switch(ID.attackProc){
			case "stun":
				scene("\n\tHas a "+ID.attackProcChance+"% chance to stun your enemy when you deal damage with this weapon. ",false);
				break;
			case "drain":
				scene("\n\tHas a "+ID.attackProcChance+"% chance to restore "+int(ID.attackProcPower)+"% of the damage dealt by this weapon as health. ",false);
				break;
		}
	}
	
	//Armor stats
	if(ID.Defense > 0){
		scene("\n\tIncreases defense by "+ID.Defense+". ",false);
		switch(ID.damageStat){
			case "AGI":
			case "STR":
			case "INT":
				scene("\n\tIncreases damaging scaling of "+ID.damageStat+" based weapons by "+int(ID.damageScaling*100)+"%. ",false);
				break;
		}
	}
	
	//Stat buffs
	if(ID.agiBuff != 0 || ID.strBuff != 0 || ID.endBuff != 0 || ID.intBuff != 0 || ID.manaBuff != 0 || ID.healthBuff != 0){ scene("\n\t",false); }
	if(ID.agiBuff > 0){scene(" Agi +"+ID.agiBuff,false);}
	if(ID.agiBuff < 0){scene(" Agi "+ID.agiBuff,false);}
	if(ID.strBuff > 0){scene(" Str +"+ID.strBuff,false);}
	if(ID.strBuff < 0){scene(" Str "+ID.strBuff,false);}
	if(ID.endBuff > 0){scene(" End +"+ID.endBuff,false);}
	if(ID.endBuff < 0){scene(" End "+ID.endBuff,false);}
	if(ID.intBuff > 0){scene(" Int +"+ID.intBuff,false);}
	if(ID.intBuff < 0){scene(" Int "+ID.intBuff,false);}
	if(ID.manaBuff > 0){scene(" Max Mana +"+ID.manaBuff,false);}
	if(ID.manaBuff < 0){scene(" Max Mana "+ID.manaBuff,false);}
	if(ID.healthBuff > 0){scene(" Max Health +"+ID.healthBuff,false);}
	if(ID.healthBuff < 0){scene(" Max Health "+ID.healthBuff,false);}
	
	//Stat restoration
	if(ID.Heal > 0 || ID.Mana > 0 || ID.Stamina > 0){
		scene("\n\tRestores: ",false);
		if(ID.Heal > 0){scene(ID.Heal+" health ",false);}
		if(ID.Mana > 0){scene(ID.Mana+" mana ",false);}
		if(ID.Stamina > 0){scene(ID.Stamina+" stamina ",false);}
	}
	
	scene("</i>",false);
}

//finds an item in your inventory and returns its location in the appropriate array
protected function itemFind(ID:Items):int{
	var hasItem:int = -1;
	switch(ID.Quest){
		case true:
			//searches for quest items
			for(i=0;i<keyInvArray.length;i++){
				var testKeyItem:Items = keyInvArray[i];
				if(ID.Name == testKeyItem.Name){hasItem = i;}
			}
			break;
		default:
			//searches for regular items
			for(i=0;i<invArray.length;i++){
				var testItem:Items = invArray[i];
				if(ID.Name == testItem.Name){hasItem = i;}
			}
			break;
	}
	return hasItem;
}

//Tells if you have the item in your inventory or not
protected function itemOwned(ID:Items):Boolean{
	var itemFound:Boolean = false;
	if(itemFind(ID) > -1){itemFound = true;}
	return itemFound;
}

//Expends a charge for an item and removes that item from your inventory if the charges hit 0
protected function expendItem(ID:Items):void{
	var expendedItem:Items = ObjectUtil.copy(ID) as Items;
	expendedItem.Charges--;
	switch(expendedItem.Charges > 0){
		case true:
			invArray.splice(invArray.indexOf(ID),1,expendedItem);
			break;
		default:
			invArray.splice(invArray.indexOf(ID),1);
			break;
	}
}

//Removes input item from your appropriate inventory
protected function removeItem(ID:Items):void{
	if(itemOwned(ID)){
		switch(ID.Quest){
			case true:
				keyInvArray.splice(itemFind(ID),1);
				break;
			default:
				invArray.splice(invArray.indexOf(ID),1);
				break;
		}
	}
}

//Returns the index of an item you can stack the nput item on to
protected function testStackItem(ID:Items):int{
	var hasItem:int = -1;
	for(i=0;i<invArray.length;i++){
		var invItem:Items = invArray[i];
		if(ID.Name == invItem.Name && invItem.Charges + ID.Charges <= invItem.StackLimit){hasItem = i;}
	}
	return hasItem;
}

//Tests to see if there is somewhere in your inventory you can stack the item
protected function canStackItem(stackItem:Items):Boolean{
	var canStack:Boolean = false;
	if(testStackItem(stackItem) > -1){canStack = true;}
	return canStack;
}

//Stacks the input item into your inventory wherever it's capable of stacking
protected function stackItem(ID:Items,charges:int):void{
	var stackingItem:Items = ObjectUtil.copy(ID) as Items;
	stackingItem.Charges += charges;
	invArray.splice(invArray.indexOf(ID),1,stackingItem);
}

//Forces you to get an item even if your inventory is full. Mostly used to prevent players from getting stuck in the "inventory too full" dialogue if you receive an item in the middle of an event
protected function forceGetItem(ID:Items):void{
	scene("<li>You got "+ID.article+" "+ID.Name+"!</li>",false);
	switch(ID.Quest){
		case true:
			var keyItem:Items = ObjectUtil.copy(ID) as Items;
			keyInvArray.push(keyItem);
			break;
		default:
			switch(canStackItem(ID)){
				case true:
					//Stacks the item if possible
					if(canStackItem(ID)){stackItem(invArray[testStackItem(ID)],ID.Charges);}
					break;
				case false:
					//Adds item to inventory if possible
					var inventoryItem:Items = ObjectUtil.copy(ID) as Items;
					invArray.push(inventoryItem);
					break;
			}
			break;
	}
}

//Function that gives the player the input item
protected function getItem(ID:Items):void{
	scene("<li>You got "+ID.article+" "+ID.Name+"!</li>",false);
	
	switch(ID.Quest){
		case true:
			//Receive quest items
			var keyItem:Items = ObjectUtil.copy(ID) as Items;
			keyInvArray.push(keyItem);
			break;
		default:
			//Stacks the item in your inventory if possible
			if(canStackItem(ID)){stackItem(invArray[testStackItem(ID)],ID.Charges);}
				
			//Adds item to inventory if possible
			else if(invArray.length < maxInv){
				var inventoryItem:Items = ObjectUtil.copy(ID) as Items;
				invArray.push(inventoryItem);
			}
				
			//Discard dialogue if inventory is too full
			else{
				clearView();
				appView(0);
				scene("Unfortunately you don't have room in your inventory. Do you want to discard this item or discard another item", false);
				if (ID.Consume == false || ID.Useable == false){ scene("? ", false); }
				if (ID.Consume){
					scene(", or use this now? ", false);
					btntxt(13,"Use this now");
				}
				btntxt(11,"Discard this");
				btntxt(12,"Discard another");
				listen = function():void{
					switch(btnchc){
						case 11:
							//Causes the player to move on without the item
							doNext();
							break;
						case 12:
							//Brings up the dialogue to choose an item to discard
							clearView();
							itemButtons();
							pageView();
							listen = function():void{
								if (btnchc > 0 && btnchc < 10) {
									removeItem(invArray[(btnchc - 1)+((invPage-1)*9)]);
									getItem(ID);
									doNext();
								}
								if (btnchc == 11){
									if(invPage > 1){invPage--;}
									itemButtons();
								}
								if (btnchc == 13){
									if(invPage < invArray.length / 9){invPage++;}
									itemButtons();
								}
							}
							break;
						case 13:
							//Causes the player to immediately use the item that they just attempted to receive
							doUseItem(ID);
							break;
					}
				}
			}
			break;
	}
}

//Displays the key item inventory
protected function doKeyInventory():void{
	clearView();
	invView(0);
	invPage = 1;
	
	//Resets the selected item. selectedItem is used to tell the game which item you selected when it brings up the "Are you sure you want to use this item?" dialogue
	selectedItem = null;
	
	//Alphabetizes the key item inventory
	keyInvArray.sortOn("Name",Array.CASEINSENSITIVE);
	
	//Writes the useable key items to the buttons
	for(i = ((invPage - 1) * 9);i < invPage * 9;i++){
		var tempKeyItemWrite:Items = keyInvArray[i];
		if(tempKeyItemWrite != null){
			writeItems(i,tempKeyItemWrite);
		}
	}
	btntxt(12,"Normal inventory");
	
	listen = function():void{
		switch(btnchc){
			case 1:
			case 2:
			case 3:
			case 4:
			case 5:
			case 6:
			case 7:
			case 8:
			case 9:
				if(keyInvArray[(btnchc - 1)+((invPage-1)*9)] != null){
					selectedItem = keyInvArray[(btnchc - 1)+((invPage-1)*9)];
					scene("<b>"+capFirst(selectedItem.Name)+"</b>: \n\t"+selectedItem.Description,true);
					switch(selectedItem.Useable){
						case true:
							scene("\n\nAre you sure you want to use this item? ",false);
							yesView(11);
							break;
						default:
							buttonVisibledec1 = false;
							decision1.setStyle("icon",null);
							break;
					}
				}
				break;
			case 11:
				//Displays the scene for the appropriate key item and executes whatever effect the item is supposed to cause
				scene("\t",true);
				switch(selectedItem.Name){
					
				}
				break;
			case 12:
				//leaves the key item inventory page and returns to the normal inventory
				keyItems = false;
				doInventory();
				break;			
		}
	}
}

//Displays your inventory
protected function doInventory():void{
	updateStats();
	clearView();
	appView(0);
	
	//Resets the selected item. selectedItem is used to tell the game which item you selected when it brings up the "Are you sure you want to use this item?" dialogue
	selectedItem = null;
	
	//Alphebetizes inventory
	invArray.sortOn("Name",Array.CASEINSENSITIVE);
	
	//Moves you to the correct state based on wether you're in combat or not
	if(inCombat()){currentState = "combatInventory";}
	if(!inCombat()){currentState = "inventory";}
	
	invView(1);
	
	listen = function():void{
		switch(discarding){
			case true:
				//Discards the item you've clicked on
				switch(btnchc){
					case 1:
					case 2:
					case 3:
					case 4:
					case 5:
					case 6:
					case 7:
					case 8:
					case 9:
						if(invArray[(btnchc - 1)+((invPage-1)*9)] != null){
							selectedItem = invArray[(btnchc - 1)+((invPage-1)*9)];
							if(!inCombat()){scene("",true);}
							if(inCombat()){combatDialogue();}
							itemDescribe(selectedItem);
							scene("\nAre you sure you want to discard this item? ",false);
							yesView(11);
						}
						break;
					case 11:
						if(selectedItem != null){
							removeItem(selectedItem);
							doInventory();
						}
						break;
					
				}
				break;
			case false:
				//Asks if you want to use the item you clicked on
				switch(btnchc){
					case 1:
					case 2:
					case 3:
					case 4:
					case 5:
					case 6:
					case 7:
					case 8:
					case 9:
						if(invArray[btnchc - 1+((invPage-1)*9)] != null){
							
							//Records which item you've selected so that this function now which item you attempting to use
							selectedItem = invArray[btnchc-1+((invPage-1)*9)];
							
							//Properly displays the item description based on if you're in combat or not
							if(!inCombat()){scene("",true);}
							if(inCombat()){combatDialogue();}
							itemDescribe(selectedItem);
							
							if(selectedItem.Useable){
								scene("\nAre you sure you want to use this item? ",false);
								//Displays warning before you eat something that might cause you to explode
								if(selectedItem.eat + selectedItem.drink > remainingCapacity() && selectedItem.eat + selectedItem.drink > 0){scene("You're already "+hungry()+". ",false);}
								yesView(11);
							}
							if(!selectedItem.Useable){ clearButton(11); }
						}
						break;
					case 11:
						if(selectedItem != null){
							//Removes a charge from the item and then executes the effects of the item, if you have an item selected
							if(selectedItem.Consume){expendItem(selectedItem);}
							doUseItem(selectedItem);
						}
						break;
					case 12:
						//Switches to the key item inventory
						discarding = false;
						keyItems = true;
						doKeyInventory();
						break;
				}
				break;
		}
	}
	
	
	itemButtons();
	
	//Displays the switch to key items only if you're not in combat
	if(!inCombat()){ btntxt(12,"Important items"); }
}

//Writes inventory to buttons based on which page number you're on
protected function itemButtons():void{
	for(i=(invPage-1)*9;i<invPage*9;i++){
		var tempItemWrite:Items = invArray[i];
		if(tempItemWrite != null){ writeItems(i,tempItemWrite); }
	}
}

//Writes the items' names and charges remaining if the item has more than 1 charge
protected function writeItems(slot:int,item:Items):void{
	slot++;
	if(slot > 9){slot %= 9;}
	if(slot == 0){slot = 9;}
	if(item.Charges <= 1){btntxt(slot,capFirst(item.Name));}
	if(item.Charges > 1){btntxt(slot,capFirst(item.Name)+" x"+item.Charges);}
	iconItems(slot,item);
}

//Writes button icons based on input button number and input item
protected function iconItems(slot:int,item:Items):void{
	switch(item.type){
		case null:
			buttonIcons(slot,null);
			break
		default:
			buttonIcons(slot,null);
			break;
	}
}

//Moves inventory page up based on which state you are in
protected function doPageUp():void{
	if(currentState == "storage"){
		if(invPage > 1){invPage--;}
		doStorage();
	}
	if(currentState == "spells" || currentState == "combatSpells"){
		if(spellPage > 1){spellPage--;}
		doSpells();
	}
	else{
		if(invPage > 1){invPage--}
		if(currentState == "inventory" || currentState == "combatInventory"){doInventory();}
		else if(inShop == true){doVendoring();}
	}
}

//Moves inventory page down based on which state you are in
protected function doPageDown():void{
	switch(currentState){
		case "storage":
			if(depositing == true){if(invPage < invArray.length / 9){invPage++;}}
			else{if(invPage < storageArray.length / 9){invPage++;}}
			doStorage();
			break;
		case "spells":
		case "combatSpells":
			if(spellPage < spellArray.length / 9){spellPage++;}
			doSpells();
			break;
		default:
			if(invPage < invArray.length / 9){invPage++;}
			if(currentState == "inventory" || currentState == "combatInventory"){doInventory();}
			else if(inShop == true){doVendoring();}
			break;
	}
}

//Displays the unequip choices
protected function doUnequip():void{
	invView(0);
	
	scene("You are wearing: \n",true);
	itemDescribe(TOP);
	scene("\n",false);
	itemDescribe(BTM);
	scene("\n",false);
	itemDescribe(ARM);
	scene("\n",false);
	itemDescribe(WEA);
	
	clearView();
	
	//Displays buttons of unequippable slots
	if(WEA.Name != "fists"){btntxt(1,"Weapon");}
	if(ARM.Name != "unarmored"){btntxt(3,"Armor");}
	if(TOP.Name != "naked chest"){btntxt(7,"Top");}
	if(BTM.Name != "naked legs"){btntxt(9,"Bottom");}
	returnView(12);
	
	listen = function():void{
		if(btnchc == 1){tryUnequip("WEA");}
		if(btnchc == 3){tryUnequip("ARM");}
		if(btnchc == 7){tryUnequip("TOP");}
		if(btnchc == 9){tryUnequip("BTM");}
		if(btnchc == 12){doInventory();}
	}
}

//Function attempts to unequip input item
protected function tryUnequip(ID:String):void{
	clearView();
	
	if(invArray.length < maxInv){
		//If you have room in you inventory, adds the unequipped item to your inventory and replaces the unequipped slot with the "no equipment" equipment, I.E. "bare hands" etc.
		switch(ID){
			case "WEA":
				if(WEA.Name != "fists"){
					WEA.Charges = 1;
					invArray.push(WEA);
				}
				WEA = ObjectUtil.copy(Weaponless) as Items;
				break;
			case "ARM":
				if(ARM.Name != "unarmored"){
					ARM.Charges = 1;
					invArray.push(ARM);
				}
				ARM = ObjectUtil.copy(Armorless) as Items;
				break;
			case "TOP":
				if(TOP.Name != "naked chest"){
					TOP.Charges = 1;
					invArray.push(TOP);
				}
				TOP = ObjectUtil.copy(Shirtless) as Items;
				break;
			case "BTM":
				if(BTM.Name != "naked legs"){
					BTM.Charges = 1;
					invArray.push(BTM);
				}
				BTM = ObjectUtil.copy(Pantsless) as Items;
				break;
		}
		doUnequip();
	}
	else{
		//Brings up discard options if you try to unequip an item while your inventory is full
		scene("\nYou don't have enough room in your inventory. Do you want to discard this item, or keep it equipped? ",false);
		clearDecisionView();
		btntxt(11,"Discard this");
		btntxt(13,"Keep Equipped");
		listen = function():void{
			switch(btnchc){
				case 11:
					switch(ID){
						case "WEA":
							WEA = ObjectUtil.copy(Weaponless) as Items;
							break;
						case "ARM":
							ARM = ObjectUtil.copy(Armorless) as Items;
							break;
						case "TOP":
							TOP = ObjectUtil.copy(Shirtless) as Items;
							break;
						case "BTM":
							BTM = ObjectUtil.copy(Pantsless) as Items;
							break;
					}
					doUnequip();
					break;
				case 13:
					doUnequip();
					break;
			}
		}
	}
}

//Displays storage dialogue
protected function doStorage():void{
	currentState = "storage";
	clearView();
	
	//displays the appropriate UI panels
	GoldStorage.visible = false;
	inventoryPanel.visible = true;
	
	scene("\n\n",false);
	
	//Alphebetizes store items
	storageArray.sortOn("Name",Array.CASEINSENSITIVE);
	
	if(depositing == false){
		scene("What would you like to withdraw? ",false);
		
		//Displays stored items to the buttons
		for(i = ((invPage - 1) * 9);i < invPage * 9;i++){
			var strItem:Items = storageArray[i];
			if(strItem != null){writeItems(i,strItem);}
		}
		
		listen = function():void{
			if (btnchc > 0 && btnchc < 10 && storageArray[(btnchc - 1)+((invPage-1)*9)] != null){
				if(invArray.length < maxInv){
					//Adds selected item to your inventory and removes it from storage
					getItem(storageArray[(btnchc - 1)+((invPage-1)*9)]);
					storageArray.splice((btnchc - 1)+((invPage-1)*9),1);
					doStorage();
				}
				else{
					//If there's no room in your inventory then nothing gets moved
					doStorage();
					scene("\nThere's not enough room in your inventory. ",false);
				}
			}
		}
	}
	else{
		scene("What would you like to deposit? ",false);
		
		//Displays your inventory to the buttons
		itemButtons();
		
		listen = function():void{
			if (btnchc > 0 && invArray[(btnchc - 1)+((invPage-1)*9)] != null){
				if(storageArray.length < maxStorage){
					//Removes selected item from your inventory and adds it to storage
					storageArray.push(invArray[(btnchc - 1)+((invPage-1)*9)]);
					removeItem(invArray[(btnchc - 1)+((invPage-1)*9)]);
					doStorage();
				}
				else{
					//If your storage is full, then nothing gets moved
					doStorage();
					scene("\nThere's not enough room in your storage chest. ",false);
				}
			}
		}
	}
	
	//Lists storage contents
	scene("\n\nStorage contents" +
		"\n~~~~~~~~~~~~~~~~~~~~~~" +
		"\n<li>Gold: "+storageGold+"</li>",false)
	for(i = 1;i <= storageArray.length;i++){
		var storageItem:Items = storageArray[i-1];
		if(storageItem != null){
			scene("<li>",false);
			if(storageItem.Charges <= 1){scene(capFirst(storageItem.Name),false)}
			else{scene(capFirst(storageItem.Name)+"x"+storageItem.Charges,false)}
			scene("</li>",false);
		}
	}

}

//Displays dialogue for gold storage
protected function doStoreGold():void{
	clearView();
	
	//Displays appropriate UI panels
	GoldStorage.visible = true;
	inventoryPanel.visible = false;
	depositAmount.text = "0";
	depositAmount.setFocus();
	depositAmount.selectAll();
}

//Adds/removes gold from storage
protected function confirmGold():void{
	
	//Converts the number typed by the player into an actual integer
	var goldAmount:int = parseInt(depositAmount.text);
	
	if(depositing == false){
		//Removes gold to storage and adds it to your gold total
		if(goldAmount > storageGold){goldAmount = storageGold;}
		GLD += goldAmount;
		storageGold -= goldAmount;
	}
	else{
		//Removes gold from your character and adds it to storage
		if(goldAmount > GLD){goldAmount = GLD}
		GLD -= goldAmount;
		storageGold += goldAmount;
	}
	doStorage();
}

//Stores or removes all gold
protected function doAllGold():void{
	if(depositing == false){
		GLD += storageGold;
		storageGold = 0;
	}
	else{
		storageGold += GLD;
		GLD = 0;
	}
	doStorage();
}

//Toggles between depositing/withdrawing items/gold from storage
protected function toggleDeposit():void{
	//Toggles "depositing" tag
	depositing = !depositing;
	//Updates the label on the "depositing/withdrawing" button
	depositLabel = (depositing) ? "Depositing": "Withdrawing";
	//Moves you to page 1 of your storage
	invPage = 1;
	doStorage();
}

//Toggles between discarding/using items in your inventory
protected function toggleDiscard():void{
	//Toggles "discarding" tag
	discarding = !discarding;
	//Updates the label on the "discarding/withdrawing" button
	discardLabel = (discarding) ? "Discarding": "Using";
	//Moves you to page 1 of your inventory
	invPage = 1;
	doInventory();
}

//Displays a shop's buying/selling dialogue/buttons
protected function doShop():void{
	//moves you to page 1 of the stores inventory when you first enter the store
	if(!inShop){ invPage = 1; }
	//Displays the vendor's buying scene
	scene(Vendor.Buying+"\n",true);
	inShop = true;
	clearView();
	appView(0);
	//Alphebetizes the vendors inventory
	Vendor.vendArray.sortOn("Name",Array.CASEINSENSITIVE);
	
	//Displays item names and prices
	for(i=0;i<Vendor.vendArray.length;i++){
		var storeCosts:Items = Vendor.vendArray[i];
		if(storeCosts != null){ scene("<li>"+capFirst(storeCosts.Name)+"......"+buyValue(storeCosts)+" gold</li>",false); }
	}
	scene("\n",false);
	
	//Displays the vendors inventory to the buttons
	for(i=0;i<9;i++){
		var inventoryItem:Items = Vendor.vendArray[i+(9*(invPage - 1))];
		if(inventoryItem != null){ writeItems(i,inventoryItem); }
	}
	
	//Page rotation button
	if(Vendor.vendArray.length > 9){
		btntxt(11,"More items");
	}
	
	btntxt(12,"Sell");
	leaveButton(13);
	
	listen = function():void{
		switch(btnchc){
			case 11:
				//Moves to the previous page of the shop's inventory
				switch(invPage < Math.ceil(Vendor.vendArray.length / 9)){
					case true:
						invPage++;
						break;
					default:
						invPage = 1;
						break;
				}
				doShop();
				break;
			case 12:
				//Switch to "sell" mode
				doVendoring();
				break;
			case 13:
				//Leaves the store
				leaveStore();
				break;
			default:
				//Attempt to buy the item you clicked on
				if(Vendor.vendArray[btnchc-1+(9*(invPage - 1))] != null){ tryBuyItem(Vendor.vendArray[btnchc-1+(9*(invPage - 1))]); }
				break;
		}
	}
}

//Item buying confirmation
protected function tryBuyItem(ID:Items):void{
	doShop();
	
	itemDescribe(ID);
	scene("\n",false)
	if(invArray.length >= maxInv){ scene("But you have no room. ",false); }
	else if(GLD >= buyValue(ID)){
		//Asks you if you want to buy the item if you have enough gold and room in your inventory
		scene("Are you sure you want to buy this? ",false);
		choiceButton();
		clrchc();
		listen = function():void{
			if(btnchc == 11){doBuyItem(ID);}
			if(btnchc == 13){
				doShop();
				scene("\"Suit yourself.\" ",false);
			}		
		}
	}
	else if(GLD < buyValue(ID)){
		//Stops you from buying the item if you don't have enough money and displays the vendors scene for when you're too poor
		doShop();
		scene(Vendor.NoMoney,false);
	}
}

//Buys the input item
protected function doBuyItem(ID:Items):void{
	doShop();
	scene("\n"+Vendor.Bought,false);
	getItem(ID);
	doGold(-buyValue(ID));
}

//Display sellable items
protected function doVendoring():void{
	scene(Vendor.Selling+"\n",true);
	
	//Writes the items you can sell to the buttons
	for(i=1;i<=invArray.length;i++){
		var inventoryItem:Items = invArray[i-1];
		if(inventoryItem != null){ scene("\n"+capFirst(inventoryItem.Name)+"......"+sellValue(inventoryItem)+" gold",false); }
	}
	clearView();
	appView(0);
	returnView(12);
	pageView();
	
	listen = function():void{
		if (btnchc == 11){doPageUp();}
		if (btnchc == 13){doPageDown();}
		if (btnchc == 12) {
			//Switches back to buying mode
			invPage = 1;
			doShop();
		}
		//Attempts to sell the selected item
		else if(btnchc > 0 && btnchc < 10 && invArray[(btnchc - 1)+((invPage-1)*9)] != null){trySellItem(invArray[(btnchc - 1)+((invPage-1)*9)]);}
	}
	//Displays the items you can sell
	itemButtons();
}

//Item selling confirmation
protected function trySellItem(ID:Items):void{
	scene("\n"+ID.Description+"Are you sure you want to sell this for "+sellValue(ID)+" gold? ",false);
	choiceButton();
	listen = function():void{
		if(btnchc == 11){doSellItem(ID);}
		if(btnchc == 13){doVendoring();}		
	}
}

//Sells the input item
protected function doSellItem(ID:Items):void{
	removeItem(ID);
	doVendoring();
	scene("\n"+Vendor.Sold,false);
	doGold(sellValue(ID));
}

//Enters a store
protected function enterStore(ID:Vendors):void{
	Vendor = ObjectUtil.copy(ID) as Vendors;
	Vendor.StoreExit = ID.StoreExit;
	doShop();	
}

//Leaves store and displays text for leaving
protected function leaveStore():void{
	inShop = false;
	locationTravel(Vendor.StoreExit);
	scene("\t"+Vendor.Leaving,true);
}

//Returns the buy value of item
protected function buyValue(ID:Items):int{
	var tempValue:Number = ID.Value;
	if(ID.Charges > 0){tempValue = ID.Charges * ID.Value;}
	return Math.ceil(tempValue);
}

//Returns the sell value of input item
protected function sellValue(item:Items):int{ return Math.floor(buyValue(item) * .5); }

