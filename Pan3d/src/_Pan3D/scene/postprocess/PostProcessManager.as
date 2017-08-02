package _Pan3D.scene.postprocess
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.RectangleTexture;
	
	import _Pan3D.program.Program3DManager;

	public class PostProcessManager
	{
		private var _context3D:Context3D;
		private var _imgWidth:int;
		private var _imgHeight:int;
		
		public var outTexture:RectangleTexture;
		
		public var outDistortionTexture:RectangleTexture;
		
		private var _hdrPostRender:PostHDRRender;
		
		public var useDistortion:Boolean;
		
		private static var _instance:PostProcessManager;
		public function PostProcessManager()
		{
			
		}
		
		public static function getInstance():PostProcessManager{
			if(!_instance){
				_instance = new PostProcessManager;
			}
			return _instance;
		}
		
		public function init(context:Context3D):void{
			this._context3D = context;
			Program3DManager.getInstance().registe(RenderToTextureShader.RENDER_TO_TEXTURESHADER,RenderToTextureShader);
			Program3DManager.getInstance().registe(LumShader.LUMSHADER,LumShader);
			Program3DManager.getInstance().registe(BloomShader.BLOOM_SHADER,BloomShader);
			Program3DManager.getInstance().registe(BloomFilterShader.BLOOM_FILTER_SHADER,BloomFilterShader);
			Program3DManager.getInstance().registe(BloomYFilterShader.Bloom_Y_FilterShader,BloomYFilterShader);
			Program3DManager.getInstance().registe(HDRShader.HDR_SHADER,HDRShader);
			Program3DManager.getInstance().registe(BloomResultShader.BLOOM_RESULT_SHADER,BloomResultShader);
			_hdrPostRender = new PostHDRRender(_context3D);
		}
		
		public function setHDRBloomScale(value:Number):void{
			_hdrPostRender.bloomScale = value;
		}
		
		public function setHDRBloomRang(value:Number):void{
			_hdrPostRender.bloomRang = value;
		}
		
		public function setHDRExposure(value:Number):void{
			_hdrPostRender.hdrExposure = value;
		}
		
		public function setHDRWhite(value:Number):void{
			_hdrPostRender.whiteNum = value;
		}
		
		public function setUseHDR(value:Boolean):void{
			_hdrPostRender.useHDR = value;
		}
		
		
		public function setPsData(value:Object):void{
			_hdrPostRender.setPsData(value);
			
			useDistortion = value.distortion;
		}
		
		public function resize($width:int,$height:int):void{
			if($width <= 0 || $height <= 0){
				_imgWidth = 128;
				_imgHeight = 128;
			}else{
				_imgWidth = $width;
				_imgHeight = $height;
			}
			
			
			initTexture();
		}
		
		private function initTexture():void{
			if(outTexture){
				outTexture.dispose();
			}
			
			if(outDistortionTexture){
				outDistortionTexture.dispose()
			}
			
			outTexture = _context3D.createRectangleTexture(_imgWidth,_imgHeight,Context3DTextureFormat.RGBA_HALF_FLOAT,true);
			
			outDistortionTexture = _context3D.createRectangleTexture(_imgWidth/4,_imgHeight/4,Context3DTextureFormat.RGBA_HALF_FLOAT,true);
			
			_hdrPostRender.initTexture(outTexture,outDistortionTexture,_imgWidth,_imgHeight);
			
		}
		
		public function update():void{
			_hdrPostRender.update();
		}
		
		
		
	}
}