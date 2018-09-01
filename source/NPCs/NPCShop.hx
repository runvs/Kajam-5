package;

/**
 * ...
 * @author 
 */
class NPCShop extends NPCIdle
{

	
	private var _myShop : ShopState;
	public function new(s:PlayState) 
	{
		super(s);
		
		//_myShop = new ShopState(s);
		
	}
	
	override public function interact():Void 
	{
		super.interact();
		
		openShop();
		MyInput.reset();
	}
	
	function openShop() 
	{
		
	}
	
}