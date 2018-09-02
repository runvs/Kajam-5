package ;


import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class ShopItem extends FlxSpriteGroup
{
	public var available : Bool = true;
	public var ItemCost : Int = 1;
	private var myCallback : PlayState -> Void;
	
	private var spr : FlxSprite;
	private var text : FlxText;
	
	public var item : Item = null;
	
	public var ItemPos : Int = 0;
	
	
	public function new(icon: Dynamic, it : Item, cost: Int, cb : PlayState -> Void) 
	{
		super();
		
		item = it;
		ItemCost = cost;
		myCallback = cb;
		
		spr = new FlxSprite(0, 0);
		spr.loadGraphic(icon, false);
		spr.scrollFactor.set();
		add(spr);
		
		text = new FlxText(0, 0, 0, it.name + " : " + Std.string(cost) + " gp");
		text.scrollFactor.set();
		add(text);
		
		this.scrollFactor.set();
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		//selector.setPosition(oX + 60, oY + 60 + selectorPosition * selectorYOffset);
		spr.setPosition(ShopState.oX + 60  + 20 , ShopState.oY + 60 + ItemPos * ShopState.selectorYOffset);
		
		text.setPosition(ShopState.oX + 60 + 20 + 20 , ShopState.oY + 60 + ItemPos * ShopState.selectorYOffset);
		if (available)
		{
			spr.color = FlxColor.WHITE;
			text.color = FlxColor.WHITE;
		}
		else
		{
			//trace("not available");
			spr.color = FlxColor.GRAY;
			text.color = FlxColor.GRAY;
		}
	}
	
	
	public function onBuy(s :PlayState)
	{
		s.player.gold -= ItemCost;
		if (myCallback != null)
			myCallback(s);
	}
	
	override public function draw():Void 
	{
		super.draw();
		//trace(spr.x);
	}
}