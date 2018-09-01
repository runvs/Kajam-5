package;

import ShopItem;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class ShopState extends FlxSubState
{

	private var shopType : Int = 0; 	// 0 Weapons
									// 1 Bow
									// 2 Armor
									// 3 Consumables
									
	private var bg : FlxSprite;
	
	private var _state : PlayState;
	
	private var inputWallTime : Float = 0;
	
	private var selector : FlxSprite;
	private var selectorPosition : Int = 0;
	private var selectorPositionMax : Int = 3;
	public static var selectorYOffset : Int = 24;
	
	public static var oX : Float = 200;
	public static var oY: Float = 150;
	
	public var allEntries : FlxTypedGroup<ShopItem>;
	
	
	public function new(s : PlayState) 
	{
		super();
		_state = s;
		allEntries = new FlxTypedGroup<ShopItem>();
		//allEntries.scrollfact
		
	}
	
	override public function create():Void 
	{
		super.create();
		
		bg = new FlxSprite(oX + 50, oY + 50);
		bg.makeGraphic(300,200);
		bg.color = FlxColor.fromRGB(100, 100, 20);
		bg.scrollFactor.set();
		add(bg);
		
		selector = new FlxSprite (oX + 60, oY + 60);
		selector.makeGraphic(16, 16);
		selector.scrollFactor.set();
		add(selector);
		
		add(allEntries);
		
	}
	
	
	public function setShopType(i : Int)
	{
		// weapons
		if (i == 0)
		{
			setShopTypeWeapon();
		}
		else if (i == 1)
		{
			setShopTypeBow();
		}
		else if (i == 2)
		{
			setShopTypeArmor();
		}
		else
		{
			setShopTypeConsumables();
		}
	}
	
	function setShopTypeConsumables() 
	{
		
	}
	
	function setShopTypeArmor() 
	{
		
	}
	
	function setShopTypeBow() 
	{
		
	}
	
	function setShopTypeWeapon()
	{
		allEntries = new FlxTypedGroup<ShopItem>();
		
		{
			var i : ShopItem = new ShopItem(AssetPaths.shortsword__png, "short sword", 5, 
			function(s:PlayState)
			{
				s.player.swordItem = Item.GetShortSword();
			});
			//trace(allEntries.length);
			i.ItemPos = allEntries.length;
			//add(i);
			allEntries.add(i);
		}
		{
			var i : ShopItem = new ShopItem(AssetPaths.dagger__png, "dagger", 10, 
			function(s:PlayState)
			{
				s.player.swordItem = Item.GetDagger();
			});
			i.ItemPos = allEntries.length;
			//add(i);
			allEntries.add(i);
		}
		{
			var i : ShopItem = new ShopItem(AssetPaths.claymore__png, "claymore", 15, 
			function(s:PlayState)
			{
				s.player.swordItem = Item.GetClaymore();
			});
			i.ItemPos = allEntries.length;
			//add(i);
			allEntries.add(i);
		}
		{
			var i : ShopItem = new ShopItem(AssetPaths.katana__png, "katana", 20, 
			function(s:PlayState)
			{
				s.player.swordItem = Item.GetKatana();
			});
			i.ItemPos = allEntries.length;
			//add(i);
			allEntries.add(i);
		}
		
		selectorPositionMax = allEntries.length;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		MyInput.update();
		
		if (MyInput.DashButtonJustPressed)
		{
			this.close();
		}
		
		inputWallTime -= elapsed;
		if (inputWallTime <= 0)
		{
			if (MyInput.yVal <= -0.1)
			{
				selectorPosition--;
				inputWallTime = 0.1;
			}
			if (MyInput.yVal >= 0.1)
			{
				selectorPosition++;
				inputWallTime = 0.1;
			}
			
			
			if (selectorPosition < 0)
			{
				selectorPosition = selectorPositionMax - 1;
			}
			else if (selectorPosition >= selectorPositionMax)
			{
				selectorPosition = 0;
			}
		}
		
		
		selector.setPosition(oX + 60, oY + 60 + selectorPosition * selectorYOffset);
		
		
	}
	
	override public function draw():Void 
	{
		super.draw();
		trace(selector.x);
		//var rng : Array<Int> = [-400,-300,-200,-100,0,100,200,300,400];
	
		//trace(this.length);
		
		//bg.draw();
	}
}