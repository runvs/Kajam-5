package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

/**
 * ...
 * @author 
 */
class HealthContainer extends FlxSprite
{
	private var sprempty : FlxSprite;
	private var sprhalf : FlxSprite;
	private var sprfull : FlxSprite;

	static public var xOffset : Float = 210;
	static public var yOffset : Float = 160;
	
	static public var xShift : Float = 16;
	static public var yShift : Float = 0;
	
	//private var health : Float = 1;
	private var maxHealth : Float = 1;
	
	public function new(empty: Dynamic, half : Dynamic, full : Dynamic) 
	{
		super();
		health = 1;
		sprempty = new FlxSprite();
		sprempty.loadGraphic(empty, false);
		sprempty.scrollFactor.set();
		
		sprhalf = new FlxSprite();
		sprhalf.loadGraphic(half, false);
		sprhalf.scrollFactor.set();
		
		sprfull = new FlxSprite();
		sprfull.loadGraphic(full, false);
		sprfull.scrollFactor.set();
	}
	

	override public function draw():Void 
	{
		var h = MathExtender.castToHalfSteps(health);
		if (health > 0 &&  h == 0) h = 0.5;
		
		//////////////////////////////////////////////////
		// Draw full hearts
		//////////////////////////////////////////////////
		var hi : Int = Math.floor(h);
		var idx = 0;
		for (i in 0 ... (hi))
		{
			idx = i;
			
			sprfull.setPosition( xOffset + i * xShift, yOffset + i * yShift);
			sprfull.draw();
		
		}
		
		//////////////////////////////////////////////////
		// Draw half hearts
		//////////////////////////////////////////////////
		var hi2  : Int = Math.ceil(h);
		//if (idx == 0) idx--;
		//trace(hi + " " + hi2 + " " + idx);
		if (hi2 > hi)
		{
			if (hi != 0) idx++;
			
			sprhalf.setPosition(xOffset + idx * xShift, yOffset + idx * yShift);
			sprhalf.draw();
			
		}
		
		//////////////////////////////////////////////////
		// Draw empty hearts
		//////////////////////////////////////////////////
		var hi3 : Int = Math.ceil(maxHealth);
		if (hi3 > hi2)
		{
			for (i in hi2 ... hi3)
			{
				if(hi2 != 0) idx++;
				sprempty.setPosition(xOffset + idx * xShift, yOffset + idx * yShift);
				sprempty.draw();
			}
		}
		
	}
	
	public function SetHealth(h : Float, hm : Float )
	{
		health = h;
		maxHealth = hm;
		
		
		
	}
	
	
}