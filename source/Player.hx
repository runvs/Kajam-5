package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class Player extends FlashSprite
{
    //#################################################################

	public var swordItem  : Item;
	public var armorItem  : Item;
	public var bowItem    : Item;
	
	public var inventory : Inventory;
	public var gold : Int = 70;
	
	public var healthMax     : Float;
	
	public var _itemDashMultiplier : Float = 1.0;
	public var dashCooldownMultiplier : Float = 1.0;
	
    var _dashDir        : FlxPoint;
	var _dashCooldown   : Float;
    var _dashSpeedMax   : Float;
    var _accelFactor    : Float;
	var _dashSprite1    : FlxSprite;
	var _dashSprite2    : FlxSprite;
	var _dashSprite3    : FlxSprite;
	var _dashSprite4    : FlxSprite;

	var _state      : PlayState;

	var _hitArea        : FlxSprite;
	
	var _facing         : Facing;
	var _attackCooldown : Float;
	
	
	var _dashCooldownBar: HudBar;
	var _playerInfo     : PlayerInfo;

	
	//var _attackSound     : FlxSound;
	//var _dashSound       : FlxSound;
	//var _takeDamageSound : FlxSound;
	
	var _damageWallTime : Float = 0;
	
	var dustparticles : MyParticleSystem;
	var dustTime : Float = 0;
	
	var _slashSprite     :FlxSprite;
	public var timeSinceDash : Float = 0; 
	public var timeInTrap : Float = 0;
	
	public var walkSpeedMultiplier  : Float = 1.0;
	
	private var _bowTimer : Float = 0;
	
	private var bowBar : HudBar;
	
	private var healthCont : HealthContainer;
	
    //#################################################################

    public function new(playState: PlayState)
    {
        super();

		// Give the player some basic items
		trace('Picking up items...');
		pickupItem(Item.GetShortSword());
		pickupItem(Item.GetSelfbow());
		pickupItem(Item.GetRobe());
		trace('Items picked up.');
		
		inventory = new Inventory();

		loadGraphic(AssetPaths.Thyl__png, true, 16, 16);
		animation.add("walk_south", [0, 1, 2, 3], 8);
		animation.add("walk_west",  [12, 13, 14,  15], 8);
		animation.add("walk_north", [4, 5, 6, 7], 8);
		animation.add("walk_east",  [8, 9, 10, 11], 8);
		animation.add("idle", [0]);
		animation.play("idle");
		//makeGraphic(16,16);
		_dashSprite1 = new FlxSprite();
		_dashSprite1.makeGraphic(16, 16);
		
		_dashSprite2 = new FlxSprite();
		_dashSprite2.makeGraphic(16, 16);
		
		_dashSprite3 = new FlxSprite();
		_dashSprite3.makeGraphic(16, 16);
		
		_dashSprite4 = new FlxSprite();
		_dashSprite4.makeGraphic(16, 16);
		
		dustparticles = new MyParticleSystem();
		dustparticles.mySize = 500;

		_hitArea = new FlxSprite();
		_hitArea.makeGraphic(16, 16, flixel.util.FlxColor.fromRGB(255, 255, 255, 64));
		_hitArea.alpha = 0;
		_facing = Facing.SOUTH;
		_attackCooldown = 0.0;
		
		_accelFactor = GameProperties.PlayerMovementAcceleration;
		drag         = GameProperties.PlayerMovementDrag;
		maxVelocity  = GameProperties.PlayerMovementMaxVelocity;

		//trace("player max velo X: " + maxVelocity.x);
		//trace("player max velo Y: " + maxVelocity.y);
        _dashCooldown = 0;
        _dashDir = new FlxPoint();
		

		_state = playState;

		setPosition(12 * GameProperties.TileSize, 15 * GameProperties.TileSize);
		
		health = healthMax = GameProperties.PlayerHealthMaxDefault;
		healthCont = new HealthContainer(AssetPaths.heart_empty__png, AssetPaths.heart_half__png, AssetPaths.heart_full__png);
		healthCont.SetHealth(health, healthMax);
		
		_dashCooldownBar = new HudBar(10, 32, 48, 8, false, FlxColor.BLUE);
		//_dashCooldownBar.color = GameProperties.ColorStaminaBar;
		_dashCooldownBar._background.color = FlxColor.fromRGB(100, 100, 100, 100);

		_playerInfo = new PlayerInfo(this);
		bowBar = new HudBar(0, 0, 32, 10, false, FlxColor.BLUE);
		
		//_attackSound     = FlxG.sound.load(AssetPaths.attack1__ogg, 1);
		//_dashSound       = FlxG.sound.load(AssetPaths.dash__ogg, 0.25);
		//_takeDamageSound = FlxG.sound.load(AssetPaths.takeHit__ogg, 1);
		//
		_slashSprite = new FlxSprite();
		_slashSprite.loadGraphic(AssetPaths.slash__png, true, 16, 16);
		_slashSprite.animation.add("slash", [4, 5, 6, 3], 14, false);
		_slashSprite.animation.add("idle", [3]);
		_slashSprite.animation.play("idle");
		_slashSprite.origin.set(8, 8);
		
		
    }

    //#################################################################

    public override function update(elapsed: Float)
    {
        super.update(elapsed);
		timeSinceDash += elapsed;
		_damageWallTime -= elapsed;
		//dustparticles.update(elapsed);
		
		_slashSprite.update(elapsed);
		
		_dashSprite1.update(elapsed);
		_dashSprite2.update(elapsed);
		_dashSprite3.update(elapsed);
		_dashSprite4.update(elapsed);
		
		handleSlashSpriteAndAnim();

        handleInput(elapsed);
		var l : Float = velocity.distanceTo(new FlxPoint());
		if (l <= GameProperties.PlayerMovementMaxVelocity.x / 8 )
		{
			animation.play("idle", true);
		}
		else
		{
			dustTime -= elapsed;
		}
		
        _playerInfo.update(elapsed);
		
		
        _dashSpeedMax = GameProperties.PlayerMovementDashCooldown;
        _dashSpeedMax = _dashSpeedMax < 0.5 ? 0.5 : _dashSpeedMax;

		_dashCooldownBar.health = 1.0 - _dashCooldown / _dashSpeedMax;
		_dashCooldownBar.update(elapsed);
		
		updateBow(elapsed);
		
		if (FlxG.keys.justPressed.F9)
		{
			health -= 0.5;
			
		}
		if (FlxG.keys.justPressed.F10)
		{
			health += 0.5;
		}
		
    }
	
	function updateBow(elapsed:Float) 
	{
		bowBar.update(elapsed);
		if (MyInput.BowButtonJustPressed)
		{
			//trace("justpressed");
			maxVelocity = getMaxVelocityWithItems().scale(GameProperties.PlayerBowSlowDownFactor);
		}
		else if (MyInput.BowButtonJustReleased)
		{
			//trace("justreleased");
			maxVelocity = getMaxVelocityWithItems();
			ShootBow();
		}
		
		
		bowBar.health = 0;
		
		if (MyInput.BowButtonPressed)
		{
			_bowTimer += elapsed;
			var v : Float = _bowTimer / GameProperties.PlayerBowMaxTimer;
			if (v <= 0) v = 0;
			if (v >= 1) v = 1;
			bowBar.health = v;
			
		}
		
		healthCont.SetHealth(health, healthMax);
		//trace(health + " " + healthMax);
	}
	
	function ShootBow() 
	{
		if (_bowTimer >= 0.05)
		{
			var dx : Float = velocity.x;
			var dy : Float = velocity.y;
			var l : Float = Math.sqrt(dx * dx + dy * dy);
			if (l == 0)
			{
				l = 1;
				switch _facing
				{
					case Facing.EAST:
						dx = 1;
						dy = 0;
						
					case Facing.WEST:
						dx = -1;
						dy = 0;
						
					case Facing.NORTH:
						dx = 0;
						dy = -1;						
			
					case Facing.SOUTH:
						dx = 0;
						dy = 1;
					
					case Facing.NORTHEAST:
						dx = Math.sqrt(2.0);
						dy = -Math.sqrt(2.0);
						
					case Facing.NORTHWEST:
						dx = -Math.sqrt(2.0);
						dy = -Math.sqrt(2.0);
						
					case Facing.SOUTHEAST:
						dx = Math.sqrt(2.0);
						dy = Math.sqrt(2.0);
						
					case Facing.SOUTHWEST:
						dx = -Math.sqrt(2.0);
						dy = Math.sqrt(2.0);
				}
			}
			
			var v : Float = _bowTimer / GameProperties.PlayerBowMaxTimer;
			if (v < 0) return;
			if (v >= 1) v = 1;
			var s : PlayerShot = new PlayerShot(x , y , dx/l, dy/l, v);
			_state.level.allPlayerShots.add(s);
		}
		
		_bowTimer = 0;
	}
	

    //#################################################################

    function handleInput(elapsed : Float)
    {
        var vx : Float = MyInput.xVal * _accelFactor;
		var vy : Float = MyInput.yVal * _accelFactor;
		var l : Float = Math.sqrt(vx * vx + vy * vy);

		if(MyInput.InventoryButtonJustPressed) {
			_playerInfo.visible = !_playerInfo.visible;
		}
		
		if (l >= 25)
		{
			_dashDir.set(vx / l, vy / l);

			if(vx > 0)
			{
				_facing = Facing.EAST;
				if(vy > 0) _facing = Facing.SOUTHEAST;
				if(vy < 0) _facing = Facing.NORTHEAST;
			}
			else if(vx < 0)
			{
				_facing = Facing.WEST;
				if(vy > 0) _facing = Facing.SOUTHWEST;
				if(vy < 0) _facing = Facing.NORTHWEST;
			}
			else
			{
				if(vy > 0) _facing = Facing.SOUTH;
				if(vy < 0) _facing = Facing.NORTH;
			}
		}
		acceleration.set(vx, vy);
		
		if (acceleration.x > 0 && velocity.x < 0 || acceleration.x < 0 && velocity.x > 0)
			velocity.x *= 0.3;
		if (acceleration.y > 0 && velocity.y < 0 || acceleration.y < 0 && velocity.y > 0)
			velocity.y *= 0.3;
			
		if (_dashCooldown <= 0)
		{
			if (MyInput.DashButtonJustPressed)
			{
				dash();
				_dashCooldown = getDashTime();
                //trace(_dashSpeedMax);
				velocity.set(velocity.x/2, velocity.y/2);
			}
		}
		else
		{
			_dashCooldown -= elapsed;
		}
		
		_attackCooldown -= elapsed;
		if(_attackCooldown <= 0.0)
		{
			if(MyInput.InteractButtonJustPressed) attack();
		}
    }
	
	public function getDashTime() : Float
	{
		return _dashSpeedMax  / dashCooldownMultiplier;
	}

    //#################################################################

	function attack()
	{
		//trace("attack");
		_attackCooldown += GameProperties.PlayerAttackCooldown;
		_slashSprite.animation.play("slash", true);

		//if(GameProperties.SoundTimeout <= 0.0)
		//{
			//_attackSound.pitch = GameProperties.rng.float(0.8, 1.2);
			//_attackSound.play();
//
			//GameProperties.SoundTimeout = GameProperties.SoundTimeoutMax;
		//}
		
		var enemyHit = false;
		// TODO check if enemy is hit
		for(enemy in _state.level.allEnemies)
		{
			if(FlxG.overlap(_hitArea, enemy))
			{
				enemy.hit(getMeleeDamage(), x, y);
				enemyHit = true;
				_state.level.spladder(enemy.x + GameProperties.TileSize/2, enemy.y + GameProperties.TileSize/2, enemy.enemySpladderColor);
			}
		}
		
		for (ti in _state.level.allTrigger)
		{
			var t : Trigger = ti;
			//trace(_hitArea);
			//trace(t);
			
			if (FlxG.overlap(_hitArea, t))
			{
				t.perform();
			}
		}
		
		
		for (ni in _state.level.allNSCs)
		{
			var n: NPC = ni;
		//trace(n.objectName + " " + FlxG.overlap(n, _hitArea));	
			if (FlxG.overlap(n, _hitArea))
			{
				n.interact();
			}
		}
	}

    //#################################################################

    public function getMeleeDamage() : Float
    {
		var damageMultiplier = (swordItem.damageMultiplier + armorItem.damageMultiplier) / 2;
		return GameProperties.PlayerAttackBaseDamage * damageMultiplier;
    }

	//#################################################################

	public function getRangedDamage() : Float
	{
		var damageMultiplier = (bowItem.damageMultiplier + armorItem.damageMultiplier) / 2;
		return GameProperties.PlayerAttackBaseDamage * damageMultiplier;
	}

	//#################################################################

	public function pickupItem(item : Item) : Void
	{
		trace('Picking up a ' + item.name);
		trace(item);
		if(item.type == ItemType.SWORD) {
			swordItem = item;
		} else if(item.type == ItemType.BOW) {
			bowItem = item;
		} else if(item.type == ItemType.ARMOR) {
			armorItem = item;
		}
		
		if(swordItem == null || bowItem == null || armorItem == null) return;
		
		walkSpeedMultiplier = (
			swordItem.walkSpeedMultiplier
			+ bowItem.walkSpeedMultiplier
			+ armorItem.walkSpeedMultiplier
		) / 3.0;
		maxVelocity = getMaxVelocityWithItems();

		_itemDashMultiplier = (
			swordItem.dashDistanceMultiplier
			+ bowItem.dashDistanceMultiplier
			+ armorItem.dashDistanceMultiplier
		) / 3.0;
		
		dashCooldownMultiplier = (
			swordItem.dashCooldownMultiplier 
			+ bowItem.dashCooldownMultiplier
			+ armorItem.dashCooldownMultiplier
		)/3.0;
	}

    //#################################################################

	public function getMaxVelocityWithItems()  : FlxPoint
	{
		return new FlxPoint(GameProperties.PlayerMovementMaxVelocity.x,GameProperties.PlayerMovementMaxVelocity.y).scale(walkSpeedMultiplier);
	}
	
	function dash()
	{
		var stepSize = GameProperties.PlayerMovementMaxDashLength / GameProperties.TileSize / 2 * _itemDashMultiplier;
		var currentStep = 0.0;
		var lastPosition    = new FlxVector(x, y);
		var initialPosition = new FlxVector(x, y);

		_damageWallTime = 0.2;
		timeSinceDash = - 0.2;
		
		//if(GameProperties.SoundTimeout <= 0.0)
		//{
			//_dashSound.play();	
			//GameProperties.SoundTimeout = GameProperties.SoundTimeoutMax;
		//}

		while(currentStep < GameProperties.PlayerMovementMaxDashLength * _itemDashMultiplier)
		{
			lastPosition = new FlxVector(x, y);

			setPosition(x + _dashDir.x * stepSize, y + _dashDir.y * stepSize);

			 
			if(FlxG.overlap(this, _state.level.collisionMap))
			{
				setPosition(lastPosition.x, lastPosition.y);
				break;
			}
//
			currentStep += stepSize;
		}

		var dashSprite2Position = lastPosition.subtractNew(initialPosition).scale(0.33);
		var dashSprite3Position = lastPosition.subtractNew(initialPosition).scale(0.66);
		var dashSprite4Position = lastPosition.subtractNew(initialPosition).scale(1.0);
		_dashSprite1.setPosition(initialPosition.x, initialPosition.y);
		_dashSprite2.setPosition(initialPosition.x + dashSprite2Position.x, initialPosition.y + dashSprite2Position.y);
		_dashSprite3.setPosition(initialPosition.x + dashSprite3Position.x, initialPosition.y + dashSprite3Position.y);
		_dashSprite4.setPosition(initialPosition.x + dashSprite4Position.x, initialPosition.y + dashSprite4Position.y);
		_dashSprite1.alpha = 0.9;
		_dashSprite2.alpha = 0.8;
		_dashSprite3.alpha = 0.7;
		_dashSprite4.alpha = 0.6;
		FlxTween.tween(_dashSprite1, { alpha: 0 }, 0.3);
		FlxTween.tween(_dashSprite2, { alpha: 0 }, 0.4);
		FlxTween.tween(_dashSprite3, { alpha: 0 }, 0.5);
		FlxTween.tween(_dashSprite4, { alpha: 0 }, 0.55);
	}
	
	function handleSlashSpriteAndAnim():Void 
	{
		_slashSprite.setPosition(_hitArea.x, _hitArea.y);
		
		switch _facing
		{
			case Facing.EAST:
				_hitArea.setPosition(x + GameProperties.TileSize, y);
				animation.play("walk_east", false);
				_slashSprite.angle = 90;
				
			case Facing.WEST:
				_hitArea.setPosition(x - GameProperties.TileSize, y);
				animation.play("walk_west", false);
				_slashSprite.angle = -90;
				
			case Facing.NORTH:
				_hitArea.setPosition(x, y - GameProperties.TileSize);
				animation.play("walk_north", false);
				_slashSprite.angle = 0;
				
	
			case Facing.SOUTH:
				_hitArea.setPosition(x, y + GameProperties.TileSize);
				animation.play("walk_south", false);
				_slashSprite.angle = 180;
			
			case Facing.NORTHEAST:
				_hitArea.setPosition(x + GameProperties.TileSize / 2, y - GameProperties.TileSize / 2);
				animation.play("walk_north", false);
				_slashSprite.angle = 45;
			case Facing.NORTHWEST:
				_hitArea.setPosition(x - GameProperties.TileSize / 2, y - GameProperties.TileSize / 2);
				animation.play("walk_north", false);
				_slashSprite.angle = -45;
				
			case Facing.SOUTHEAST:
				_hitArea.setPosition(x + GameProperties.TileSize / 2, y + GameProperties.TileSize / 2);
				animation.play("walk_south", false);
				_slashSprite.angle = 135;
				
			case Facing.SOUTHWEST:
				_hitArea.setPosition(x - GameProperties.TileSize / 2, y + GameProperties.TileSize / 2);
				animation.play("walk_south", false);
				_slashSprite.angle = -135;
		}
	}

    //#################################################################
	
	public override function draw() 
	{
		dustparticles.draw();

		_dashSprite1.draw();
		_dashSprite2.draw();
		_dashSprite3.draw();
		_dashSprite4.draw();
		super.draw();

		_hitArea.draw();
		_slashSprite.draw();
	}

    //#################################################################

	public function drawHud()
	{

		//_dashCooldownBar.draw();

		if (_bowTimer > 0)
		{
			bowBar.setPosition(FlxG.camera.target.x - FlxG.camera.scroll.x, FlxG.camera.target.y - FlxG.camera.scroll.y - 32);
			//trace(bowBar.x + " " + bowBar.y);
			bowBar.draw();
		}
		if(_playerInfo.visible) {
			_playerInfo.draw();
		}
		
		
		drawHealthContainer();
		
		// TODO draw inventory
	}
	
	function drawHealthContainer() 
	{
		healthCont.draw();
	}

    //#################################################################
	
	public function heal(f:Float)
	{
		if (health >= healthMax) return;
		
		this.health += f;
		if (f >= healthMax)
		f = healthMax;
		
		FlxTween.color(this, 0.25, FlxColor.GREEN, FlxColor.WHITE, { type : FlxTweenType.PERSIST} );
	}

    //#################################################################
	
	public function takeDamage(d:Float) : Void
	{
		if (_damageWallTime > 0) return;
		
		_damageWallTime = GameProperties.PlayerDamageWallTime;
		
		trace(health + " - " + d  + " = " + (health - d) );
		
		health -= d;
		if (health <= 0)
		{
			alive = false;
		}
		
		this.Flash(0.2, FlxColor.RED);
		_state.level.spladder(x, y, FlxColor.RED);
		
	}


    //#################################################################
	
	public function restoreHealth()
	{
		health = healthMax;
	}
	
    //#################################################################
}