package page.sousou
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.components.LRadio;
	import zhanglubin.legend.components.LRadioChild;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.display.LURLLoader;
	import zhanglubin.legend.events.LEvent;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LFilter;
	import zhanglubin.legend.utils.LGlobal;

	public class SouSouMake extends LSprite
	{
		private var _barSprite:LSprite;
		private var _ctrlSprite:LSprite;
		private var _file:File;
		private var _filePath:String;
		private var _urlloader:LURLLoader;
		private var _iniArray:Array;
		private var _sousouPath:String;
		private var _btnSetPath:LButton;
		private var _radioIndex:int;
		private var _radio:LRadio;
		private var _lblPath:LLabel;
		private var _bytesList:Array;
		public function SouSouMake()
		{
			addBar();
			loadIni();
		}
		private function addBar():void{
			_ctrlSprite = new LSprite();
			_ctrlSprite.x = 80;
			this.addChild(_ctrlSprite);
			_barSprite = new LSprite();
			LDisplay.drawRectGradient(_barSprite.graphics,[0,0,LGlobal.stage.stageWidth,30],[0xcccccc,0x0000ff]);
			_barSprite.y = LGlobal.stage.stageHeight - Global.lmaker.title.height - _barSprite.height;
			this.addChild(_barSprite);
			
			_lblPath = new LLabel();
			_lblPath.x = 10;
			_lblPath.y = 3;
			_barSprite.addChild(_lblPath);
			_btnSetPath = LGlobal.getModelButton(0,[0,0,100,20,"设定游戏目录",15,0xff0000]);
			_btnSetPath.x = LGlobal.stage.stageWidth - _btnSetPath.width - 10;
			_btnSetPath.y = 3;
			_barSprite.addChild(_btnSetPath);
			_btnSetPath.addEventListener(MouseEvent.MOUSE_UP,toSelectPath);
		}
		private function toSelectPath(event:MouseEvent):void{
			_file = new File();
			
			_file.browseForDirectory("请选择游戏目录");
			_file.addEventListener(Event.SELECT,onSingleSelect); 
		}
		private function loadIni():void{
			if(!Global.existsApp("","LMaker.ini"))Global.saveAppData("","LMaker.ini","appPath:\nsousouPath:\nslgPath:\nrpgPath:\nmmrpgPath:");
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadIniOver);
			_urlloader.load(new URLRequest("LMaker.ini"));
		}
		private function loadIniOver(event:Event):void{
			var data:String = event.target.data;
			var i:int,index:int,pathArr:Array;
			_urlloader.die();
			_urlloader = null;
			_iniArray = data.split("\n");
			for(i=0;i<_iniArray.length;i++){
				pathArr = (_iniArray[i] as String).split(":");
				if(pathArr[0] == "sousouPath"){
					index = (_iniArray[i] as String).indexOf(":");
					this._sousouPath = (_iniArray[i] as String).substring(index + 1);
					Global.sousouPath = this._sousouPath;
					_lblPath.htmlText = "<font size='20'><b>" + Global.sousouPath + "</b></font>";
					break;
				}
			}
			if(_sousouPath.length > 0 && Global.isDirectory(_sousouPath)){
				initSouSou();
			}
		}
		private function onSingleSelect(event:Event):void{
			_filePath = (event.target as File).nativePath.toString();
			var msg:String,pathArr:Array,i:int;
			for(i=0;i<_iniArray.length;i++){
				pathArr = (_iniArray[i] as String).split(":");
				if(pathArr[0] == "sousouPath"){
					_iniArray[i] = "sousouPath:"+_filePath;
					break;
				}
			}
			Global.saveAppData("","LMaker.ini",_iniArray.join("\n"));
			initSouSou();
		}
		private function initSouSou():void{
			if(!Global.exists(this._sousouPath,"game.ini")){
				Global.showMsg("错误信息","路径不正确，或者游戏版本不正确。\n请重新设置正确的游戏路径。");
				return;
			}
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadGameIniOver);
			_urlloader.load(new URLRequest(this._sousouPath+"/game.ini"));
		}
		private function loadGameIniOver(event:Event):void{
			var data:String = event.target.data;
			_urlloader.die();
			_urlloader = null;
			var i:int,index:int,pathArr:Array,ver:Number;
			_iniArray = data.split("\n");
			for(i=0;i<_iniArray.length;i++){
				pathArr = (_iniArray[i] as String).split(":");
				if(pathArr[0] == "ver"){
					index = (_iniArray[i] as String).indexOf(":");
					ver = Number((_iniArray[i] as String).substring(index + 1));
					break;
				}
			}
			
			if(ver < 0.2){
				Global.showMsg("错误信息","LMaker不支持该游戏版本"+ver+"。\n请重新设置正确的游戏路径。");
				return;
			}
			addRadioButton();
		}
		private function getRadioChild(label:String,value:String):LRadioChild{
			var radioChild:LRadioChild;
			var btn:LButton,bit:LBitmap;
			btn = LGlobal.getModelButton(0,[0,0,80,20,label,15,0xff0000]);
			bit = new LBitmap(LDisplay.displayToBitmap(btn));
			LFilter.setFilter(bit,LFilter.GRAY);
			radioChild = new LRadioChild(value,bit,btn);
			radioChild.y = (_radioIndex++)*20;
			return radioChild;
		}
		private function addRadioButton():void{
			_radio = new LRadio();
			_radio.push(getRadioChild("头像","face"));
			_radio.push(getRadioChild("R形象","rimg"));
			_radio.push(getRadioChild("S形象","simg"));
			_radio.push(getRadioChild("人物数据","t_chara"));
			_radio.push(getRadioChild("兵种数据","t_arms"));
			_radio.push(getRadioChild("装备数据","t_item"));
			_radio.push(getRadioChild("物品数据","t_props"));
			_radio.push(getRadioChild("特技数据","t_skill"));
			_radio.push(getRadioChild("法术数据","t_strategy"));
			_radio.push(getRadioChild("地形数据","t_terrain"));
			_radio.push(getRadioChild("R地图","rmap"));
			_radio.push(getRadioChild("S地图","smap"));
			_radio.push(getRadioChild("R剧本","r_juben"));
			_radio.push(getRadioChild("S剧本","s_juben"));
			_radio.addEventListener(LEvent.RADIO_VALUE_CHANGE,onRadioChange);
			_radio.value = "face";
			
			this.addChild(_radio);
		}
		private function onRadioChange(event:LEvent):void{
			_ctrlSprite.die();
			switch(_radio.value){
				case "face":
					LDisplay.drawRectGradient(_ctrlSprite.graphics,[0,0,LGlobal.stage.stageWidth - _ctrlSprite.x,LGlobal.stage.stageHeight - Global.lmaker.title.height - _barSprite.height],[0xcccccc,0x999999]);
					_urlloader = new LURLLoader();
					_urlloader.addEventListener(Event.COMPLETE,loadFaceOver);
					_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
					_urlloader.load(new URLRequest(_sousouPath+"/images/face.limg"))
					break;
				case "rimg":
					LDisplay.drawRectGradient(_ctrlSprite.graphics,[0,0,LGlobal.stage.stageWidth - _ctrlSprite.x,LGlobal.stage.stageHeight - Global.lmaker.title.height - _barSprite.height],[0xcccccc,0x999999]);
					_urlloader = new LURLLoader();
					_urlloader.addEventListener(Event.COMPLETE,loadR0Over);
					_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
					_urlloader.load(new URLRequest(_sousouPath+"/images/r0.limg"))
					break;
				case "simg":
					LDisplay.drawRectGradient(_ctrlSprite.graphics,[0,0,LGlobal.stage.stageWidth - _ctrlSprite.x,LGlobal.stage.stageHeight - Global.lmaker.title.height - _barSprite.height],[0xcccccc,0x999999]);
					_urlloader = new LURLLoader();
					_urlloader.addEventListener(Event.COMPLETE,loadAtkOver);
					_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
					_urlloader.load(new URLRequest(_sousouPath+"/images/atk.limg"))
					break;
			}
		}
		private function loadFaceOver(event:Event):void{
			_urlloader.die();
			var sousouFace:SouSouFace = new SouSouFace(event.target.data);
			sousouFace.x = 10;
			sousouFace.y = 10;
			_ctrlSprite.addChild(sousouFace);
		}
		private function loadR0Over(event:Event):void{
			_bytesList = new Array();
			_bytesList.push(event.target.data);
			_urlloader.die();
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadR1Over);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(_sousouPath+"/images/r1.limg"))
		}
		private function loadR1Over(event:Event):void{
			_bytesList.push(event.target.data);
			_urlloader.die();
			var sousouRimg:SouSouRImg = new SouSouRImg(_bytesList);
			sousouRimg.x = 10;
			sousouRimg.y = 10;
			_ctrlSprite.addChild(sousouRimg);
			_bytesList = null;
		}
		private function loadAtkOver(event:Event):void{
			_bytesList = new Array();
			_bytesList.push(event.target.data);
			_urlloader.die();
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadMovOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(_sousouPath+"/images/mov.limg"))
		}
		private function loadMovOver(event:Event):void{
			_bytesList.push(event.target.data);
			_urlloader.die();
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadSpcOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(_sousouPath+"/images/spc.limg"))
		}
		private function loadSpcOver(event:Event):void{
			_bytesList.push(event.target.data);
			_urlloader.die();
			var sousouSimg:SouSouSImg = new SouSouSImg(_bytesList);
			sousouSimg.x = 10;
			sousouSimg.y = 10;
			_ctrlSprite.addChild(sousouSimg);
			_bytesList = null;
		}
	}
}