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

class SmashGroundEnemy extends Enemy
{
    //#################################################################

    public var AttackStrength : Float;
	public var AttackTimer	  : Float;
    public var MaxHealth      : Float;
    public var CurrentHealth  : Float;
    public var attackRangeInTiles   : Float;
    public var accel : Float;
	
    private var _thinkTime    : Float;
    private var _playerLocked : Bool;
	
	private var _distanceToPlayer : Float;
	
	private var _idleTimer : Float;
	var _attacking:Bool;
	public var _attackingUnderlay : FlxSprite;
	
	
	
	//var attackSound : FlxSound;
	
	var colorTween : FlxTween = null;
	

    //#################################################################

    public function new( playState: PlayState)
    {
        super(playState);

        AttackStrength = 1;
		AttackTimer	   = 0.1;
        MaxHealth      = 1;
        CurrentHealth  = 1;
        attackRangeInTiles   = 4.5;
		accel = 550;
		_attacking 	   = false;

        _playState    = playState;
        _thinkTime    = GameProperties.EnemyMovementRandomWalkThinkTime;
        _playerLocked = false;

        makeGraphic(16, 16, flixel.util.FlxColor.fromRGB(255, 0, 255));
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
		
        setPosition(128, 160);
		this.color = FlxColor.WHITE;

        drag.set(250,250);
        maxVelocity.set(55,55);
		
		_distanceToPlayer = 0;
		_idleTimer = 0;
		
		
		_attackingUnderlay = new FlxSprite(x, y);
		var sf : Float = 3.5;
		_attackingUnderlay.makeGraphic(Std.int(GameProperties.TileSize * sf), Std.int(GameProperties.TileSize * sf));
		var ofs : Float = -GameProperties.TileSize * 0.5 + GameProperties.TileSize * sf * 0.5;
		_attackingUnderlay.offset.set(ofs, ofs);
		_attackingUnderlay.alpha = 0;
		
		//attackSound = FlxG.sound.load(AssetPaths.takeHit__ogg, 0.125);
		
    }

    //#################################################################

    public override function update(elapsed)
    {
		super.update(elapsed);
		_attackingUnderlay.setPosition(x, y);
		
		if (_attacking)
		{
			velocity.set();
			acceleration.set();
			immovable = true;
			
		}
		else
		{
			
			immovable = false;
			_idleTimer -= elapsed;
			AttackTimer -= elapsed;
			
			if (_idleTimer <= 0)
			{
				doMovement();
				
				doAnimations();
				
				
				
				if (_distanceToPlayer <= GameProperties.TileSize * 2.2)
				{
					Attack();	
				}
			}
			
			
		}
        
    }
	
	function Attack() 
	{
		if (!_attacking)
		{
			if (AttackTimer <= 0)
			{
				_attacking = true;
				this.animation.play("attackUP", true);
				_attackingUnderlay.alive = true;
				_attackingUnderlay.scale.set(1, 1);
				
				var t : FlxTimer = new FlxTimer();
				t.start(0.65, function(t: FlxTimer) 
				{
					FlxG.camera.shake(0.0025, 0.2);
					//attackSound.pitch = FlxG.random.float(0.2, 0.4);
					//attackSound.play();
					
					
					this.animation.play("attackDOWN");
					_attacking = false; 
					_idleTimer = 0.2;  
					AttackTimer = 0.45;
					this.velocity.set();
					this.acceleration.set();
					_attackingUnderlay.alpha = 1.0;
					FlxTween.tween(_attackingUnderlay, { alpha:0.0 }, 0.2);
					FlxTween.tween(_attackingUnderlay.scale, { x:1.5, y:1.5 }, 0.15,{startDelay:0.05});
				});
				
				FlxTween.tween(_attackingUnderlay, { alpha:0.5 }, 0.45*0.9);
			}
		}
	}

    //#################################################################

    public function hit(damage: Float, px:Float, py:Float)
    {
        CurrentHealth -= damage;
        //trace(CurrentHealth);
		
		// calculate pushback
		var dir : FlxVector = new FlxVector (x -px, y - py);
		dir = dir.normalize();
		
		this.velocity.set(dir.x * accel, dir.y * accel);
		_idleTimer = 0.35;
		
		if (colorTween != null)
		{
			colorTween.cancel();
			color = FlxColor.WHITE;
		}
		
		colorTween = FlxTween.color(this, 0.18, FlxColor.RED, FlxColor.WHITE, { type : FlxTween.PERSIST} );

        if(CurrentHealth <= 0.0)
        {
            alive = false;
			trace('I am dead');
			// TODO
			//_playState.level.spawnCoins(this);
			
			if (colorTween != null)
			{
				colorTween.cancel();
			}			
        }
    }

    //#################################################################

    function doMovement()
    {
		
        var playerVector = new FlxVector(_playState.player.x, _playState.player.y);
        var enemyVector = new FlxVector(x, y);
		
		_distanceToPlayer = playerVector.dist(enemyVector);

        if(_distanceToPlayer <= attackRangeInTiles * GameProperties.TileSize)
        {
            if(_distanceToPlayer > GameProperties.TileSize)
            {
                _playerLocked = true;

                var direction = playerVector.subtractNew(enemyVector).normalize();
                acceleration.set(
                    direction.x * accel,
                    direction.y * accel
                );
            }
            else
            {
                acceleration.set(0, 0);
            }
        }
        else
        {
            if(_playerLocked)
            {
                acceleration.set(0, 0);
                _playerLocked = false;
            }
            else
            {
                acceleration.set(acceleration.x / 10, acceleration.y / 10);
            }

            if(_thinkTime <= 0.0)
            {
                // Decide for a new direction to walk to
                _thinkTime += GameProperties.EnemyMovementRandomWalkThinkTime;
                
                acceleration.set(
                    FlxG.random.float(-1.0, 1.0) * accel ,
                    FlxG.random.float(-1.0, 1.0) * accel 
                );
            }
            else
            {
                _thinkTime -= FlxG.elapsed;
            }
        }
    }
	


    //#################################################################

	public override function drawUnderlay()
	{
		_attackingUnderlay.draw();
	}
	
    public override function draw()
    {
        super.draw();
    }


    //#################################################################
}