package page.sousou
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.xml.XMLDocument;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.components.LTextInput;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LScrollbar;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.display.LURLLoader;
	import zhanglubin.legend.utils.LDisplay;
	
	public class SouSouTChara extends LSprite
	{
		private var x999999Bit:BitmapData = new BitmapData(100,20,false,0x999999);
		private var _urlloader:LURLLoader;
		private var _chara:Array;
		private var _charaXml:XML;
		private var listSprite:LSprite;
		private var listScrollbar:LScrollbar;
		private var selectBit:LBitmap;
		private var viewSprite:LSprite;
		private var bitView:LBitmap;
		private var bitSprite:LSprite;
		private var bitScrollbar:LScrollbar;
		private var _facelist:Array;
		private var _charaIndex:int;
		public function SouSouTChara()
		{
			super();
			LDisplay.drawRectGradient(this.graphics,[0,20,800,500],[0xffffff,0x8A98F4]);
			LDisplay.drawRect(this.graphics,[0,20,800,500],false,0x000000);
			LDisplay.drawRect(this.graphics,[10,30,124,484],false,0x000000);
			LDisplay.drawRect(this.graphics,[140,30,650,484],false,0x000000);
			
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadTCharaOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/initialization/chara.sgj"))
		}
		private function loadTCharaOver(event:Event):void{
			//trace("event.target.data = " + event.target.data);
			_urlloader.die();
			_urlloader = null;
			_charaXml = new XML(event.target.data);
			
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadFaceOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/images/face.limg"))
		}
		private function loadFaceOver(event:Event):void{
			_urlloader.die();
			_urlloader = null;
			var lbl:LLabel,i:int,bitmapdata:BitmapData,size:int,w:int,h:int,byte:ByteArray;
			var bytes:ByteArray = event.target.data;
			_facelist = new Array();
			this.disposeList = _facelist;
			bytes.uncompress();
			for(i=0;i<bytes.length;i+=size){
				w = bytes.readUnsignedInt();
				h = bytes.readUnsignedInt();
				bitmapdata = new BitmapData(w,h);
				byte = new ByteArray();
				bytes.readBytes(byte,0,w*h*4);
				bitmapdata.setPixels(bitmapdata.rect,byte);
				_facelist.push(bitmapdata); 
				size = w*h*4 + 8;
			}
			
			setCharaList();
			view(0,0);
			listScrollbar.scrollToTop();
		}
		public function setCharaList():void{
			var i:int;
			var bitmapdata:BitmapData;
			var size:uint;
			var w:uint;
			var h:uint;
			var lbl:LLabel,element:XML;
			var byte:ByteArray;
			_chara = new Array();
			listSprite = new LSprite();
			for each(element in this._charaXml.elements()){
				lbl = new LLabel();
				lbl.text = element.Name;
				lbl.y = i*20;
				listSprite.addChild(lbl);
				_chara.push(element);
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
			listScrollbar = new LScrollbar(listSprite,100,480,20,false);
			listScrollbar.x = 12;
			listScrollbar.y = 32;
			listScrollbar.scrollToBottom();
			this.addChild(listScrollbar);
		}
		private function mouseclicklist(event:MouseEvent):void{
			var i:int = int(event.currentTarget.mouseY/selectBit.height);
			view(0,i);
		}
		private function mouseoutlist(event:MouseEvent):void{
			selectBit.y = _charaIndex*selectBit.height;
		}
		private function mousemovelist(event:MouseEvent):void{
			selectBit.y = int(event.currentTarget.mouseY/selectBit.height)*selectBit.height;
		}
		public function view(by:int,bindex:int):void{
			_charaIndex = bindex;
			if(viewSprite != null){
				viewSprite.removeFromParent();
			}
			if(!selectBit){
				selectBit = new LBitmap(x999999Bit);
				selectBit.alpha = 0.5;
			}
			selectBit.y = by;
			
			viewSprite = new LSprite(); 
			LDisplay.drawLine(viewSprite.graphics,[0,40,650,40]);
			LDisplay.drawRectGradient(viewSprite.graphics,[10,50,120,120],[0xffffff,0x000000]);
			viewSprite.x = 140;
			viewSprite.y = 30;
			this.addChild(viewSprite);
			//头像
			viewFace();
			
			var charaName:LTextInput = new LTextInput();
			charaName.text = _chara[_charaIndex].Name;
			charaName.x = 10;
			charaName.y= 180;
			viewSprite.addChild(charaName);
		}
		/**
		 *头像
		 **/
		private function viewFace():void{
			var index:int = _chara[_charaIndex].Face;
			bitView = new LBitmap();
			bitView.bitmapData = _facelist[index];
			bitSprite = new LSprite();
			bitSprite.addChild(bitView);
			bitScrollbar=new LScrollbar(bitSprite,600,400);
			bitScrollbar.x = 10;
			bitScrollbar.y= 50;
			viewSprite.addChild(bitScrollbar);
		}
	}
}