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
	
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LImageLoader;
	import zhanglubin.legend.display.LScrollbar;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.display.LURLLoader;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LFilter;
	import zhanglubin.legend.utils.LGlobal;

	public class SouSouRImg extends SouSouImg
	{
		private const SAVE_INDEX:int = 1;
		
		private var _urlloader:LURLLoader;
		private var _bytesList:Array;
		private var xffffffBit:BitmapData = new BitmapData(100,20,false,0xffffff);
		private var xccccccBit:BitmapData = new BitmapData(100,20,false,0xcccccc);
		private var x999999Bit:BitmapData = new BitmapData(100,20,false,0x999999);
		private var _file:FileReference;
		private var listSprite:LSprite;
		private var listScrollbar:LScrollbar;
		private var lbtn:LButton;
		private var viewSprite:LSprite;
		private var imglistR0:Array;
		private var imglistR1:Array;
		private var imgByteArray:ByteArray;
		private var iload:LImageLoader;
		private var imgIndex:int;
		private var bitViewR0:LBitmap;
		private var bitViewR1:LBitmap;
		private var bitSprite:LSprite;
		private var bitScrollbar:LScrollbar;
		private var selectBit:LBitmap;
		private var _btnSave:LButton;
		private var _bitSave:LBitmap;
		private var _ctrl_type:int;
		public function SouSouRImg(bytesLilt:Array = null)
		{ 
			super();
			LDisplay.drawRectGradient(this.graphics,[0,20,800,500],[0xffffff,0x8A98F4]);
			LDisplay.drawRect(this.graphics,[0,20,800,500],false,0x000000);
			LDisplay.drawRect(this.graphics,[10,30,124,484],false,0x000000);
			LDisplay.drawRect(this.graphics,[140,30,650,484],false,0x000000);
			
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadR0Over);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/images/r0.limg"))
		}
		private function loadR0Over(event:Event):void{
			_bytesList = new Array();
			_bytesList.push(event.target.data);
			_urlloader.die();
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadR1Over);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/images/r1.limg"))
		}
		private function loadR1Over(event:Event):void{
			_bytesList.push(event.target.data);
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
			
			setImageList(_bytesList);
			imgView(0,0);
			listScrollbar.scrollToTop();
			
			_bytesList = null;
		}
		public function setImageList(bytesLilt:Array):void{
			var bytesR0:ByteArray,bytesR1:ByteArray;
			var i:int;
			var bitmapdata:BitmapData;
			var size:uint;
			var w:uint;
			var h:uint;
			var byte:ByteArray;
			var sizebyte:ByteArray;
			imglistR0 = new Array();
			imglistR1 = new Array();
			
			if(bytesLilt != null && bytesLilt.length > 0){
				bytesR0 = bytesLilt[0];
				bytesR1 = bytesLilt[1];
			}
			
			if(bytesR0 == null || bytesR1 == null){
				lbtn = new LButton(xccccccBit,x999999Bit,x999999Bit);
				lbtn.name = "0";
				lbtn.label= "图片[0]";
				lbtn.coordinate = new Point(0,0);
				lbtn.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
				listSprite = new LSprite();
				listSprite.addChild(lbtn);
				listScrollbar = new LScrollbar(listSprite,100,460,20,false);
				listScrollbar.x = 12;
				listScrollbar.y = 32;
				this.addChild(listScrollbar);
			}else{
				bytesR0.uncompress();
				for(i=0;i<bytesR0.length;i+=size){
					w = bytesR0.readUnsignedInt();
					h = bytesR0.readUnsignedInt();
					bitmapdata = new BitmapData(w,h);
					byte = new ByteArray();
					bytesR0.readBytes(byte,0,w*h*4);
					bitmapdata.setPixels(bitmapdata.rect,byte);
					imglistR0.push(bitmapdata); 
					
					size = w*h*4 + 8;
				}
				
				bytesR1.uncompress();
				for(i=0;i<bytesR1.length;i+=size){
					w = bytesR1.readUnsignedInt();
					h = bytesR1.readUnsignedInt();
					bitmapdata = new BitmapData(w,h);
					byte = new ByteArray();
					bytesR1.readBytes(byte,0,w*h*4);
					bitmapdata.setPixels(bitmapdata.rect,byte);
					imglistR1.push(bitmapdata); 
					
					size = w*h*4 + 8;
				}
				
				lbtn = new LButton(xccccccBit,x999999Bit,x999999Bit);
				lbtn.name = "0";
				lbtn.label= "图片[0]";
				lbtn.coordinate = new Point(0,0);
				lbtn.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
				listSprite = new LSprite();
				listSprite.addChild(lbtn);
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
			LDisplay.drawRect(viewSprite.graphics,[22,62,48,380],true,0x0000ff,1);
			LDisplay.drawRect(viewSprite.graphics,[122,62,48,380],true,0x0000ff,1);
			viewSprite.x = 140;
			viewSprite.y = 60;
			this.addChild(viewSprite);
			bitViewR0 = new LBitmap();
			bitViewR1 = new LBitmap();
			bitViewR1.x = 100;
			bitSprite = new LSprite();
			bitSprite.addChild(bitViewR0);
			bitSprite.addChild(bitViewR1);
			bitScrollbar=new LScrollbar(bitSprite,600,380);
			bitScrollbar.x = 22;
			bitScrollbar.y= 62;
			viewSprite.addChild(bitScrollbar);
			LDisplay.drawLine(viewSprite.graphics,[0,40,650,40]);
			
			//lbtn = LGlobal.getModelButton(0,[0,0,80,20,"载入图片",15,0x0000ff]);
			//lbtn.name = "new";
			lbtn = new LButton(Global.imgData[2]);
			lbtn.name = "openR0";
			lbtn.coordinate = new Point(25,10);
			lbtn.addEventListener(MouseEvent.MOUSE_UP,loadimg);
			viewSprite.addChild(lbtn);
			lbtn = new LButton(Global.imgData[2]);
			lbtn.name = "openR1";
			lbtn.coordinate = new Point(125,10);
			lbtn.addEventListener(MouseEvent.MOUSE_UP,loadimg);
			viewSprite.addChild(lbtn);
			
			imgIndex = bindex;
			if(imgIndex < imglistR0.length){
				lbtn = new LButton(Global.imgData[3]);
				lbtn.name = "deleteR0";
				lbtn.coordinate = new Point(55,10);
				lbtn.addEventListener(MouseEvent.MOUSE_UP,deleteimg);
				viewSprite.addChild(lbtn);
				bitViewR0.bitmapData = imglistR0[imgIndex];
			}
			if(imgIndex < imglistR1.length){
				lbtn = new LButton(Global.imgData[3]);
				lbtn.name = "deleteR1";
				lbtn.coordinate = new Point(155,10);
				lbtn.addEventListener(MouseEvent.MOUSE_UP,deleteimg);
				viewSprite.addChild(lbtn);
				bitViewR1.bitmapData = imglistR1[imgIndex];
			}
			
		}
		public function deleteimg(event:MouseEvent):void{
			var scroll_y:int = listScrollbar.scrollY;
			var index:int = imgIndex;
			var by:int = selectBit.y;
			if(event.currentTarget.name == "deleteR0"){
				imglistR0.splice(imgIndex,1);
			}else{
				imglistR1.splice(imgIndex,1);
			}
			
			resetList();
			imgView(by,index);
			listScrollbar.scrollY = scroll_y;
			this._btnSave.visible = true;
		}
		public function loadimg(event:MouseEvent):void{
			if(event.currentTarget.name == "openR0"){
				_ctrl_type = 0;
			}else{
				_ctrl_type = 1;
			}
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
			var bitView:LBitmap,imglist:Array;
			if(_ctrl_type == 0){
				bitView = bitViewR0;
				imglist = imglistR0;
			}else{
				bitView = bitViewR1;
				imglist = imglistR1;
			}
			bitView.bitmapData = bitmapdata;
			if(imgIndex >= imglist.length){
				imglist.push(bitmapdata);
				resetList();
			}else{
				(imglist[imgIndex] as BitmapData).dispose();
				imglist[imgIndex] = bitmapdata;
			}
		}
		private function resetList():void{
			if(listScrollbar)listScrollbar.removeFromParent();
			var i:int;
			listSprite = new LSprite();
			for(i=0;i<imglistR0.length;i++){
				lbtn = new LButton(xccccccBit,x999999Bit,x999999Bit);
				lbtn.name = i.toString();
				lbtn.label= "图片["+i.toString()+"]";
				lbtn.coordinate = new Point(0,i*20);
				lbtn.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
				listSprite.addChild(lbtn);
			}
			selectBit = new LBitmap(x999999Bit);
			selectBit.alpha = 0.5;
			selectBit.coordinate = new Point(0,i*20);
			lbtn = new LButton(xccccccBit,x999999Bit,x999999Bit);
			lbtn.name = i.toString();
			lbtn.label= "图片["+i.toString()+"]";
			lbtn.coordinate = new Point(0,i*20);
			lbtn.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			listSprite.addChild(lbtn);
			listSprite.addChild(selectBit);
			listScrollbar = new LScrollbar(listSprite,100,480,20,false);
			listScrollbar.x = 12;
			listScrollbar.y = 32;
			listScrollbar.scrollToBottom();
			this.addChild(listScrollbar);
		}
		public function save(event:MouseEvent):void{
			var bytesR0:ByteArray = new ByteArray();
			var bytesR1:ByteArray = new ByteArray();
			var bitmapdata:BitmapData;
			var byte:ByteArray;
			var i:int;
			
			for(i=0;i<imglistR0.length;i++){
				bitmapdata = imglistR0[i];
				byte = bitmapdata.getPixels(bitmapdata.rect);
				bytesR0.writeUnsignedInt(bitmapdata.width);
				bytesR0.writeUnsignedInt(bitmapdata.height);
				bytesR0.writeBytes(byte);
			}
			bytesR0.compress();
			Global.saveBytesData(Global.sousouPath + "/images","r0.limg",bytesR0);
			
			for(i=0;i<imglistR1.length;i++){
				bitmapdata = imglistR1[i];
				byte = bitmapdata.getPixels(bitmapdata.rect);
				bytesR1.writeUnsignedInt(bitmapdata.width);
				bytesR1.writeUnsignedInt(bitmapdata.height);
				bytesR1.writeBytes(byte);
			}
			bytesR1.compress();
			Global.saveBytesData(Global.sousouPath + "/images","r1.limg",bytesR1);
			this._btnSave.visible = false;
		}
	}
}