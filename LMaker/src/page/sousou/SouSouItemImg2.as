package page.sousou
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.components.LTextInput;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LImageLoader;
	import zhanglubin.legend.display.LScrollbar;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.display.LURLLoader;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LFilter;
	import zhanglubin.legend.utils.LGlobal;
	import zhanglubin.legend.utils.LString;

	public class SouSouItemImg2 extends LSprite
	{
		private var _urlloader:LURLLoader;
		private const SAVE_INDEX:int = 1;
		private var x999999Bit:BitmapData = new BitmapData(100,20,false,0x999999);
		private var _file:FileReference;
		private var listSprite:LSprite;
		private var listScrollbar:LScrollbar;
		private var lbtn:LButton;
		private var viewSprite:LSprite;
		private var imglist:Array;
		private var imgByteArray:ByteArray;
		private var iload:LImageLoader;
		private var imgIndex:int;
		private var bitView:LBitmap;
		private var bitSprite:LSprite;
		private var bitScrollbar:LScrollbar;
		private var selectBit:LBitmap;
		private var _btnSave:LButton;
		private var _bitSave:LBitmap;
		private var _bitName:LTextInput;
		public function SouSouItemImg2(bytes:ByteArray = null)
		{ 
			super();
			LDisplay.drawRectGradient(this.graphics,[0,20,800,500],[0xffffff,0x8A98F4]);
			LDisplay.drawRect(this.graphics,[0,20,800,500],false,0x000000);
			LDisplay.drawRect(this.graphics,[10,30,124,484],false,0x000000);
			LDisplay.drawRect(this.graphics,[140,30,650,484],false,0x000000);
			/**
			if(!Global.exists(Global.sousouPath+"/images","item.limg2")){
				trace("new");
				var bytes:ByteArray = new ByteArray();
				var bitmapdata:BitmapData;
				var byte:ByteArray;
				var i:int;
				var str:String = "akjdkdkffid";
				bitmapdata = new BitmapData(60,400,false,0xff0000);
				byte = bitmapdata.getPixels(bitmapdata.rect);
				bytes.writeUnsignedInt(str.length);
				bytes.writeUTFBytes(str);
				bytes.writeUnsignedInt(bitmapdata.width);
				bytes.writeUnsignedInt(bitmapdata.height);
				bytes.writeBytes(byte);
				bytes.compress();
				Global.saveBytesData(Global.sousouPath + "/images","item.limg2",bytes);
			}*/
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadStrategyImgOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/images/item.limg2"));
			
		}
		private function loadStrategyImgOver(event:Event):void{
			_urlloader.die();
			_urlloader = null;
			
			_bitSave = new LBitmap(Global.imgData[SAVE_INDEX]);
			LFilter.setFilter(_bitSave,LFilter.GRAY);
			_bitSave.x = 20;
			this.addChild(_bitSave);
			
			_btnSave = new LButton(Global.imgData[SAVE_INDEX]);
			_btnSave.x = 20;
			this.addChild(_btnSave);
			_btnSave.addEventListener(MouseEvent.MOUSE_UP,save);
			_btnSave.visible = false;
			
			setImageList(event.target.data);
			imgView(0,0);
			listScrollbar.scrollToTop();
		}
		public function setImageList(bytes:ByteArray = null):void{
			bytes.uncompress();
			var i:int;
			var bitmapdata:BitmapData;
			var size:uint;
			var limg2:String;
			var l:uint,w:uint,h:uint;
			var byte:ByteArray;
			var sizebyte:ByteArray;
			var lbl:LLabel;
			imglist = new Array();
			if(bytes == null){
				lbl = new LLabel();
				lbl.text = "新增";
				listSprite = new LSprite();
				listSprite.addChild(lbl);
				listScrollbar = new LScrollbar(listSprite,100,460,20,false);
				listScrollbar.x = 12;
				listScrollbar.y = 32;
				this.addChild(listScrollbar);
			}else{
				for(i=0;i<bytes.length;i+=size){
					l = bytes.readUnsignedInt();
					limg2 = bytes.readUTFBytes(l);
					w = bytes.readUnsignedInt();
					h = bytes.readUnsignedInt();
					bitmapdata = new BitmapData(w,h);
					byte = new ByteArray();
					bytes.readBytes(byte,0,w*h*4);
					bitmapdata.setPixels(bitmapdata.rect,byte);
					imglist.push([limg2,bitmapdata]); 
					//this.disposeList.push(bitmapdata);
					size = l + w*h*4 + 12;
				}
				lbl = new LLabel();
				lbl.text = "新增";
				listSprite = new LSprite();
				listSprite.addChild(lbl);
				listScrollbar = new LScrollbar(listSprite,100,460,20,false);
				listScrollbar.x = 12;
				listScrollbar.y = 32;
				this.addChild(listScrollbar);
				resetList();
			}
		}
		public function mouseUp(event:MouseEvent):void{
			imgView(event.currentTarget.y,int(event.currentTarget.name));
		}
		public function imgView(by:int,bindex:int):void{
			if(viewSprite != null){
				viewSprite.removeFromParent();
			}
			if(!selectBit){
				selectBit = new LBitmap(x999999Bit);
				selectBit.alpha = 0.5;
			}
			selectBit.y = by;
			viewSprite = new LSprite(); 
			//LDisplay.drawRectGradient(viewSprite.graphics,[22,62,120,120],[0xffffff,0x000000]);
			viewSprite.x = 140;
			viewSprite.y = 30;
			this.addChild(viewSprite);
			bitView = new LBitmap();
			bitSprite = new LSprite();
			bitSprite.addChild(bitView);
			bitScrollbar=new LScrollbar(bitSprite,600,380);
			bitScrollbar.x = 22;
			bitScrollbar.y= 82;
			viewSprite.addChild(bitScrollbar);
			LDisplay.drawLine(viewSprite.graphics,[0,60,650,60]);
			
			//lbtn = LGlobal.getModelButton(0,[0,0,80,20,"载入图片",15,0x0000ff]);
			lbtn = new LButton(Global.imgData[2]);
			lbtn.name = "new";
			lbtn.coordinate = new Point(40,40);
			lbtn.addEventListener(MouseEvent.MOUSE_UP,loadimg);
			viewSprite.addChild(lbtn);
			
			imgIndex = bindex;
			if(imgIndex < imglist.length){
				lbtn = new LButton(Global.imgData[3]);
				lbtn.name = "delete";
				lbtn.coordinate = new Point(100,40);
				lbtn.addEventListener(MouseEvent.MOUSE_UP,deleteimg);
				viewSprite.addChild(lbtn);
				bitView.bitmapData = imglist[imgIndex][1];
				LDisplay.drawRect(bitSprite.graphics,[0,0,bitView.width,bitView.height],true,0x000000,1);
				this._bitName = new LTextInput();
				_bitName.text = imglist[imgIndex][0];
				_bitName.x = 40;
				_bitName.y = 10;
				viewSprite.addChild(_bitName);
			}else{
				lbtn = new LButton(Global.imgData[3]);
				lbtn.name = "delete";
				lbtn.coordinate = new Point(100,40);
				lbtn.addEventListener(MouseEvent.MOUSE_UP,deleteimg);
				viewSprite.addChild(lbtn);
				bitView.bitmapData = new BitmapData(64,128,false,0x000000);
				this._bitName = new LTextInput();
				_bitName.text = LString.getRandWord(10);
				_bitName.x = 40;
				_bitName.y = 10;
				viewSprite.addChild(_bitName);
				imglist.push([_bitName.text,bitView.bitmapData]);
			}
			this.resetList();
			selectBit.y = imgIndex*selectBit.height;
		}
		public function deleteimg(event:MouseEvent):void{
			var scroll_y:int = listScrollbar.scrollY;
			var index:int = imgIndex;
			var by:int = selectBit.y;
			imglist.splice(imgIndex,1);
			resetList();
			imgView(by,index);
			listScrollbar.scrollY = scroll_y;
			this._btnSave.visible = true;
		}
		public function loadimg(event:MouseEvent):void{
			_file = new FileReference();
			_file.browse([new FileFilter("Image", "*.jpg;*.gif;*.png") ] );
			_file.addEventListener(Event.SELECT,openFile);
			
		}
		private function openFile(event:Event) :void{
			_file.load();
			_file.addEventListener(Event.COMPLETE,readFile);
		}
		private function readFile(event:Event) :void{
			iload = new LImageLoader(event.currentTarget.data);
			iload.addEventListener(Event.COMPLETE,loadImgOver);
		}
		private function loadImgOver(event:Event):void{
			this._btnSave.visible = true;
			var bitmapdata:BitmapData = iload.data;
			bitView.bitmapData = bitmapdata;
			
			(imglist[imgIndex][1] as BitmapData).dispose();
			imglist[imgIndex][1] = bitmapdata;
			
		}
		private function resetList():void{
			if(listScrollbar)listScrollbar.removeFromParent();
			var i:int,lbl:LLabel;
			listSprite = new LSprite();
			for(i=0;i<imglist.length;i++){
				lbl = new LLabel();
				lbl.text = imglist[i][0];
				lbl.y = i*20;
				listSprite.addChild(lbl);
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
			this.imglist[imgIndex][0] = _bitName.text;
			
			var i:int = int(event.currentTarget.mouseY/selectBit.height);
			imgView(i*20,i);
		}
		private function mouseoutlist(event:MouseEvent):void{
			selectBit.y = imgIndex*selectBit.height;
		}
		private function mousemovelist(event:MouseEvent):void{
			selectBit.y = int(event.currentTarget.mouseY/selectBit.height)*selectBit.height;
		}
		public function save(event:MouseEvent):void{
			this.imglist[imgIndex][0] = _bitName.text;
			this.resetList();
			selectBit.y = imgIndex*selectBit.height;
			
			var bytes:ByteArray = new ByteArray();
			var bitmapdata:BitmapData;
			var byte:ByteArray;
			var i:int,name:String;
			for(i=0;i<imglist.length;i++){
				name = imglist[i][0];
				bitmapdata = imglist[i][1];
				byte = bitmapdata.getPixels(bitmapdata.rect);
				bytes.writeUnsignedInt(name.length);
				bytes.writeUTFBytes(name);
				bytes.writeUnsignedInt(bitmapdata.width);
				bytes.writeUnsignedInt(bitmapdata.height);
				bytes.writeBytes(byte);
			}
			bytes.compress();
			Global.saveBytesData(Global.sousouPath + "/images","item.limg2",bytes);
			this._btnSave.visible = false;
		}
	}
}