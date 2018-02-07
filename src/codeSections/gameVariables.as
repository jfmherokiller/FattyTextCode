import mx.collections.ArrayCollection;

import valueObjects.Defeats;
import valueObjects.NPCs;

[Bindable] protected var version:Number = 0.6;

//Embedded images////////////////////////////////////////////////

//Enemy Images
[Bindable] protected var enemyImageSource:Class;

//Location images
[Bindable] protected var backgroundImageSource:Class;



//Player stats, these are modified by the other stat variables
[Bindable] protected var STR:Number = 0;
[Bindable] protected var AGI:Number = 0;
[Bindable] protected var INT:Number = 0;
[Bindable] protected var STO:Number = 0;
[Bindable] protected var END:Number = 0;

//The players base stats before modifiers
//these are the stats that are actually increased when your character raises their stats
[Bindable] protected var bSTR:Number = 0;
protected var bAGI:Number = 0;
protected var bINT:Number = 0;
protected var bSTO:Number = 0;
protected var bEND:Number = 0;

//The temporary modifiers for the players stats, usually done by enemy attacks
protected var tenemySTRdebuff:Number = 0;
protected var tenemyAGIdebuff:Number = 0;
protected var tenemyINTdebuff:Number = 0;
protected var tenemySTOdebuff:Number = 0;
protected var tenemyENDdebuff:Number = 0;
[Bindable] protected var tenemyFATdebuff:Number = 0;

//Temporary magic duffs and debuffs
protected var tmagicSTRbuff:Number = 0;
protected var tmagicAGIbuff:Number = 0;
protected var tmagicINTbuff:Number = 0;
protected var tmagicSTObuff:Number = 0;
protected var tmagicENDbuff:Number = 0;
protected var tmagicDEFbuff:Number = 0;
protected var tmagicDODGEbuff:int = 0;
protected var tmagicREGENbuff:int = 0;
protected var tmagicREGENbuffDamage:int = 0;
protected var tmagicREGENbuffRange:int = 0;

//Stat bar colors, these are changed by the updateStats() function
[Bindable] protected var strColor:uint = uint(0x000000);
[Bindable] protected var agiColor:uint = uint(0x000000);
[Bindable] protected var endColor:uint = uint(0x000000);
[Bindable] protected var intColor:uint = uint(0x000000);
[Bindable] protected var stoColor:uint = uint(0x000000);
[Bindable] protected var manaColor:uint = uint(0x000000);
[Bindable] protected var healthColor:uint = uint(0x000000);

//Players maximum values for stats, these are updated by the updateStats() function
[Bindable] protected var maxFUL:int = 1;
[Bindable] protected var maxHEA:int = 100;
[Bindable] protected var bmaxHEA:int = 100;
[Bindable] protected var tmaxHEA:int = 100;
[Bindable] protected var maxMANA:int = 1;
[Bindable] protected var tmaxMANA:int;

//Constantly varying player stats
[Bindable] protected var HEA:int = 0;
[Bindable] protected var MANA:Number = 0;
[Bindable] protected var FUL:int = 0;
[Bindable] protected var FULbarScale:Number = 0;
[Bindable] protected var HEAbarScale:Number = 0;
[Bindable] protected var MANAbarScale:Number = 0;
[Bindable] protected var STA:Number = 0;
[Bindable] protected var ATE:Number = 0;
[Bindable] protected var Eaten:Number = 0;
[Bindable] protected var Drank:Number = 0;
protected var Inflated:Number = 0;
[Bindable] protected var InflatedMass:Number = 0;
protected var Calories:Number = 0;
[Bindable] protected var FAT:Number = 0;

//Quests array
protected var questArray:Array = new Array();

//Character's descriptive characteristics
[Bindable] protected var playerHeight:int = 70;
[Bindable] protected var playerSpecies:Species;
[Bindable] protected var playerName:String;
[Bindable] protected var playerGender:Gender;

