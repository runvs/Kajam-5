package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledImageLayer;
import flixel.addons.editors.tiled.TiledImageTile;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import haxe.io.Path;

/**
 * @author Samuel Batista
 */
class TiledLevel extends TiledMap
{
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image 
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/images/";
	
	private var tileSet:TiledTileSet;
	
	
	public var levelPath : String = "";
	
	
	
	
	
	public var baseTiles:FlxGroup;
	public var midTiles:FlxGroup;
	public var topTiles:FlxGroup;
	
	// Array of Int used for collision
	var collisionArray : Array<Int>;
	// final collisionMap with refined collisions
	public var collisionMap : FlxSpriteGroup;
	
	public var exits : FlxTypedGroup<Exit>;
	public var entries : FlxTypedGroup<Entry>;
	
	public var allEnemies : AdministratedList<Enemy>;
	public var deadEnemies : FlxSpriteGroup;
	
	public var allNSCs : AdministratedList<NPC>;
	
	public var goreLayer : FlxSprite;
	
	private var _state : PlayState;
	
	
	public function new(tiledLevel:Dynamic, s : PlayState)
	{
		super(tiledLevel);
		_state = s;
		
		levelPath = tiledLevel ;

		
		
		baseTiles= new FlxGroup();
		midTiles = new FlxGroup();
		topTiles = new FlxGroup();
		
		collisionMap = new FlxSpriteGroup();
		
		exits = new FlxTypedGroup<Exit>();
		entries = new FlxTypedGroup<Entry>();
		
		allEnemies = new AdministratedList<Enemy>();
		allEnemies.DestroyCallBack.push( function (e : Enemy ) : Void  { addDeadEnemy(e); } );
		
		allNSCs = new AdministratedList<NPC>();
		
		tileSet = tilesets["tileset.png"];
		
		goreLayer  = new FlxSprite(0, 0 );
		deadEnemies = new FlxSpriteGroup();
	
		collisionArray = new Array<Int>();
		
			
		
		//trace(this.width);
		
		var wit : Int = this.width; 
		var hit : Int = this.height; 
		
		FlxG.camera.setScrollBounds(0, this.fullWidth, 0, this.fullHeight);
		
		// Load Tile Maps
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.TILE) continue;
			var tileLayer:TiledTileLayer = cast layer;
			
