package;

import flixel.FlxObject;

/**
 * ...
 * @author 
 */
class Exit extends FlxObject
{

	public var target : String = "";
	public var entryid : Int = 0;
	public function new(X:Float=0, Y:Float=0, Width:Float=0, Height:Float=0, t : String, eid : Int) 
	{
		super(X, Y, Width, Height);
		target = t;
		entryid = eid;
	}
	
}