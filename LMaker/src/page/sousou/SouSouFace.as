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

	public class SouSouFace extends LSprite
	{
		private var _urlloader:LURLLoader;
		private const SAVE_INDEX:int = 1;
		private var xffffffBit:BitmapData = new BitmapData(100,20,false,0xffffff);
		private var xccccccBit:BitmapData = new BitmapData(100,20,false,0xcccccc);
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
		public function SouSouFace(bytes:ByteArray = null)
		{ 
			LDisplay.drawRectGradient(this.graphics,[0,20,800,500],[0xffffff,0x8A98F4]);
			LDisplay.drawRect(this.graphics,[0,20,800,500],false,0x000000);
			LDisplay.drawRect(this.graphics,[10,30,124,484],false,0x000000);
			LDisplay.drawRect(this.graphics,[140,30,650,484],false,0x000000);
			
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadFaceOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/images/face.limg"))
			
		}
		private function loadFaceOver(event:Event):void{
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
			var w:uint;
			var h:uint;
			var byte:ByteArray;
			var sizebyte:ByteArray;
			imglist = new Array();
			if(bytes == null){
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
				for(i=0;i<bytes.length;i+=size){
					w = bytes.readUnsignedInt();
					h = bytes.readUnsignedInt();
					bitmapdata = new BitmapData(w,h);
					byte = new ByteArray();
					bytes.readBytes(byte,0,w*h*4);
					bitmapdata.setPixels(bitmapdata.rect,byte);
					imglist.push(bitmapdata); 
					
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
			LDisplay.drawRectGradient(viewSprite.graphics,[22,62,120,120],[0xffffff,0x000000]);
			viewSprite.x = 140;
			viewSprite.y = 60;
			this.addChild(viewSprite);
			bitView = new LBitmap();
			bitSprite = new LSprite();
			bitSprite.addChild(bitView);
			bitScrollbar=new LScrollbar(bitSprite,600,400);
			bitScrollbar.x = 22;
			bitScrollbar.y= 62;
			viewSprite.addChild(bitScrollbar);
			LDisplay.drawLine(viewSprite.graphics,[0,40,650,40]);
			
			lbtn = LGlobal.getModelButton(0,[0,0,80,20,"载入图片",15,0x0000ff]);
			lbtn.name = "new";
			lbtn.coordinate = new Point(10,10);
			lbtn.addEventListener(MouseEvent.MOUSE_UP,loadimg);
			viewSprite.addChild(lbtn);
			
			imgIndex = bindex;
			if(imgIndex < imglist.length){
				lbtn = LGlobal.getModelButton(0,[0,0,80,20,"删除图片",15,0x0000ff]);
				lbtn.name = "delete";
				lbtn.coordinate = new Point(120,10);
				lbtn.addEventListener(MouseEvent.MOUSE_UP,deleteimg);
				viewSprite.addChild(lbtn);
				bitView.bitmapData = imglist[imgIndex];
			}
			
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
			for(i=0;i<imglist.length;i++){
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
			var bytes:ByteArray = new ByteArray();
			var bitmapdata:BitmapData;
			var byte:ByteArray;
			var i:int;
			for(i=0;i<imglist.length;i++){
				bitmapdata = imglist[i];
				byte = bitmapdata.getPixels(bitmapdata.rect);
				bytes.writeUnsignedInt(bitmapdata.width);
				bytes.writeUnsignedInt(bitmapdata.height);
				bytes.writeBytes(byte);
			}
			bytes.compress();
			Global.saveBytesData(Global.sousouPath + "/images","face.limg",bytes);
			this._btnSave.visible = false;
		}
	}
}