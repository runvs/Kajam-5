package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class PlayerShot extends GenericShot
{
	public var damage : Float = 10;
	
	public function new(?X:Float=0, ?Y:Float=0, vx: Float, vy: Float, BowTimeFactor : Float) 
	{
		super(X, Y,vx,vy);
		
		var vsc : Float = 200;
		var dg : Float = 150;
		
		if (BowTimeFactor < 0.25)	
		{
			var v : Float = BowTimeFactor * 2 + 0.125;	// 0.125 - 0.625
			vsc *= v;
		}
		else if (BowTimeFactor < 0.5)	// 0.25 - 0.5
		{
			vsc *= 0.65;
			
		}
		else if (BowTimeFactor < 0.75) // 0.5 - 0.75
		{
			vsc *= 0.85;
		}
		else	// 0.75 - 1
		{
			vsc *= 1.0;
			// 1.00 -> dg = 0.5;
			// 0.75 -> dg = 1
			var dx = 1.0 - 0.75;
			var dy = 0.5 - 1.0;
			var sl = dy / dx;
			var ofs = 0.5 - sl * 1.0;
			dg *= sl * BowTimeFactor + ofs;
		}
		
		this.velocity.scale(vsc);
		
		
		
		this.drag.set(dg * 1.1, dg*0.95);
	}
	
	override public function createImage() 
	{
		super.createImage();
		this.makeGraphic(8, 3, FlxColor.BLUE);
		this.angle = MathExtender.Rad2Deg(Math.atan2(velocity.y, velocity.x));
	}
}