			for (j in 0...hit)
			{
				for (i in 0...wit)
				{
				
					var idx = i + j * wit;
					if (tileLayer.name == "top")
					{
						var tileType : Int = tileLayer.tileArray[idx];// tilemap.getTile(i, j);
						var s : FlxSprite = new FlxSprite(i * 16, j * 16);
						s.immovable = true;
						s.loadGraphic(AssetPaths.tileset__png, true, 16, 16);
						s.animation.add("idle", [tileType-1]);
						s.animation.play("idle");
						topTiles.add(s);
					}
					else if (tileLayer.name == "mid")
					{
						var tileType : Int = tileLayer.tileArray[idx];// tilemap.getTile(i, j);
						var s : FlxSprite = new FlxSprite(i * 16, j * 16);
						s.immovable = true;
						s.loadGraphic(AssetPaths.tileset__png, true, 16, 16);
						s.animation.add("idle", [tileType-1]);
						s.animation.play("idle");
						midTiles.add(s);
					}
					else
					{
						var tileType : Int = tileLayer.tileArray[idx];
						var s : FlxSprite = new FlxSprite(i * 16, j * 16);
						s.immovable = true;
						s.loadGraphic(AssetPaths.tileset__png, true, 16, 16);
						s.animation.add("idle", [tileType-1]);
						s.animation.play("idle");
						baseTiles.add(s);
						
						CheckForRandomOverlays(i,j,tileType);
						
						CreateCollisionTile(i, j, tileType);
					}
				}
			}
		}
		
		refineCollisions(wit, hit);
		
		loadObjects();
		
		goreLayer.makeGraphic(this.fullWidth, fullHeight, FlxColor.TRANSPARENT, true);
	}
	
	function CheckForRandomOverlays(i: Int, j : Int , tileType:Int) 
	{
		if (tileType == 2)
		{
			trace("spawn grass");
			if (FlxG.random.bool(50))
			{
				
				var ot : Int = FlxG.random.int(0, 7);
				var s : FlxSprite = new FlxSprite();
				s.loadGraphic(AssetPaths.grass_overlay__png, true, 16, 16, false);
				s.animation.add("idle", [ot,ot,ot,ot,ot,ot,ot,ot,ot,ot,ot,ot, ot+8], 3, true);
				s.animation.play("idle",false, false, -1);
				s.setPosition(i * GameProperties.TileSize, j * GameProperties.TileSize);
				midTiles.add(s);
			}
		}
	}
	
	
	
	function CreateCollisionTile(x : Int, y : Int, type : Int) 
	{
		var cols : Int = tileSet.numCols;
		var rows : Int = tileSet.numRows;
		
		var rowIndex :Int = Std.int((type-1) / rows);
		//trace(Std.string(cols) + " " + Std.string(rows));
		
		if (rowIndex == 0)
		{	
			collisionArray.push(0);
			return;
		}
		else /*if (rowIndex == 1 ||rowIndex == 2)*/
		{
			collisionArray.push(1);
		}
	}
	
	private function loadSpecialTile(x:Int, y:Int, type : Int)
	{
		if (type == 0) return;
		
		//if (type == 5 || type == 16 || type == 17|| type ==26)
		//{
			//var bt :BreakableTile = new BreakableTile(x * 32, y * 32, type);
			
		//}
		//else if (type == 6 || type == 7)
		//{
			//var ds : FlxSprite = new FlxSprite(x * 32, y * 32);
			//ds.loadGraphic(AssetPaths.tilesheet__png, true, 32, 32);
			//ds.animation.add("idle", (type == 6? [5] : [6]));
			//ds.animation.play("idle");
			
		//}
		//else if ( type == 9|| type == 19 || type == 29)  // onOff Switch 1
		//{
			//var s : FlxSprite = new FlxSprite(x * 32, y * 32);
			//s.loadGraphic(AssetPaths.tilesheet__png, true, 32, 32);
			//s.origin.set(16, 32);
			//s.animation.add("idle", [(type-1)]);
			//s.animation.play("idle");
			//s.immovable = true;
			//s.ID = type +1;
			
			//CreateCollisionTile(x, y, 2);
		//}
		//else if ( type == 10 ||type == 20 ||type == 30) // onOff Block
		//{
			//var s : FlxSprite = new FlxSprite(x * 32, y * 32);
			//s.loadGraphic(AssetPaths.tilesheet__png, true, 32, 32);
			//s.origin.set(16, 32);
			//s.animation.add("idle", [(type-1)]);
			//s.animation.play("idle");
			//s.immovable = true;
			//s.ID = type;
			
		//}
		//
	}
	
	
	public function loadObjects()
	{
		var layer:TiledObjectLayer;
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.OBJECT)
				continue;
			var objectLayer:TiledObjectLayer = cast layer;

			
			//objects layer
			if (layer.name == "objects" )
			{
				trace("load object layer");
				for (oi in objectLayer.objects)
				{
					var o : TiledObject = oi;
					trace("load object: " + o.name);
					if (o.type.toLowerCase() == "npc")
					{
						loadNSC( o, objectLayer);
					}
					else if (o.type.toLowerCase() == "entry")
					{
						loadEntry(o, objectLayer);
					}
					else if (o.type.toLowerCase() == "exit")
					{
						loadExit(o, objectLayer);
					}
				}
			}
			else if (layer.name == "enemies")
			{
				trace("load enemy layer");
				for (oi in objectLayer.objects)
				{
					var o : TiledObject = oi;
					loadEnemy(o, objectLayer);
				}
			}
		}
	}
	
	
	private function loadEnemy(o:TiledObject, g:TiledObjectLayer)
	{
		//trace("load object of type " + o.type);
		var x:Int = o.x;
		var y:Int = o.y;
		
		if (o.type.toLowerCase() == "smashground")
		{
			//trace();
			var e : Enemy_SmashGround = new Enemy_SmashGround(_state);
			e.setPosition(x, y);
			allEnemies.add(e);
		}
		else if (o.type.toLowerCase() == "runner")
		{
			//trace();
			var e : Enemy_Runner = new Enemy_Runner(_state);
			e.setPosition(x, y);
			allEnemies.add(e);
		}
	}
	
	private function loadEntry(o:TiledObject, g:TiledObjectLayer)
	{
		//trace("load object of type " + o.type);
		var x:Int = o.x;
		var y:Int = o.y;
		
		var entryid = o.properties.get("entryid");
		if (entryid != null)
		{
			var id : Int = Std.parseInt(entryid);		
			var e :Entry = new Entry(x, y, id);
			entries.add(e);
		}
	}
	
	private function loadExit(o:TiledObject, g:TiledObjectLayer)
	{
		//trace("load object of type " + o.type);
		var x:Int = o.x;
		var y:Int = o.y -1;
		
		
		var entryid = o.properties.get("entryid");
		var target = o.properties.get("target");
		if (entryid != null && target != null)
		{
			var id : Int = Std.parseInt(entryid);		
			var e : Exit = new Exit(x, y, o.width, o.height,target, id);
			exits.add(e);
		}
	}
	
	private function loadNSC(o:TiledObject, g:TiledObjectLayer)
	{
		//trace("load object of type " + o.type);
		var x:Int = o.x;
		var y:Int = o.y -1;
		
		
		var nsctype = o.properties.get("npctype");
		if (nsctype != null)
		{
			if (nsctype.toLowerCase() == "guard")
			{
				//trace(x);
				var n : NPC_Guard = new NPC_Guard(_state);
				n.setPosition(x , y );
				n.objectName = o.name;
				allNSCs.add(n);
				trace("add nsc guard '" +  n.objectName + "'");
			}
			if (nsctype.toLowerCase() == "smith")
			{
				var n : NPC_Smith = new NPC_Smith(_state);
				n.setPosition(x, y);
				n.objectName = o.name;
				allNSCs.add(n);
			}
		}
		
	}
	
	function refineCollisions(wit: Int, hit: Int):Void 
	{
		var blubb : Array<Array<Int> > = new Array<Array<Int> >();
		blubb = CollisionMerger.Merge(collisionArray, wit, hit);
		
		trace(collisionArray.length + " " + wit * hit + " " + blubb.length);
		
		for (i in 0 ... blubb.length)
		{
			if (blubb[i][0] != 0)
			{
				var t : FlxSprite = new FlxSprite(0, 0);
				t.makeGraphic(Std.int( GameProperties.TileSize * blubb[i][1]), Std.int(GameProperties.TileSize  * blubb[i][0]));
				
				t.setPosition((i % wit ) * GameProperties.TileSize, Std.int(i / wit) * GameProperties.TileSize);
				t.update(0.1);
				t.color = Palette.color2;
				t.immovable = true;
				collisionMap.add(t);
			}
		}
	}
		
	public function spladder (x: Float, y : Float)
	{
		var s : FlxSprite = new FlxSprite();
		s.makeGraphic(FlxG.random.int(1, 3), FlxG.random.int(1, 3), FlxColor.fromRGB(175,0,0));
		
		var N : Int = 5;
		
		for (i in 0 ... N)
		{
			var px : Int = Std.int(FlxG.random.floatNormal(x, GameProperties.TileSize / 2.5));
			var py : Int = Std.int(FlxG.random.floatNormal(y, GameProperties.TileSize / 2.5));
			goreLayer.stamp(s, px, py);
		}
	}
	
	public function addDeadEnemy(e:Enemy)
	{
		e.color = FlxColor.fromRGB(100, 100, 100);
		e.scale.set(0.9,1);
		e.angle = 90;
		deadEnemies.add(e);
	}
	
	public function getEntry (entryid : Int ) :Entry
	{
		for (ei in entries)
		{
			var e : Entry = ei;
			if (e.entryID == entryid)
				return e;
		}
		return null;
	}
}