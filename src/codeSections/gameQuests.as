import valueObjects.Quests;

//Adds the quest to your quest log if you don't already have the quest
protected function getQuest(ID:Quests):void{
	if(!hasQuest(ID)){
		var questReceived:Quests = ObjectUtil.copy(ID) as Quests;
		questArray.push(questReceived);
	}
}

//Returns wether you have a quest and have not completed it yet
protected function questActive(ID:Quests):Boolean{
	var doingQuest:Boolean = false;
	if(hasQuest(ID) && !questCompleted(ID)){ doingQuest = true; }
	return doingQuest;
}

//Returns index of input quest, or -1 if quest doesn't exist in your quest log
protected function questFind(quest:Quests):int{
	var questIndex:int = -1;
	for(i=0;i<questArray.length;i++){
		var testQuest:Quests = questArray[i];
		if(quest.questName == testQuest.questName){questIndex = i;};
	}	
	return questIndex;
}

//Returns which stage of a quest you're on. Returns -1 if you're not on that quest
protected function questStage(ID:Quests):int{
	var stage:int = -1;
	if(hasQuest(ID)){
		var testQuest:Quests = questArray[questFind(ID)];
		stage = testQuest.questProgress;
	}
	return stage;
}

//Returns wether or not you have a quest
protected function hasQuest(ID:Quests):Boolean{
	var hasQuest:Boolean = false;
	if(questFind(ID) > -1){hasQuest = true;}
	return hasQuest;
}

//Progresses the input quest by one
protected function questAdvance(ID:Quests):void{
	if(hasQuest(ID)){
		var advancingQuest:Quests = ObjectUtil.copy(questArray[questFind(ID)]) as Quests;
		if(advancingQuest.questProgress < advancingQuest.questGoal){advancingQuest.questProgress++;}	
		questArray.splice(questFind(ID),1,advancingQuest);
	}
}

//Tests to see if you're ready to turn in a quest
protected function questReady(ID:Quests):Boolean{
	var testQuest:Quests;
	var completed:Boolean = false;
	if(hasQuest(ID)){
		testQuest = questArray[questFind(ID)];
		if(testQuest.questProgress >= testQuest.questGoal){completed = true;}
	}
	return completed;
}

//Tests to see if a test is marked as completed
protected function questCompleted(ID:Quests):Boolean{
	var completed:Boolean = false;
	if(hasQuest(ID)){
		var testQuest:Quests = questArray[questFind(ID)];
		if(testQuest.completed == true){completed = true;}
	}
	return completed;
}

//Completes quest and gives you rewards
protected function questReward(inputQuest:Quests):void{
	if(hasQuest(inputQuest)){
		var ID:Quests = questArray[questFind(inputQuest)];
		scene("<li>Quest complete!</li>",false);
		
		//Grants quest rewards
		doXP(ID.questXP);
		doGold(ID.questGold);
		if(ID.questItem != null){forceGetItem(ID.questItem);}
		
		//Flags quest as completed and hides it from the quest log
		ID.questProgress = ID.questGoal;
		ID.completed = true;
		ID.visible = false;
	}
}

//Removes quests. Note, not used normally. When quests are completed they are marked as hiddin so the game can still keep track of what quests you have completed
protected function questRemove(quest:Quests):void{ if(hasQuest(quest)){ questArray.splice(questFind(quest),1); } }
