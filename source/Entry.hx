package;

import flixel.FlxObject;

/**
 * ...
 * @author 
 */
class Entry extends FlxObject
{

	public var entryID : Int = 0;
	public function new(X:Float=0, Y:Float=0, i : Int) 
	{
		super(X, Y);
		
		entryID = i;
	}
	
}