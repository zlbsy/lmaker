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
	
	public class SouSouTItem extends LSprite
	{
		private const SAVE_INDEX:int = 1;
		private var x999999Bit:BitmapData = new BitmapData(100,20,false,0x999999);
		private var _urlloader:LURLLoader;
		private var _arms:Array;
		private var _armsXml:XML;
		private var _terrain:Array;
		private var _terrainXml:XML;
		private var _item:Array;
		private var _itemXml:XML;
		private var listSprite:LSprite;
		private var listScrollbar:LScrollbar;
		private var scrollLayer:LScrollbar;
		private var rangeSprite:LSprite;
		private var selectBit:LBitmap;
		private var _itemIndex:int;
		private var viewSprite:LSprite;
		private var viewMenuSprite:LSprite;
		private var rangeArray:Array;
		private var _bitView:LBitmap;
		private var _selectView:LComboBox;
		private var imglist:Array;
		private var _btnSave:LButton;
		private var _bitSave:LBitmap;
		public function SouSouTItem()
		{
			super();
			LDisplay.drawRectGradient(this.graphics,[0,20,800,500],[0xffffff,0x8A98F4]);
			LDisplay.drawRect(this.graphics,[0,20,800,500],false,0x000000);
			LDisplay.drawRect(this.graphics,[10,30,124,484],false,0x000000);
			LDisplay.drawRect(this.graphics,[140,30,650,484],false,0x000000);
			
			
			
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadTArmsOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/initialization/Arms.sgj"));
		}
		private function loadTArmsOver(event:Event):void{
			_urlloader.die();
			_urlloader = null;
			_armsXml = new XML(event.target.data);
			_arms = new Array();
			var element:XML;
			for each(element in this._armsXml.elements())_arms.push(element);
			
			
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadTItemOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/initialization/Item.sgj"));
		}
		private function loadItemImgOver(event:Event):void{
			_urlloader.die();
			_urlloader = null;
			var bytes:ByteArray = ByteArray(event.target.data);
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
			for(i=0;i<bytes.length;i+=size){
				l = bytes.readUnsignedInt();
				limg2 = bytes.readUTFBytes(l);
				w = bytes.readUnsignedInt();
				h = bytes.readUnsignedInt();
				bitmapdata = new BitmapData(w,h);
				byte = new ByteArray();
				bytes.readBytes(byte,0,w*h*4);
				bitmapdata.setPixels(bitmapdata.rect,byte);
				imglist[limg2] = bitmapdata;
				//imglist.push([limg2,bitmapdata]); 
				size = l + w*h*4 + 12;
			}
			
			_bitSave = new LBitmap(Global.imgData[SAVE_INDEX]);
			LFilter.setFilter(_bitSave,LFilter.GRAY);
			_bitSave.x = 20;
			this.addChild(_bitSave);
			
			_btnSave = new LButton(Global.imgData[SAVE_INDEX]);
			_btnSave.x = 20;
			this.addChild(_btnSave);
			_btnSave.addEventListener(MouseEvent.MOUSE_UP,save);
			_btnSave.visible = false;
			
			view(0,0);
			listScrollbar.scrollToTop();
		}
		public function save(event:MouseEvent):void{}
		private function imgChange(event:Event):void{
			_bitView.bitmapData = imglist[_selectView.value] as BitmapData;
		}
		private function loadTItemOver(event:Event):void{
			_urlloader.die();
			_urlloader = null;
			_itemXml = new XML(event.target.data);
			setItemList();
			
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadItemImgOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/images/item.limg2"));
			
		}
		public function setItemList():void{
			var i:int;
			var bitmapdata:BitmapData;
			var size:uint;
			var w:uint;
			var h:uint;
			var lbl:LLabel,element:XML;
			var byte:ByteArray;
			if(listSprite != null)listSprite.removeFromParent();
			listSprite = new LSprite();
			_item = new Array();
			for each(element in this._itemXml.elements()){
				lbl = new LLabel();
				lbl.text = element.Name;
				lbl.y = i*20;
				listSprite.addChild(lbl);
				_item.push(element);
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
			selectBit.y = _itemIndex*selectBit.height;
		}
		private function mousemovelist(event:MouseEvent):void{
			selectBit.y = int(event.currentTarget.mouseY/selectBit.height)*selectBit.height;
		}
		public function view(by:int,bindex:int):void{
			_itemIndex = bindex;
			trace( _item[_itemIndex]);
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
			LDisplay.drawRectGradient(viewSprite.graphics,[200,30,130,130],[0xcccccc,0x333333]);
			
			_bitView = new LBitmap(new BitmapData(64,64));
			_bitView.bitmapData = null;
			_bitView.x = 220;
			_bitView.y= 50;
			viewSprite.addChild(_bitView);
			
			if(_itemIndex >= _item.length){
				var xml:XML = <Item>
	<Index>1</Index>
	<Name>未命名</Name>
	<Money>100</Money>
	<Type ex="0头盔，1武器，2盔甲，3坐骑">1</Type>
	<MaxLv>3</MaxLv>
	<Icon>mujian</Icon>
	<Can>
	</Can>
	<Attack ex="攻击加成" add="5">10</Attack>
	<Defense ex="防御加成" add="0">0</Defense>
	<Spirit ex="策略加成" add="0">0</Spirit>
	<Breakout ex="暴发加成" add="0">0</Breakout>
	<Morale ex="士气加成" add="0">0</Morale>
	<Hp ex="Hp加成" add="0">0</Hp>
	<Mp ex="Mp加成" add="0">0</Mp>
	<Distance ex="移动力加成" add="0">0</Distance>
	<Introduction ex="介绍">无。</Introduction>
</Item>;
				_itemXml.appendChild(xml); 
				setItemList();
			}
			
			_selectView = new LComboBox(new BitmapData(80,20,false,0x999999));
			for(var namestr:String in imglist){
				_selectView.push(namestr,namestr);
			}
			this._selectView.value = _item[_itemIndex].Icon;
			imgChange(null);
			_selectView.x = 70;
			_selectView.y= 50;
			_selectView.addEventListener(LEvent.CHANGE_VALUE,imgChange);
			viewMenuSprite.addChild(_selectView);
			
			var i:int;
			var lblx:int = 10,inputx:int = 70,lbly:int = 170,showIndex:int = 0;
			//装备名
			var lblName:LLabel = new LLabel();
			lblName.text = "装备名";
			lblName.x = lblx;
			lblName.y= lbly + showIndex * 20;
			viewSprite.addChild(lblName);
			var itemName:LTextInput = new LTextInput();
			itemName.text = _item[_itemIndex].Name;
			itemName.x = inputx;
			itemName.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(itemName);
			//价格
			var lblMoney:LLabel = new LLabel();
			lblMoney.text = "价格";
			lblMoney.x = lblx;
			lblMoney.y= lbly + showIndex * 20;
			viewSprite.addChild(lblMoney);
			var itemMoney:LTextInput = new LTextInput();
			itemMoney.text = _item[_itemIndex].Money;
			itemMoney.x = inputx;
			itemMoney.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(itemMoney);
			//最高等级
			var lblMaxLv:LLabel = new LLabel();
			lblMaxLv.text = "最高等级";
			lblMaxLv.x = lblx;
			lblMaxLv.y= lbly + showIndex * 20;
			viewSprite.addChild(lblMaxLv);
			var itemMaxLv:LTextInput = new LTextInput();
			itemMaxLv.text = _item[_itemIndex].MaxLv;
			itemMaxLv.x = inputx;
			itemMaxLv.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(itemMaxLv);
			//攻击加成
			var lblAttack:LLabel = new LLabel();
			lblAttack.text = "攻击加成";
			lblAttack.x = lblx;
			lblAttack.y= lbly + showIndex * 20;
			viewSprite.addChild(lblAttack);
			var itemAttack:LTextInput = new LTextInput();
			itemAttack.text = _item[_itemIndex].Attack;
			itemAttack.x = inputx;
			itemAttack.y= lbly + showIndex * 20;
			viewSprite.addChild(itemAttack);
			var lblAttackAdd:LLabel = new LLabel();
			lblAttackAdd.text = "升级增值";
			lblAttackAdd.x = inputx + itemAttack.width;
			lblAttackAdd.y= lbly + showIndex * 20;
			viewSprite.addChild(lblAttackAdd);
			var itemAttackAdd:LTextInput = new LTextInput();
			itemAttackAdd.text = _item[_itemIndex].Attack.@add;
			itemAttackAdd.x = inputx + itemAttack.width + lblAttackAdd.width;
			itemAttackAdd.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(itemAttackAdd);
			//防御加成
			var lblDefense:LLabel = new LLabel();
			lblDefense.text = "防御加成";
			lblDefense.x = lblx;
			lblDefense.y= lbly + showIndex * 20;
			viewSprite.addChild(lblDefense);
			var itemDefense:LTextInput = new LTextInput();
			itemDefense.text = _item[_itemIndex].Defense;
			itemDefense.x = inputx;
			itemDefense.y= lbly + showIndex * 20;
			viewSprite.addChild(itemDefense);
			var lblDefenseAdd:LLabel = new LLabel();
			lblDefenseAdd.text = "升级增值";
			lblDefenseAdd.x = inputx + itemDefense.width;
			lblDefenseAdd.y= lbly + showIndex * 20;
			viewSprite.addChild(lblDefenseAdd);
			var itemDefenseAdd:LTextInput = new LTextInput();
			itemDefenseAdd.text = _item[_itemIndex].Defense.@add;
			itemDefenseAdd.x = inputx + itemDefense.width + lblDefenseAdd.width;
			itemDefenseAdd.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(itemDefenseAdd);
			//策略加成
			var lblSpirit:LLabel = new LLabel();
			lblSpirit.text = "策略加成";
			lblSpirit.x = lblx;
			lblSpirit.y= lbly + showIndex * 20;
			viewSprite.addChild(lblSpirit);
			var itemSpirit:LTextInput = new LTextInput();
			itemSpirit.text = _item[_itemIndex].Spirit;
			itemSpirit.x = inputx;
			itemSpirit.y= lbly + showIndex * 20;
			viewSprite.addChild(itemSpirit);
			var lblSpiritAdd:LLabel = new LLabel();
			lblSpiritAdd.text = "升级增值";
			lblSpiritAdd.x = inputx + itemSpirit.width;
			lblSpiritAdd.y= lbly + showIndex * 20;
			viewSprite.addChild(lblSpiritAdd);
			var itemSpiritAdd:LTextInput = new LTextInput();
			itemSpiritAdd.text = _item[_itemIndex].Spirit.@add;
			itemSpiritAdd.x = inputx + itemSpirit.width + lblSpiritAdd.width;
			itemSpiritAdd.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(itemSpiritAdd);
			//暴发加成
			var lblBreakout:LLabel = new LLabel();
			lblBreakout.text = "暴发加成";
			lblBreakout.x = lblx;
			lblBreakout.y= lbly + showIndex * 20;
			viewSprite.addChild(lblBreakout);
			var itemBreakout:LTextInput = new LTextInput();
			itemBreakout.text = _item[_itemIndex].Breakout;
			itemBreakout.x = inputx;
			itemBreakout.y= lbly + showIndex * 20;
			viewSprite.addChild(itemBreakout);
			var lblBreakoutAdd:LLabel = new LLabel();
			lblBreakoutAdd.text = "升级增值";
			lblBreakoutAdd.x = inputx + itemBreakout.width;
			lblBreakoutAdd.y= lbly + showIndex * 20;
			viewSprite.addChild(lblBreakoutAdd);
			var itemBreakoutAdd:LTextInput = new LTextInput();
			itemBreakoutAdd.text = _item[_itemIndex].Breakout.@add;
			itemBreakoutAdd.x = inputx + itemBreakout.width + lblBreakoutAdd.width;
			itemBreakoutAdd.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(itemBreakoutAdd);
			//士气加成
			var lblMorale:LLabel = new LLabel();
			lblMorale.text = "士气加成";
			lblMorale.x = lblx;
			lblMorale.y= lbly + showIndex * 20;
			viewSprite.addChild(lblMorale);
			var itemMorale:LTextInput = new LTextInput();
			itemMorale.text = _item[_itemIndex].Morale;
			itemMorale.x = inputx;
			itemMorale.y= lbly + showIndex * 20;
			viewSprite.addChild(itemMorale);
			var lblMoraleAdd:LLabel = new LLabel();
			lblMoraleAdd.text = "升级增值";
			lblMoraleAdd.x = inputx + itemMorale.width;
			lblMoraleAdd.y= lbly + showIndex * 20;
			viewSprite.addChild(lblMoraleAdd);
			var itemMoraleAdd:LTextInput = new LTextInput();
			itemMoraleAdd.text = _item[_itemIndex].Morale.@add;
			itemMoraleAdd.x = inputx + itemMorale.width + lblMoraleAdd.width;
			itemMoraleAdd.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(itemMoraleAdd);
			//Hp加成
			var lblHp:LLabel = new LLabel();
			lblHp.text = "Hp加成";
			lblHp.x = lblx;
			lblHp.y= lbly + showIndex * 20;
			viewSprite.addChild(lblHp);
			var itemHp:LTextInput = new LTextInput();
			itemHp.text = _item[_itemIndex].Hp;
			itemHp.x = inputx;
			itemHp.y= lbly + showIndex * 20;
			viewSprite.addChild(itemHp);
			var lblHpAdd:LLabel = new LLabel();
			lblHpAdd.text = "升级增值";
			lblHpAdd.x = inputx + itemHp.width;
			lblHpAdd.y= lbly + showIndex * 20;
			viewSprite.addChild(lblHpAdd);
			var itemHpAdd:LTextInput = new LTextInput();
			itemHpAdd.text = _item[_itemIndex].Hp.@add;
			itemHpAdd.x = inputx + itemHp.width + lblHpAdd.width;
			itemHpAdd.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(itemHpAdd);
			//Mp加成
			var lblMp:LLabel = new LLabel();
			lblMp.text = "Mp加成";
			lblMp.x = lblx;
			lblMp.y= lbly + showIndex * 20;
			viewSprite.addChild(lblMp);
			var itemMp:LTextInput = new LTextInput();
			itemMp.text = _item[_itemIndex].Mp;
			itemMp.x = inputx;
			itemMp.y= lbly + showIndex * 20;
			viewSprite.addChild(itemMp);
			var lblMpAdd:LLabel = new LLabel();
			lblMpAdd.text = "升级增值";
			lblMpAdd.x = inputx + itemMp.width;
			lblMpAdd.y= lbly + showIndex * 20;
			viewSprite.addChild(lblMpAdd);
			var itemMpAdd:LTextInput = new LTextInput();
			itemMpAdd.text = _item[_itemIndex].Mp.@add;
			itemMpAdd.x = inputx + itemMp.width + lblMpAdd.width;
			itemMpAdd.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(itemMpAdd);
			//移动加成
			var lblDistance:LLabel = new LLabel();
			lblDistance.text = "移动加成";
			lblDistance.x = lblx;
			lblDistance.y= lbly + showIndex * 20;
			viewSprite.addChild(lblDistance);
			var itemDistance:LTextInput = new LTextInput();
			itemDistance.text = _item[_itemIndex].Distance;
			itemDistance.x = inputx;
			itemDistance.y= lbly + showIndex * 20;
			viewSprite.addChild(itemDistance);
			var lblDistanceAdd:LLabel = new LLabel();
			lblDistanceAdd.text = "升级增值";
			lblDistanceAdd.x = inputx + itemDistance.width;
			lblDistanceAdd.y= lbly + showIndex * 20;
			viewSprite.addChild(lblDistanceAdd);
			var itemDistanceAdd:LTextInput = new LTextInput();
			itemDistanceAdd.text = _item[_itemIndex].Distance.@add;
			itemDistanceAdd.x = inputx + itemDistance.width + lblDistanceAdd.width;
			itemDistanceAdd.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(itemDistanceAdd);
			//介绍
			var lblIntroduction:LLabel = new LLabel();
			lblIntroduction.text = "介绍";
			lblIntroduction.x = lblx;
			lblIntroduction.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(lblIntroduction);
			var inputIntroduction:LTextInput = new LTextInput();
			inputIntroduction.text = _item[_itemIndex].Introduction;
			inputIntroduction.x = lblx;
			inputIntroduction.y= lbly + (showIndex++) * 20;
			inputIntroduction.width = 320;
			inputIntroduction.height = 60;
			inputIntroduction.wordWrap = true;
			viewSprite.addChild(inputIntroduction);
			
			//Icon
			
			//可装备兵种
			var lblCan:LLabel = new LLabel();
			lblCan.text = "可装备兵种";
			lblCan.x = 400;
			lblCan.y= 5;
			viewSprite.addChild(lblCan);
			setScrollCan();
			
		}
		private function setScrollCan():void{
			if(scrollLayer != null)scrollLayer.removeFromParent();
			var spriteCan:LSprite = new LSprite();
			var armsIndex:int = 0,i:int,j:int,lblArms:LLabel,inputArms:LTextInput,intArms:int,element:XML,selectArms:LComboBox;
			var restrainArray:Array = new Array();
			for(i=0;i<_arms.length;i++){
				intArms = 0;
				lblArms = new LLabel();
				lblArms.text = _arms[i].Name;
				lblArms.y = i*25;
				spriteCan.addChild(lblArms);
				selectArms = new LComboBox(new BitmapData(80,20,false,0xcccccc));
				selectArms.push("X","0");
				selectArms.push("允许装备","1");
				if(_item[_itemIndex]["Can"]["list"+(i + 1)] != null && (_item[_itemIndex]["Can"]["list"+(i + 1)].toString()).length){
					intArms = 1;
				}
				selectArms.value = intArms.toString();
				selectArms.x = 100;
				selectArms.y = i*25;
				spriteCan.addChild(selectArms);
			}
			scrollLayer = new LScrollbar(spriteCan,210,440,20,false);
			LDisplay.drawRect(scrollLayer.graphics,[0,0,210,440]);
			scrollLayer.x = 400;
			scrollLayer.y = 25;
			viewSprite.addChild(scrollLayer);
		}
	}
}