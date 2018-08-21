package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class NPC extends FlxSprite
{
	
	private var _state : PlayState;
	
	public var objectName : String;
	
	public var closeRangeDistance: Float = 32;

	public function new(s : PlayState) 
	{
		super();
		_state = s;
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		checkCloseRange();
	}
	
	function checkCloseRange() 
	{
		var dx = _state.player.x - x;
		var dy = _state.player.y - y;
		
		var dsq : Float = dx * dx + dy * dy;
		
		if (dsq < closeRangeDistance * closeRangeDistance)
		{
			onCloseRange();
		}
		
	}
	
	public function interact () : Void
	{
		// do nothing
	}
	
	public function onCloseRange () : Void
	{
		
	}
	
}