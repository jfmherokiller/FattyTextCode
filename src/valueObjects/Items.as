package valueObjects
{
	[Bindable]
	public class Items
	{
		//Name of item and the article that should preceed it
		//I.E. "a cookie", "an amulet"
		public var article:String = "a";
		public var Name:String = "Name error";
		
		//Type of item, as in "food", "armor", etc. 
		//Must use specific predetermined names based on how other functions are set up
		//Refer to already existing items for examples
		public var type:String = "";
		
		//The value of the item
		public var Value:Number = 0;
		
		//Text displayed when you look at an item
		public var Description:String = "Description error";
		
		//Text displayed when you use an item
		public var itemUse:String = "You used the item! ";
		
		//Text displayed when consuming the item causes you to explode
		public var overfilled:String = "";
		
		//Various flags to tell other functions how to process the item///////////////
		//Item can be used when clicked on
		public var Useable:Boolean = false;
		//Item can be used in combat
		public var combatUseable:Boolean = true;
		//Item has a charge consumed when used
		public var Consume:Boolean = false;
		
		//Item is of the listed category
		public var Food:Boolean = false;
		public var Drink:Boolean = false;
		public var Special:Boolean = false;
		public var Quest:Boolean = false;
		
		//Item is equipped in the listed slot
		public var Weapon:Boolean = false;
		public var Armor:Boolean = false;
		public var Top:Boolean = false;
		public var Bottom:Boolean = false;
		
		//Item is a status effecting item
		public var Status:Boolean = false;
		//item affects you for the input amount of time
		public var StatusTime:int = 0;
		
		//Descriptions and flags used for clothing bursting of you when you grow to large
		public var Popoff:String = "";
		public var Popped:Boolean = false;
		public var PoppedDescription:String = "";
		public var Toosmall:String = "";
		//How big your waist can get before the clothing explodes
		public var Expand:int = 0;
		
		//How many uses an item has. Note, equippable items still have 1 charge, this is so that they get removed from you inventory when you equip them
		public var Charges:int = 1;
		
		//How high an item can be stacked
		public var StackLimit:int = 1;
		
		//Weapon stats//////////
		//Text displayed when you attack
		public var attackDescription:String = "Attack error";
		//Type of damage the weapon does
		public var damageType:DamageType;
		//What effect the weapon can proc
		public var attackProc:String;
		//The percentage chance of that effect proccing
		public var attackProcChance:int;
		//How powerful that effect is when it procs
		public var attackProcPower:int;
		//How large the die that gets rolled for damage is
		public var WEAr:int = 0;
		//how many die get rolled for damage
		public var WEAd:int = 0;
		//How much defens the item grants you
		public var Defense:int = 0;
		//Which stat the weapon uses for scaling; "STR", "AGI", "INT"
		public var damageStat:String;
		//How much damage scales with that stat
		public var damageScaling:Number = 0;
		
		//How much the equipment buffs the given stat
		public var manaBuff:int = 0;
		public var agiBuff:int = 0;
		public var strBuff:int = 0;
		public var endBuff:int = 0;
		public var intBuff:int = 0;
		public var healthBuff:int = 0;
		
		//How much the item increases the given stat
		public var drink:int = 0;
		public var eat:int = 0;
		public var Calories:Number = 0;
		public var Heal:int = 0;
		public var Mana:int = 0;
		public var Stamina:int = 0;
		
		
		public function Items()
		{
			
		}
	}
}