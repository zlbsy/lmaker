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
	
	import com.lufylegend.legend.components.LLabel;
	import com.lufylegend.legend.components.LRadio;
	import com.lufylegend.legend.components.LRadioChild;
	import com.lufylegend.legend.display.LBitmap;
	import com.lufylegend.legend.display.LButton;
	import com.lufylegend.legend.display.LSprite;
	import com.lufylegend.legend.display.LURLLoader;
	import com.lufylegend.legend.events.LEvent;
	import com.lufylegend.legend.utils.LDisplay;
	import com.lufylegend.legend.utils.LFilter;
	import com.lufylegend.legend.utils.LGlobal;

	public class SouSouMake extends LSprite
	{
		private const BTN_LABEL_SET:String = "设定游戏目录";
		private const SELECT_TEXT:String = "请选择游戏目录";
		private const STR_EMPTY:String = "";
		private const STR_COLON:String = ":";
		private const STR_ENTER:String = "\n";
		private const STR_SLASH:String = "/";
		private const STR_VER:String = "ver";
		private const STR_SOUSOUPATH:String = "sousouPath";
		private const ERROR_TITLE:String = "错误信息";
		private const FILE_GAME_INI_NAME:String = "game.ini";
		private const FILE_LMAKER_INI_NAME:String = "LMaker.ini";
		private const DEFAULT_LMAKER_INI_MSG:String = "appPath:\nsousouPath:\nslgPath:\nrpgPath:\nmmrpgPath:";
		
		
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
			_btnSetPath = LGlobal.getModelButton(0,[0,0,100,20,BTN_LABEL_SET,15,0xff0000]);
			_btnSetPath.x = LGlobal.stage.stageWidth - _btnSetPath.width - 10;
			_btnSetPath.y = 3;
			_barSprite.addChild(_btnSetPath);
			_btnSetPath.addEventListener(MouseEvent.MOUSE_UP,toSelectPath);
		}
		private function toSelectPath(event:MouseEvent):void{
			_file = new File();
			
			_file.browseForDirectory(SELECT_TEXT);
			_file.addEventListener(Event.SELECT,onSingleSelect); 
		}
		private function loadIni():void{
			if(!Global.existsApp(STR_EMPTY,FILE_LMAKER_INI_NAME))Global.saveAppData(STR_EMPTY,FILE_LMAKER_INI_NAME,DEFAULT_LMAKER_INI_MSG);
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadIniOver);
			_urlloader.load(new URLRequest(FILE_LMAKER_INI_NAME));
		}
		private function loadIniOver(event:Event):void{
			var data:String = event.target.data;
			var i:int,index:int,pathArr:Array;
			_urlloader.die();
			_urlloader = null;
			_iniArray = data.split(STR_ENTER);
			for(i=0;i<_iniArray.length;i++){
				pathArr = (_iniArray[i] as String).split(STR_COLON);
				if(pathArr[0] == STR_SOUSOUPATH){
					index = (_iniArray[i] as String).indexOf(STR_COLON);
					this._sousouPath = (_iniArray[i] as String).substring(index + 1);
					Global.sousouPath = this._sousouPath;
					_lblPath.htmlText = "<font size='20'><b>" + Global.sousouPath + "</b></font>";
					break;
				}
			}
			if(_sousouPath && _sousouPath.length > 0 && Global.isDirectory(_sousouPath)){
				initSouSou();
			}
		}
		private function onSingleSelect(event:Event):void{
			_filePath = (event.target as File).nativePath.toString();
			var msg:String,pathArr:Array,i:int;
			for(i=0;i<_iniArray.length;i++){
				pathArr = (_iniArray[i] as String).split(STR_COLON);
				if(pathArr[0] == STR_SOUSOUPATH){
					_iniArray[i] = STR_SOUSOUPATH + STR_COLON + _filePath;
					break;
				}
			}
			trace(STR_EMPTY,FILE_LMAKER_INI_NAME,_iniArray.join(STR_ENTER));
			Global.saveAppData(STR_EMPTY,FILE_LMAKER_INI_NAME,_iniArray.join(STR_ENTER));
			initSouSou();
		}
		private function initSouSou():void{
			trace(this._sousouPath,FILE_GAME_INI_NAME);
			if(!Global.exists(this._sousouPath,FILE_GAME_INI_NAME)){
				Global.showMsg(ERROR_TITLE,"路径不正确，或游戏版本不正确。\n请重新设置正确的游戏路径。");
				return;
			}
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadGameIniOver);
			_urlloader.load(new URLRequest(this._sousouPath + STR_SLASH + FILE_GAME_INI_NAME));
		}
		private function loadGameIniOver(event:Event):void{
			var data:String = event.target.data;
			_urlloader.die();
			_urlloader = null;
			var i:int,index:int,pathArr:Array,ver:Number;
			_iniArray = data.split(STR_ENTER);
			for(i=0;i<_iniArray.length;i++){
				pathArr = (_iniArray[i] as String).split(STR_COLON);
				if(pathArr[0] == STR_VER){
					index = (_iniArray[i] as String).indexOf(STR_COLON);
					ver = Number((_iniArray[i] as String).substring(index + 1));
					break;
				}
			}
			
			if(ver < 0.2){
				Global.showMsg(ERROR_TITLE,"LMaker不支持该游戏版本"+ver+"。\n请重新设置正确的游戏路径。");
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
			_radio.push(getRadioChild("法术图片","strategy_img2"));
			_radio.push(getRadioChild("装备图片","item_img2"));
			_radio.push(getRadioChild("系统图片","img_img2"));
			_radio.push(getRadioChild("R地图","rmap"));
			_radio.push(getRadioChild("S地图","smap"));
			_radio.push(getRadioChild("人物数据","t_chara"));
			_radio.push(getRadioChild("兵种数据","t_arms"));
			_radio.push(getRadioChild("装备数据","t_item"));
			_radio.push(getRadioChild("物品数据","t_props"));
			/**_radio.push(getRadioChild("特技数据","t_skill"));
			_radio.push(getRadioChild("法术数据","t_strategy"));*/
			_radio.push(getRadioChild("地形数据","t_terrain"));
			_radio.push(getRadioChild("R剧本","r_juben"));
			_radio.push(getRadioChild("S剧本","s_juben"));
			_radio.addEventListener(LEvent.CHANGE_VALUE,onRadioChange);
			_radio.value = "item_img2";
			
			this.addChild(_radio);
		}
		private function onRadioChange(event:LEvent):void{
			_ctrlSprite.die();
			switch(_radio.value){
				case "item_img2":
					LDisplay.drawRectGradient(_ctrlSprite.graphics,[0,0,LGlobal.stage.stageWidth - _ctrlSprite.x,LGlobal.stage.stageHeight - Global.lmaker.title.height - _barSprite.height],[0xcccccc,0x999999]);
					var sousouItemImg2:SouSouItemImg2 = new SouSouItemImg2();
					sousouItemImg2.x = 10;
					sousouItemImg2.y = 10;
					_ctrlSprite.addChild(sousouItemImg2);
					break;
				case "strategy_img2":
					LDisplay.drawRectGradient(_ctrlSprite.graphics,[0,0,LGlobal.stage.stageWidth - _ctrlSprite.x,LGlobal.stage.stageHeight - Global.lmaker.title.height - _barSprite.height],[0xcccccc,0x999999]);
					var sousouStrategyImg2:SouSouStrategyImg2 = new SouSouStrategyImg2();
					sousouStrategyImg2.x = 10;
					sousouStrategyImg2.y = 10;
					_ctrlSprite.addChild(sousouStrategyImg2);
					break;
				case "t_props":
					LDisplay.drawRectGradient(_ctrlSprite.graphics,[0,0,LGlobal.stage.stageWidth - _ctrlSprite.x,LGlobal.stage.stageHeight - Global.lmaker.title.height - _barSprite.height],[0xcccccc,0x999999]);
					var sousouProps:SouSouTProps = new SouSouTProps();
					sousouProps.x = 10;
					sousouProps.y = 10;
					_ctrlSprite.addChild(sousouProps);
					break;
				case "t_item":
					LDisplay.drawRectGradient(_ctrlSprite.graphics,[0,0,LGlobal.stage.stageWidth - _ctrlSprite.x,LGlobal.stage.stageHeight - Global.lmaker.title.height - _barSprite.height],[0xcccccc,0x999999]);
					var sousouItem:SouSouTItem = new SouSouTItem();
					sousouItem.x = 10;
					sousouItem.y = 10;
					_ctrlSprite.addChild(sousouItem);
					break;
				case "face":
					LDisplay.drawRectGradient(_ctrlSprite.graphics,[0,0,LGlobal.stage.stageWidth - _ctrlSprite.x,LGlobal.stage.stageHeight - Global.lmaker.title.height - _barSprite.height],[0xcccccc,0x999999]);
					var sousouFace:SouSouFace = new SouSouFace();
					sousouFace.x = 10;
					sousouFace.y = 10;
					_ctrlSprite.addChild(sousouFace);
					break;
				case "rimg":
					LDisplay.drawRectGradient(_ctrlSprite.graphics,[0,0,LGlobal.stage.stageWidth - _ctrlSprite.x,LGlobal.stage.stageHeight - Global.lmaker.title.height - _barSprite.height],[0xcccccc,0x999999]);
					var sousouRimg:SouSouRImg = new SouSouRImg(_bytesList);
					sousouRimg.x = 10;
					sousouRimg.y = 10;
					_ctrlSprite.addChild(sousouRimg);
					break;
				case "simg":
					LDisplay.drawRectGradient(_ctrlSprite.graphics,[0,0,LGlobal.stage.stageWidth - _ctrlSprite.x,LGlobal.stage.stageHeight - Global.lmaker.title.height - _barSprite.height],[0xcccccc,0x999999]);
					var sousouSimg:SouSouSImg = new SouSouSImg(_bytesList);
					sousouSimg.x = 10;
					sousouSimg.y = 10;
					_ctrlSprite.addChild(sousouSimg);
					break;
				case "rmap":
					LDisplay.drawRectGradient(_ctrlSprite.graphics,[0,0,LGlobal.stage.stageWidth - _ctrlSprite.x,LGlobal.stage.stageHeight - Global.lmaker.title.height - _barSprite.height],[0xcccccc,0x999999]);
					var sousouRMap:SouSouRMap = new SouSouRMap();
					sousouRMap.x = 10;
					sousouRMap.y = 10;
					_ctrlSprite.addChild(sousouRMap);
					break;
				case "smap":
					LDisplay.drawRectGradient(_ctrlSprite.graphics,[0,0,LGlobal.stage.stageWidth - _ctrlSprite.x,LGlobal.stage.stageHeight - Global.lmaker.title.height - _barSprite.height],[0xcccccc,0x999999]);
					var sousouSMap:SouSouSMap = new SouSouSMap();
					sousouSMap.x = 10;
					sousouSMap.y = 10;
					_ctrlSprite.addChild(sousouSMap);
					break;
				case "t_chara":
					LDisplay.drawRectGradient(_ctrlSprite.graphics,[0,0,LGlobal.stage.stageWidth - _ctrlSprite.x,LGlobal.stage.stageHeight - Global.lmaker.title.height - _barSprite.height],[0xcccccc,0x999999]);
					var sousouTChara:SouSouTChara = new SouSouTChara();
					sousouTChara.x = 10;
					sousouTChara.y = 10;
					_ctrlSprite.addChild(sousouTChara);
					break;
				case "t_arms":
					LDisplay.drawRectGradient(_ctrlSprite.graphics,[0,0,LGlobal.stage.stageWidth - _ctrlSprite.x,LGlobal.stage.stageHeight - Global.lmaker.title.height - _barSprite.height],[0xcccccc,0x999999]);
					var sousouTArms:SouSouTArms = new SouSouTArms();
					sousouTArms.x = 10;
					sousouTArms.y = 10;
					_ctrlSprite.addChild(sousouTArms);
					break;
					break;
			}
		}
	}
}