package
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LFilter;
	import zhanglubin.legend.utils.LGlobal;

	public class Global
	{
		private static const X:String = "X";
		
		public static var lmaker:LMaker;
		public static var imgData:Array;
		public static var sousouPath:String;
		
		public static function saveBytesData(path:String,filename:String,msg:ByteArray):void{
			var file:File = new File(path);
			file = file.resolvePath(filename);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(msg);
			//stream.writeUTFBytes(msg);
			stream.close();
		}
		public static function saveData(path:String,filename:String,msg:String):void{
			var file:File = new File(path);
			file = file.resolvePath(filename);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(msg);
			stream.close();
		}
		/**
		 * 所安装应用程序的根目录（该目录包含所安装应用程序的 application.xml 文件）的路径
		 */
		public static function saveAppData(path:String,filename:String,msg:String):void{
			var file:File = new File();
			file.url = "app:/"+path;
			saveData(file.nativePath,filename,msg);
		}
		/**
		 * 应用程序存储目录的路径。对于每个安装的应用程序，AIR 定义了一个唯一的应用程序存储目录
		 */
		public static function saveAppStorageData(path:String,filename:String,msg:String):void{
			var file:File = new File();
			file.url = "app-storage:/"+path;
			saveData(file.nativePath,filename,msg);
		}
		public static function exists(path:String,filename:String):Boolean{
			try{
				var file:File = new File(path);
				file = file.resolvePath(filename);
			}catch(e:Error){
				return false;
			}
			return file.exists;
		}
		public static function existsApp(path:String,filename:String):Boolean{
			var file:File = new File();
			file.url = "app:/"+path;
			return exists(file.nativePath,filename);
		}
		public static function existsAppStorage(path:String,filename:String):Boolean{
			var file:File = new File();
			file.url = "app-storage:/"+path;
			return exists(file.nativePath,filename);
		}
		public static function isDirectory(path:String):Boolean{
			try{
				var file:File = new File(path);
			}catch(e:Error){
				return false;
			}
			return file.isDirectory;
		}
		public static function isDirectoryApp(path:String):Boolean{
			var file:File = new File();
			file.url = "app:/"+path;
			return isDirectory(file.nativePath);
		}
		public static function isDirectoryAppStorage(path:String):Boolean{
			var file:File = new File();
			file.url = "app-storage:/"+path;
			return isDirectory(file.nativePath);
		}
		
		public static function showMsg(title:String,msg:String):void{
			var aboutSprite:LSprite = new LSprite();
			LDisplay.drawRect(aboutSprite.graphics,[0,0,LGlobal.stage.stageWidth,LGlobal.stage.stageHeight],true,0,0.3);
			Global.lmaker.addChild(aboutSprite);
			var aboutWindow:LSprite = new LSprite();
			
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
			aboutTitle.htmlText = "<b><font color='#ffffff' size='20'>" + title + "</font></b>";;
			aboutWindow.addChild(aboutTitle);
			
			var explanationTxt:LLabel = new LLabel();
			explanationTxt.x = 10;
			explanationTxt.y = 40;
			explanationTxt.width = 480;
			explanationTxt.wordWrap = true;
			explanationTxt.htmlText = msg;
			aboutWindow.addChild(explanationTxt);
			
			aboutWindow.x = (LGlobal.stage.stageWidth - 500)/2;
			aboutWindow.y = 100;
			aboutSprite.addChild(aboutWindow);
			
			LDisplay.drawRoundRect(aboutWindow.graphics,[0,0,500,explanationTxt.height + 50,10,10],true,0xffffff);
			LDisplay.drawRoundRect(aboutWindow.graphics,[1,1,498,30,10,10],true,0x333333);
			LDisplay.drawRoundRect(aboutWindow.graphics,[468,2,30,28,10,10],true,0x999999);
			LFilter.setFilter(aboutWindow,LFilter.SHADOW);
		}
	}
}