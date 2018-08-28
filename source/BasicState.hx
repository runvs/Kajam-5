package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

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
	
	public function switchToState (newState : BasicState)
	{
		
		FlxG.switchState(newState);
	}
	
}