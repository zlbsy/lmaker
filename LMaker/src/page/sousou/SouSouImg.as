package page.sousou
{
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.utils.LGlobal;

	public class SouSouImg extends LSprite
	{
		public function SouSouImg()
		{
		}
		override public function die():void{
			LGlobal.bitmapDataDispose = true;
			super.die();
			LGlobal.bitmapDataDispose = false;
		}
	}
}