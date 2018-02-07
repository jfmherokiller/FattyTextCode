package valueObjects
{
	public class Quests
	{
		//Name of quest
		public var questName:String = "";
		
		//The description of the quest
		public var questDescription:String = "";
		
		//Tag showing whether the quest should appear in the quest log
		public var visible:Boolean = true;
		
		//Tag showing whether the quest is completed or not
		public var completed:Boolean = false;
		
		
		//Records the characteristics of the NPC who gave you the quest. Used for when a quest can be given by a randomized NPC.
		public var questNPC:NPCs;
		
		//The item you have to get for the quest
		public var questTarget:Items;
		
		//What stage of the quest you're on
		public var questProgress:int = 0;
		
		//What stage of the quest you have to get to before it's completed
		public var questGoal:int = 0;
		
		//The rewards for the quest
		public var questItem:Items;
		public var questGold:int = 0;
		public var questXP:int = 0;
		
		public function Quests()
		{
		}
	}
}