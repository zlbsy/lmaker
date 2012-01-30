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
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LImageLoader;
	import zhanglubin.legend.display.LScrollbar;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.display.LURLLoader;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LFilter;
	import zhanglubin.legend.utils.LGlobal;

	public class SouSouSImg extends SouSouImg
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
		private var imglistATK:Array;
		private var imglistMOV:Array;
		private var imglistSPC:Array;
		private var imgByteArray:ByteArray;
		private var iload:LImageLoader;
		private var imgIndex:int;
		private var bitViewATK:LBitmap;
		private var bitViewMOV:LBitmap;
		private var bitViewSPC:LBitmap;
		private var bitSprite:LSprite;
		private var bitScrollbar:LScrollbar;
		private var selectBit:LBitmap;
		private var _btnSave:LButton;
		private var _bitSave:LBitmap;
		private var _ctrl_type:int;
		public function SouSouSImg(bytesLilt:Array = null)
		{ 
			super();
			LDisplay.drawRectGradient(this.graphics,[0,20,800,500],[0xffffff,0x8A98F4]);
			LDisplay.drawRect(this.graphics,[0,20,800,500],false,0x000000);
			LDisplay.drawRect(this.graphics,[10,30,124,484],false,0x000000);
			LDisplay.drawRect(this.graphics,[140,30,650,484],false,0x000000);
			
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadAtkOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/images/atk.limg"))
		}
		private function loadAtkOver(event:Event):void{
			_bytesList = new Array();
			_bytesList.push(event.target.data);
			_urlloader.die();
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadMovOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/images/mov.limg"))
		}
		private function loadMovOver(event:Event):void{
			_bytesList.push(event.target.data);
			_urlloader.die();
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadSpcOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/images/spc.limg"))
		}
		private function loadSpcOver(event:Event):void{
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
			var bytesATK:ByteArray,bytesMOV:ByteArray,bytesSPC:ByteArray;
			var i:int,lbl:LLabel
			var bitmapdata:BitmapData;
			var size:uint;
			var w:uint;
			var h:uint;
			var byte:ByteArray;
			var sizebyte:ByteArray;
			imglistATK = new Array();
			imglistMOV = new Array();
			imglistSPC = new Array();
			this.bitmapdataList.push(imglistATK,imglistMOV,imglistSPC);
			if(bytesLilt != null && bytesLilt.length > 0){
				bytesATK = bytesLilt[0];
				bytesMOV = bytesLilt[1];
				bytesSPC = bytesLilt[2];
			}
			
			if(bytesATK == null || bytesMOV == null || bytesSPC == null){
				/**
				lbtn = new LButton(xccccccBit,x999999Bit,x999999Bit);
				lbtn.name = "0";
				lbtn.label= "图片[0]";
				lbtn.coordinate = new Point(0,0);
				lbtn.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
				*/
				lbl = new LLabel();
				lbl.text = "图片[0]";
				listSprite = new LSprite();
				listSprite.addChild(lbl);
				listScrollbar = new LScrollbar(listSprite,100,460,20,false);
				listScrollbar.x = 12;
				listScrollbar.y = 32;
				this.addChild(listScrollbar);
			}else{
				bytesATK.uncompress();
				for(i=0;i<bytesATK.length;i+=size){
					w = bytesATK.readUnsignedInt();
					h = bytesATK.readUnsignedInt();
					bitmapdata = new BitmapData(w,h);
					byte = new ByteArray();
					bytesATK.readBytes(byte,0,w*h*4);
					bitmapdata.setPixels(bitmapdata.rect,byte);
					imglistATK.push(bitmapdata); 
					
					size = w*h*4 + 8;
				}
				
				bytesMOV.uncompress();
				for(i=0;i<bytesMOV.length;i+=size){
					w = bytesMOV.readUnsignedInt();
					h = bytesMOV.readUnsignedInt();
					bitmapdata = new BitmapData(w,h);
					byte = new ByteArray();
					bytesMOV.readBytes(byte,0,w*h*4);
					bitmapdata.setPixels(bitmapdata.rect,byte);
					imglistMOV.push(bitmapdata); 
					
					size = w*h*4 + 8;
				}
				
				bytesSPC.uncompress();
				for(i=0;i<bytesSPC.length;i+=size){
					w = bytesSPC.readUnsignedInt();
					h = bytesSPC.readUnsignedInt();
					bitmapdata = new BitmapData(w,h);
					byte = new ByteArray();
					bytesSPC.readBytes(byte,0,w*h*4);
					bitmapdata.setPixels(bitmapdata.rect,byte);
					imglistSPC.push(bitmapdata); 
					
					size = w*h*4 + 8;
				}
				/**
				lbtn = new LButton(xccccccBit,x999999Bit,x999999Bit);
				lbtn.name = "0";
				lbtn.label= "图片[0]";
				lbtn.coordinate = new Point(0,0);
				lbtn.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
				listSprite = new LSprite();
				listSprite.addChild(lbtn);
				*/
				
				lbl = new LLabel();
				lbl.text = "图片[0]";
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
			viewSprite.x = 140;
			viewSprite.y = 60;
			this.addChild(viewSprite);
			bitViewATK = new LBitmap();
			bitViewMOV = new LBitmap();
			bitViewMOV.x = 100;
			bitViewSPC = new LBitmap();
			bitViewSPC.x = 200;
			bitSprite = new LSprite();
			LDisplay.drawRect(bitSprite.graphics,[0,0,64,768],true,0x0000ff,1);
			LDisplay.drawRect(bitSprite.graphics,[100,0,48,528],true,0x0000ff,1);
			LDisplay.drawRect(bitSprite.graphics,[200,0,48,240],true,0x0000ff,1);
			bitSprite.addChild(bitViewATK);
			bitSprite.addChild(bitViewMOV);
			bitSprite.addChild(bitViewSPC);
			bitScrollbar=new LScrollbar(bitSprite,600,380);
			bitScrollbar.x = 22;
			bitScrollbar.y= 62;
			viewSprite.addChild(bitScrollbar);
			LDisplay.drawLine(viewSprite.graphics,[0,40,650,40]);
			
			//lbtn = LGlobal.getModelButton(0,[0,0,80,20,"载入图片",15,0x0000ff]);
			//lbtn.name = "new";
			lbtn = new LButton(Global.imgData[2]);
			lbtn.name = "openATK";
			lbtn.coordinate = new Point(25,10);
			lbtn.addEventListener(MouseEvent.MOUSE_UP,loadimg);
			viewSprite.addChild(lbtn);
			lbtn = new LButton(Global.imgData[2]);
			lbtn.name = "openMOV";
			lbtn.coordinate = new Point(125,10);
			lbtn.addEventListener(MouseEvent.MOUSE_UP,loadimg);
			viewSprite.addChild(lbtn);
			lbtn = new LButton(Global.imgData[2]);
			lbtn.name = "openSPC";
			lbtn.coordinate = new Point(225,10);
			lbtn.addEventListener(MouseEvent.MOUSE_UP,loadimg);
			viewSprite.addChild(lbtn);
			
			imgIndex = bindex;
			if(imgIndex < imglistATK.length){
				lbtn = new LButton(Global.imgData[3]);
				lbtn.name = "deleteATK";
				lbtn.coordinate = new Point(55,10);
				lbtn.addEventListener(MouseEvent.MOUSE_UP,deleteimg);
				viewSprite.addChild(lbtn);
				bitViewATK.bitmapData = imglistATK[imgIndex];
			}
			if(imgIndex < imglistMOV.length){
				lbtn = new LButton(Global.imgData[3]);
				lbtn.name = "deleteMOV";
				lbtn.coordinate = new Point(155,10);
				lbtn.addEventListener(MouseEvent.MOUSE_UP,deleteimg);
				viewSprite.addChild(lbtn);
				bitViewMOV.bitmapData = imglistMOV[imgIndex];
			}
			if(imgIndex < imglistSPC.length){
				lbtn = new LButton(Global.imgData[3]);
				lbtn.name = "deleteSPC";
				lbtn.coordinate = new Point(255,10);
				lbtn.addEventListener(MouseEvent.MOUSE_UP,deleteimg);
				viewSprite.addChild(lbtn);
				bitViewSPC.bitmapData = imglistSPC[imgIndex];
			}
		}
		public function deleteimg(event:MouseEvent):void{
			var scroll_y:int = listScrollbar.scrollY;
			var index:int = imgIndex;
			var by:int = selectBit.y;
			if(event.currentTarget.name == "deleteATK"){
				imglistATK.splice(imgIndex,1);
			}else if(event.currentTarget.name == "deleteMOV"){
				imglistMOV.splice(imgIndex,1);
			}else{
				imglistSPC.splice(imgIndex,1);
			}
			
			resetList();
			imgView(by,index);
			listScrollbar.scrollY = scroll_y;
			this._btnSave.visible = true;
		}
		public function loadimg(event:MouseEvent):void{
			if(event.currentTarget.name == "openATK"){
				_ctrl_type = 0;
			}else if(event.currentTarget.name == "openMOV"){
				_ctrl_type = 1;
			}else{
				_ctrl_type = 2;
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
				bitView = bitViewATK;
				imglist = imglistATK;
			}else if(_ctrl_type == 0){
				bitView = bitViewMOV;
				imglist = imglistMOV;
			}else{
				bitView = bitViewSPC;
				imglist = imglistSPC;
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
			var i:int,lbl:LLabel;
			listSprite = new LSprite();
			for(i=0;i<imglistATK.length;i++){
				lbl = new LLabel();
				lbl.text = "图片["+i.toString()+"]";
				lbl.y = i*20;
				listSprite.addChild(lbl);
				/**
				lbtn = new LButton(xccccccBit,x999999Bit,x999999Bit);
				lbtn.name = i.toString();
				lbtn.label= "图片["+i.toString()+"]";
				lbtn.coordinate = new Point(0,i*20); 
				lbtn.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
				listSprite.addChild(lbtn);
				*/
			}
			selectBit = new LBitmap(x999999Bit);
			selectBit.alpha = 0.5;
			selectBit.y = i*20;
			lbl = new LLabel();
			lbl.text = "新增";
			lbl.y = i*20;
			listSprite.addChild(lbl);
			/**
			lbtn = new LButton(xccccccBit,x999999Bit,x999999Bit);
			lbtn.name = i.toString();
			lbtn.label= "图片["+i.toString()+"]";
			lbtn.coordinate = new Point(0,i*20);
			lbtn.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			listSprite.addChild(lbtn);
			*/
			listSprite.addChild(selectBit);
			listSprite.addEventListener(MouseEvent.MOUSE_MOVE,mousemovelist);
			listSprite.addEventListener(MouseEvent.MOUSE_UP,mouseclicklist);
			listSprite.addEventListener(MouseEvent.MOUSE_OUT,mouseoutlist);
			listScrollbar = new LScrollbar(listSprite,100,480,20,false);
			listScrollbar.x = 12;
			listScrollbar.y = 32;
			listScrollbar.scrollToBottom();
			this.addChild(listScrollbar);
		}
		private function mouseclicklist(event:MouseEvent):void{
			var i:int = int(event.currentTarget.mouseY/selectBit.height);
			imgView(0,i);
		}
		private function mouseoutlist(event:MouseEvent):void{
			selectBit.y = imgIndex*selectBit.height;
		}
		private function mousemovelist(event:MouseEvent):void{
			selectBit.y = int(event.currentTarget.mouseY/selectBit.height)*selectBit.height;
		}
		public function save(event:MouseEvent):void{
			var bytesATK:ByteArray = new ByteArray();
			var bytesMOV:ByteArray = new ByteArray();
			var bytesSPC:ByteArray = new ByteArray();
			var bitmapdata:BitmapData;
			var byte:ByteArray;
			var i:int;
			
			for(i=0;i<imglistATK.length;i++){
				bitmapdata = imglistATK[i];
				byte = bitmapdata.getPixels(bitmapdata.rect);
				bytesATK.writeUnsignedInt(bitmapdata.width);
				bytesATK.writeUnsignedInt(bitmapdata.height);
				bytesATK.writeBytes(byte);
			}
			bytesATK.compress();
			Global.saveBytesData(Global.sousouPath + "/images","atk.limg",bytesATK);
			
			for(i=0;i<imglistMOV.length;i++){
				bitmapdata = imglistMOV[i];
				byte = bitmapdata.getPixels(bitmapdata.rect);
				bytesMOV.writeUnsignedInt(bitmapdata.width);
				bytesMOV.writeUnsignedInt(bitmapdata.height);
				bytesMOV.writeBytes(byte);
			}
			bytesMOV.compress();
			Global.saveBytesData(Global.sousouPath + "/images","mov.limg",bytesMOV);
			
			for(i=0;i<imglistSPC.length;i++){
				bitmapdata = imglistSPC[i];
				byte = bitmapdata.getPixels(bitmapdata.rect);
				bytesSPC.writeUnsignedInt(bitmapdata.width);
				bytesSPC.writeUnsignedInt(bitmapdata.height);
				bytesSPC.writeBytes(byte);
			}
			bytesSPC.compress();
			Global.saveBytesData(Global.sousouPath + "/images","spc.limg",bytesSPC);
			
			this._btnSave.visible = false;
		}
	}
}