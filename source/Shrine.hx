package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Shrine extends FlxSprite
{
	
	public var shrineID : Int = -1;
	
	private var particles : FlxSpriteGroup;
	

	public function new(?X:Float=0, ?Y:Float=0, id: Int) 
	{
		super(X, Y);
		shrineID = id;
		//this.makeGraphic(32, 32);
		//this.color = FlxColor.CYAN;
		this.loadGraphic(AssetPaths.shrine__png, false, 16, 16);
		this.immovable = true;
		
		particles = new FlxSpriteGroup();
		for (i in 0 ... 40)
		{
			var px : Float = x + width / 2 + FlxG.random.floatNormal(0, 24);
			var py : Float = y + width / 2 + FlxG.random.floatNormal(0, 24);
			var s : FlxSprite = new FlxSprite(px, py);
			s.makeGraphic(2,2);
			s.alpha = FlxG.random.float(0.2, 0.5);
			//s.angularVelocity = 200;
			//s.angle = FlxG.random.float(0, 360);
			s.health = FlxG.random.floatNormal(0.95, 1.05);
			particles.add(s);
		}
	}
	
	
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		particles.update(elapsed);
		for (i in 0...particles.length)
		{
			
			var s : FlxSprite = particles.members[i];
			//s.health += elapsed;
			var dx = s.x - (x + width / 2.0);
			var dy = s.y - (y + height / 2.0);
			
			var r : Float = Math.sqrt(dx * dx + dy * dy);
			if (r < 12) r += 12;
			var phi = Math.atan2(dy, dx) + s.health * elapsed * MathExtender.Deg2Rad(1.0/r*640) * ((i>particles.length/2)?-1:1);
			
			s.setPosition( (x+width/2.0) + r * Math.cos(phi), (y+height/2.0) + r * Math.sin(phi));
			
		}
		
		
		
	}
	public function drawOverlay () : Void
	{
		particles.draw();
	}
}