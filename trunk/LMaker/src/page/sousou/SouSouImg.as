package page.sousou
{
	import flash.display.BitmapData;
	
	import zhanglubin.legend.display.LSprite;
	import zhanglubin.legend.utils.LGlobal;

	public class SouSouImg extends LSprite
	{
		protected var bitmapdataList:Array;
		public function SouSouImg()
		{
			bitmapdataList = new Array();
			super();
		}
		override public function die():void{
			//LGlobal.bitmapDataDispose = true;
			//LGlobal.bitmapDataDispose = false;
			var i:int,j:int,arr:Array,bitmapdata:BitmapData;
			for(i=0;i<bitmapdataList.length;i++){
				arr = bitmapdataList[i];
				for(j=0;j<arr.length;j++){
					bitmapdata = arr[j];
					bitmapdata.dispose();
				}
			}
			super.die();
		}
	}
}