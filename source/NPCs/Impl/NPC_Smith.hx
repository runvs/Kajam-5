package;

/**
 * ...
 * @author 
 */
class NPC_Smith extends NPCIdle
{

	public function new(s:PlayState) 
	{
		super(s);
		loadGraphic(AssetPaths.smith__png, true, 16, 16);
		animation.add("idle", [0, 1, 0, 1, 0, 1, 2], 3, true);
		animation.play("idle");
	}
	
	override public function interact():Void 
	{
		super.interact();
	}
	
	override public function onCloseRange():Void 
	{
		super.onCloseRange();
	}
	
}