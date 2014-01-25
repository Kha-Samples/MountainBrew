package;

import kha.AnimatedImageCursor;
import kha.Animation;
import kha.Color;
import kha.Cursor;
import kha.Font;
import kha.FontStyle;
import kha.ImageCursor;
import kha.Loader;
import kha.Painter;
import kha.Scene;
import kha.Sprite;

enum OrderType {
	Nothing;
	MoveTo;
	Take;
	InventoryItem;
}

class AdventureCursor implements Cursor {
	private var font: Font;
	
	public var width(get,never): Int;
	public var height(get, never): Int;
	public var clickX(get,never): Int;
	public var clickY(get, never): Int;
	
	private function get_clickX() : Int {
		return currentCursor.clickX;
	}
	private function get_clickY() : Int {
		return currentCursor.clickY;
	}
	private function get_width() : Int {
		return currentCursor.width;
	}
	private function get_height() : Int {
		return currentCursor.height;
	}
	
	var currentCursor : Cursor;
	var cursors : Map<OrderType, Cursor> = new Map();
	
	public var hoveredType : OrderType = Nothing;
	public var hoveredObject : UseableSprite = null;
	
	public function new() {
		cursors[MoveTo] = new AnimatedImageCursor(Loader.the.getImage("gumba"), Std.int(96 / 3), 32, new Animation([0, 2], 14), 16, 16);
		cursors[Take] = new ImageCursor(Loader.the.getImage("handcursor"), 6, 9);
		cursors[InventoryItem] = new ImageCursor(Loader.the.getImage("handcursor"), 6, 9);
		currentCursor = null;
		kha.Sys.mouse.forceSystemCursor(true);
		font = Loader.the.loadFont("Arial", new FontStyle(false, false, false), 12);
	}
	
	public function render(painter: Painter, x: Int, y: Int): Void {
		if (currentCursor != null) {
			currentCursor.render(painter, x, y);
			if (hoveredObject != null) {
				if (hoveredType == InventoryItem) {
					drawTooltip(painter, hoveredObject.name, x, y - clickY - 16);
				} else {
					drawTooltip(painter, hoveredObject.name, x, y - clickY + height);
				}
			}
		}
	}
	
	private function drawTooltip(painter: Painter, tip: String, x: Int, y: Int): Void {
		painter.setColor(Color.fromBytes(0, 0, 0));
		painter.fillRect(x - 2, y - 2, font.stringWidth(tip) + 4, font.getHeight() + 4);
		painter.setColor(Color.fromBytes(255, 255, 255));
		painter.drawString(tip, x, y);
	}
	
	public function update(x : Int, y : Int) {
		hoveredType = OrderType.Nothing;
		hoveredObject = Inventory.getItemBelowPoint(x, y);
		var jmpMan = Jumpman.getInstance();
		if (hoveredObject != null) {
			hoveredType = OrderType.InventoryItem;
		} else if (y < Inventory.y) {
			var worldX = x + Scene.the.screenOffsetX;
			var worldY = y + Scene.the.screenOffsetY;
			if (worldX < jmpMan.x || jmpMan.x + jmpMan.width < worldX) {
				hoveredType = OrderType.MoveTo;
			}
			for (hero in Scene.the.getHeroesBelowPoint(worldX, worldY)) {
				if (Std.is(hero, UseableSprite)) {
					hoveredObject = cast hero;
					hoveredType = OrderType.Take;
					break;
				}
			}
		}
		if (cursors.exists(hoveredType)) {
			currentCursor = cursors[hoveredType];
			kha.Sys.mouse.forceSystemCursor(false);
			currentCursor.update(x, y);
		} else {
			kha.Sys.mouse.forceSystemCursor(true);
			currentCursor = null;
		}
	}
}