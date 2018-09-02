package;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author 
 */
class NPCShop extends NPCIdle
{

	
	private var _myShop : ShopState;
	
	private var _underlay : GlowOverlay;
	
	public function new(s:PlayState) 
	{
		super(s);
		
		
		_underlay = new GlowOverlay(0, 0, FlxG.camera, 48, 1,0.9);
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
	
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		_underlay.setPosition(x + width/2, y + width/2);
		if (FlxG.overlap(_state.player._hitArea, this))
		{
			_underlay.alpha = 0.8;
		}
		else
		{
			_underlay.alpha = 0;
		}
	}
	
	override public function draw():Void 
	{
		_underlay.draw();
		super.draw();
		
	}
	
}