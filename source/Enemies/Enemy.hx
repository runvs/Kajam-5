package;

import flixel.FlxSprite;
import flixel.math.FlxVector;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Enemy extends FlashSprite
{

	private var _state    : PlayState;
	private var _facing       : Facing;
	
	public var MaxHealth      : Float;
	
	private var _idleTimer : Float;
	
	private var _takeDamageWallTime : Float = 0;
	
	public var enemySpladderColor : FlxColor;
	
	public function new(s : PlayState) 
	{
		super();
		_state = s;
		_idleTimer = 0;
		health = 30;
		enemySpladderColor = FlxColor.fromRGB(175, 0, 0);
	}
	
	public function drawUnderlay()
	{
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		_takeDamageWallTime -= elapsed;
	}
	
	private function doAnimations():Void 
	{
		var vx : Float = velocity.x;
		var vy : Float = velocity.y;
		
		if (vx * vx + vy * vy > maxVelocity.x * maxVelocity.y / 8 / 8)
		{
			if(vx > 0)
			{
				_facing = Facing.EAST;
				this.animation.play("walk_east",false);
			
			}
			else if(vx < 0)
			{
				_facing = Facing.WEST;
				this.animation.play("walk_west",false);
				
			}
			else
			{
				if (vy > 0) 
				{
					_facing = Facing.SOUTH;
					this.animation.play("walk_south",false);
				}
				
				if (vy < 0) 
				{
					_facing = Facing.NORTH;
					this.animation.play("walk_north",false);
				}
			}
		}
	}
	
	
	public function hit(damage: Float, px:Float, py:Float)
    {
		if (_takeDamageWallTime >= 0) return;
		
		
		_takeDamageWallTime = 0.1;
        health -= damage;
        trace(health);
		
		// calculate pushback
		var dir : FlxVector = new FlxVector (x -px, y - py);
		dir = dir.normalize();
		
		this.velocity.set(dir.x * 300, dir.y * 300);
		_idleTimer = 0.35;
		
		Flash(0.5, FlxColor.RED);
		
        if(health <= 0.0)
        {
            alive = false;
			onDeath();
			//trace('I am dead');
        }
    }

	public function onDeath()
	{
		_flashOverlay.alpha = 0;
		_flashTimer = -1;
	}
	
}