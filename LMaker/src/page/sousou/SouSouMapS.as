package page.sousou
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LShape;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.math.LCoordinate;
	
	public class SouSouMapS extends LSprite
	{
		private var backmap:LBitmap;
		private var _mapData:Array;
		private var grid:LSprite;
		private var _linecolor:int = 0xff0000;
		private var _linesize:int = 1;
		private var _nodeLength:int = 48;
		public function SouSouMapS(map:BitmapData,data:Array)
		{
			backmap = new LBitmap(map);
			_mapData = data;
			this.addChild(backmap);
			grid = new LSprite();
			this.addChild(grid);
			this.addEventListener(MouseEvent.MOUSE_MOVE,onmove);
			this.addEventListener(MouseEvent.MOUSE_UP,onup);
		}
		private function onup(event:MouseEvent):void{
			var indexX:int = Math.floor(mouseX/_nodeLength);
			var indexY:int = Math.floor(mouseY/_nodeLength);
			setTerrain(indexX,indexY,Global.terrainindex)
			
		}
		private function onmove(event:MouseEvent):void{
			var indexX:int = Math.floor(mouseX/_nodeLength);
			var indexY:int = Math.floor(mouseY/_nodeLength);
			//Global.coordinate.text = "(" + indexX + "," +indexY + ")";
		}
		public function get bitmapdata():BitmapData{
			return this.backmap.bitmapData;
		}
		public function get data():String{
			var mapdata:String = "";
			var i:int,j:int;
			var istr:String = "\n";
			var jstr:String = "";
			for(i = 0;i<_mapData.length;i++){
				jstr = "";
				for(j = 0;j<_mapData[i].length;j++){
					mapdata += (jstr + _mapData[i][j]);
					jstr = ",";
				}
				
				if(i<_mapData.length - 1)mapdata += istr;
			}
			return mapdata;
		}
		
		public function setTerrain(cx:int = -1,cy:int = -1,value:int = 0):void{
			if(cx >= 0 && cy >= 0 && cx < _mapData[0].length && cy < _mapData.length){
				_mapData[cy][cx] = value;
			}
			drawGrid();
		}
		private function drawGrid():void{
			grid.die();
			var i:int,j:int;
			var color:int;
			var txt:LLabel;
			for(i = 0;i<_mapData.length;i++){
				for(j = 0;j<_mapData[i].length;j++){
					color = int(Global.terrain["Terrain" + _mapData[i][j]].@color);
					LDisplay.drawRect(grid.graphics,[j*_nodeLength,i*_nodeLength,_nodeLength,_nodeLength],true,color,Global.terrainAlpha/10);
					LDisplay.drawRect(grid.graphics,[j*_nodeLength,i*_nodeLength,_nodeLength,_nodeLength],false,color);
					txt = new LLabel();
					txt.htmlText = "<font size='15'><b>" + Global.terrain["Terrain" + _mapData[i][j]] + "</b></font>";
					txt.xy = new LCoordinate(j*_nodeLength+(_nodeLength/2 - txt.width/2),i*_nodeLength + (_nodeLength/2 - txt.height/2 ));
					grid.addChild(txt);
				}
			}
		}
	}
}