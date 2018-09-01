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
	
	public var allEntries : AdministratedList<ShopItem>;
	
	
	public function new(s : PlayState) 
	{
		super();
		_state = s;
		allEntries = new AdministratedList<ShopItem>();
		
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
		//allEntries = new AdministratedList<ShopItem>();
		allEntries.getList().clear();
		{
			var cost : Int = 5;
			if (_state.player.inventory.hasBoughtShortSword) cost = 0;
			var i : ShopItem = new ShopItem(AssetPaths.shortsword__png, "short sword", cost, 
			function(s:PlayState)
			{
				s.player.inventory.hasBoughtShortSword = true;
				s.player.pickupItem(Item.GetShortSword());
			});
			//trace(allEntries.length);
			i.ItemPos = allEntries.getList().length;
			
			
			allEntries.add(i);
		}
		{
			var cost : Int = 10;
			if (_state.player.inventory.hasBoughtDagger) cost = 0;
			var i : ShopItem = new ShopItem(AssetPaths.dagger__png, "dagger", cost, 
			function(s:PlayState)
			{
				s.player.inventory.hasBoughtDagger = true;
				s.player.pickupItem(Item.GetDagger());
			});
			i.ItemPos = allEntries.getList().length;
			allEntries.add(i);
		}
		{
			var cost : Int = 15;
			if (_state.player.inventory.hasBoughtClaymore) cost = 0;
			var i : ShopItem = new ShopItem(AssetPaths.claymore__png, "claymore", cost, 
			function(s:PlayState)
			{
				s.player.inventory.hasBoughtClaymore = true;
				s.player.pickupItem(Item.GetClaymore());
			});
			i.ItemPos = allEntries.getList().length;
			
			allEntries.add(i);
		}
		{
			var cost : Int = 25;
			if (_state.player.inventory.hasBoughtKatana) cost = 0;
			var i : ShopItem = new ShopItem(AssetPaths.katana__png, "katana", cost, 
			function(s:PlayState)
			{
				s.player.inventory.hasBoughtKatana = true;
				s.player.pickupItem(Item.GetKatana());
			});
			i.ItemPos = allEntries.getList().length;
			
			
			allEntries.add(i);
		}
		for (i in allEntries)
		{
			//trace(i.ItemCost + " " + _state.player.gold);
			
			if (_state.player.gold < i.ItemCost)
			{
				//trace("not available ");
				i.available = false;
			}
		}
		
		selectorPositionMax = allEntries.getList().length;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		MyInput.update();
		
		if (MyInput.DashButtonJustPressed)
		{
			this.close();
		}
		if (MyInput.InteractButtonJustPressed)
		{
			Buy();
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
	
	function Buy() 
	{
		var si : ShopItem = allEntries.getList().members[selectorPosition];
		
		if (si.available)
		{
			si.onBuy(_state);
			this.close();
		}
	}
	
	override public function draw():Void 
	{
		super.draw();
		
	}
}