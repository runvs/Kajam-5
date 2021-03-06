package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class TownPortal extends FlxSprite
{
	
	public var activated : Bool = false;

	private var _state : PlayState;
	public var wasOverlapping : Bool = false;
	
	public static var lastTPLevel : String = "";
	public static var lastTPEntryID : Int = 0;
	
	public var thisPortalLevel : String = "";
	public var thisPortalEntryID : Int;
	public function new(?X:Float=0, ?Y:Float=0, w: Int, h : Int, state: PlayState) 
	{
		super(X, Y);
		_state = state;
		
		//this.makeGraphic(w,h);
		this.loadGraphic(AssetPaths.teleporter__png, true, 32, 32);
		this.animation.add("idle", [0, 1, 2, 3, 4, 5], 7);
		this.animation.play("idle");
	}
	
	
	
	
	
}