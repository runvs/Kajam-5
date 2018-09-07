package;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class NPC_townpeople extends NPC
{

	public function new(s:PlayState) 
	{
		super(s);
		this.loadGraphic(AssetPaths.town_people__png, true, 16, 20);
		var r : Int = FlxG.random.int(0, 10);
		this.animation.add("south", [r * 4 + 0], 8, true);
		this.animation.add("north", [r * 4 + 1], 8, true);
		this.animation.add("east",  [r * 4 + 2], 8, true);
		this.animation.add("west",  [r * 4 + 3], 8, true);
		this.animation.play("south");
	}
	
	
	override public function onCloseRange():Void 
	{
		if ( _speechDisplayTimer <= GameProperties.NPCSpeechFadeOutTime)
		{
			var i : Int = FlxG.random.int(0, 2);
			if (i == 0)
				speak("Hey Thyl", 2);
			else if (i == 1)
				speak("Good day sir", 2);
			else if ( i == 2)
				speak("Greetings", 2);
			else 
				speak("How are you?");
		}
	}
	
	override public function interact():Void 
	{
		speak("Hey Thyl, how are you?");
	}
	
}