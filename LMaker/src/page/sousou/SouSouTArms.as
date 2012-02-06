package page.sousou
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import zhanglubin.legend.components.LComboBox;
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.components.LRadio;
	import zhanglubin.legend.components.LRadioChild;
	import zhanglubin.legend.components.LTextInput;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LScrollbar;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.display.LURLLoader;
	import zhanglubin.legend.events.LEvent;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LFilter;
	import zhanglubin.legend.utils.LGlobal;
	
	public class SouSouTArms extends LSprite
	{
		private var x999999Bit:BitmapData = new BitmapData(100,20,false,0x999999);
		private var _urlloader:LURLLoader;
		private var _arms:Array;
		private var _armsXml:XML;
		private var _terrain:Array;
		private var _terrainXml:XML;
		private var _strategy:Array;
		private var _strategyXml:XML;
		private var listSprite:LSprite;
		private var listScrollbar:LScrollbar;
		private var scrollLayer:LScrollbar;
		private var rangeSprite:LSprite;
		private var selectBit:LBitmap;
		private var _armsIndex:int;
		private var viewSprite:LSprite;
		private var viewMenuSprite:LSprite;
		private var rangeArray:Array;
		public function SouSouTArms()
		{
			super();
			LDisplay.drawRectGradient(this.graphics,[0,20,800,500],[0xffffff,0x8A98F4]);
			LDisplay.drawRect(this.graphics,[0,20,800,500],false,0x000000);
			LDisplay.drawRect(this.graphics,[10,30,124,484],false,0x000000);
			LDisplay.drawRect(this.graphics,[140,30,650,484],false,0x000000);
			
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadTStrategyOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath + "/initialization/Strategy.sgj"));
		}
		private function loadTStrategyOver(event:Event):void{
			_urlloader.die();
			_urlloader = null;
			_strategyXml = new XML(event.target.data);
			_strategy = new Array();
			var element:XML;
			for each(element in this._strategyXml.elements())_strategy.push(element);
			
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadTTerrainOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath + "/initialization/Terrain.sgj"));
		}
		private function loadTTerrainOver(event:Event):void{
			_urlloader.die();
			_urlloader = null;
			_terrainXml = new XML(event.target.data);
			_terrain = new Array();
			var element:XML;
			for each(element in this._terrainXml.elements())_terrain.push(element);
			
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadTArmsOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/initialization/Arms.sgj"));
		}
		private function loadTArmsOver(event:Event):void{
			_urlloader.die();
			_urlloader = null;
			_armsXml = new XML(event.target.data);
			setArmsList();
			view(0,0);
			listScrollbar.scrollToTop();
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
			_armsIndex = bindex;
			trace( _arms[_armsIndex]);
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
			viewSprite.x = 140;
			viewSprite.y = 30;
			viewMenuSprite.x = viewSprite.x;
			viewMenuSprite.y = viewSprite.y;
			this.addChild(viewSprite);
			this.addChild(viewMenuSprite);
			LDisplay.drawRectGradient(viewSprite.graphics,[450,30,130,130],[0xcccccc,0x333333]);
			
			if(_armsIndex >= _arms.length){
				var xml:XML = <Arms>
  <Name ex="兵种名">新增兵种</Name>
  <Arms_type ex="0武将1军师2全能">0</Arms_type>
  <MoveType ex="0骑兵1步兵">0</MoveType>
  <Property ex="兵种属性">
    <Attack ex="攻击">B</Attack>
    <Spirit ex="策略">B</Spirit>
    <Defense ex="防御">B</Defense>
    <Breakout ex="暴发">B</Breakout>
    <Morale ex="士气">B</Morale>
    <Troops ex="Troops">5</Troops>
    <Strategy ex="Strategy">1</Strategy>
  </Property>
  <Distance ex="移动力">5</Distance>
  <Helmet ex="头盔">0</Helmet>
  <Equipment ex="防具(0:铠甲1:衣服)">0</Equipment>
  <Weapon ex="武器(0:剑类1:枪类2:策略剑类3弓箭类)">1</Weapon>
  <Horse ex="坐骑(0:马1:鞋)">0</Horse>
  <AttackLong>1</AttackLong>
  <Restrain ex="兵种相克">
    <list10>110</list10>
    <list13>90</list13>
  </Restrain>
  <Terrain ex="地形属性">
    <Terrain0 Addition="110">1</Terrain0>
    <Terrain1 Addition="110">1</Terrain1>
    <Terrain2 Addition="80">2</Terrain2>
    <Terrain3 Addition="100">100</Terrain3>
    <Terrain4 Addition="100">100</Terrain4>
    <Terrain5 Addition="120">1</Terrain5>
    <Terrain6 Addition="100">1</Terrain6>
    <Terrain7 Addition="110">1</Terrain7>
    <Terrain8 Addition="80">3</Terrain8>
    <Terrain9 Addition="100">1</Terrain9>
    <Terrain10 Addition="100">100</Terrain10>
    <Terrain11 Addition="100">100</Terrain11>
    <Terrain12 Addition="100">1</Terrain12>
    <Terrain13 Addition="80">2</Terrain13>
  </Terrain>
  <RangeAttack ex="攻击距离">
    <List>0,-1</List>
    <List>0,1</List>
    <List>-1,0</List>
    <List>1,0</List>
  </RangeAttack>
  <RangeAttackTarget ex="攻击范围">
    <List>0,0</List>
  </RangeAttackTarget>
  <Strategy ex="策略"/>
  <Introduction ex="兵种介绍">骑兵系的初级兵种，攻击很强，但是防御一般。</Introduction>
</Arms>;
				_armsXml.appendChild(xml); 
				setArmsList();
			}
			
			var i:int;
			var lblx:int = 10,inputx:int = 70,lbly:int = 10,showIndex:int = 0;
			//兵种名
			var lblName:LLabel = new LLabel();
			lblName.text = "兵种名";
			lblName.x = lblx;
			lblName.y= lbly + showIndex * 20;
			viewSprite.addChild(lblName);
			var armsName:LTextInput = new LTextInput();
			armsName.text = _arms[_armsIndex].Name;
			armsName.x = inputx;
			armsName.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(armsName);
			
			lbly = 35,showIndex=0;
			var lblArmsType:LLabel = new LLabel();
			lblArmsType.text = "兵种类型";
			lblArmsType.x = lblx;
			lblArmsType.y= lbly + showIndex * 20;
			viewSprite.addChild(lblArmsType);
			var selectArmsType:LComboBox = new LComboBox(new BitmapData(80,20,false,0x999999));
			selectArmsType.push("武将","0");
			selectArmsType.push("军师","1");
			selectArmsType.push("全能","2");
			selectArmsType.value = _arms[_armsIndex].Arms_type;
			selectArmsType.x = inputx;
			selectArmsType.y= lbly + (showIndex++) * 20;
			viewMenuSprite.addChild(selectArmsType);
			
			lbly = 60,showIndex=0;
			var lblMoveType:LLabel = new LLabel();
			lblMoveType.text = "移动类型";
			lblMoveType.x = lblx;
			lblMoveType.y= lbly + showIndex * 20;
			viewSprite.addChild(lblMoveType);
			var selectMoveType:LComboBox = new LComboBox(new BitmapData(80,20,false,0x999999));
			selectMoveType.push("骑兵","0");
			selectMoveType.push("步兵","1");
			selectMoveType.value = _arms[_armsIndex].MoveType;
			selectMoveType.x = inputx;
			selectMoveType.y= lbly + (showIndex++) * 20;
			viewMenuSprite.addChild(selectMoveType);
			
			//攻击
			lbly = 85,showIndex=0;
			var lblAttack:LLabel = new LLabel();
			lblAttack.text = "攻击";
			lblAttack.x = lblx;
			lblAttack.y= lbly + showIndex * 20;
			viewSprite.addChild(lblAttack);
			var selectAttack:LComboBox = new LComboBox(new BitmapData(80,20,false,0x999999));
			selectAttack.push("S","S");
			selectAttack.push("A","A");
			selectAttack.push("B","B");
			selectAttack.push("C","C");
			selectAttack.value = _arms[_armsIndex].Property.Attack;
			selectAttack.x = inputx;
			selectAttack.y= lbly + (showIndex++) * 20;
			viewMenuSprite.addChild(selectAttack);
			
			//策略
			lbly = 110,showIndex=0;
			var lblSpirit:LLabel = new LLabel();
			lblSpirit.text = "策略";
			lblSpirit.x = lblx;
			lblSpirit.y= lbly + showIndex * 20;
			viewSprite.addChild(lblSpirit);
			var selectSpirit:LComboBox = new LComboBox(new BitmapData(80,20,false,0x999999));
			selectSpirit.push("S","S");
			selectSpirit.push("A","A");
			selectSpirit.push("B","B");
			selectSpirit.push("C","C");
			selectSpirit.value = _arms[_armsIndex].Property.Spirit;
			selectSpirit.x = inputx;
			selectSpirit.y= lbly + (showIndex++) * 20;
			viewMenuSprite.addChild(selectSpirit);
			
			//防御
			lbly = 135,showIndex=0;
			var lblDefense:LLabel = new LLabel();
			lblDefense.text = "防御";
			lblDefense.x = lblx;
			lblDefense.y= lbly + showIndex * 20;
			viewSprite.addChild(lblDefense);
			var selectDefense:LComboBox = new LComboBox(new BitmapData(80,20,false,0x999999));
			selectDefense.push("S","S");
			selectDefense.push("A","A");
			selectDefense.push("B","B");
			selectDefense.push("C","C");
			selectDefense.value = _arms[_armsIndex].Property.Defense;
			selectDefense.x = inputx;
			selectDefense.y= lbly + (showIndex++) * 20;
			viewMenuSprite.addChild(selectDefense);
			
			//暴发
			lbly = 160,showIndex=0;
			var lblBreakout:LLabel = new LLabel();
			lblBreakout.text = "暴发";
			lblBreakout.x = lblx;
			lblBreakout.y= lbly + showIndex * 20;
			viewSprite.addChild(lblBreakout);
			var selectBreakout:LComboBox = new LComboBox(new BitmapData(80,20,false,0x999999));
			selectBreakout.push("S","S");
			selectBreakout.push("A","A");
			selectBreakout.push("B","B");
			selectBreakout.push("C","C");
			selectBreakout.value = _arms[_armsIndex].Property.Breakout;
			selectBreakout.x = inputx;
			selectBreakout.y= lbly + (showIndex++) * 20;
			viewMenuSprite.addChild(selectBreakout);
			
			//士气
			lbly = 185,showIndex=0;
			var lblMorale:LLabel = new LLabel();
			lblMorale.text = "士气";
			lblMorale.x = lblx;
			lblMorale.y= lbly + showIndex * 20;
			viewSprite.addChild(lblMorale);
			var selectMorale:LComboBox = new LComboBox(new BitmapData(80,20,false,0x999999));
			selectMorale.push("S","S");
			selectMorale.push("A","A");
			selectMorale.push("B","B");
			selectMorale.push("C","C");
			selectMorale.value = _arms[_armsIndex].Property.Morale;
			selectMorale.x = inputx;
			selectMorale.y= lbly + (showIndex++) * 20;
			viewMenuSprite.addChild(selectMorale);
			
			//HP成长
			lbly = 210,showIndex=0;
			var lblTroops:LLabel = new LLabel();
			lblTroops.text = "HP成长";
			lblTroops.x = lblx;
			lblTroops.y= lbly + showIndex * 20;
			viewSprite.addChild(lblTroops);
			var inputTroops:LTextInput = new LTextInput();
			inputTroops.text = _arms[_armsIndex].Property.Troops;
			inputTroops.x = inputx;
			inputTroops.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(inputTroops);
			
			//MP成长
			var lblStrategy:LLabel = new LLabel();
			lblStrategy.text = "MP成长";
			lblStrategy.x = lblx;
			lblStrategy.y= lbly + showIndex * 20;
			viewSprite.addChild(lblStrategy);
			var inputStrategy:LTextInput = new LTextInput();
			inputStrategy.text = _arms[_armsIndex].Property.Strategy;
			inputStrategy.x = inputx;
			inputStrategy.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(inputStrategy);
			
			//移动力
			var lblDistance:LLabel = new LLabel();
			lblDistance.text = "移动力";
			lblDistance.x = lblx;
			lblDistance.y= lbly + showIndex * 20;
			viewSprite.addChild(lblDistance);
			var inputDistance:LTextInput = new LTextInput();
			inputDistance.text = _arms[_armsIndex].Distance;
			inputDistance.x = inputx;
			inputDistance.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(inputDistance);
			
			//防具类型
			lbly = 275,showIndex=0;
			var lblEquipment:LLabel = new LLabel();
			lblEquipment.text = "防具类型";
			lblEquipment.x = lblx;
			lblEquipment.y= lbly + showIndex * 20;
			viewSprite.addChild(lblEquipment);
			var selectEquipment:LComboBox = new LComboBox(new BitmapData(80,20,false,0x999999));
			selectEquipment.push("铠甲","0");
			selectEquipment.push("衣服","1");
			selectEquipment.value = _arms[_armsIndex].Equipment;
			selectEquipment.x = inputx;
			selectEquipment.y= lbly + (showIndex++) * 20;
			viewMenuSprite.addChild(selectEquipment);
			
			//武器类型
			lbly = 300,showIndex=0;
			var lblWeapon:LLabel = new LLabel();
			lblWeapon.text = "武器类型";
			lblWeapon.x = lblx;
			lblWeapon.y= lbly + showIndex * 20;
			viewSprite.addChild(lblWeapon);
			var selectWeapon:LComboBox = new LComboBox(new BitmapData(80,20,false,0x999999));
			selectWeapon.push("剑类","0");
			selectWeapon.push("枪类","1");
			selectWeapon.push("策略剑类","2");
			selectWeapon.push("弓箭类","3");
			selectWeapon.value = _arms[_armsIndex].Weapon;
			selectWeapon.x = inputx;
			selectWeapon.y= lbly + (showIndex++) * 20;
			viewMenuSprite.addChild(selectWeapon);
			
			//坐骑类型
			lbly = 325,showIndex=0;
			var lblHorse:LLabel = new LLabel();
			lblHorse.text = "坐骑类型";
			lblHorse.x = lblx;
			lblHorse.y= lbly + showIndex * 20;
			viewSprite.addChild(lblHorse);
			var selectHorse:LComboBox = new LComboBox(new BitmapData(80,20,false,0x999999));
			selectHorse.push("马","0");
			selectHorse.push("鞋","1");
			selectHorse.value = _arms[_armsIndex].Horse;
			selectHorse.x = inputx;
			selectHorse.y= lbly + (showIndex++) * 20;
			viewMenuSprite.addChild(selectHorse);
			
			//转职兵种
			lbly = 350,showIndex=0;
			var lblTo:LLabel = new LLabel();
			lblTo.text = "转职兵种";
			lblTo.x = lblx;
			lblTo.y= lbly + showIndex * 20;
			viewSprite.addChild(lblTo);
			var selectTo:LComboBox = new LComboBox(new BitmapData(80,20,false,0x999999));
			selectTo.push("无","");
			for(i=0;i<_arms.length;i++){
				if(_armsIndex == i)continue;
				selectTo.push(_arms[i].Name,i.toString());
			}
			selectTo.value = _arms[_armsIndex].To;
			selectTo.x = inputx;
			selectTo.y= lbly + (showIndex++) * 20;
			viewMenuSprite.addChild(selectTo);
			
			//兵种介绍
			var lblIntroduction:LLabel = new LLabel();
			lblIntroduction.text = "兵种介绍";
			lblIntroduction.x = 450;
			lblIntroduction.y= 180;
			viewSprite.addChild(lblIntroduction);
			var inputIntroduction:LTextInput = new LTextInput();
			inputIntroduction.text = _arms[_armsIndex].Introduction;
			inputIntroduction.x = 450;
			inputIntroduction.y= 200;
			inputIntroduction.width = 180;
			inputIntroduction.height = 140;
			inputIntroduction.wordWrap = true;
			viewSprite.addChild(inputIntroduction);
			
			//兵种相克&地形适应
			lblx = 190,inputx = 270,lbly = 10,showIndex = 0;
			var radioRestrain:LRadio = new LRadio();
			radioRestrain.push(getRadioChild("兵种相克","restrain",0,lbly + showIndex * 20));
			radioRestrain.push(getRadioChild("地形适应","terrain",78,lbly + showIndex * 20));
			radioRestrain.push(getRadioChild("策略习得","strategy",156,lbly + showIndex * 20));
			radioRestrain.value = "restrain";
			radioRestrain.x = lblx;
			viewSprite.addChild(radioRestrain);
			radioRestrain.addEventListener(LEvent.CHANGE_VALUE,changeValue);
			setScrollRestrain();
			
			//攻击范围，攻击目标scrollRange
			lblx = 450,inputx = 270,lbly = 10,showIndex = 0;
			var radioRange:LRadio = new LRadio();
			radioRange.push(getRadioChild("攻击范围","attack",0,lbly + showIndex * 20,0xff0000));
			radioRange.push(getRadioChild("攻击目标","target",78,lbly + showIndex * 20,0xff0000));
			radioRange.value = "attack";
			radioRange.x = lblx;
			viewSprite.addChild(radioRange);
			radioRange.addEventListener(LEvent.CHANGE_VALUE,changeRangeValue);
			setAttackRange();
			
		}
		private function setAttackRange():void{
			if(rangeSprite != null)rangeSprite.removeFromParent();
			rangeSprite = new LSprite();
			rangeSprite.x = 450;
			rangeSprite.y = 30;
			var i:int,j:int,mx:int,my:int;
			var element:XML,elementArr:Array;
			rangeArray = [
			[0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0]
			];
			mx = int(rangeArray[0].length / 2);
			my = int(rangeArray.length / 2);
			rangeSprite.graphics.lineStyle(1,0x000000);
			for each(element in this._arms[_armsIndex]["RangeAttack"].elements()){
				elementArr = (element + "").split(",");
				rangeArray[my + int(elementArr[1])][mx + int(elementArr[0])] = 1;
			}
			for(i=0;i<rangeArray.length;i++){
				for(j=0;j<rangeArray.length;j++){
					LDisplay.drawRect(rangeSprite.graphics,[j*10,i*10,10,10],true,0xff0000,rangeArray[i][j],1);
				}
			}
			LDisplay.drawRect(rangeSprite.graphics,[mx*10,my*10,10,10],false,0x000000,1,3);
			rangeSprite.addEventListener(MouseEvent.MOUSE_DOWN,setRange);
			viewSprite.addChild(rangeSprite);
		}
		private function setRange(event:MouseEvent):void{
			rangeSprite.graphics.clear();
			var ix:int = int(event.currentTarget.mouseX/10);
			var iy:int = int(event.currentTarget.mouseY/10);
			rangeArray[iy][ix] = !rangeArray[iy][ix];
			var i:int,j:int,mx:int,my:int;
			mx = int(rangeArray[0].length / 2);
			my = int(rangeArray.length / 2);
			rangeSprite.graphics.lineStyle(1,0x000000);
			for(i=0;i<rangeArray.length;i++){
				for(j=0;j<rangeArray.length;j++){
					LDisplay.drawRect(rangeSprite.graphics,[j*10,i*10,10,10],true,0xff0000,rangeArray[i][j],1);
				}
			}
			LDisplay.drawRect(rangeSprite.graphics,[mx*10,my*10,10,10],false,0x000000,1,3);
		}
		private function setTargetRange():void{
			if(rangeSprite != null)rangeSprite.removeFromParent();
			rangeSprite = new LSprite();
			rangeSprite.x = 450;
			rangeSprite.y = 30;
			var i:int,j:int,mx:int,my:int;
			var element:XML,elementArr:Array;
			rangeArray = [
				[0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0]
			];
			mx = int(rangeArray[0].length / 2);
			my = int(rangeArray.length / 2);
			rangeSprite.graphics.lineStyle(1,0x000000);
			for each(element in this._arms[_armsIndex]["RangeAttackTarget"].elements()){
				elementArr = (element + "").split(",");
				rangeArray[my + int(elementArr[1])][mx + int(elementArr[0])] = 1;
			}
			for(i=0;i<rangeArray.length;i++){
				for(j=0;j<rangeArray.length;j++){
					LDisplay.drawRect(rangeSprite.graphics,[j*10,i*10,10,10],true,0xff0000,rangeArray[i][j],1);
				}
			}
			LDisplay.drawRect(rangeSprite.graphics,[mx*10,my*10,10,10],false,0x000000,1,3);
			rangeSprite.addEventListener(MouseEvent.MOUSE_DOWN,setRange);
			viewSprite.addChild(rangeSprite);
		}
		private function changeRangeValue(event:LEvent):void{
			if(event.currentTarget.value == "attack"){
				setAttackRange();
			}else{
				setTargetRange();
			}
		}
		private function changeValue(event:LEvent):void{
			if(event.currentTarget.value == "restrain"){
				setScrollRestrain();
			}else if(event.currentTarget.value == "terrain"){
				setScrollTerrain();
			}else{
				setScrollStrategy();
			}
		}
		private function setScrollStrategy():void{
			if(scrollLayer != null)scrollLayer.removeFromParent();
			trace("setScrollStrategy run");
			var spriteStrategy:LSprite = new LSprite();
			var i:int,j:int,lblStrategy:LLabel,inputStrategy:LTextInput,intStrategy:int,selectStrategy:LComboBox,element:XML,strategyIndex:int;
			var restrainArray:Array = new Array();
			for(i=0;i<_strategy.length;i++){
				intStrategy = -1;
				lblStrategy = new LLabel();
				lblStrategy.text = _strategy[i].Name;
				lblStrategy.y = i*25;
				spriteStrategy.addChild(lblStrategy);
				inputStrategy = new LTextInput();
				inputStrategy.width = 30;
				inputStrategy.x = 55;
				inputStrategy.y = i*25;
				for each(element in _arms[_armsIndex]["Strategy"].elements()){
					if(int(element) != (i + 1))continue;
					if(this._strategyXml["Strategy" + element] != null && (this._strategyXml["Strategy" + element].toString()).length){
						intStrategy = element.@lv;
						break;
					}
				}
				inputStrategy.text = intStrategy.toString();
				spriteStrategy.addChild(inputStrategy);
				lblStrategy = new LLabel();
				lblStrategy.text = "lv";
				lblStrategy.x = 85;
				lblStrategy.y = i*25;
				spriteStrategy.addChild(lblStrategy);
				restrainArray.push(lblStrategy);
			}
			scrollLayer = new LScrollbar(spriteStrategy,210,440,20,false);
			LDisplay.drawRect(scrollLayer.graphics,[0,0,210,440]);
			scrollLayer.x = 190;
			scrollLayer.y = 25;
			viewSprite.addChild(scrollLayer);
		}
		private function setScrollTerrain():void{
			if(scrollLayer != null)scrollLayer.removeFromParent();
			var spriteTerrain:LSprite = new LSprite();
			var i:int,j:int,lblTerrain:LLabel,inputTerrain:LTextInput,intTerrain:int,selectTerrain:LComboBox;
			var restrainArray:Array = new Array();
			for(i=0;i<_terrain.length;i++){
				intTerrain = 100;
				lblTerrain = new LLabel();
				lblTerrain.text = _terrain[i];
				lblTerrain.y = i*25;
				spriteTerrain.addChild(lblTerrain);
				inputTerrain = new LTextInput();
				inputTerrain.width = 30;
				inputTerrain.x = 55;
				inputTerrain.y = i*25;
				if(_arms[_armsIndex]["Terrain"]["Terrain"+i] != null && (_arms[_armsIndex]["Terrain"]["Terrain"+i].toString()).length){
					intTerrain = _arms[_armsIndex]["Terrain"]["Terrain"+i].@Addition;
				}
				inputTerrain.text = intTerrain.toString();
				spriteTerrain.addChild(inputTerrain);
				lblTerrain = new LLabel();
				lblTerrain.text = "%";
				lblTerrain.x = 85;
				lblTerrain.y = i*25;
				spriteTerrain.addChild(lblTerrain);
				restrainArray.push(lblTerrain);
				selectTerrain = new LComboBox(new BitmapData(25,20,false,0xcccccc));
				for(j = 1;j<=int(_arms[_armsIndex].Distance);j++)selectTerrain.push(j.toString(),j.toString());
				selectTerrain.push("X","255");
				selectTerrain.value = _arms[_armsIndex]["Terrain"]["Terrain"+i];
				selectTerrain.x = 100;
				selectTerrain.y = i*25;
				spriteTerrain.addChild(selectTerrain);
			}
			scrollLayer = new LScrollbar(spriteTerrain,210,440,20,false);
			LDisplay.drawRect(scrollLayer.graphics,[0,0,210,440]);
			scrollLayer.x = 190;
			scrollLayer.y = 25;
			viewSprite.addChild(scrollLayer);
		}
		private function setScrollRestrain():void{
			if(scrollLayer != null)scrollLayer.removeFromParent();
			var spriteRestrain:LSprite = new LSprite();
			var restrainIndex:int,i:int,lblArmsRestrain:LLabel,inputArmsRestrain:LTextInput,intRestrain:int;
			var restrainArray:Array = new Array();
			for(i=0;i<_arms.length;i++){
				if(_armsIndex == i)continue;
				intRestrain = 100;
				lblArmsRestrain = new LLabel();
				lblArmsRestrain.text = _arms[i].Name;
				lblArmsRestrain.y = restrainIndex*25;
				spriteRestrain.addChild(lblArmsRestrain);
				inputArmsRestrain = new LTextInput();
				inputArmsRestrain.width = 50;
				inputArmsRestrain.x = 80;
				inputArmsRestrain.y = restrainIndex*25;
				if(_arms[_armsIndex]["Restrain"]["list"+(i + 1)] != null && (_arms[_armsIndex]["Restrain"]["list"+(i + 1)].toString()).length){
					intRestrain = _arms[_armsIndex]["Restrain"]["list"+(i + 1)];
				}
				inputArmsRestrain.text = intRestrain.toString();
				spriteRestrain.addChild(inputArmsRestrain);
				lblArmsRestrain = new LLabel();
				lblArmsRestrain.text = "%";
				lblArmsRestrain.x = 130;
				lblArmsRestrain.y = restrainIndex*25;
				spriteRestrain.addChild(lblArmsRestrain);
				restrainArray.push(lblArmsRestrain);
				restrainIndex++;
			}
			scrollLayer = new LScrollbar(spriteRestrain,210,440,20,false);
			LDisplay.drawRect(scrollLayer.graphics,[0,0,210,440]);
			scrollLayer.x = 190;
			scrollLayer.y = 25;
			viewSprite.addChild(scrollLayer);
		}
		private function getRadioChild(label:String,value:String,rx:int,ry:int,color:int=0x00ffff):LRadioChild{
			var radioChild:LRadioChild;
			var btn:LButton,bit:LBitmap;
			btn = LGlobal.getModelButton(1,[0,0,70,15,label,11,color]);
			bit = new LBitmap(LDisplay.displayToBitmap(btn));
			LFilter.setFilter(bit,LFilter.GRAY);
			bit.alpha = 0.5;
			radioChild = new LRadioChild(value,bit,btn);
			radioChild.x = rx;
			radioChild.y = ry;
			return radioChild;
		}
	}
}