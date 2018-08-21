package;

import NPCIdle;

/**
 * ...
 * @author 
 */
class NPC_Guard extends NPCIdle
{

	public function new(s:PlayState) 
	{
		super(s);
	}
	
	override public function interact():Void 
	{
		trace ("talked to guard");
	}
	
	override public function onCloseRange():Void 
	{
		trace("close to guard");
	}
}