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
	private static var _chargeSpeed : Float = 180;
	
	
	private static var _timeInChargeMax : Float = -0.6;
	private static var _recoverTime : Float = _timeInChargeMax -  1.25;
	
	
	var dashRangeInTiles : Float  = 4.0;
	
	
	
	//var attackSound : FlxSound;
	

    //#################################################################

    public function new( playState: PlayState)
    {
        super(playState);

        MaxHealth      = health;

        makeGraphic(16, 12);
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
		
		_chargeTime -= FlxG.elapsed;
		//trace(_chargeTime);
        var playerVector = new FlxVector(_playState.player.x + _playState.player.width/2.0, _playState.player.y + _playState.player.height/2.0);
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
				color = FlxColor.BROWN;
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
					color = FlxColor.BLUE;
					_chargeTime = 0.45; 
					this.velocity.set();
					this.acceleration.set();
				
				}
				// Trigger: loose track of player 
				if (_distanceToPlayer >= aggroRangeInTiles * 1.2 * GameProperties.TileSize)
				{
					_playerLocked = false;
					maxVelocity.set(_normalRandomWalkSpeed, _normalRandomWalkSpeed);
					this.velocity.set();
					this.acceleration.set();
				}
				else
				{
					color = FlxColor.RED;
					acceleration.set(
						direction.x * accel,
						direction.y * accel
					);
				}
			}
			else if (_chargeTime <= 0)
			{
				color = FlxColor.GREEN;
				
				
				// trigger: back to randomWalk
				if (_chargeTime - FlxG.elapsed < _timeInChargeMax)
				{
					_playerLocked = false;
					color = FlxColor.BROWN;
					maxVelocity.set(_normalRandomWalkSpeed, _normalRandomWalkSpeed);
					drag.set(_normalDrag, _normalDrag);
					velocity.set();
					acceleration.set();
				}
				
				
			}
			else 	// charge time > 0
			{
				
				color = FlxColor.YELLOW;
				// charging and dont move
				velocity.set();
				acceleration.set();
				// trigger: Charge 
				if (_chargeTime - FlxG.elapsed <= 0)
				{
					maxVelocity.set(_chargeSpeed, _chargeSpeed);
					this.drag.set(_chargeDrag, _chargeDrag);
					this.velocity.set(direction.x * _chargeSpeed, direction.y * _chargeSpeed);
					
				}
				
			}
			
		}
		
		
    }
	


    //#################################################################

	public override function drawUnderlay()
	{

	}
	
    public override function draw()
    {
        super.draw();
    }


    //#################################################################
}