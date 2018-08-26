package;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class PlayerInfo extends FlxSprite
{
	var _player     : Player;
	// var _background : FlxSprite;
	
	public function new(player : Player)
	{
		super();

		x = 100;
		y = 100;

		makeGraphic(100, 100, FlxColor.MAGENTA);
		
		//origin.set(0, 0);
		scrollFactor.set();

		// _background = new FlxSprite(10, 10);
		// _background.makeGraphic(100, 100, FlxColor.fromRGB(64, 64, 64, 100));
		// _background.scrollFactor.set();

		_player = player;

		visible = true;
	}
	
	public override function update(elapsed : Float) : Void
	{
		super.update(elapsed);
		// _background.update(elapsed);
	}

	public override function draw() : Void 
	{
		// _background.draw();
		super.draw();
	}
}