//Players secondary stats
[Bindable] protected var XP:int = 0;
[Bindable] protected var XPtoLevel:int = 100;
[Bindable] protected var LVL:int = 1;
protected var LVLup:int = 0;

//Equipped items
protected var WEA:Items;
protected var ARM:Items;
protected var TOP:Items;
protected var BTM:Items;

//Timed event counters
//Many timed events are broken up into a timer component and a power component
//For instance "statusENDBuff" represents how long your endurance is buffed for and "statusENDBuffPower" represents how much your endurance is buffed by
//Different counters count up or down depending on what the event calls for
protected var statusStomachStretch:int = 0;
protected var statusBloatVenom:int = 0;
protected var statusBloatVenomPower:int = 0;
protected var statusBurn:int = 0;
protected var statusBurnPower:int = 0;
protected var statusWellFed:int = 0;
protected var statusWellFedPower:int = 0;
protected var statusSTRBuff:int = 0;
protected var statusSTRBuffPower:int = 0;
protected var statusAGIBuff:int = 0;
protected var statusAGIBuffPower:int = 0;
protected var statusINTBuff:int = 0;
protected var statusINTBuffPower:int = 0;
protected var statusENDBuff:int = 0;
protected var statusENDBuffPower:int = 0;
protected var statusMANABuff:int = 0;
protected var statusMANABuffPower:int = 0;
protected var statusSTOBuff:int = 0;
protected var statusSTOBuffPower:int = 0;

//Clock variables
[Bindable] protected var day:int = 1;
[Bindable] protected var AMPM:String = "AM";
[Bindable] protected var hour:int = 9;
[Bindable] protected var displayHour:int = 8;
[Bindable] protected var tensMinute:int = 0;
[Bindable] protected var onesMinute:Number = 0;

//Main scene text
[Bindable] protected var mainText:String = "";

//Miscellaneous scene text
//Used for things like the "Surroundings" menu and other submenus so that the main screen text doesn't get overwritten
[Bindable] protected var miscellaneousText:String = "";

//Tags for states of being
//Mostly used so various functions now how to properly execute
protected var inShop:Boolean = false;
protected var depositing:Boolean = false;
protected var discarding:Boolean = false;
protected var keyItems:Boolean = false;

//Hides or displays the rest, inventory, spells, instructions, options, and load buttons
//This is used to prevent the player from getting stuck after clicking on one of those buttons
[Bindable] protected var appButtonVisibility:Boolean = false;

//Both of these variables record which stage of a special event you are in. I recommend using the "subEvent" variable
//Used to record what stage of an event you are on so it might go "1" -> "11" -> "112" -> "1121" -> etc.
//Not a very intuitive way to record what stage you're on though and can be confusing to work with
protected var specialEvent:int = 0;

//Also used to keep track of what stage of an event you are on, but this is represented with text. For example you might use
//"introduction" -> "opened door" -> "pulled rope" -> "failed to dodge boulder" -> etc.
//This is much more intuitive and easy to remember what you're doing, since things have actual names rather than being strings of numbers
protected var subEvent:String = "";

//Records what caused you to be defeated, E.G. overeating, defeated in battle, overinflated, etc.
protected var defeatedBy:Defeats;

//records whether you've started a game or not. Used to tell certain functions how to work
[Bindable] protected var newGame:Boolean = true;

//Records where you are and where you came from
[Bindable] protected var location:Locations;
[Bindable] protected var cameFrom:Locations;

//Records which one of the decision buttons you clicked on
/*The buttons are arranged as so on the screen
[1][2][3]
[4][5][6]
[7][8][9]
[11][12][13]*/
//There is no button 10 so that the bottom first button ends with 1 and the second buttons ends with 2 and the third button ends with 3. 
//It's just to make them easier to remember
protected var btnchc:int = 0;

//Perhaps most important variable in the game!////////////////////////////////////////////
//This is why clicking on decision buttons does stuff!////////////////////////////////////
//Every time you click a decision making button, the game records which button you clicked and then runs the "listen" function
//You're supposed to set the listen function to take the appropriate action based on which button click the game recorded
protected var listen:Function;

