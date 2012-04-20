package;

import kha.Button;
import kha.Color;
import kha.Game;
import kha.HighscoreList;
import kha.Key;
import kha.Loader;
import kha.Music;
import kha.Painter;
import kha.Scene;
import kha.Score;
import kha.Tilemap;

enum Mode {
	Game;
	Highscore;
	EnterHighscore;
}

class SuperMarioLand extends Game {
	static var instance : SuperMarioLand;
	var music : Music;
	var tileColissions : Array<Bool>;
	var map : Array<Array<Int>>;
	var originalmap : Array<Array<Int>>;
	var highscoreName : String;
	var shiftPressed : Bool;
	
	var mode : Mode;
	
	public function new() {
		super("SML", 600, 520);
		instance = this;
		shiftPressed = false;
		highscoreName = "";
		mode = Mode.Game;
	}
	
	public static function getInstance() : SuperMarioLand {
		return instance;
	}

	public override function init() {
		tileColissions = new Array<Bool>();
		for (i in 0...140) tileColissions.push(isCollidable(i));
		var blob = Loader.getInstance().getBlob("level.map");
		var levelWidth : Int = blob.readInt();
		var levelHeight : Int = blob.readInt();
		originalmap = new Array<Array<Int>>();
		for (x in 0...levelWidth) {
			originalmap.push(new Array<Int>());
			for (y in 0...levelHeight) {
				originalmap[x].push(blob.readInt());
			}
		}
		map = new Array<Array<Int>>();
		for (x in 0...originalmap.length) {
			map.push(new Array<Int>());
			for (y in 0...originalmap[0].length) {
				map[x].push(0);
			}
		}
		music = Loader.getInstance().getMusic("level1");
		startGame();
	}
	
	public function startGame() {
		if (Jumpman.getInstance() == null) new Jumpman(music);
		Scene.getInstance().clear();
		Scene.getInstance().setBackgroundColor(new Color(255, 255, 255));
		var tilemap : Tilemap = new Tilemap("sml_tiles.png", 32, 32, map, tileColissions);
		Scene.getInstance().setColissionMap(tilemap);
		Scene.getInstance().addBackgroundTilemap(tilemap, 1);
		var TILE_WIDTH : Int = 32;
		var TILE_HEIGHT : Int = 32;
		for (x in 0...originalmap.length) {
			for (y in 0...originalmap[0].length) {
				switch (originalmap[x][y]) {
				case 15:
					map[x][y] = 0;
					Scene.getInstance().addEnemy(new Gumba(x * TILE_WIDTH, y * TILE_HEIGHT));
				case 16:
					map[x][y] = 0;
					Scene.getInstance().addEnemy(new Koopa(x * TILE_WIDTH, y * TILE_HEIGHT - 16));
				case 17:
					map[x][y] = 0;
					Scene.getInstance().addEnemy(new Fly(x * TILE_WIDTH - 32, y * TILE_HEIGHT));
				case 46:
					map[x][y] = 0;
					Scene.getInstance().addEnemy(new Coin(x * TILE_WIDTH, y * TILE_HEIGHT));
				case 52:
					map[x][y] = 52;
					Scene.getInstance().addEnemy(new Exit(x * TILE_WIDTH, y * TILE_HEIGHT));
				case 56:
					map[x][y] = 1;
					Scene.getInstance().addEnemy((new BonusBlock(x * TILE_WIDTH, y * TILE_HEIGHT)));
				default:
					map[x][y] = originalmap[x][y];
				}
			}
		}
		music.start();
		Jumpman.getInstance().reset();
		Scene.getInstance().addHero(Jumpman.getInstance());
	}
	
	public function showHighscore() {
		Scene.getInstance().clear();
		mode = Mode.EnterHighscore;
		music.stop();
	}
	
	private static function isCollidable(tilenumber : Int) : Bool {
		switch (tilenumber) {
		case 1: return true;
		case 6: return true;
		case 7: return true;
		case 8: return true;
		case 26: return true;
		case 33: return true;
		case 39: return true;
		case 48: return true;
		case 49: return true;
		case 50: return true;
		case 53: return true;
		case 56: return true;
		case 60: return true;
		case 61: return true;
		case 62: return true;
		case 63: return true;
		case 64: return true;
		case 65: return true;
		case 67: return true;
		case 68: return true;
		case 70: return true;
		case 74: return true;
		case 75: return true;
		case 76: return true;
		case 77: return true;
		case 84: return true;
		case 86: return true;
		case 87: return true;
		default:
			return false;
		}
	}
	
	public override function update() {
		super.update();
		music.update();
		Scene.getInstance().camx = Std.int(Jumpman.getInstance().x) + Std.int(Jumpman.getInstance().width / 2);
	}
	
	public override function render(painter : Painter) {
		switch (mode) {
		case Highscore:
			painter.setColor(255, 255, 255);
			painter.fillRect(0, 0, getWidth(), getHeight());
			painter.setColor(0, 0, 0);
			var i : Int = 0;
			while (i < 10 && i < getHighscores().getScores().length) {
				var score : Score = getHighscores().getScores()[i];
				painter.drawString(Std.string(i + 1) + ": " + score.getName(), 100, i * 30 + 100);
				painter.drawString(" -           " + Std.string(score.getScore()), 200, i * 30 + 100);
				++i;
			}
			//break;
		case EnterHighscore:
			painter.setColor(255, 255, 255);
			painter.fillRect(0, 0, getWidth(), getHeight());
			painter.setColor(0, 0, 0);
			painter.drawString("Enter your name", getWidth() / 2 - 100, 200);
			painter.drawString(highscoreName, getWidth() / 2 - 50, 250);
			//break;
		case Game:
			super.render(painter);
			painter.translate(0, 0);
			painter.setColor(0, 0, 0);
			painter.drawString("Score: " + Std.string(Jumpman.getInstance().getScore()), 20, 25);
			painter.drawString("Round: " + Std.string(Jumpman.getInstance().getRound()), getWidth() - 100, 25);
			//break;
		}
	}

	override public function buttonDown(button : Button) : Void {
		switch (mode) {
		case Game:
			switch (button) {
			case UP, BUTTON_1, BUTTON_2:
				Jumpman.getInstance().setUp();
			case LEFT:
				Jumpman.getInstance().left = true;
			case RIGHT:
				Jumpman.getInstance().right = true;
			default:
			}
		default:
		}
	}
	
	override public function buttonUp(button : Button) : Void {
		switch (mode) {
		case Game:
			switch (button) {
			case UP, BUTTON_1, BUTTON_2:
				Jumpman.getInstance().up = false;
			case LEFT:
				Jumpman.getInstance().left = false;
			case RIGHT:
				Jumpman.getInstance().right = false;
			default:
			}	
		default:
		}
	}
	
	override public function keyDown(key : Key, char : String) : Void {
		if (key == null) {
			if (mode == Mode.EnterHighscore) {
				if (highscoreName.length < 20) highscoreName += shiftPressed ? char.toUpperCase() : char.toLowerCase();
			}
		}
		else {
			if (highscoreName.length > 0) {
				switch (key) {
				case ENTER:
					getHighscores().addScore(highscoreName, Jumpman.getInstance().getScore());
					mode = Mode.Highscore;
				case BACKSPACE:
					highscoreName = highscoreName.substr(0, highscoreName.length - 1);
				default:
				}
			}
			if (key == SHIFT) shiftPressed = true;
		}
	}
	
	override public function keyUp(key : Key, char : String) : Void {
		if (key != null && key == Key.SHIFT) shiftPressed = false;
	}
}