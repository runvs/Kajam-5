package;

import NPCIdle;
import flixel.FlxG;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class NPC_Guard extends NPCIdle
{

	public function new(s:PlayState) 
	{
		super(s);
		this.loadGraphic(AssetPaths.Guard__png, true, 16, 16, false);
		this.animation.add("idle", [0, 2, 1, 2, 0, 2, 0, 2, 1, 2], 3, true);
		
		var t : FlxTimer = new FlxTimer();
		t.start(FlxG.random.float(0, 0.5), function(t) { this.animation.play("idle"); });
	}
	
	override public function interact():Void 
	{
		trace ("talked to guard");
	}
	
	override public function onCloseRange():Void 
	{
		//trace("close to guard");
	}
}