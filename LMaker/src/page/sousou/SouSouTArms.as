package page.sousou
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LScrollbar;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.display.LURLLoader;
	import zhanglubin.legend.utils.LDisplay;
	
	public class SouSouTArms extends LSprite
	{
		private var x999999Bit:BitmapData = new BitmapData(100,20,false,0x999999);
		private var _urlloader:LURLLoader;
		private var _arms:Array;
		private var _armsXml:XML;
		private var listSprite:LSprite;
		private var listScrollbar:LScrollbar;
		private var selectBit:LBitmap;
		private var _armsIndex:int;
		public function SouSouTArms()
		{
			super();
			LDisplay.drawRectGradient(this.graphics,[0,20,800,500],[0xffffff,0x8A98F4]);
			LDisplay.drawRect(this.graphics,[0,20,800,500],false,0x000000);
			LDisplay.drawRect(this.graphics,[10,30,124,484],false,0x000000);
			LDisplay.drawRect(this.graphics,[140,30,650,484],false,0x000000);
			
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadTArmsOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/initialization/Arms.sgj"));
		}
		private function loadTArmsOver(event:Event):void{
			//trace("event.target.data = " + event.target.data);
			_urlloader.die();
			_urlloader = null;
			_armsXml = new XML(event.target.data);
			setArmsList();
			view(0,0);
		}
		public function setArmsList():void{
			var i:int;
			var bitmapdata:BitmapData;
			var size:uint;
			var w:uint;
			var h:uint;
			var lbl:LLabel,element:XML;
			var byte:ByteArray;
			if(listSprite != null)listSprite.removeFromParent();
			listSprite = new LSprite();
			_arms = new Array();
			for each(element in this._armsXml.elements()){
				lbl = new LLabel();
				lbl.text = element.Name;
				lbl.y = i*20;
				listSprite.addChild(lbl);
				_arms.push(element);
				i++;
			}
			selectBit = new LBitmap(x999999Bit);
			selectBit.alpha = 0.5;
			selectBit.y = i*20;
			lbl = new LLabel();
			lbl.text = "新增";
			lbl.y = i*20;
			listSprite.addChild(lbl);
			listSprite.addChild(selectBit);
			listSprite.addEventListener(MouseEvent.MOUSE_MOVE,mousemovelist);
			listSprite.addEventListener(MouseEvent.MOUSE_UP,mouseclicklist);
			listSprite.addEventListener(MouseEvent.ROLL_OUT,mouseoutlist);
			LDisplay.drawRect(listSprite.graphics,[0,0,150,(i+1)*20],true,0,0);
			listScrollbar = new LScrollbar(listSprite,100,480,20,false);
			listScrollbar.x = 12;
			listScrollbar.y = 32;
			listScrollbar.scrollToBottom();
			this.addChild(listScrollbar);
		}
		private function mouseclicklist(event:MouseEvent):void{
			var i:int = int(event.currentTarget.mouseY/selectBit.height);
			view(i*20,i);
		}
		private function mouseoutlist(event:MouseEvent):void{
			selectBit.y = _armsIndex*selectBit.height;
		}
		private function mousemovelist(event:MouseEvent):void{
			selectBit.y = int(event.currentTarget.mouseY/selectBit.height)*selectBit.height;
		}
		public function view(by:int,bindex:int):void{
			trace( _arms[_armsIndex]);
			
		}
	}
}