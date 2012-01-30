package page.sousou
{
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.display.LURLLoader;
	
	public class SouSouTChara extends SouSouImg
	{
		private var _urlloader:LURLLoader;
		public function SouSouTChara()
		{
			super();
			_urlloader = new LURLLoader();
			_urlloader.addEventListener(Event.COMPLETE,loadTCharaOver);
			_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloader.load(new URLRequest(Global.sousouPath+"/initialization/chara.sgj"))
		}
		private function loadTCharaOver(event:Event):void{
			trace("event.target.data = " + event.target.data);
			_urlloader.die();
			_urlloader = null;
		}
	}
}