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
	
	public class SouSouTProps extends LSprite
	{
		private var x999999Bit:BitmapData = new BitmapData(100,20,false,0x999999);
		private var _urlloader:LURLLoader;
		private var _props:Array;
		private var _propsXml:XML;
		private var listSprite:LSprite;
		private var listScrollbar:LScrollbar;
		private var scrollLayer:LScrollbar;
		private var rangeSprite:LSprite;
		private var selectBit:LBitmap;
		private var _propsIndex:int;
		private var viewSprite:LSprite;
		private var viewMenuSprite:LSprite;
		private var rangeArray:Array;
		public function SouSouTProps()
		{
			super();
			LDisplay.drawRectGradient(this.graphics,[0,20,800,500],[0xffffff,0x8A98F4]);
			LDisplay.drawRect(this.graphics,[0,20,800,500],false,0x000000);
			LDisplay.drawRect(this.graphics,[10,30,124,484],false,0x000000);
			LDisplay.drawRect(this.graphics,[140,30,650,484],false,0x000000);
			
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadTItemOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath + "/initialization/Props.sgj"));
		}
		private function loadTItemOver(event:Event):void{
			_urlloader.die();
			_urlloader = null;
			_propsXml = new XML(event.target.data);
			setPropsList();
			view(0,0);
			listScrollbar.scrollToTop();
		}
		public function setPropsList():void{
			var i:int;
			var bitmapdata:BitmapData;
			var size:uint;
			var w:uint;
			var h:uint;
			var lbl:LLabel,element:XML;
			var byte:ByteArray;
			if(listSprite != null)listSprite.removeFromParent();
			listSprite = new LSprite();
			_props = new Array();
			for each(element in this._propsXml.elements()){
				lbl = new LLabel();
				lbl.text = element.Name;
				lbl.y = i*20;
				listSprite.addChild(lbl);
				_props.push(element);
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
			selectBit.y = _propsIndex*selectBit.height;
		}
		private function mousemovelist(event:MouseEvent):void{
			selectBit.y = int(event.currentTarget.mouseY/selectBit.height)*selectBit.height;
		}
		public function view(by:int,bindex:int):void{
			_propsIndex = bindex;
			trace( _props[_propsIndex]);
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
			//LDisplay.drawRectGradient(viewSprite.graphics,[450,30,130,130],[0xcccccc,0x333333]);
			
			if(_propsIndex >= _props.length){
				var xml:XML = 
					<Props>
					<Type>0</Type>
					<Name>未命名</Name>
					<Money>30</Money>
					<Icon>mantou</Icon>
					<Num>7</Num>
					<Hp>0</Hp>
					<Mp>0</Mp>
					<Force ex="武力">0</Force>
					<Intelligence ex="智力">0</Intelligence>
					<Command ex="统帅">0</Command>
					<Agile ex="敏捷">0</Agile>
					<Luck ex="运气">0</Luck>
	<Introduction ex="介绍">无。</Introduction>
</Props>;
				_propsXml.appendChild(xml); 
				setPropsList();
			}
			
			var i:int;
			var lblx:int = 10,inputx:int = 70,lbly:int = 170,showIndex:int = 0;
			//物品名
			var lblName:LLabel = new LLabel();
			lblName.text = "物品名";
			lblName.x = lblx;
			lblName.y= lbly + showIndex * 20;
			viewSprite.addChild(lblName);
			var propsName:LTextInput = new LTextInput();
			propsName.text = _props[_propsIndex].Name;
			propsName.x = inputx;
			propsName.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(propsName);
			//价格
			var lblMoney:LLabel = new LLabel();
			lblMoney.text = "价格";
			lblMoney.x = lblx;
			lblMoney.y= lbly + showIndex * 20;
			viewSprite.addChild(lblMoney);
			var propsMoney:LTextInput = new LTextInput();
			propsMoney.text = _props[_propsIndex].Money;
			propsMoney.x = inputx;
			propsMoney.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(propsMoney);
			//武力加成
			var lblForce:LLabel = new LLabel();
			lblForce.text = "武力加成";
			lblForce.x = lblx;
			lblForce.y= lbly + showIndex * 20;
			viewSprite.addChild(lblForce);
			var propsForce:LTextInput = new LTextInput();
			propsForce.text = _props[_propsIndex].Force;
			propsForce.x = inputx;
			propsForce.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(propsForce);
			//智力加成
			var lblIntelligence:LLabel = new LLabel();
			lblIntelligence.text = "智力加成";
			lblIntelligence.x = lblx;
			lblIntelligence.y= lbly + showIndex * 20;
			viewSprite.addChild(lblIntelligence);
			var propsIntelligence:LTextInput = new LTextInput();
			propsIntelligence.text = _props[_propsIndex].Intelligence;
			propsIntelligence.x = inputx;
			propsIntelligence.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(propsIntelligence);
			var lblDefenseAdd:LLabel = new LLabel();
			//统帅加成
			var lblCommand:LLabel = new LLabel();
			lblCommand.text = "统帅加成";
			lblCommand.x = lblx;
			lblCommand.y= lbly + showIndex * 20;
			viewSprite.addChild(lblCommand);
			var propsCommand:LTextInput = new LTextInput();
			propsCommand.text = _props[_propsIndex].Command;
			propsCommand.x = inputx;
			propsCommand.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(propsCommand);
			//敏捷加成
			var lblAgile:LLabel = new LLabel();
			lblAgile.text = "敏捷加成";
			lblAgile.x = lblx;
			lblAgile.y= lbly + showIndex * 20;
			viewSprite.addChild(lblAgile);
			var propsAgile:LTextInput = new LTextInput();
			propsAgile.text = _props[_propsIndex].Agile;
			propsAgile.x = inputx;
			propsAgile.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(propsAgile);
			//运气加成
			var lblLuck:LLabel = new LLabel();
			lblLuck.text = "运气加成";
			lblLuck.x = lblx;
			lblLuck.y= lbly + showIndex * 20;
			viewSprite.addChild(lblLuck);
			var propsLuck:LTextInput = new LTextInput();
			propsLuck.text = _props[_propsIndex].Luck;
			propsLuck.x = inputx;
			propsLuck.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(propsLuck);
			var lblMoraleAdd:LLabel = new LLabel();
			//Hp加成
			var lblHp:LLabel = new LLabel();
			lblHp.text = "Hp加成";
			lblHp.x = lblx;
			lblHp.y= lbly + showIndex * 20;
			viewSprite.addChild(lblHp);
			var propsHp:LTextInput = new LTextInput();
			propsHp.text = _props[_propsIndex].Hp;
			propsHp.x = inputx;
			propsHp.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(propsHp);
			//Mp加成
			var lblMp:LLabel = new LLabel();
			lblMp.text = "Mp加成";
			lblMp.x = lblx;
			lblMp.y= lbly + showIndex * 20;
			viewSprite.addChild(lblMp);
			var propsMp:LTextInput = new LTextInput();
			propsMp.text = _props[_propsIndex].Mp;
			propsMp.x = inputx;
			propsMp.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(propsMp);
			//介绍
			var lblIntroduction:LLabel = new LLabel();
			lblIntroduction.text = "介绍";
			lblIntroduction.x = lblx;
			lblIntroduction.y= lbly + (showIndex++) * 20;
			viewSprite.addChild(lblIntroduction);
			var inputIntroduction:LTextInput = new LTextInput();
			inputIntroduction.text = _props[_propsIndex].Introduction;
			inputIntroduction.x = lblx;
			inputIntroduction.y= lbly + (showIndex++) * 20;
			inputIntroduction.width = 320;
			inputIntroduction.height = 60;
			inputIntroduction.wordWrap = true;
			viewSprite.addChild(inputIntroduction);
			
			//Icon
			
			
		}
	}
}