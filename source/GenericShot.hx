package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class GenericShot extends FlxSprite
{
	private var age : Float = 0;

	public function new(?X:Float=0, ?Y:Float=0, vx: Float, vy: Float) 
	{
		super(X, Y);
		
		//this.makeGraphic(6, 6, FlxColor.RED);
		
		this.velocity.set(vx, vy);
		createImage();
	}
	
	
	public function createImage() 
	{
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		age += elapsed;
		
		if (age >= GameProperties.WorldShotLifeTimeMax)
			alive = false;
	}
	
}