package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxAxes;

/**
 * ...
 * @author 
 */
class CreditsScene extends FlxState
{

	var age : Float = 0;
	
	public static var playTime : Float = 0;
	
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		var t : FlxText = new FlxText(0, 0, 800, "THE END\n\n\nPlaytime:\n" + MathExtender.roundForDisplay(playTime), 32);
		t.alignment = FlxTextAlign.CENTER;
		t.screenCenter(FlxAxes.XY);
		
		add(t);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		age += elapsed;
		
		
		if (age >= 1.5)
		{
			if (MyInput.DashButtonJustPressed || MyInput.InteractButtonJustPressed)
			{
				FlxG.switchState(new MenuState());
			}
		}
		
		if (age >= 8)
		{
			FlxG.switchState(new MenuState());
		}
	}
	
}