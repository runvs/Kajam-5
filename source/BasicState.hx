package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class BasicState extends FlxState
{
	
	public var overlay : FlxSprite;
	private var ending : Bool = false;
	
	public var level : TiledLevel;
	

	override public function create() 
	{
		overlay = new FlxSprite();
		overlay.makeGraphic(FlxG.width, FlxG.height);
		overlay.color = FlxColor.BLACK;
		overlay.alpha = 1;
		
		
		FlxG.camera.pixelPerfectRender = true;
		FlxG.camera.zoom = 2;
		
		
		
		FlxTween.tween (overlay, { alpha : 0 }, 0.25);
	}
	
	override public function draw():Void 
	{
		super.draw();
		drawObjects();
		
		drawOverlay();
	}
	
	public function drawObjects () : Void
	{
		
	}
	
	public function drawOverlay() : Void
	{
		overlay.draw();
	}
	
	
	function EndGame() 
	{
		if (!ending)
		{
			ending = true;
			FlxTween.tween(overlay, { alpha : 1.0 }, 0.9);
			
			var t: FlxTimer = new FlxTimer();
			t.start(1,function(t:FlxTimer): Void {MenuState.setNewScore(0); FlxG.switchState(new MenuState()); } );
		}
		
	}
	
}