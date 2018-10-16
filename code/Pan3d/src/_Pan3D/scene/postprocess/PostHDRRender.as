package _Pan3D.scene.postprocess
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import _Pan3D.core.MathCore;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	import materials.TexItem;

	public class PostHDRRender extends PostBaseRender
	{
		public var baseTexture:TextureBase;
		public var distortionTexture:TextureBase;
		public var texBloomTexture:TextureBase;
		public var texBloomFilterTexture:TextureBase;
		public var lumTexture:TextureBase;
		public var _lumProgram:Program3D;
		public var _bloomProgram:Program3D;
		public var _bloomFilterProgram:Program3D;
		public var _bloomYFilterProgram:Program3D;
		public var _hdrProgram:Program3D;
		public var _bloomResultProgram:Program3D;
		public var _baseWidth:int;
		public var _baseHeight:int;
		public var _bloomWidth:int;
		public var _bloomHeight:int;
		private var _lumBitmapdata:BitmapData;
		private var _lumBmp:Bitmap;
		private var _avaerage:Number = 0;
		
		public var bloomScale:Number = 0.5;
		
		public var bloomRang:Number = 0.5;
		
		public var hdrExposure:Number = 1;
		
		public var whiteNum:Number = 11.2;
		
		public var useHDR:Boolean;
		
		private var _useDistortion:Boolean;
		
		private var _usePs:Boolean;//开启调色
		private var _brightness:Number;//亮度
		private var _contrast:Number;//对比度
		private var _avaBrightness:Number;//平均亮度
		private var _saturation:Number;//饱和度
		
		private var _useVignette:Boolean;
		private var _vignetteUrl:String;
		private var _vignetteTexture:Texture;
		
		public function PostHDRRender(context3d:Context3D)
		{
			super(context3d);
			_program = Program3DManager.getInstance().getProgram(RenderToTextureShader.RENDER_TO_TEXTURESHADER);
			_lumProgram = Program3DManager.getInstance().getProgram(LumShader.LUMSHADER);
			_bloomProgram = Program3DManager.getInstance().getProgram(BloomShader.BLOOM_SHADER);
			_bloomFilterProgram = Program3DManager.getInstance().getProgram(BloomFilterShader.BLOOM_FILTER_SHADER);
			_bloomYFilterProgram = Program3DManager.getInstance().getProgram(BloomYFilterShader.Bloom_Y_FilterShader);
			_hdrProgram = Program3DManager.getInstance().getProgram(HDRShader.HDR_SHADER);
			//_bloomResultProgram = Program3DManager.getInstance().getProgram(BloomResultShader.BLOOM_RESULT_SHADER);
		}
		
		override public function update():void{
			
			_context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			
			renderBloom();
			renderBloomFilter();
			renderBloomYFilter();
//			renderBack();
			renderBloomResult();
//			if(useHDR){
//				renderHDR();
//			}else{
//				renderBloomResult();
//			}
			
		}
		
		public function setPsData(obj:Object):void{
			_usePs = obj.usePs;
			_brightness = obj.brightness;
			_contrast = obj.contrast;
			_avaBrightness = obj.avaBrightness;
			_saturation = obj.saturation;
			
			_useVignette = obj.vignette;
			
			_useDistortion = obj.distortion;
			
			if(_useVignette){
				processVignetteBmp(obj.vignetteRadius,obj.vignetteAlpha,obj.vignetteBlur);
			}
			
			
//			if(_useVignette){
//				trace(obj.vignetteUrl);
//			}
//			
//			_vignetteUrl = obj.vignetteUrl;
//			
//			if(_useVignette && _vignetteUrl){
//				vignetteUrl = _vignetteUrl;
//			}
			
			var shaderParamAry:Array = [_usePs,_useVignette,_useDistortion];
			
			_bloomResultProgram = Program3DManager.getInstance().getProgramByParam(BloomResultShader.BLOOM_RESULT_SHADER,shaderParamAry);
			
			applyPs();
		}
		
		private function processVignetteBmp(r:Number,alpha:Number,blurNum:Number):void{
			var baseNum:int = 128;
			var shape:Shape = new Shape;
			shape.graphics.clear();
			shape.graphics.beginFill(MathCore.argbToHex16(0xff * alpha,0xff * alpha,0xff * alpha));
			shape.graphics.drawRect(0,0,baseNum,baseNum);
			shape.graphics.drawCircle(baseNum/2,baseNum/2,r*baseNum*0.5);
			shape.graphics.endFill();
			
			var bitmapdata:BitmapData = new BitmapData(128,128,true,0xffffffff);
			bitmapdata.draw(shape);
			
//			var alpha:Number;
//			var ary:Array = new Array;
//			ary = ary.concat(alpha,0,0,0,0);
//			ary = ary.concat(0,alpha,0,0,0);
//			ary = ary.concat(0,0,alpha,0,0);
//			ary = ary.concat(0,0,0,1,0);
//			
//			var colorMatrix:ColorMatrixFilter;
//			colorMatrix = new ColorMatrixFilter(ary);
			
			var rec:Rectangle = new Rectangle(0,0,baseNum,baseNum);
			var p:Point = new Point();
			
//			bitmapdata.applyFilter(bitmapdata,rec,p,colorMatrix);
	
			var blurFilter:BlurFilter = new BlurFilter(blurNum,blurNum,BitmapFilterQuality.HIGH);
			bitmapdata.applyFilter(bitmapdata,rec,p,blurFilter);
			
			if(!_vignetteTexture){
				_vignetteTexture = _context3D.createTexture(baseNum,baseNum,Context3DTextureFormat.BGRA,false);
			}
			
			_vignetteTexture.uploadFromBitmapData(bitmapdata);
			
		}
		
		public function get vignetteUrl():String
		{
			return _vignetteUrl;
		}
		
		public function set vignetteUrl(value:String):void
		{
			_vignetteUrl = value;
			
			TextureManager.getInstance().addTexture(Scene_data.fileRoot + value,onTextureLoad,_vignetteUrl);
		}
		
		private function onTextureLoad($textureVo:TextureVo,str:String):void{
			_vignetteTexture = $textureVo.texture;
		}
		
		
		private var _psR:Vector3D = new Vector3D;
		private var _psG:Vector3D = new Vector3D;
		private var _psB:Vector3D = new Vector3D;
		public function applyPs():void{
			setV3dValue(_psR,_contrast * (0.3086 * (1-_saturation) + _saturation),0.6094*(1-_saturation),0.0820*(1-_saturation),_avaBrightness * (1 - _contrast) + _brightness);
			setV3dValue(_psG,0.3086 * (1-_saturation),_contrast * (0.6094*(1-_saturation) + _saturation),0.0820*(1-_saturation),_avaBrightness * (1 - _contrast) + _brightness);
			setV3dValue(_psB,0.3086 * (1-_saturation),0.6094*(1-_saturation),_contrast*(0.0820*(1-_saturation) + _saturation),_avaBrightness * (1 - _contrast) + _brightness);
		}
		
		private function setV3dValue(v3d:Vector3D,x:Number,y:Number,z:Number,w:Number):void{
			v3d.x = x;
			v3d.y = y;
			v3d.z = z;
			v3d.w = w;
		}
		
		private function renderBloomResult():void{
			_context3D.setRenderToBackBuffer();
			_context3D.configureBackBuffer(_baseWidth,_baseHeight,0);
			_context3D.clear(0,0,0,1);
			_context3D.setProgram(_bloomResultProgram);
			
			_context3D.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context3D.setTextureAt(0, baseTexture);
			_context3D.setTextureAt(1, texBloomTexture);
			
			if(_useVignette){
				_context3D.setTextureAt(2, _vignetteTexture);
			}
			
			if(_useDistortion){
				_context3D.setTextureAt(3, distortionTexture);
			}
			
			if(_usePs){
				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>([_psR.x,_psR.y,_psR.z,_psR.w]));
				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,1,Vector.<Number>([_psG.x,_psG.y,_psG.z,_psG.w]));
				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,2,Vector.<Number>([_psB.x,_psB.y,_psB.z,_psB.w]));
			}
			
			_context3D.drawTriangles(_objData.indexBuffer, 0, -1);
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setTextureAt(0,null);
			_context3D.setTextureAt(1,null);
			_context3D.setTextureAt(2,null);
			_context3D.setTextureAt(3,null);
			
			_context3D.present();
		}
		
		
		private function renderHDR():void{
			_context3D.setRenderToBackBuffer();
			_context3D.configureBackBuffer(_baseWidth,_baseHeight,0);
			_context3D.clear(0,0,0,1);
			_context3D.setProgram(_hdrProgram);
			
			var A:Number = 0.15;
			var B:Number = 0.50;
			var C:Number = 0.10;
			var D:Number = 0.20;
			var E:Number = 0.02;
			var F:Number = 0.30;
			var W:Number = 11.2;
			var whiteScale:Number = 1/Uncharted2Tonemap(whiteNum);
//			
//			float3 Uncharted2Tonemap(float3 x)
//			{
//				return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
//			}
			
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>([0.299,0.5870,0.1140,1]));
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,1,Vector.<Number>([_avaerage,hdrExposure,1/2.2,0]));
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,2,Vector.<Number>([A,C*B,D*E,B]));
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,3,Vector.<Number>([D*F,E/F,whiteScale,0]));
			
			
			_context3D.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context3D.setTextureAt(0, baseTexture);
			_context3D.setTextureAt(1, texBloomTexture);
			_context3D.drawTriangles(_objData.indexBuffer, 0, -1);
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setTextureAt(0,null);
			_context3D.setTextureAt(1,null);
			
			_context3D.present();
		}
		private function  Uncharted2Tonemap(x:Number):Number
		{
			var A:Number = 0.15;
			var B:Number = 0.50;
			var C:Number = 0.10;
			var D:Number = 0.20;
			var E:Number = 0.02;
			var F:Number = 0.30;
			return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
		}
		
		private function renderBloom():void{
			_context3D.setRenderToTexture(texBloomTexture,true);
			_context3D.clear(0,0,0,1);
			_context3D.setProgram(_bloomProgram);
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>([0.299,0.5870,0.1140,1]));
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,1,Vector.<Number>([bloomScale,bloomRang,0,0]));
			
			renderTexture(baseTexture);
		}
		
		private function renderBloomFilter():void{
			_context3D.setRenderToTexture(texBloomFilterTexture,true);
			_context3D.clear(0,0,0,1);
			_context3D.setProgram(_bloomFilterProgram);
			
			// 5 filter
			//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>([0.22163460022301817,0.18994016342562733,0.11955136722390616,0.0552650771070826]));
			//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,1,Vector.<Number>([0.01876313946403925,0.00467863026895464,0,0]));
			//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,2,Vector.<Number>([1/(_bloomWidth),2/(_bloomWidth),3/(_bloomWidth),4/(_bloomWidth)]));
			
			//8filter
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>([0.14775640014867877,0.13796194236277726,0.11230479402381788,0.07970091148260411]));
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,1,Vector.<Number>([0.04931218855185363,0.026599364703187196,0.012508759642692832,0.005128415782612627]));
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,2,Vector.<Number>([1/(_bloomWidth),2/(_bloomWidth),3/(_bloomWidth),4/(_bloomWidth)]));
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,3,Vector.<Number>([5/(_bloomWidth),6/(_bloomWidth),7/(_bloomWidth),8/(_bloomWidth)]));
			renderTexture(texBloomTexture);
		}
		
		private function renderBloomYFilter():void{
			_context3D.setRenderToTexture(texBloomTexture,true);
			_context3D.clear(0,0,0,1);
			_context3D.setProgram(_bloomYFilterProgram);
			// 5 filter
			//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>([0.22163460022301817,0.18994016342562733,0.11955136722390616,0.0552650771070826]));
			//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,1,Vector.<Number>([0.01876313946403925,0.00467863026895464,0,0]));
			//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,2,Vector.<Number>([1/(_bloomWidth),2/(_bloomWidth),3/(_bloomWidth),4/(_bloomWidth)]));
			
			//8filter
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>([0.14775640014867877,0.13796194236277726,0.11230479402381788,0.07970091148260411]));
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,1,Vector.<Number>([0.04931218855185363,0.026599364703187196,0.012508759642692832,0.005128415782612627]));
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,2,Vector.<Number>([1/(_bloomWidth),2/(_bloomWidth),3/(_bloomWidth),4/(_bloomWidth)]));
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,3,Vector.<Number>([5/(_bloomWidth),6/(_bloomWidth),7/(_bloomWidth),8/(_bloomWidth)]));
			
			renderTexture(texBloomFilterTexture);
		}
		
		private function renderLum():void{
			_context3D.setRenderToBackBuffer();
			_context3D.configureBackBuffer(50,50,0);
			_context3D.clear(0,0,0,1);
			_context3D.setProgram(_lumProgram);
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>([0.299,0.5870,0.1140,1]));
			
			renderTexture(baseTexture);
			
			_context3D.drawToBitmapData(_lumBitmapdata);
			
			getAverage();
		}
		
		private function getAverage():void{
			var color:Vector3D = new Vector3D;
			var allNum:Number = 0;
			for(var i:int;i<_lumBitmapdata.width;i++){
				for(var j:int=0;j<_lumBitmapdata.height;j++){
					MathCore.hexToArgbNum(_lumBitmapdata.getPixel(i,j),false,color);
					allNum += color.x;
				}
			}
			_avaerage = allNum/(_lumBitmapdata.width * _lumBitmapdata.height);
			//trace(_avaerage);
		}
		
		
		
		private function renderBack():void{
			_context3D.setRenderToBackBuffer();
			_context3D.configureBackBuffer(_baseWidth,_baseHeight,0);
			_context3D.clear(0,0,0,1);
			_context3D.setProgram(_program);
			renderTexture(texBloomTexture);
			_context3D.present();
		}
		
		public function renderTexture($texture:TextureBase):void{
			_context3D.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context3D.setTextureAt(0, $texture);
			_context3D.drawTriangles(_objData.indexBuffer, 0, -1);
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setTextureAt(0,null);
		}
		
		override protected function setVa() : void {
			_context3D.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context3D.setTextureAt(0, texBloomTexture);
			_context3D.drawTriangles(_objData.indexBuffer, 0, -1);
		}
		
		override protected function resetVa() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setTextureAt(0,null);
		}
		override protected function setVc() : void {
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>([1,0,0,1]));
		}
		
		public function initTexture($baseTexture:TextureBase,$distortionTexture:TextureBase,$width:int,$height:int):void{
			baseTexture = $baseTexture;
			distortionTexture = $distortionTexture;
			
			_baseWidth = $width;
			_baseHeight = $height;
			
			
			if(texBloomTexture){
				texBloomTexture.dispose();
			}
			
			_bloomWidth = $width/8;
			_bloomHeight = $height/8;
			
			texBloomTexture = _context3D.createRectangleTexture(_bloomWidth,_bloomHeight,Context3DTextureFormat.RGBA_HALF_FLOAT,true);
			
			
			if(texBloomFilterTexture){
				texBloomFilterTexture.dispose();
			}
			texBloomFilterTexture = _context3D.createRectangleTexture(_bloomWidth,_bloomHeight,Context3DTextureFormat.RGBA_HALF_FLOAT,true);
			
			if(lumTexture){
				lumTexture.dispose();
			}
			lumTexture = _context3D.createRectangleTexture(50,50,Context3DTextureFormat.RGBA_HALF_FLOAT,true);
			
			_lumBitmapdata = new BitmapData(50,50,false,0);
			
			if(!_lumBmp){
				_lumBmp = new Bitmap();
				//Scene_data.stage.addChild(_lumBmp);
			}
			//_lumBmp.bitmapData = _lumBitmapdata;
		}


		

		
	}
}