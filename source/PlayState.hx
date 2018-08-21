package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var backgroundSprite : FlxSprite;
	public var overlay : FlxSprite;
	private var ending : Bool;
	
	
	private var player : Player;
	
	private var level : TiledLevel;
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		backgroundSprite = new FlxSprite();
		backgroundSprite.makeGraphic(FlxG.width, FlxG.height);
		backgroundSprite.color = Palette.color1;
		add(backgroundSprite);
		
		FlxG.camera.pixelPerfectRender = true;
		FlxG.camera.zoom = 2;
		
		level = new TiledLevel("assets/data/Wimborne.tmx");
		add(level.baseTiles);
		add(level.midTiles);
		
		player = new Player(this);
		add(player);
		FlxG.camera.follow(player, flixel.FlxCameraFollowStyle.TOPDOWN);
		
		
		add(level.topTiles);
		
		
		ending = false;
		overlay = new FlxSprite();
		overlay.makeGraphic(FlxG.width, FlxG.height);
		overlay.color = Palette.color1;
		overlay.alpha = 1;
		add(overlay);
	
		FlxTween.tween (overlay, { alpha : 0 }, 0.25);
		
		
	}
	
	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	
	override public function draw() : Void
	{
		super.draw();
		
	}
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed : Float):Void
	{
		super.update(elapsed);
		MyInput.update();
		
		
		
		if (!ending)
		{
			
			FlxG.collide(player, level.collisionMap);
		}
	}	
	

	
	function EndGame() 
	{
		if (!ending)
		{
			ending = true;
			
			
			
			FlxTween.tween(overlay, {alpha : 1.0}, 0.9);
			
			var t: FlxTimer = new FlxTimer();
			t.start(1,function(t:FlxTimer): Void {MenuState.setNewScore(0); FlxG.switchState(new MenuState()); } );
		}
		
	}
	
}