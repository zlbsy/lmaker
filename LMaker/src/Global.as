package
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import zhanglubin.legend.components.LLabel;
	import zhanglubin.legend.components.LTextInput;
	import zhanglubin.legend.display.LButton;
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.utils.LDisplay;
	import zhanglubin.legend.utils.LFilter;
	import zhanglubin.legend.utils.LGlobal;

	public class Global
	{
		private static const X:String = "X";
		
		public static var terrain:XML;
		public static var terrainindex:int;
		public static var terrainAlpha:int = 5;
		public static var lmaker:LMaker;
		public static var imgData:Array;
		public static var appPath:String;
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
		public static function deleteFile(path:String,filename:String):void{
			var file:File = new File(path);
			file = file.resolvePath(filename);
			file.deleteFile();
		}
		public static function getFileList(path:String,filetype:String):Array{
			var file:File = new File(path);
			var list:Array = new Array();
			var arr:Array;
			var child:File;
			if(file.isDirectory){
				arr=file.getDirectoryListing();
				for each(child in arr){
					if(child.type == filetype)list.push([child.name,child.nativePath]);
				}
			}
			return list;
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
		
		public static function showMsg(title:String,msg:String,txtBox:LTextInput = null,btn:LButton = null):LSprite{
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
			
			if(txtBox != null){
				txtBox.x = (aboutWindow.width - txtBox.width)/2;
				txtBox.y = aboutWindow.height + 20;
				aboutWindow.addChild(txtBox);
			}
			
			if(btn != null){
				btn.x = (aboutWindow.width - btn.width)/2;
				btn.y = aboutWindow.height + 20;
				aboutWindow.addChild(btn);
			}
			aboutWindow.x = (LGlobal.stage.stageWidth - 500)/2;
			aboutWindow.y = 100;
			aboutSprite.addChild(aboutWindow);
			
			LDisplay.drawRoundRect(aboutWindow.graphics,[0,0,500,aboutWindow.height + 50,10,10],true,0xffffff);
			LDisplay.drawRoundRect(aboutWindow.graphics,[1,1,498,30,10,10],true,0x333333);
			LDisplay.drawRoundRect(aboutWindow.graphics,[468,2,30,28,10,10],true,0x999999);
			LFilter.setFilter(aboutWindow,LFilter.SHADOW);
			return aboutSprite;
		}
		
		
		/**
		private function pop(file:File):void  
        {  
			var thisPath = file.nativePath;
			var strType = "";
			if(thisPath == this.filePath + "\\images\\list"){
				strType = "list";
			}else if(thisPath == this.filePath + "\\images\\view"){
				strType = "view";
			}else if(thisPath != this.filePath && thisPath != this.filePath + "\\images"){
				return;
			}
            if(file.isDirectory)  
            { //指示是否为对目录的引用。如果 File 对象指向一个目录，则该值为 true；否则为 false  
                var arr:Array=file.getDirectoryListing();//getDirectoryListing()返回与此 File 对象表示的目录下的文件和目录对应的 File 对象的数组。此方法不浏览子目录的内容。   
                for each(var file:File in arr){//File 对象表示文件或目录的路径(既可以是文件也可以是路径)  
                    if(!file.isDirectory)  
                    {  
                        //var vo:fileVo=new FileVo();  
                        var path:String=file.nativePath;  
                        var startIndex:int=path.lastIndexOf("\\");  
                        //lastIndexOf(searchElement:*, fromIndex:int = 0x7fffffff):int  
                        //使用全等运算符 (===) 搜索数组中的项（从最后一项开始向前搜索），并返回匹配项的索引位置。  
                       var endIndex:int=path.lastIndexOf("."); 
						  var obj:Object = new Object();
					   if(strType == "list"){
							//obj.path = path.split("\\").join("/");
							obj.path = path;
							obj.strName = path.replace(thisPath + "\\","");
							
							loadImageList.push(obj);  
					   }else if(strType == "view"){
							//obj.path = path.split("\\").join("/");
							obj.path = path;
							obj.strName = path.replace(thisPath + "\\","");
							
							loadImageView.push(obj);  
					   }
						//trace("id = " + int(path.substring(startIndex+1,endIndex)));
                        //vo.path=path;  
                        //vo.id=int(path.substring(startIndex+1,endIndex));  
                        //substring返回一个字符串，其中包含由 startIndex 指定的字符和一直到 endIndex - 1 的所有字符。  
                        //fileArray.push(vo);  
                    }else  
                    {  
                        pop(file);  
                    }  
                }  
            }  
           // fileArray.sortOn("id",Array.NUMERIC);  
           // tList.dataProvider=fileArray;  
        }  
		 * */
	}
}