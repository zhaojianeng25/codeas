package materials
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.geom.Vector3D;
	
	import curves.Curve;
	import curves.CurveItem;
	
	import textures.TextureBaseVo;

	public class DynamicTexItem
	{
		public var url:String;
		public var target:TexItem;
		public var paramName:String;
		public var texture:Texture;
		public var textureVo:TextureBaseVo;
		public var isParticleColor:Boolean;
		public var curve:Curve;
		private var _life:int;
		
		public function DynamicTexItem()
		{
			
		}
		
		public function initCurve($type:int):void{
			curve = new Curve
			curve.type = $type;
		}
		
		public function getData():Object{
			var obj:Object = new Object;
			obj.url = url;
			obj.paramName = paramName;
			obj.isParticleColor = isParticleColor;
			if(isParticleColor){
				obj.curve = curve.getData();
			}
			return obj;
		}
		
		public function setData(obj:Object):void{
			this.url = obj.url;
			this.paramName = obj.paramName;
			this.isParticleColor = obj.isParticleColor;
			if(isParticleColor){
				curve = new Curve;
				curve.setData(obj.curve);
			}
		}
		private var bgBmp:Bitmap;
		private var showBmp:Bitmap;
		public function creatTextureByCurve($context3d:Context3D,stage:Stage=null):void{
			var curveList:Vector.<CurveItem> = curve.curveList;
			var bmp:BitmapData = new BitmapData(life,1,true,0xffffffff);
			if(curveList.length != 0){
				var endIndex:int = curveList.length - 1;
				var endVecIndex:int = (curveList[endIndex].frame - curveList[0].frame);
				for(var i:int;i<life;i++){
					if(i<curveList[0].frame){
						bmp.setPixel32(i,0,argbToHex(curve.valueVec[0][0],curve.valueVec[1][0],curve.valueVec[2][0],curve.valueVec[3][0]));
					}else if(i > curveList[endIndex].frame){
						bmp.setPixel32(i,0,argbToHex(curve.valueVec[0][endVecIndex],curve.valueVec[1][endVecIndex],curve.valueVec[2][endVecIndex],curve.valueVec[3][endVecIndex]));
					}else{
						var index:int = i - curveList[0].frame;
						bmp.setPixel32(i,0,argbToHex(curve.valueVec[0][index],curve.valueVec[1][index],curve.valueVec[2][index],curve.valueVec[3][index]));
					}
				}
			}
			
			var bmp64:BitmapData = new BitmapData(64,1,true,0);
			var ma:Matrix = new Matrix;
			ma.scale(64/life,1);
			bmp64.draw(bmp,ma);
			
//			if(stage){
//				if(!bgBmp){
//					bgBmp = new Bitmap(new BitmapData(100,30,true,0xff000000));
//					stage.addChild(bgBmp);
//				}
//				
//				if(!showBmp){
//					var showBmp:Bitmap = new Bitmap();
//					showBmp.x = 10;
//					showBmp.y = 10;
//					stage.addChild(showBmp);
//				}
//				showBmp.bitmapData = bmp64;
//			}
			
			if(!texture){
				texture = $context3d.createTexture(64,1,Context3DTextureFormat.BGRA,true);
			}
			texture.uploadFromBitmapData(bmp64);
			
		}
		
		public function argbToHex(r:Number, g:Number, b:Number,a:Number):uint
		{
			var expColor:uint= uint(a * 0xff) << 24 | uint(r * 0xff) << 16 | uint(g * 0xff) << 8 | uint(b * 0xff);
			
//			var colorV3d:Vector3D = new Vector3D;
//			
//			colorV3d.w =(expColor>>24) & 0xFF;
//			colorV3d.x= (expColor>>16) & 0xFF;
//			colorV3d.y = (expColor>>8) & 0xFF;
//			colorV3d.z = (expColor) & 0xFF;
			
			return expColor;
		}

		public function get life():int
		{
			return _life;
		}

		public function set life(value:int):void
		{
			_life = value;
		}

		
	}
}