//Items handling variables

//The arrays for your regular and key items
[Bindable] protected var invArray:Array = [];
[Bindable] protected var keyInvArray:Array = [];

//The gold you're carrying
[Bindable] protected var GLD:int;

//The array for your stored items as well as your stored gold variable
protected var storageArray:Array = new  Array();
protected var storageGold:int;

//What page of an inventory screen you are one
//Used for inventory, storage, shops, possibly some other thing I forgot
[Bindable] protected var invPage:int = 1;

//The maximum number of items you can hold in your inventory
[Bindable] protected var maxInv:int = 18;

//Maximum amount of items you can keep in storage
protected var maxStorage:int = 36;

//Your known spells array
protected var spellArray:Array = [];

//The page of your spell book that you're on
[Bindable] protected var spellPage:int = 1;

//NPC and vendor object slots
protected var NPC1:NPCs = defaultNPC;
protected var NPC2:NPCs = defaultNPC;
protected var NPC3:NPCs = defaultNPC;
protected var NPC4:NPCs = defaultNPC;
protected var Vendor:Vendors;

//Enemy object slot
//You can reference the "enemy" object for it's original statistics. 
//Never change the "enemy" object or else it'll change the original object you created in the code. That's what the "enemyt" object is for.
[Bindable] protected var enemy:Enemies;

//Temporary enemy object. This one can be editted freely because it just disappears after you use it.
//this allows you to change it's description based on it's race or gender, or your player's race or gender, without permanently changing the original objects description
[Bindable] protected var enemyt:Enemies;

//The enemy's health and mana
[Bindable] protected var eHEA:int;
protected var eMANA:int;

//How much damage the enemy is going to do. Used by the doeDMG() and doeSpellDMG() functions
protected var eDMG:int;

//Tracks how strongly your character is grappled
protected var grapple:int;

//Tracks whether you choose to surrender or devour your enemy. Used so the enemyAttack() and 
protected var surrender:Boolean = false;
protected var voreing:Boolean = false;

//Status effects that are affecting your enemy
protected var eStatusBurnPower:int = 0;
protected var eStatusBurnTime:int = 0;
protected var eStatusStunTime:int = 0;
protected var eStatusSlowTime:int = 0;
protected var eStatusSoakTime:int = 0;

//Statusa affects that are affecting the player
protected var pStatusStunTime:int = 0;

//Array containing all the locations around you
protected var surroundingsArray:Array = new Array();

//Random event randomization arrays
//You can set these up however you want, but the default way I use them is; Special-Enemy-Leave-Minor
//See the "eventRandomization" in "gameTravel.as" for more information
protected var exampleTravel:Array = [0,0.5,0,2,0,0.5,0,2];

//Options variables that are set in the options screen
[Bindable] protected var optionsMetric:Boolean = false;
[Bindable] protected var optionsImperial:Boolean = true;
[Bindable] protected var optionsPopping:Boolean = false;
[Bindable] protected var optionsMales:Boolean = true;
[Bindable] protected var optionsFemales:Boolean = true;
[Bindable] protected var optionsDescription:Boolean = true;


//Placeholder variables///////////////

//Used mostly to record how much an enemy is about to forcefeed you
protected var cram:int;

//Used mostly in "for" loops
protected var i:int = 0;

//Used to record how many attempts you have left to do a thing with a limited number of attempts
protected var attemptsLeft:int = 0;

//Records how much damage you're about to do in combat
[Bindable] protected var DMG:int = 0;

//Contains items in your inventory that you can tailor
protected var tailorArray:Array = new Array();

//Records which item you have selected and are about to use
protected var selectedItem:Items;

//Labels for the "discard/use" and "depositing/withdrawing" buttons
[Bindable] protected var depositLabel:String = "Depositing";
[Bindable] protected var discardLabel:String = "Using";
