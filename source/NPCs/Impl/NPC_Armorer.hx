package;

/**
 * ...
 * @author 
 */
class NPC_Armorer extends NPCShop
{

	public function new(s:PlayState) 
	{
		super(s);
		loadGraphic(AssetPaths.smith__png, true, 16, 16);
		animation.add("idle", [0, 1, 0, 1, 0, 1, 2], 3, true);
		animation.play("idle");
		//_myShop.setShopType(0);	// weapon
	}
	
	override function openShop() 
	{
		super.openShop();
		var ss : ShopState = new ShopState(_state);
		ss.setShopType(2);
		_state.openSubState(ss);
	}
	
	override public function onCloseRange():Void 
	{
		super.onCloseRange();
	}
	
}