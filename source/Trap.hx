package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Trap extends FlxSprite
{

	public var name : String = "";
	public var activated : Bool = true;
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
	}
	
}