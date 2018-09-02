package;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class PlayerInfo extends FlxSprite
{
	var _player     : Player;
	// var _background : FlxSprite;
	
	
	var infoTextItems : FlxText;
	var infoTextPlayer : FlxText;
	
	public function new(player : Player)
	{
		super();

		x = 220;
		y = 170;

		loadGraphic(AssetPaths.playerInfoBg__png, false, 360, 260);
		
		scrollFactor.set();

		_player = player;

		infoTextItems = new FlxText(250, 250, 150, "");
		infoTextItems.scrollFactor.set();
		
		infoTextPlayer = new FlxText(400, 250, 150, "");
		infoTextPlayer.scrollFactor.set();
		
		visible = false;
	}
	
	public override function update(elapsed : Float) : Void
	{
		super.update(elapsed);
		infoTextItems.text = "";
		
		infoTextItems.text += "\nEquipment:\n";
		infoTextItems.text += "\tWeapon: " + _player.swordItem.name + "\n";
		infoTextItems.text += _player.swordItem.getInfoString() + "\n\n";
		
		infoTextItems.text += "\tBow: " + _player.bowItem.name + "\n";
		infoTextItems.text += _player.bowItem.getInfoString() + "\n\n";
		
		infoTextItems.text += "\tArmor: " + _player.armorItem.name + "\n";
		infoTextItems.text += _player.armorItem.getInfoString() + "\n\n";
		
		
		infoTextPlayer.text = "";
		infoTextPlayer.text += "Health       : " + MathExtender.roundForDisplay(_player.health) + " / " + MathExtender.roundForDisplay(_player.healthMax) + "\n\n";
		
		infoTextPlayer.text += "Weapon Damage: " + MathExtender.roundForDisplay(_player.getMeleeDamage()) + "\n";
		infoTextPlayer.text += "Crit: " + MathExtender.roundForDisplay(_player.getCritChance()*100) + " % at x" + MathExtender.roundForDisplay(_player.getCritDamage()) + "\n";
		infoTextPlayer.text += "Bow Damage   : " + MathExtender.roundForDisplay(_player.getRangedDamage()) + "\n\n";
		
		infoTextPlayer.text += "Dash distance: " + MathExtender.roundForDisplay(_player._itemDashMultiplier) + "\n";
		infoTextPlayer.text += "Dash Cooldown: " + MathExtender.roundForDisplay(_player.getDashTime()) + "\n\n";
		
		infoTextPlayer.text += "Walk speed   : " + MathExtender.roundForDisplay(_player.getMaxVelocityWithItems().x) + "\n";
		infoTextPlayer.text += "Evasion Percent: " + MathExtender.roundForDisplay(_player.getEvasionChance()*100) + "\n";
		
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
		
		infoTextItems.draw();
		infoTextPlayer.draw();
	}
}