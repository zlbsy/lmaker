package page.sousou
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
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
	
	public class SouSouRMap extends LSprite
	{
		private const SAVE_INDEX:int = 1;
		private const OPEN_INDEX:int = 2;
		private const DELETE_INDEX:int = 3;
		
		private var x999999Bit:BitmapData = new BitmapData(80,20,false,0x999999);
		private var iload:LImageLoader;
		private var _list:Array;
		private var listSprite:LSprite;
		//private var lbtn:LButton;
		private var selectBit:LBitmap;
		private var listScrollbar:LScrollbar;
		private var _urlloader:LURLLoader;
		private var backmap:LBitmap;
		private var _mapData:Array;
		private var _map:SouSouMapR;
		private var _mapScrollbar:LScrollbar;
		private var _selectIndex:int = -1;
		private var _btnSave:LButton;
		private var _bitSave:LBitmap;
		private var _btnOpen:LButton;
		private var _btnDelete:LButton;
		private var _bitDelete:LBitmap;
		private var _file:FileReference;
		private var _nameInput:LTextInput;
		private var _inputButton:LButton;
		private var _windowSprite:LSprite;
		public function SouSouRMap()
		{
			super();
			
			_list = Global.getFileList(Global.sousouPath + "/images/map",".rmap");
			init();
		}
		private function init():void{
			LDisplay.drawRectGradient(this.graphics,[0,20,910,500],[0xffffff,0x8A98F4]);
			LDisplay.drawRect(this.graphics,[0,20,910,500],false,0x000000);
			LDisplay.drawRect(this.graphics,[10,30,84,480],false,0x000000);
			LDisplay.drawRect(this.graphics,[100,30,800,480],false,0x000000);
			
			_bitSave = new LBitmap(Global.imgData[SAVE_INDEX]);
			LFilter.setFilter(_bitSave,LFilter.GRAY);
			_bitSave.x = 20;
			this.addChild(_bitSave);
			_btnSave = new LButton(Global.imgData[SAVE_INDEX]);
			_btnSave.x = 20;
			this.addChild(_btnSave);
			_btnSave.addEventListener(MouseEvent.MOUSE_UP,saveMap);
			_btnSave.visible = false;
			
			_btnOpen = new LButton(Global.imgData[OPEN_INDEX]);
			_btnOpen.x = 70;
			this.addChild(_btnOpen);
			_btnOpen.addEventListener(MouseEvent.MOUSE_UP,openMap);
			
			_bitDelete = new LBitmap(Global.imgData[DELETE_INDEX]);
			LFilter.setFilter(_bitDelete,LFilter.GRAY);
			_bitDelete.x = 120;
			this.addChild(_bitDelete);
			_btnDelete = new LButton(Global.imgData[DELETE_INDEX]);
			_btnDelete.x = 120;
			this.addChild(_btnDelete);
			_btnDelete.addEventListener(MouseEvent.MOUSE_UP,deleteMap);
			_btnDelete.visible = false;
			
			addList();
		}
		private function nameIsInput(event:MouseEvent):void{
			var name:String = LString.trim(_nameInput.text).split(".")[0];
			if(name.length == 0)return;
			var bitmapd:BitmapData;
			var bytes:ByteArray = new ByteArray();
			var mapdata:String;
			_btnSave.visible = false;
			bitmapd = _map.bitmapdata;
			mapdata = _map.data;
			bytes.writeUnsignedInt(bitmapd.width);
			bytes.writeUnsignedInt(bitmapd.height);
			bytes.writeUTF(mapdata);
			bytes.writeBytes(bitmapd.getPixels(bitmapd.rect));
			bytes.compress();
			Global.saveBytesData(Global.sousouPath + "/images/map",name+".rmap",bytes);
			_list.push([name+".rmap",Global.sousouPath + "/images/map/"+name+".rmap"]);
			_windowSprite.removeFromParent();
			_selectIndex = -1;
			this.die();
			init();
		}
		private function saveMap(event:MouseEvent):void{
			if(_selectIndex < 0){
				_nameInput = new LTextInput();
				if(_inputButton == null)_inputButton = LGlobal.getModelButton(0,[0,0,80,20,"确定",15,0x0000ff]);
				_inputButton.addEventListener(MouseEvent.MOUSE_UP,nameIsInput);
				_windowSprite = Global.showMsg("保存","请输入新R地图名称",_nameInput,_inputButton);
				return;
			}
			var bitmapd:BitmapData;
			var bytes:ByteArray = new ByteArray();
			var mapdata:String;
			_btnSave.visible = false;
			bitmapd = _map.bitmapdata;
			mapdata = _map.data;
			bytes.writeUnsignedInt(bitmapd.width);
			bytes.writeUnsignedInt(bitmapd.height);
			bytes.writeUTF(mapdata);
			bytes.writeBytes(bitmapd.getPixels(bitmapd.rect));
			bytes.compress();
			Global.saveBytesData((_list[_selectIndex][1] as String).replace(_list[_selectIndex][0],""),_list[_selectIndex][0],bytes);
		}
		private function openMap(event:MouseEvent):void{
			_file = new FileReference();	
			_file.browse([new FileFilter("Image", "*.jpg;*.gif;*.png") ] );
			_file.addEventListener(Event.SELECT,openFile);
		}
		private function openFile(event:Event) :void{
			_file.load();
			_file.removeEventListener(Event.SELECT,openFile);
			_file.addEventListener(Event.COMPLETE,readFile);
		}
		private function readFile(event:Event) :void{
			if(_mapScrollbar != null){
				_mapScrollbar.removeFromParent();
			}
			_file.removeEventListener(Event.COMPLETE,readFile);
			iload = new LImageLoader(event.currentTarget.data);
			iload.addEventListener(Event.COMPLETE,loadNewMap);
		}
		private function deleteMap(event:MouseEvent):void{
			_btnDelete.visible = false;
			Global.deleteFile((_list[_selectIndex][1] as String).replace(_list[_selectIndex][0],""),_list[_selectIndex][0]);
			_list.splice(_selectIndex,1);
			_selectIndex = -1;
			this.die();
			init();
		}
		private function addList():void{
			var i:int,lbl:LLabel;
			listSprite = new LSprite();
			for(i=0;i<_list.length;i++){
				lbl = new LLabel();
				lbl.text = _list[i][0];
				lbl.y = i*20;
				listSprite.addChild(lbl);
				/**
				lbtn = new LButton(xccccccBit,x999999Bit,x999999Bit);
				lbtn.name = i.toString();
				lbtn.label= _list[i][0];
				trace(_list[i][0]);
				lbtn.y = i*20;
				lbtn.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
				listSprite.addChild(lbtn);
				 * */
			}
			
			selectBit = new LBitmap(x999999Bit);
			selectBit.alpha = 0.5;
			selectBit.y = i*20;
			listSprite.addChild(selectBit);
			listSprite.addEventListener(MouseEvent.MOUSE_MOVE,mousemovelist);
			listSprite.addEventListener(MouseEvent.MOUSE_UP,mouseclicklist);
			listSprite.addEventListener(MouseEvent.ROLL_OUT,mouseoutlist);
			listScrollbar = new LScrollbar(listSprite,80,480,20,false);
			listScrollbar.x = 12;
			listScrollbar.y = 32;
			listScrollbar.scrollToBottom();
			this.addChild(listScrollbar);
		}
		private function mouseclicklist(event:MouseEvent):void{
			_selectIndex = int(event.currentTarget.mouseY/selectBit.height);
			
			loadMap();
		}
		private function mouseoutlist(event:MouseEvent):void{
			selectBit.y = _selectIndex*selectBit.height;
		}
		private function mousemovelist(event:MouseEvent):void{
			selectBit.y = int(event.currentTarget.mouseY/selectBit.height)*selectBit.height;
		}
		public function mouseUp(event:MouseEvent):void{
			_selectIndex = int(event.currentTarget.name);
			
			loadMap();
		}
		private function loadMap():void{
			var name:String = _list[_selectIndex][1];
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadMapOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(name))
		}
		private function loadMapOver(event:Event):void{
			_urlloader.die();
			_urlloader = null;
			_btnSave.visible = true;
			_btnDelete.visible = true;
			var bytes:ByteArray = event.target.data as ByteArray;
			bytes.uncompress();
			
			var width:int = bytes.readUnsignedInt(); 
			var height:int = bytes.readUnsignedInt();
			var mapdata:String = bytes.readUTF();
			var arr:Array = mapdata.split("\n");
			var i:int = 0;
			var _mapData:Array = [];
			while(i<arr.length){
				_mapData[i] = (arr[i] as String).split(",");
				i++;
			}
			
			var bmd:BitmapData = new BitmapData(width, height, true, 0);
			bmd.setPixels(bmd.rect, bytes);
			_map = new SouSouMapR(bmd,_mapData);
			_mapScrollbar = new LScrollbar(_map,800,500);
			_mapScrollbar.x = 100;
			_mapScrollbar.y = 30;
			this.addChild(_mapScrollbar);
		}
		private function loadNewMap(event:Event):void{
			var bitmapdata:BitmapData = iload.data;
			iload.die();
			iload = null;
			var i:int,j:int;
			var w:int,h:int;
			var arr:Array = [];
			_btnSave.visible = true;
			_selectIndex = -1;
			w = bitmapdata.width/24;
			h = bitmapdata.height/24;
			for(i=0;i<h;i++){
				arr[i] = [];
				for(j=0;j<w;j++){
					arr[i][j] = 0;
				}
			}
			_map = new SouSouMapR(bitmapdata,arr);
			_mapScrollbar = new LScrollbar(_map,800,500);
			_mapScrollbar.x = 100;
			_mapScrollbar.y = 30;
			this.addChild(_mapScrollbar);
		}
	}
}