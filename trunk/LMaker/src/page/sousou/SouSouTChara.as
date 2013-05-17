package page.sousou
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.xml.XMLDocument;
	
	import com.lufylegend.legend.components.LComboBox;
	import com.lufylegend.legend.components.LLabel;
	import com.lufylegend.legend.components.LTextInput;
	import com.lufylegend.legend.display.LBitmap;
	import com.lufylegend.legend.display.LScrollbar;
	import com.lufylegend.legend.display.LSprite;
	import com.lufylegend.legend.display.LURLLoader;
	import com.lufylegend.legend.events.LEvent;
	import com.lufylegend.legend.utils.LDisplay;
	import com.lufylegend.legend.utils.LGlobal;
	import com.lufylegend.legend.utils.LImage;
	
	public class SouSouTChara extends LSprite
	{
		private var x999999Bit:BitmapData = new BitmapData(100,20,false,0x999999);
		private var _urlloader:LURLLoader;
		private var _chara:Array;
		private var _charaXml:XML;
		private var _arms:Array;
		private var _armsXml:XML;
		private var _lblArms:LLabel;
		private var _skill:Array;
		private var _skillXml:XML;
		private var _lblSkill:LLabel;
		private var listSprite:LSprite;
		private var listScrollbar:LScrollbar;
		private var selectBit:LBitmap;
		private var viewSprite:LSprite;
		private var viewMenuSprite:LSprite;
		private var bitView:LBitmap;
		private var bitFace:LBitmap;
		private var bitR:LBitmap;
		private var bitS:LBitmap;
		private var bitSprite:LSprite;
		private var bitScrollbar:LScrollbar;
		private var _facelist:Array;
		private var _rlist:Array;
		private var _slist:Array;
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
			_urlloader.load(new URLRequest(Global.sousouPath+"/initialization/chara.sgj"));
		}
		private function loadTCharaOver(event:Event):void{
			//trace("event.target.data = " + event.target.data);
			_urlloader.die();
			_urlloader = null;
			_charaXml = new XML(event.target.data);
			setCharaList();
			
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
			
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadTSkillOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/initialization/Skill.sgj"));
		}
		private function loadTSkillOver(event:Event):void{
			//trace("event.target.data = " + event.target.data);
			_urlloader.die();
			_urlloader = null;
			_skillXml = new XML(event.target.data);
			setSkillList();
			
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadFaceOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/images/face.limg"));
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
			
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadROver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/images/r0.limg"));
				/**
			setCharaList();
			view(0,0);
			listScrollbar.scrollToTop();*/
		}
		private function loadROver(event:Event):void{
			_urlloader.die();
			_urlloader = null;
			var lbl:LLabel,i:int,bitmapdata:BitmapData,size:int,w:int,h:int,byte:ByteArray;
			var bytes:ByteArray = event.target.data;
			_rlist = new Array();
			//this.disposeList = _facelist;
			bytes.uncompress();
			for(i=0;i<bytes.length;i+=size){
				w = bytes.readUnsignedInt();
				h = bytes.readUnsignedInt();
				bitmapdata = new BitmapData(w,h);
				byte = new ByteArray();
				bytes.readBytes(byte,0,w*h*4);
				bitmapdata.setPixels(bitmapdata.rect,byte);
				_rlist.push(bitmapdata); 
				this.disposeList.push(bitmapdata); 
				size = w*h*4 + 8;
			}

			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadSOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/images/mov.limg"));
		}
		private function loadSOver(event:Event):void{
			_urlloader.die();
			_urlloader = null;
			var lbl:LLabel,i:int,bitmapdata:BitmapData,size:int,w:int,h:int,byte:ByteArray;
			var bytes:ByteArray = event.target.data;
			_slist = new Array();
			//this.disposeList = _facelist;
			bytes.uncompress();
			for(i=0;i<bytes.length;i+=size){
				w = bytes.readUnsignedInt();
				h = bytes.readUnsignedInt();
				bitmapdata = new BitmapData(w,h);
				byte = new ByteArray();
				bytes.readBytes(byte,0,w*h*4);
				bitmapdata.setPixels(bitmapdata.rect,byte);
				_slist.push(bitmapdata); 
				this.disposeList.push(bitmapdata); 
				size = w*h*4 + 8;
			}
			listScrollbar.scrollToTop();
			view(0,0);
		}
		public function setSkillList():void{
			var element:XML;
			_skill = new Array();
			for each(element in this._skillXml.elements()){
				_skill.push(element);
			}
		}
		public function setArmsList():void{
			var element:XML;
			_arms = new Array();
			for each(element in this._armsXml.elements()){
				_arms.push(element);
			}
		}
		public function setCharaList():void{
			var i:int;
			var bitmapdata:BitmapData;
			var size:uint;
			var w:uint;
			var h:uint;
			var lbl:LLabel,element:XML;
			var byte:ByteArray;
			if(listSprite != null)listSprite.removeFromParent();
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
			selectBit.y = _charaIndex*selectBit.height;
		}
		private function mousemovelist(event:MouseEvent):void{
			selectBit.y = int(event.currentTarget.mouseY/selectBit.height)*selectBit.height;
		}
		public function view(by:int,bindex:int):void{
			_charaIndex = bindex;
			if(viewSprite != null){
				viewSprite.removeFromParent();
				viewMenuSprite.removeFromParent();
			}
			if(!selectBit){
				selectBit = new LBitmap(x999999Bit);
				selectBit.alpha = 0.5;
			}
			selectBit.y = by;
			
			viewSprite = new LSprite(); 
			viewMenuSprite = new LSprite();
			//LDisplay.drawLine(viewSprite.graphics,[0,40,650,40]);
			LDisplay.drawRectGradient(viewSprite.graphics,[10,50,120,120],[0xffffff,0x000000]);
			viewSprite.x = 140;
			viewSprite.y = 30;
			viewMenuSprite.x = viewSprite.x;
			viewMenuSprite.y = viewSprite.y;
			this.addChild(viewSprite);
			this.addChild(viewMenuSprite);
			
			if(_charaIndex >= _chara.length){
				var xml:XML = <peo>
				  <Name>未命名</Name>
				  <Face>0</Face>
				  <R>0</R>
				  <S>0</S>
				  <Arms>0</Arms>
				  <Lv>1</Lv>
				  <Exp>0</Exp>
				  <Troops ex="兵力">100</Troops>
				  <Strategy ex="策略">10</Strategy>
				  <MaxTroops>100</MaxTroops>
				  <MaxStrategy>10</MaxStrategy>
				  <Force>50</Force>
				  <Intelligence>50</Intelligence>
				  <Command>50</Command>
				  <Agile>50</Agile>
				  <Luck>50</Luck>
				  <Introduction></Introduction>
				</peo>;
				_charaXml.appendChild(xml); 
				setCharaList();
			}
			
			//头像
			viewFace();
			//R
			viewR();
			//S
			viewS();
			//属性
			viewPro();
		}
		/**
		 *S
		 **/
		private function viewS():void{
			var index:int = _chara[_charaIndex].S;
			if(index >= _slist.length)index = 0;
			bitS = new LBitmap(new BitmapData(48,48));
			bitS.bitmapData = LImage.getBitmapDataByDraw(_slist[index],0,48*6,48,48);
			bitS.x = 270;
			bitS.y= 50;
			viewSprite.addChild(bitS);
			var selectS:LComboBox = new LComboBox(new BitmapData(80,20,false,0x999999));
			for(var i:int=0;i<_slist.length;i++){
				selectS.push("S"+(i+1),i.toString());
			}
			selectS.value = index.toString();
			selectS.x = 250;
			selectS.y= 20;
			selectS.addEventListener(LEvent.CHANGE_VALUE,sChange);
			viewMenuSprite.addChild(selectS);
		}
		private function sChange(event:LEvent):void{
			var index:int = int(event.currentTarget.value);
			bitS.bitmapData = LImage.getBitmapDataByDraw(_slist[index],0,48*6,48,48);
		}
		/**
		 *R
		 **/
		private function viewR():void{
			var index:int = _chara[_charaIndex].R;
			if(index >= _rlist.length)index = 0;
			bitR = new LBitmap(new BitmapData(64,64));
			bitR.bitmapData = LImage.getBitmapDataByDraw(_rlist[index],0,0,64,64);
			bitR.x = 150;
			bitR.y= 50;
			viewSprite.addChild(bitR);
			var selectR:LComboBox = new LComboBox(new BitmapData(80,20,false,0x999999));
			for(var i:int=0;i<_rlist.length;i++){
				selectR.push("R"+(i+1),i.toString());
			}
			selectR.value = index.toString();
			selectR.x = 140;
			selectR.y= 20;
			selectR.addEventListener(LEvent.CHANGE_VALUE,rChange);
			viewMenuSprite.addChild(selectR);
		}
		private function rChange(event:LEvent):void{
			var index:int = int(event.currentTarget.value);
			bitR.bitmapData = LImage.getBitmapDataByDraw(_rlist[index],0,0,64,64);
		}
		/**
		 *头像
		 **/
		private function viewFace():void{
			var index:int = _chara[_charaIndex].Face;
			bitFace = new LBitmap();
			bitFace.bitmapData = _facelist[index];
			bitFace.x = 10;
			bitFace.y= 50;
			viewSprite.addChild(bitFace);
			var selectFace:LComboBox = new LComboBox(new BitmapData(100,20,false,0x999999));
			for(var i:int=0;i<_facelist.length;i++){
				selectFace.push("头像"+(i+1),i.toString());
			}
			selectFace.value = index.toString();
			selectFace.x = 10;
			selectFace.y= 20;
			selectFace.addEventListener(LEvent.CHANGE_VALUE,faceChange);
			viewMenuSprite.addChild(selectFace);
		}
		private function faceChange(event:LEvent):void{
			var index:int = int(event.currentTarget.value);
			bitFace.bitmapData = _facelist[index];
		}
		private function viewPro():void{
			
			var lblx:int = 10,inputx:int = 70,lbly:int = 180,showIndex:int = 0;
			//武将名
			var lblName:LLabel = new LLabel();
			lblName.text = "武将名";
			lblName.x = lblx;
			lblName.y= lbly + showIndex * 20;
			viewSprite.addChild(lblName);
			var charaName:LTextInput = new LTextInput();
			charaName.text = _chara[_charaIndex].Name;
			charaName.x = inputx;
			charaName.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(charaName);
			//初始Hp
			var lblTroops:LLabel = new LLabel();
			lblTroops.text = "初始Hp";
			lblTroops.x = lblx;
			lblTroops.y= lbly + showIndex * 20;
			viewSprite.addChild(lblTroops);
			var charaTroops:LTextInput = new LTextInput();
			charaTroops.text = _chara[_charaIndex].Troops;
			charaTroops.x = inputx;
			charaTroops.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(charaTroops);
			//初始Mp
			var lblStrategy:LLabel = new LLabel();
			lblStrategy.text = "初始Mp";
			lblStrategy.x = lblx;
			lblStrategy.y= lbly + showIndex * 20;
			viewSprite.addChild(lblStrategy);
			var charaStrategy:LTextInput = new LTextInput();
			charaStrategy.text = _chara[_charaIndex].Strategy;
			charaStrategy.x = inputx;
			charaStrategy.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(charaStrategy);
			//武力
			var lblForce:LLabel = new LLabel();
			lblForce.text = "武力";
			lblForce.x = lblx;
			lblForce.y= lbly + showIndex * 20;
			viewSprite.addChild(lblForce);
			var charaForce:LTextInput = new LTextInput();
			charaForce.text = _chara[_charaIndex].Force;
			charaForce.x = inputx;
			charaForce.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(charaForce);
			//智力
			var lblIntelligence:LLabel = new LLabel();
			lblIntelligence.text = "智力";
			lblIntelligence.x = lblx;
			lblIntelligence.y= lbly + showIndex * 20;
			viewSprite.addChild(lblIntelligence);
			var charaIntelligence:LTextInput = new LTextInput();
			charaIntelligence.text = _chara[_charaIndex].Intelligence;
			charaIntelligence.x = inputx;
			charaIntelligence.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(charaIntelligence);
			//统帅
			var lblCommand:LLabel = new LLabel();
			lblCommand.text = "统帅";
			lblCommand.x = lblx;
			lblCommand.y= lbly + showIndex * 20;
			viewSprite.addChild(lblCommand);
			var charaCommand:LTextInput = new LTextInput();
			charaCommand.text = _chara[_charaIndex].Command;
			charaCommand.x = inputx;
			charaCommand.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(charaCommand);
			//敏捷
			var lblAgile:LLabel = new LLabel();
			lblAgile.text = "敏捷";
			lblAgile.x = lblx;
			lblAgile.y= lbly + showIndex * 20;
			viewSprite.addChild(lblAgile);
			var charaAgile:LTextInput = new LTextInput();
			charaAgile.text = _chara[_charaIndex].Agile;
			charaAgile.x = inputx;
			charaAgile.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(charaAgile);
			//运气
			var lblLuck:LLabel = new LLabel();
			lblLuck.text = "运气";
			lblLuck.x = lblx;
			lblLuck.y= lbly + showIndex * 20;
			viewSprite.addChild(lblLuck);
			var charaLuck:LTextInput = new LTextInput();
			charaLuck.text = _chara[_charaIndex].Luck;
			charaLuck.x = inputx;
			charaLuck.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(charaLuck);
			//兵种
			viewArms(lblx,inputx,lbly + (showIndex++) * 20 + 5);
			//特技
			viewSkill(lblx,inputx,lbly + (showIndex++) * 20 + 10);
			
			//武将简介
			lblx = 180,inputx = 180,lbly = 180,showIndex = 0;
			var lblIntroduction:LLabel = new LLabel();
			lblIntroduction.text = "简介";
			lblIntroduction.x = lblx;
			lblIntroduction.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(lblIntroduction);
			var charaIntroduction:LTextInput = new LTextInput();
			charaIntroduction.text = _chara[_charaIndex].Introduction;
			charaIntroduction.x = lblx;
			charaIntroduction.y= lbly + showIndex * 20;
			charaIntroduction.width = 200;
			charaIntroduction.height = 190;
			charaIntroduction.wordWrap = true;
			viewSprite.addChild(charaIntroduction);
		}
		/**
		 *兵种
		 **/
		private function viewArms(lblx:int,inputx:int,lbly:int):void{
			var index:int = _chara[_charaIndex].Arms;
			_lblArms = new LLabel();
			_lblArms.text = "兵种";
			_lblArms.x = lblx;
			_lblArms.y= lbly;
			viewSprite.addChild(_lblArms);
			var selectArms:LComboBox = new LComboBox(new BitmapData(80,20,false,0x999999));
			for(var i:int=0;i<this._arms.length;i++){
				selectArms.push(_arms[i].Name,i.toString());
			}
			selectArms.value = (index - 1).toString();
			selectArms.x = inputx;
			selectArms.y= lbly;
			viewMenuSprite.addChild(selectArms);
		}
		/**
		 *特技
		 **/
		private function viewSkill(lblx:int,inputx:int,lbly:int):void{
			var index:int;
			if(_chara[_charaIndex].Skill == null){
				index = -1;
			}else{ 
				index = _chara[_charaIndex].Skill;
			}
			_lblSkill = new LLabel();
			_lblSkill.text = "特技";
			_lblSkill.x = lblx;
			_lblSkill.y= lbly;
			viewSprite.addChild(_lblSkill);
			var selectSkill:LComboBox = new LComboBox(new BitmapData(80,20,false,0x999999));
			selectSkill.push("无","0");
			for(var i:int=0;i<this._skill.length;i++){
				selectSkill.push(_skill[i].Name,(i + 1).toString());
			}
			selectSkill.value = (index).toString();
			selectSkill.x = inputx;
			selectSkill.y= lbly;
			viewMenuSprite.addChild(selectSkill);
		}
	}
}