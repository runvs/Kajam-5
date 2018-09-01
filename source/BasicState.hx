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
	public var background : FlxSprite;
	public var overlay : FlxSprite;
	private var ending : Bool = false;
	
	public var level : TiledLevel;
	
	private var vignette : Vignette;

	override public function create() 
	{
		overlay = new FlxSprite();
		overlay.makeGraphic(FlxG.width, FlxG.height);
		overlay.color = FlxColor.BLACK;
		overlay.alpha = 1;
		overlay.scrollFactor.set();
		
		background = new FlxSprite(0, 0);
		background.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(50, 50, 50));
		background.scrollFactor.set();
		
		FlxG.camera.pixelPerfectRender = true;
		FlxG.camera.zoom = 2;
		
		
		
		FlxTween.tween (overlay, { alpha : 0 }, 0.25);
		vignette = new Vignette(FlxG.camera,0.5,0.5*0.95,1 );
		
	}
	
	override public function draw():Void 
	{
		
		background.draw();
		drawObjects();
		super.draw();
		drawOverlay();
	}
	
	public function drawObjects () : Void
	{
		
	}
	
	public function drawOverlay() : Void
	{
		overlay.draw();
		vignette.draw();
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