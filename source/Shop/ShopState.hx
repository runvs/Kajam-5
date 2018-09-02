package;

import ShopItem;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
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
									
	private var bg : FlxSprite;
	
	private var _state : PlayState;
	
	private var inputWallTime : Float = 0;
	
	private var selector : FlxSprite;
	private var selectorPosition : Int = 0;
	private var selectorPositionMax : Int = 4;
	public static var selectorYOffset : Int = 28;
	
	public static var oX : Float = 200;
	public static var oY: Float = 150;
	
	public var allEntries : AdministratedList<ShopItem>;
	
	private var goldtxt : FlxText;
	
	private var itemDescriptionText : FlxText;
	
	public function new(s : PlayState) 
	{
		super();
		_state = s;
		allEntries = new AdministratedList<ShopItem>();
		
	}
	
	override public function create():Void 
	{
		super.create();
		
		bg = new FlxSprite(oX + 20 + 8  , oY + 2 );
		//bg.makeGraphic(300,200);
		bg.loadGraphic(AssetPaths.ShopBg__png, false, 360, 260);
		//bg.color = FlxColor.fromRGB(102, 57, 49);
		bg.scrollFactor.set();
		add(bg);
		
		selector = new FlxSprite (oX + 60, oY + 60);
		//selector.makeGraphic(16, 16);
		selector.loadGraphic(AssetPaths.Arrow__png);
		selector.scrollFactor.set();
		add(selector);
		
		add(allEntries);
		
		goldtxt = new FlxText(oX + 200 - 100, oY + 10, 100, "gold: " + _state.player.gold);
		goldtxt.scrollFactor.set();
		add(goldtxt);
		
		itemDescriptionText = new FlxText(oX + 40, oY + 180, 150, "");
		itemDescriptionText.scrollFactor.set();
		add(itemDescriptionText);
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
		else
		{
			setShopTypeArmor();
		}
	}
	
	function setShopTypeArmor() 
	{
		allEntries.getList().clear();
		{
			var cost : Int = 5;
			if (_state.player.inventory.hasBoughtRobe) cost = 0;
			var i : ShopItem = new ShopItem(AssetPaths.robe__png, Item.GetRobe(), cost, 
			function(s:PlayState)
			{
				s.player.inventory.hasBoughtRobe = true;
				s.player.pickupItem(Item.GetRobe());
			});
			//trace(allEntries.length);
			i.ItemPos = allEntries.getList().length;
			
			
			allEntries.add(i);
		}
		{
			var cost : Int = 10;
			if (_state.player.inventory.hasBoughtLeatherArmor) cost = 0;
			var i : ShopItem = new ShopItem(AssetPaths.leatherarmor__png, Item.GetLeatherArmor(), cost, 
			function(s:PlayState)
			{
				s.player.inventory.hasBoughtLeatherArmor = true;
				s.player.pickupItem(Item.GetLeatherArmor());
			});
			i.ItemPos = allEntries.getList().length;
			allEntries.add(i);
		}
		{
			var cost : Int = 15;
			if (_state.player.inventory.hasBoughtChainMail) cost = 0;
			var i : ShopItem = new ShopItem(AssetPaths.chainmail__png, Item.GetChainMail(), cost, 
			function(s:PlayState)
			{
				s.player.inventory.hasBoughtChainMail = true;
				s.player.pickupItem(Item.GetChainMail());
			});
			i.ItemPos = allEntries.getList().length;
			
			allEntries.add(i);
		}
		{
			var cost : Int = 25;
			if (_state.player.inventory.hasBoughtPlateMail) cost = 0;
			var i : ShopItem = new ShopItem(AssetPaths.platemail__png, Item.GetPlateMail(), cost, 
			function(s:PlayState)
			{
				s.player.inventory.hasBoughtPlateMail = true;
				s.player.pickupItem(Item.GetPlateMail());
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
	
	function setShopTypeBow() 
	{
		allEntries.getList().clear();
		{
			var cost : Int = 5;
			if (_state.player.inventory.hasBoughtSelfBow) cost = 0;
			var i : ShopItem = new ShopItem(AssetPaths.selfbow__png, Item.GetSelfbow(), cost, 
			function(s:PlayState)
			{
				s.player.inventory.hasBoughtSelfBow = true;
				s.player.pickupItem(Item.GetSelfbow());
			});
			//trace(allEntries.length);
			i.ItemPos = allEntries.getList().length;
			
			
			allEntries.add(i);
		}
		{
			var cost : Int = 10;
			if (_state.player.inventory.hasBoughtLongBow) cost = 0;
			var i : ShopItem = new ShopItem(AssetPaths.longbow__png, Item.GetLongbow(), cost, 
			function(s:PlayState)
			{
				s.player.inventory.hasBoughtLongBow = true;
				s.player.pickupItem(Item.GetLongbow());
			});
			i.ItemPos = allEntries.getList().length;
			allEntries.add(i);
		}
		{
			var cost : Int = 15;
			if (_state.player.inventory.hasBoughtCrossbow) cost = 0;
			var i : ShopItem = new ShopItem(AssetPaths.crossbow__png, Item.GetCrossbow(), cost, 
			function(s:PlayState)
			{
				s.player.inventory.hasBoughtCrossbow = true;
				s.player.pickupItem(Item.GetCrossbow());
			});
			i.ItemPos = allEntries.getList().length;
			
			allEntries.add(i);
		}
		{
			var cost : Int = 25;
			if (_state.player.inventory.hasBoughtRecurveBow) cost = 0;
			var i : ShopItem = new ShopItem(AssetPaths.recurvebow__png, Item.GetRecurveBow(), cost, 
			function(s:PlayState)
			{
				s.player.inventory.hasBoughtRecurveBow = true;
				s.player.pickupItem(Item.GetRecurveBow());
			});
			i.ItemPos = allEntries.getList().length;
			
			allEntries.add(i);
		}
		//trace(allEntries.length);
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
	
	function setShopTypeWeapon()
	{
		
		allEntries.getList().clear();
		{
			var cost : Int = 5;
			if (_state.player.inventory.hasBoughtShortSword) cost = 0;
			var i : ShopItem = new ShopItem(AssetPaths.shortsword__png, Item.GetShortSword(), cost, 
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
			var i : ShopItem = new ShopItem(AssetPaths.dagger__png, Item.GetDagger(), cost, 
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
			var i : ShopItem = new ShopItem(AssetPaths.claymore__png, Item.GetClaymore(), cost, 
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
			var i : ShopItem = new ShopItem(AssetPaths.katana__png, Item.GetKatana(), cost, 
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
		
		CreditsScene.playTime += elapsed;
		_state.updatePlayTimeText();
		
		goldtxt.text = "gold: " + _state.player.gold;
		
		if (MyInput.DashButtonJustPressed || FlxG.keys.justPressed.ESCAPE)
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
				inputWallTime = GameProperties.WorldShopInputWallTime;
			}
			if (MyInput.yVal >= 0.1)
			{
				selectorPosition++;
				inputWallTime = GameProperties.WorldShopInputWallTime;
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
		
		itemDescriptionText.text = allEntries.getList().members[selectorPosition].item.getInfoString();
		
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