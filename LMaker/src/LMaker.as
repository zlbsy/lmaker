package
{
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;
	
	import page.logo.Logo;
	import page.sousou.SouSouMake;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LImageLoader;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.display.LURLLoader;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LFilter;
	import zhanglubin.legend.utils.LGlobal;
	
	[SWF(width="1024",height="700",frameRate="50",backgroundcolor="0x000000")]
	public class LMaker extends LSprite
	{
		private const URL_BLOG:String = "http://blog.csdn.com/lufy_Legend";
		private const TITLE_LOGO:String = "LMaker游戏开发";
		private const TITLE_SOUSOU:String = "战棋游戏开发";
		private const BAR_ABOUT:String = "<b><font color='#ffffff' size='15'><u><a href='event:" + URL_BLOG + "'>关于LMaker</a></u></font></b>";
		private const BAR_LOGO:String = "<b><font color='#ffffff' size='15'><u><a href='event:" + URL_BLOG + "'>主菜单</a></u></font></b>";
		private const X:String = "X";
		private const ABOUT_TITLE:String = "<b><font color='#ffffff' size='20'>About LMaker</font></b>";
		private const ABOUT_MSG:String = "<b><font color='#000000' size='25'>" + 
			"LMaker 0.2.0</font></b>\n\n\n" + 
			"<b><font color='#000000' size='20'>" + 
			"LMaker是L#游戏引擎的专用制作工具，是L#开发者lufy为方便引擎的推广使用而开发。\n\n" + 
			"LMaker随引擎更新而更新，如果您想了解更多关于L#引擎或者LMaker的最新信息以及使用方法，\n" + 
			"欢迎光临作者的官方博客：\n" + "</font></b>";
		private const ABOUT_URL:String = "<b><font color='#000000' size='20'><u><a href='event:" + URL_BLOG + "'>" + URL_BLOG + "</a></u></font></b>";
		
		private var _backLayer:LSprite;
		private var _title:LSprite;
		private var _titleName:LSprite;
		private var _menuAbout:LLabel;
		private var _returnLogo:LLabel;
		private var _imageLoader:LImageLoader;
		public function LMaker()
		{
			LGlobal.stage = stage;
			LDisplay.drawRectGradient(this.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],[0xcccccc,0x0000ff]);
			
			_imageLoader = new LImageLoader(["images/logo.png","images/save.png","images/open.png","images/delete.png"]);
			_imageLoader.addEventListener(Event.COMPLETE,showStart);
			//showStart();
		}
		public function showStart(event:Event):void{
			Global.imgData = _imageLoader.dateArray;
			_backLayer = new LSprite();
			this.addChild(_backLayer);
			Global.lmaker = this;
			_title = new LSprite();
			LDisplay.drawRectGradient(_title.graphics,[0,0,LGlobal.stage.stageWidth,30],[0xcccccc,0x0000ff]);
			this.addChild(_title);
			
			_titleName = new LSprite();
			_title.addChild(_titleName);
			
			_menuAbout = new LLabel();
			_menuAbout.htmlText = BAR_ABOUT;
			_menuAbout.x = LGlobal.stage.stageWidth - _menuAbout.width - 10;
			_title.addChild(_menuAbout);
			_menuAbout.addEventListener(TextEvent.LINK, showAbout);
			
			_returnLogo = new LLabel();
			_returnLogo.htmlText = BAR_LOGO;
			_returnLogo.x = LGlobal.stage.stageWidth - _menuAbout.width - 10 - _returnLogo.width - 10;
			_title.addChild(_returnLogo);
			_returnLogo.addEventListener(TextEvent.LINK, showLogo);
			
			showLogo();
		}
		public function get title():LSprite
		{
			return _title;
		}

		public function showAbout(event:TextEvent):void{
			var aboutSprite:LSprite = new LSprite();
			LDisplay.drawRect(aboutSprite.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0,0.3);
			this.addChild(aboutSprite);
			var aboutWindow:LSprite = new LSprite();
			LDisplay.drawRoundRect(aboutWindow.graphics,[0,0,500,400,10,10],true,0xffffff);
			LDisplay.drawRoundRect(aboutWindow.graphics,[1,1,498,30,10,10],true,0x333333);
			LDisplay.drawRoundRect(aboutWindow.graphics,[468,2,30,28,10,10],true,0x999999);
			
			var closeButton:LButton = new LButton(new BitmapData(28,28,true,0x000000));
			closeButton.labelSize = 28;
			closeButton.label = X;
			closeButton.x = 470;
			closeButton.y = -2;
			aboutWindow.addChild(closeButton);
			
			closeButton.addEventListener(MouseEvent.MOUSE_UP,function(event:MouseEvent):void{
				aboutSprite.removeFromParent();
			});
			var aboutTitle:LLabel = new LLabel();
			aboutTitle.x = 5;
			aboutTitle.y = 3;
			aboutTitle.htmlText = ABOUT_TITLE;
			aboutWindow.addChild(aboutTitle);
			
			var explanationTxt:LLabel = new LLabel();
			explanationTxt.x = 10;
			explanationTxt.y = 40;
			explanationTxt.width = 480;
			explanationTxt.wordWrap = true;
			explanationTxt.htmlText = ABOUT_MSG;
			aboutWindow.addChild(explanationTxt);
			var urlTxt:LLabel = new LLabel();
			urlTxt.x = 10;
			urlTxt.y = 250;
			urlTxt.htmlText = ABOUT_URL;
			urlTxt.addEventListener(TextEvent.LINK, function (event:TextEvent):void{
				var url:String = URL_BLOG;
				var request:URLRequest = new URLRequest(url);
				navigateToURL(request);
			});
			aboutWindow.addChild(urlTxt);
			
			aboutWindow.x = (LGlobal.stage.stageWidth - 500)/2;
			aboutWindow.y = 100;
			aboutSprite.addChild(aboutWindow);
			LFilter.setFilter(aboutWindow,LFilter.SHADOW);
		}
		public function showLogo(event:TextEvent = null):void{
			_backLayer.die();
			setTitleName(TITLE_LOGO);
			
			var logopage:Logo = new Logo();
			_backLayer.addChild(logopage);
		}
		public function showSouSou():void{
			_backLayer.die();
			setTitleName(TITLE_SOUSOU);
			
			var sousoupage:SouSouMake = new SouSouMake();
			sousoupage.y = _title.height;
			_backLayer.addChild(sousoupage);
		}
		public function setTitleName(value:String):void{
			_titleName.removeFromParent();
			_titleName = LGlobal.getColorText(new BitmapData(10,10,false,0x000000),value,20);
			_titleName.x = 5;
			_titleName.y = 0;
			_title.addChild(_titleName);
		}
	}
}