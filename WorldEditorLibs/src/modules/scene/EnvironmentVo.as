package modules.scene
{
	import proxy.top.render.Render;
	

	public class EnvironmentVo
	{
		private var _openLater:Boolean   //是否开起后期
		private var _highlightNum:Number //高光
		private  var _highLightRang:Number;
		private var _openHdr:Boolean
		private var _exposureNum:Number//曝光
		private var _whiteBalance:Number//曝光
		
		private var _usePs:Boolean;//开启调色
		private var _brightness:Number;//亮度
		private var _contrast:Number;//对比度
		private var _avaBrightness:Number;//平均亮度
		private var _saturation:Number;//饱和度
		private var _vignette:Boolean;
		private var _vignetteUrl:String;
		private var _vignetteRadius:Number;
		private var _vignetteBlur :Number;
		private var _vignetteAlpha:Number;
		private var _distortion:Boolean;
//		虚光半径 vignetteRadius 0-2
//		虚光模糊 vignetteBlur 0-128
//		虚光alpha vignetteAlpha 0-1
		private static var instance:EnvironmentVo;
		public function EnvironmentVo()
		{
		}


		public function get vignetteAlpha():Number
		{
			return _vignetteAlpha;
		}

		public function set vignetteAlpha(value:Number):void
		{
			_vignetteAlpha = value;
			Render.setEnvironment(readObject())
		}

		public function get vignetteBlur():Number
		{
			return _vignetteBlur;
		}

		public function set vignetteBlur(value:Number):void
		{
			_vignetteBlur = value;
			Render.setEnvironment(readObject())
		}

		public function get vignetteRadius():Number
		{
			return _vignetteRadius;
		}

		public function set vignetteRadius(value:Number):void
		{
			_vignetteRadius = value;
			Render.setEnvironment(readObject())

		}

		public function get vignette():Boolean
		{
			return _vignette;
		}

		public function set vignette(value:Boolean):void
		{
			_vignette = value;
			Render.setEnvironment(readObject())
		}

		public function get vignetteUrl():String
		{
			return _vignetteUrl;
		}

		public function set vignetteUrl(value:String):void
		{
			_vignetteUrl = value;
			Render.setEnvironment(readObject())
		}

		public function get openHdr():Boolean
		{
			return _openHdr;
		}

		public function set openHdr(value:Boolean):void
		{
			_openHdr = value;
			Render.setEnvironment(readObject())
		}

		public function get whiteBalance():Number
		{
			return _whiteBalance;
		}

		public function set whiteBalance(value:Number):void
		{
			_whiteBalance = value;
			Render.setEnvironment(readObject())
		}

		public function get openLater():Boolean
		{
			return _openLater;
		}

		public function set openLater(value:Boolean):void
		{
			_openLater = value;
			Render.setEnvironment(readObject())
		}

		public function get highlightNum():Number
		{
			return _highlightNum;
		}

		public function set highlightNum(value:Number):void
		{
			_highlightNum = value;
			Render.setEnvironment(readObject())
		}
		
		public function get highLightRang():Number
		{
			return _highLightRang;
		}
		
		public function set highLightRang(value:Number):void
		{
			_highLightRang = value;
			Render.setEnvironment(readObject())
		}

		public function get exposureNum():Number
		{
			return _exposureNum;
		}

		public function set exposureNum(value:Number):void
		{
			_exposureNum = value;
			Render.setEnvironment(readObject())
		}
		
		public function get usePs():Boolean
		{
			return _usePs;
		}
		
		public function set usePs(value:Boolean):void
		{
			_usePs = value;
			Render.setEnvironment(readObject())
		}
		
		public function get brightness():Number
		{
			return _brightness;
		}
		
		public function set brightness(value:Number):void
		{
			_brightness = value;
			Render.setEnvironment(readObject())
		}
		
		public function get contrast():Number
		{
			return _contrast;
		}
		
		public function set contrast(value:Number):void
		{
			_contrast = value;
			Render.setEnvironment(readObject())
		}
		
		public function get avaBrightness():Number
		{
			return _avaBrightness;
		}
		
		public function set avaBrightness(value:Number):void
		{
			_avaBrightness = value;
			Render.setEnvironment(readObject())
		}
		
		public function get saturation():Number
		{
			return _saturation;
		}
		
		public function set saturation(value:Number):void
		{
			_saturation = value;
			Render.setEnvironment(readObject())
		}
		
		public function get distortion():Boolean
		{
			return _distortion;
		}
		
		public function set distortion(value:Boolean):void
		{
			_distortion = value;
			Render.setEnvironment(readObject())
		}

		public static function getInstance():EnvironmentVo{
			if(!instance){
				instance = new EnvironmentVo();
			}
			return instance;
		}
		public function objToEnvironment($obj:Object):void
		{
			
			if($obj&&$obj.distortion){
				_distortion=$obj.distortion
			}else{
				_distortion=false
			}

			if($obj&&$obj.openLater){
				_openLater=$obj.openLater
			}else{
				_openLater=false
			}
			if($obj&&$obj.highlightNum){
				_highlightNum=$obj.highlightNum
			}else{
				_highlightNum=0.5
			}
			if($obj&&$obj.highLightRang){
				_highLightRang=$obj.highLightRang
			}else{
				_highLightRang=0.5
			}
			if($obj&&$obj.openHdr){
				_openHdr=$obj.openHdr
			}else{
				_openHdr=false
			}
			if($obj&&$obj.exposureNum){
				_exposureNum=$obj.exposureNum
			}else{
				_exposureNum=2
			}
			if($obj&&$obj.whiteBalance){
				_whiteBalance=$obj.whiteBalance
			}else{
				_whiteBalance=10
			}

			if($obj && $obj.usePs){
				_usePs = $obj.usePs;
			}else{
				_usePs = false;
			}
			
			if($obj && $obj.brightness){
				_brightness = $obj.brightness;
			}else{
				_brightness = 0;
			}
			
			if($obj && $obj.contrast){
				_contrast = $obj.contrast;
			}else{
				_contrast = 1;
			}
			
			if($obj && $obj.avaBrightness){
				_avaBrightness = $obj.avaBrightness;
			}else{
				_avaBrightness = 0.5;
			}
			
			if($obj && $obj.saturation){
				_saturation = $obj.saturation;
			}else{
				_saturation = 1;
			}
			if($obj && $obj.vignette){
				_vignette = $obj.vignette;
			}else{
				_vignette = false;
			}
			if($obj && $obj.vignetteUrl){
				_vignetteUrl = $obj.vignetteUrl;
			}else{
				_vignetteUrl = "";
			}
			if($obj && $obj.vignetteRadius){
				_vignetteRadius = $obj.vignetteRadius;
			}else{
				_vignetteRadius = 1
			}
			if($obj && $obj.vignetteBlur){
				_vignetteBlur = $obj.vignetteBlur;
			}else{
				_vignetteBlur = 10
			}
		
			if($obj && $obj.vignetteAlpha){
				_vignetteAlpha = $obj.vignetteAlpha;
			}else{
				_vignetteAlpha =0.5
			}
			
			Render.setEnvironment(readObject())
		}
		//		虚光半径 vignetteRadius 0-2
		//		虚光模糊 vignetteBlur 0-128
		//		虚光alpha vignetteAlpha 0-1
		public function readObject():Object
		{
			var $obj:Object=new Object;
			$obj.openLater=openLater;
			$obj.highlightNum=highlightNum;
			$obj.exposureNum=exposureNum;
			$obj.whiteBalance=whiteBalance;
			$obj.openHdr=openHdr;
			$obj.highLightRang=highLightRang;
			
			$obj.usePs = usePs;
			$obj.brightness = brightness;
			$obj.contrast = contrast;
			$obj.avaBrightness = avaBrightness;
			$obj.saturation = saturation;
			$obj.vignette = vignette;
			$obj.vignetteRadius = vignetteRadius;
			$obj.vignetteBlur = vignetteBlur;
			$obj.vignetteAlpha = vignetteAlpha;
			$obj.vignetteUrl = vignetteUrl;
			$obj.distortion = distortion;
				

			return $obj
		}




	}
}