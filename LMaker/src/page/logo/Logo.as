package page.logo
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.display.LBitmap;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LImageLoader;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LFilter;
	import zhanglubin.legend.utils.LGlobal;

	public class Logo extends LSprite
	{

		private const IMG_LOGO_INDEX:int = 0;
		private const TITLE:String = "LMaker游戏开发";
		private const TITLE_MINI:String = "・L#游戏引擎专用开发工具(http://blog.csdn.net/lufy_Legend)";
		private const BTN_APP:String = "简单应用开发";
		private const BTN_SOUSOU:String = "战棋游戏开发";
		private const BTN_SLG:String = "<font color='#ffffff' size='20'><b>大型SLG战略游戏开发</b></font>";
		private const BTN_RPG:String = "<font color='#ffffff' size='20'><b>RPG角色游戏开发</b></font>";
		private const BTN_MMRPG:String = "<font color='#ffffff' size='20'><b>MMRPG在线游戏开发</b></font>";
		
		private var _imageLoader:LImageLoader;
		private var _bitmap:LBitmap;
		private var _title:LSprite;
		private var _titleName:LSprite;
		private var _titleMini:LSprite;
		private var _mainMenu:LSprite;
		public function Logo()
		{
			showLogo();
		}
		private function showLogo():void{
			_bitmap = new LBitmap(Global.imgData[IMG_LOGO_INDEX]);
			_bitmap.x = 400;
			_bitmap.y = 200;
			this.addChild(_bitmap);
			_title = LGlobal.getColorText(new BitmapData(10,10,false,0xff5400),TITLE,80);
			_title.x = 30;
			_title.y = 30;
			this.addChild(_title);
			
			_titleMini = LGlobal.getColorText(new BitmapData(10,10,false,0x000000),TITLE_MINI,20,0xff0000);
			_titleMini.x = 50;
			_titleMini.y = 130;
			this.addChild(_titleMini);
			this.addMenu();
		}
		private function addMenu():void{
			var btnX:int = 50;
			
			var offBtnSprite:LSprite = new LSprite();
			LDisplay.drawRectGradient(offBtnSprite.graphics,[0,0,218,48],[0xcccccc,0x999999]);
			LDisplay.drawRect(offBtnSprite.graphics,[0,0,220,50],false,0xcccccc,1,2);
			var offBitmapdata:BitmapData = LDisplay.displayToBitmap(offBtnSprite);
			
			var btnApp:LButton = LGlobal.getModelButton(0,[0,0,220,50,BTN_APP,20]);
			btnApp.x = btnX;
			btnApp.y = 250;
			this.addChild(btnApp);
			
			var btnSouSou:LButton = LGlobal.getModelButton(0,[0,0,220,50,BTN_SOUSOU,20]);
			btnSouSou.x = btnX;
			btnSouSou.y = 330;
			btnSouSou.addEventListener(MouseEvent.MOUSE_UP,sousouClick);
			this.addChild(btnSouSou);
			
			var txtApp:LLabel;
			
			var spriteSLG:LSprite = new LSprite();
			spriteSLG.x = btnX;
			spriteSLG.y = 410;
			var btnSLG:LBitmap = new LBitmap(offBitmapdata);
			spriteSLG.addChild(btnSLG);
			txtApp = new LLabel();
			txtApp.htmlText = BTN_SLG;
			txtApp.x = (spriteSLG.width - txtApp.width)/2;
			txtApp.y = (spriteSLG.height - txtApp.height)/2;
			spriteSLG.addChild(txtApp);
			this.addChild(spriteSLG);
			
			var spriteRPG:LSprite = new LSprite();
			spriteRPG.x = btnX;
			spriteRPG.y = 490;
			var btnRPG:LBitmap = new LBitmap(offBitmapdata);
			spriteRPG.addChild(btnRPG);
			txtApp = new LLabel();
			txtApp.htmlText = BTN_RPG;
			txtApp.x = (spriteRPG.width - txtApp.width)/2;
			txtApp.y = (spriteRPG.height - txtApp.height)/2;
			spriteRPG.addChild(txtApp);
			this.addChild(spriteRPG);
			
			var spriteMMRPG:LSprite = new LSprite();
			spriteMMRPG.x = btnX;
			spriteMMRPG.y = 570;
			var btnMMRPG:LBitmap = new LBitmap(offBitmapdata);
			spriteMMRPG.addChild(btnMMRPG);
			txtApp = new LLabel();
			txtApp.htmlText = BTN_MMRPG;
			txtApp.x = (spriteMMRPG.width - txtApp.width)/2;
			txtApp.y = (spriteMMRPG.height - txtApp.height)/2;
			spriteMMRPG.addChild(txtApp);
			this.addChild(spriteMMRPG);
		}
		private function sousouClick(event:MouseEvent):void{
			Global.lmaker.showSouSou();
		}
	}
}