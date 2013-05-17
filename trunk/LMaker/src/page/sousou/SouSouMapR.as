package page.sousou
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.lufylegend.legend.display.LBitmap;
	import com.lufylegend.legend.display.LShape;
	import com.lufylegend.legend.display.LSprite;
	import com.lufylegend.legend.utils.LDisplay;
	
	public class SouSouMapR extends LSprite
	{
		private var backmap:LBitmap;
		private var _mapData:Array;
		private var grid:LShape;
		private var _linecolor:int = 0xff0000;
		private var _linesize:int = 1;
		private var _nodeLength:int = 24;
		public function SouSouMapR(map:BitmapData,data:Array)
		{
			super();
			backmap = new LBitmap(map);
			
			this.disposeList.push(map);
			_mapData = data;
			this.addChild(backmap);
			grid = new LShape();
			this.addChild(grid);
			drawGrid();
			this.addEventListener(MouseEvent.MOUSE_MOVE,onmove);
			this.addEventListener(MouseEvent.MOUSE_UP,onup);
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
		private function showCoo(cx:int,cy:int):void{
			(((this.parent as LSprite).parent as LSprite).parent as SouSouRMap).terrainCoo.text = cx + "," +cy;
			
			//trace(cx,cy);
			//Global.coordinate.text = "(" + cx + "," +cy + ")";
		}
		private function onmove(event:MouseEvent):void{
			var indexX:int = Math.floor(mouseX/_nodeLength);
			var indexY:int = Math.floor(mouseY/_nodeLength);
			var mx:int = mouseX - indexX*_nodeLength;
			var my:int = mouseY - indexY*_nodeLength;
			if(((indexX + indexY) & 1) == 1){
				if(mx >= my){
					showCoo(indexX + 1,indexY);
				}else{
					showCoo(indexX,indexY + 1);
				}
			}else{
				if(mx <= _nodeLength-my){
					showCoo(indexX,indexY);
				}else{
					showCoo(indexX + 1,indexY + 1);
				}
				
			}
		}
		
		private function onup(event:MouseEvent):void{
			var indexX:int = Math.floor(mouseX/_nodeLength);
			var indexY:int = Math.floor(mouseY/_nodeLength);
			var mx:int = mouseX - indexX*_nodeLength;
			var my:int = mouseY - indexY*_nodeLength;
			if(((indexX + indexY) & 1) == 1){
				if(mx >= my){
					drawTriangle3(indexX + 1,indexY);
				}else{
					drawTriangle3(indexX,indexY + 1);
				}
			}else{
				if(mx <= _nodeLength-my){
					drawTriangle3(indexX,indexY);
				}else{
					drawTriangle3(indexX + 1,indexY + 1);
				}
				
			}
		}
		
		
		private function drawTriangle3(nx:int,ny:int):void{
			if(ny >= _mapData.length || nx >= _mapData[0].length)return;
			if(_mapData[ny][nx] == 0){
				_mapData[ny][nx] = 1;
				if(nx > 0)_mapData[ny][nx - 1] = 1;
			}else{
				_mapData[ny][nx] = 0;
				if(nx > 0)_mapData[ny][nx - 1] = 0;
			}
			drawGrid();
		}
		private function drawTriangle2(nx:int,ny:int):void{
			drawTriangle(nx - 1,ny - 1,4);
			drawTriangle(nx,ny - 1,2);
			drawTriangle(nx - 1,ny,1);
			drawTriangle(nx,ny,0);
		}
		private function drawTriangle(nx:int,ny:int,type:int):void{
			if(nx < 0 || nx >= _mapData[0].length || ny < 0 || ny >= _mapData.length)return;
			
			if(type == 0){//left up
				LDisplay.drawTriangle(grid.graphics,[nx*_nodeLength,ny*_nodeLength,nx*_nodeLength + _nodeLength,ny*_nodeLength,nx*_nodeLength,ny*_nodeLength + _nodeLength],true,_linecolor,0.5);
			}else if(type == 1){//right up
				LDisplay.drawTriangle(grid.graphics,[nx*_nodeLength,ny*_nodeLength,nx*_nodeLength + _nodeLength,ny*_nodeLength,nx*_nodeLength + _nodeLength,ny*_nodeLength + _nodeLength],true,_linecolor,0.5);
			}else if(type == 2){//left down
				LDisplay.drawTriangle(grid.graphics,[nx*_nodeLength,ny*_nodeLength,nx*_nodeLength + _nodeLength,ny*_nodeLength + _nodeLength,nx*_nodeLength,ny*_nodeLength + _nodeLength],true,_linecolor,0.5);
			}else{//right down
				LDisplay.drawTriangle(grid.graphics,[nx*_nodeLength,ny*_nodeLength + _nodeLength,nx*_nodeLength + _nodeLength,ny*_nodeLength + _nodeLength,nx*_nodeLength + _nodeLength,ny*_nodeLength],true,_linecolor,0.5);
			}
			
		}
		private function drawGrid():void{
			grid.graphics.clear();
			var i:int,j:int;
			for(i = 0;i<_mapData.length;i++){
				for(j = 0;j<_mapData[i].length;j++){
					if((i+j) %2 == 0 && _mapData[i][j] == 1){
						drawTriangle2(j,i);
					}
				}
			}
			
			grid.graphics.lineStyle(_linesize,_linecolor,1);
			for(i = 0;i<_mapData.length;i++){
				if(i % 2 == 1){
					grid.graphics.moveTo( 0, i*_nodeLength );
					//grid.graphics.lineTo(_mapData[0].length * _nodeLength ,i*_nodeLength + _mapData[0].length * _nodeLength);
					grid.graphics.lineTo(_mapData.length * _nodeLength - i*_nodeLength ,_mapData.length * _nodeLength);
				}
			}
			grid.graphics.lineStyle(_linesize,_linecolor,1);
			for(i = 0;i<_mapData[0].length;i++){
				if(i % 2 == 1){
					grid.graphics.moveTo(i*_nodeLength ,0);
					if(_mapData[0].length * _nodeLength - i*_nodeLength >= _mapData.length*_nodeLength){
						grid.graphics.lineTo(_mapData.length * _nodeLength + i*_nodeLength,_mapData.length * _nodeLength);
					}else{
						grid.graphics.lineTo(_mapData[0].length * _nodeLength,_mapData[0].length * _nodeLength-i*_nodeLength);
					}
					//grid.graphics.lineTo(i*_nodeLength + _mapData.length * _nodeLength,_mapData.length * _nodeLength);
				}
			}
			grid.graphics.lineStyle(_linesize,_linecolor,1);
			for(i = 0;i<_mapData[0].length;i++){
				if(i % 2 == 0){
					//if(i*_nodeLength - _nodeLength > _mapData[0].length*_nodeLength)break;
					grid.graphics.moveTo(i*_nodeLength + _nodeLength ,0);
					if(i*_nodeLength + _nodeLength > _mapData.length*_nodeLength){
						grid.graphics.lineTo(i*_nodeLength + _nodeLength - _mapData.length*_nodeLength,_mapData.length*_nodeLength);
					}else{
						grid.graphics.lineTo(0,i*_nodeLength + _nodeLength);
					}
				}
			}
			grid.graphics.lineStyle(_linesize,_linecolor,1);
			var add:int = _nodeLength;
			if(_mapData[0].length % 2 == 1)add = 0;
			for(i = 0;i<_mapData.length;i++){
				if(i % 2 == 0){
					grid.graphics.moveTo( _mapData[0].length * _nodeLength, i*_nodeLength + add);
					
					grid.graphics.lineTo(_mapData[0].length * _nodeLength - (_mapData.length * _nodeLength - i*_nodeLength) + add, _mapData.length * _nodeLength);
				}
			}
		}
	}
}