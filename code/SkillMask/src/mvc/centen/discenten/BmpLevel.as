package mvc.centen.discenten
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import mx.core.UIComponent;
	
	import _Pan3D.core.MathCore;
	
	import vo.FileDataVo;
	
	public class BmpLevel extends UIComponent
	{
		private var _alphaMc:Sprite;
		private var _picBmp:Bitmap;
		private var _sceneColorMc:Sprite;
		public function BmpLevel()
		{
			super();
			this._alphaMc=new Sprite;
			this.addChild(_alphaMc)
				
			this._sceneColorMc=new Sprite;
			this.addChild(_sceneColorMc);
				
			this._picBmp=new Bitmap;
			this.addChild(_picBmp)
		}
		
		public function setBmpItem(arr:Vector.<FileDataVo>):void
		{

			clearDele(arr)
			if(arr&&arr.length){
			
				var $FileDataVo:FileDataVo=arr[0];
				_picBmp.bitmapData=$FileDataVo.bmp;
				
				UiData.bitMapData=_picBmp.bitmapData;
				
			}
			drawColorSprite()

		}
		private var num10:Number=12
		public function drawColorSprite():void
		{
			
			
			
			var rect:Rectangle=UiData.sceneBmpRec;
			
			
			var sw:Number=Math.ceil(rect.width/num10);
			var sh:Number=Math.ceil(rect.height/num10);

			this.width=rect.width
			this.height=rect.height
				
			_alphaMc.graphics.clear()
			for(var i:uint=0;i<sw;i++){
				for(var j:uint=0;j<sh;j++){
					_alphaMc.graphics.beginFill((j%2+i)%2==0?0xffffff:0xaaaaaa,1)
					var kkw:Number=num10
					var kkh:Number=num10
					if((rect.width-i*num10)<num10){
						kkw=rect.width-i*num10
					}
			
					if((rect.height-j*num10)<num10){
						kkh=rect.height-j*num10
					}
					_alphaMc.graphics.drawRect(i*num10,j*num10,kkw,kkh)
					
					_alphaMc.graphics.endFill();
				}	
			}
			
			
			var colorUint:Vector3D=	MathCore.hexToArgb(UiData.sceneColor);
			colorUint.scaleBy(1/255)
			var colorVec:uint=	MathCore.vecToHex(colorUint,false);
			_sceneColorMc.graphics.clear();
			_sceneColorMc.graphics.beginFill(colorVec,colorUint.w/255)
			_sceneColorMc.graphics.drawRect(0,0,_alphaMc.width,_alphaMc.height);
			_sceneColorMc.graphics.endFill()
		
		}
		private function clearDele(arr:Vector.<FileDataVo>):void
		{

			_picBmp.bitmapData=null;
			_alphaMc.graphics.clear();
		}
	
		
		
	}
}