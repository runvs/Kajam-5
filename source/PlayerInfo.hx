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

		x = 220;
		y = 170;

		loadGraphic(AssetPaths.playerInfoBg__png, false, 360, 260);
		//makeGraphic(360, 260, FlxColor.MAGENTA);
		
		//origin.set(0, 0);
		scrollFactor.set();

		// _background = new FlxSprite(10, 10);
		// _background.makeGraphic(100, 100, FlxColor.fromRGB(64, 64, 64, 100));
		// _background.scrollFactor.set();

		_player = player;

		visible = false;
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

		_player.swordItem.x = x + 148;
		_player.swordItem.y = y + 46;
		_player.swordItem.draw();

		_player.bowItem.x = x + 172;
		_player.bowItem.y = y + 46;
		_player.bowItem.draw();

		_player.armorItem.x = x + 196;
		_player.armorItem.y = y + 46;
		_player.armorItem.draw();
	}
}