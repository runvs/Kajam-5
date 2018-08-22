package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Enemy extends FlxSprite
{

	private var _playState    : PlayState;
	private var _facing       : Facing;
	
	public function new(s : PlayState) 
	{
		super();
		
	}
	
	public function drawUnderlay()
	{
		
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
	
}