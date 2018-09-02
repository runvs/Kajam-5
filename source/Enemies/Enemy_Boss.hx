package;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Enemy_Boss extends Enemy
{
	
	private var internalState : Int = 0;	// 0 idle
	private var counter : Int = 0;
	private var counter2 : Int = 0;
	private var persistentRandom : Float = 0;
	private var thinkTimer : Float= 3;
	
	private var healthBar : HudBar;
	
	public function new(s:PlayState) 
	{
		super(s);
		
		health = MaxHealth = 120;
		
		this.loadGraphic(AssetPaths.roan__png, true, 16, 20);
		this.animation.add("idle", [0], 8, true);
		this.animation.add("cast", [3, 4, 5, 6, 7, 8, 9], 7, false);
		this.animation.add("castloop", [7, 8, 9], 8, true);
		this.animation.add("walk", [0, 1, 2, 3], 8, true);
		this.animation.add("invu", [9], 8, true);
		this.animation.play("idle");
		this.drag.set(500, 500);
		
		healthBar = new HudBar(250, 450 - 20, 200, 10, false, FlxColor.fromRGB(255,9,5), "Roan Health");
		healthBar.scrollFactor.set();
		//healthBar._background.color
	}
	
	override public function hit(damage:Float, px:Float, py:Float) 
	{
		super.hit(damage, px, py);
		healthBar.health = health / MaxHealth;
	}
	
	override public function update(elapsed:Float):Void 
	{
		//trace("update");
		super.update(elapsed);
		healthBar.update(elapsed);
		
		
		if (internalState == 0)
		{
			
			thinkTimer -= elapsed;
			if (thinkTimer <= 0)
			{
				if (counter%3 == 0)
				{
					counter++;
					internalState = 1;
					thinkTimer = 1.0;
					counter2 = 0;
					persistentRandom = FlxG.random.float(0, 90);
					this.animation.play("cast");
				}
				else if (counter % 3 == 1)
				{
					counter++;
					internalState = 2;
					thinkTimer = 1.0;
					counter2 = 0;
					//persistentRandom = FlxG.random.float(0,90
					this.animation.play("cast");
				}
				else if (counter % 3 == 2)
				{
					counter++;
					internalState = 3;
					_state.level.spawnEnemy("runner", 2 *GameProperties.TileSize, 2*GameProperties.TileSize);
					_state.level.spawnEnemy("runner", 17*GameProperties.TileSize, 2*GameProperties.TileSize);
					_state.level.spawnEnemy("runner", 2*GameProperties.TileSize, 17*GameProperties.TileSize);
					_state.level.spawnEnemy("runner", 17 * GameProperties.TileSize, 17 * GameProperties.TileSize);
					FlxTween.tween(this, { x:150, y:150 }, 1.5);
					this.acceleration.set();
					this.animation.play("invu");
					this.takeNoDamage = true;
				}
			}
			
		}
		else if (internalState == 1)
		{
			thinkTimer -= elapsed;
			if (thinkTimer <= 0)
			{
				this.animation.play("castloop");
				var a : Float = 360.0 / 6 * counter2 + persistentRandom;
				
				thinkTimer += 0.5;
				var v : FlxVector = new FlxVector();
				v.set(Math.sin(MathExtender.Deg2Rad(a)), Math.cos(MathExtender.Deg2Rad(a)));
				shoot(v);
				
				counter2++;
				if (counter2 == 6)
				{
					this.acceleration.set(20, 20);
					this.animation.play("walk");
					counter2 == 0;
					internalState = 0;
				}
			}
		}
		else if (internalState == 2)
		{
			thinkTimer -= elapsed;
			if (thinkTimer <= 0)
			{
				this.animation.play("castloop");
				thinkTimer = 0.9;
				for (i in 0 ... 20)
				{
					var a : Float = 360.0 / 20.0 * i;
					var v : FlxVector = new FlxVector();
					v.set(Math.sin(MathExtender.Deg2Rad(a)), Math.cos(MathExtender.Deg2Rad(a)));
					shoot(v);
				}
				counter2++;
				if (counter2 == 3)
				{
					this.acceleration.set(0, -20);
					this.animation.play("walk");
					counter2 == 0;
					internalState = 0;
				}
			}
		}
		else if (internalState == 3)
		{
			takeNoDamage = true;
			thinkTimer -= elapsed;
			//trace(thinkTimer);
			if (thinkTimer <= 0)
			{
				var v : FlxVector = new FlxVector();
				v.set(_state.player.x + 8 - (x + 8), _state.player.y - (y + 10));
				v = v.normalize();
				trace(v);
				shoot(v);
			
				thinkTimer = 1.7;
			}
			
			if (_state.level.allEnemies.length() == 1)
			{
				takeNoDamage = false;
				internalState = 1;
				//this.animation.
				this.animation.play("idle");
				this.acceleration.set();
			}
		}
	}
	
	override public function onDeath() 
	{
		super.onDeath();
		_state.StartEndingScene();
	}
	
	function shoot(dir : FlxVector) 
	{
		trace("shoot");
		//_shootTimer = 0.9;
		var s : EnemyShot = new EnemyShot(x + this.width / 2.0, y + this.height / 2.0, dir.x , dir.y );
		_state.level.allEnemyShots.add(s);
	}
	
	
	override public function drawUnderlay() 
	{
		super.drawUnderlay();
		healthBar.draw();
	}
}