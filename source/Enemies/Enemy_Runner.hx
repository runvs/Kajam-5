package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Enemy_Runner extends Enemy
{
    //#################################################################

	public var AttackTimer : Float = 0.1;
    
    public var aggroRangeInTiles   : Float = 5.5;
    public var accel : Float = 550;
	
    private var _thinkTime    : Float = 0;
    private var _playerLocked : Bool = false;
	
	private var _distanceToPlayer : Float = 0;
	private var _chargeTime : Float = _recoverTime;
	
	
	private static var _normalRandomWalkSpeed : Float = 35;
	private static var _normalDrag : Float  = 250;
	
	private static var _chargeDrag : Float = 10;
	private static var _chargeSpeed : Float = 160;
	
	
	private static var _timeInChargeMax : Float = -0.6;
	private static var _recoverTime : Float = _timeInChargeMax -  1.25;
	
	
	private var underlay : GlowOverlay;
	
	
	var dashRangeInTiles : Float  = 4.0;
	var isHurting : Bool = false;
	
	
	
	//var attackSound : FlxSound;
	

    //#################################################################

    public function new( playState: PlayState)
    {
        super(playState);

		health = 30;
        MaxHealth      = health;

        //makeGraphic(16, 12);
		this.loadGraphic(AssetPaths.slime__png, true, 16, 16);
		animation.add("walk", [0, 1, 2, 3], 8);
		animation.add("charge", [8], 8, true);
		animation.add("push", [4, 5], 8);
		this.animation.play("walk");
		//this.loadGraphic(AssetPaths.enemy__png, true, 16, 16);
		//this.animation.add("walk_south", [0, 8, 16,  24], 8);
		//this.animation.add("walk_west",  [1, 9, 17,  25], 8);
		//this.animation.add("walk_north", [2, 10, 18, 26], 8);
		//this.animation.add("walk_east",  [3, 11, 19, 27], 8);
		//this.animation.add("attackUP",   [4, 12], 3, false);
		//this.animation.add("attackDOWN", [12, 20, 28,28,28], 4, false);
		//this.animation.add("idle", [0]);
		//this.animation.play("idle");
		
		_facing = Facing.SOUTH;
		
		this.color = FlxColor.WHITE;

        drag.set(_normalDrag,_normalDrag);
        maxVelocity.set(_normalRandomWalkSpeed,_normalRandomWalkSpeed);
		
		_distanceToPlayer = 0;
		
		
		enemySpladderColor = FlxColor.fromRGB(18,33,21);
		
		underlay = new GlowOverlay(0, 0, FlxG.camera, 26, 1, 1.25);
		underlay.alpha = 0;
		underlay.scale.set(1, 1);
		
		
		//attackSound = FlxG.sound.load(AssetPaths.takeHit__ogg, 0.125);
		
    }

	override public function onDeath() 
	{
		super.onDeath();
		
	}

    //#################################################################

    public override function update(elapsed)
    {
		super.update(elapsed);
		
		doMovement();
		doAnimations();
		
		
    }
	
    //#################################################################

    function doMovement()
    {
		
		underlay.alpha = 0;
		_chargeTime -= FlxG.elapsed;
		//trace(_chargeTime);
        var playerVector = new FlxVector(_state.player.x + _state.player.width/2.0, _state.player.y + _state.player.height/2.0);
        var enemyVector = new FlxVector(x + width/2.0, y + height/2);
		
		_distanceToPlayer = playerVector.dist(enemyVector);
		var direction :FlxVector = playerVector.subtractNew(enemyVector).normalize();
		
		if (!_playerLocked) 
		{
			if ( _chargeTime <= _recoverTime)
			{
				color = FlxColor.WHITE;
				
				maxVelocity.set(_normalRandomWalkSpeed, _normalRandomWalkSpeed);
				_thinkTime -= FlxG.elapsed;
				if (_thinkTime <= 0)
				{
					_thinkTime = GameProperties.EnemyMovementRandomWalkThinkTime;
					velocity.set();
					this.animation.play("walk");
					acceleration.set(
						FlxG.random.float(-1.0, 1.0) * accel,
						FlxG.random.float(-1.0, 1.0) * accel 
					);
				}
				
				if (_distanceToPlayer <= aggroRangeInTiles * GameProperties.TileSize)
				{
					
					_thinkTime = GameProperties.EnemyMovementRandomWalkThinkTime;
					_playerLocked = true;
					velocity.set(direction.x * _normalRandomWalkSpeed, direction.y*_normalRandomWalkSpeed);
				}
			}
			else
			{
				
				
				velocity.set();
				acceleration.set();
			}
		}
		else
		{
			// player is locked
			
			
			
			
			
			
			// 
			if (_chargeTime < _timeInChargeMax)
			{	
				// Trigger: start charging process
				if (_distanceToPlayer <= dashRangeInTiles * GameProperties.TileSize)
				{
				
					
					animation.play("charge", true);
					_chargeTime = GameProperties.EnemyRunnerChargeTime; 
					this.velocity.set();
					this.acceleration.set();
				
				}
				// Trigger: loose track of player 
				if (_distanceToPlayer >= aggroRangeInTiles * 1.2 * GameProperties.TileSize)
				{
					_playerLocked = false;
					this.animation.play("walk");
					maxVelocity.set(_normalRandomWalkSpeed, _normalRandomWalkSpeed);
					this.velocity.set();
					this.acceleration.set();
				}
				else
				{
					
					this.animation.play("walk");
					acceleration.set(
						direction.x * accel,
						direction.y * accel
					);
				}
			}
			else if (_chargeTime <= 0)
			{
				//color = FlxColor.GREEN;
				
				
				// trigger: back to randomWalk
				if (_chargeTime - FlxG.elapsed < _timeInChargeMax)
				{
					isHurting = false;
					_playerLocked = false;
					color = FlxColor.BROWN;
					this.animation.play("walk");
					maxVelocity.set(_normalRandomWalkSpeed, _normalRandomWalkSpeed);
					drag.set(_normalDrag, _normalDrag);
					velocity.set();
					acceleration.set();
				}
				
				
			}
			else 	// charge time > 0
			{
				// charging and dont move
				velocity.set();
				acceleration.set();
				
				
				var v : Float = (1 - (_chargeTime / GameProperties.EnemyRunnerChargeTime));
				underlay.alpha =  0.8 * v*v ;
				
				// trigger: Charge 
				if (_chargeTime - FlxG.elapsed <= 0)
				{
					this.animation.play("push");
					maxVelocity.set(_chargeSpeed, _chargeSpeed);
					this.drag.set(_chargeDrag, _chargeDrag);
					this.velocity.set(direction.x * _chargeSpeed, direction.y * _chargeSpeed);
					isHurting = true;
				}
				
			}
			
		}
		
		
    }
	


    //#################################################################

	public override function drawUnderlay()
	{
		underlay.setPosition(x + width/2, y + height/2);
		underlay.draw();
	}
	
    public override function draw()
    {
        super.draw();
    }


    //#################################################################
	
	override public function isHurtingPlayer():Bool 
	{
		return isHurting;
	}
}