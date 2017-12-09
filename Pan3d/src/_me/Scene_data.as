package _me
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import PanV2.Stage3DVO;
	
	import _Pan3D.base.Camera3D;
	import _Pan3D.base.Focus3D;
	import _Pan3D.base.MouseVO;
	import _Pan3D.light.LightVo;
	import _Pan3D.light.RayTraceVo;
	import _Pan3D.texture.TextureCubeMapVo;
	import _Pan3D.vo.texture.TextureVo;
	
	
	
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class Scene_data
	{
		public static var listTxt:String="Pan3d.me";
		public static var drawNum:uint=0;
		public static var drawTriangle:uint=0;
		public static var fileRoot:String="";
		public static var md5Root:String="";
		private static var _particleRoot:String = "";
		/**
		 * buff文件的根目录 (这个在游戏启动时, 会由2D层传递过来) 
		 */		
		public static var buffRoot:String="";
		
		public static var objRoot:String;
		
		public static var framenum:Number=60;//游戏帧率
		public static var root:MovieClip;
		public static var stage:Stage;
		public static var stage3D:Stage3D;
		public static var context3D:Context3D;
		public static var program3D:Program3D;
		public static var texShadowMap:Texture;
		public static var sunMatrix:Matrix3D=new Matrix3D();
		public static var viewMatrx3D:Matrix3D;
		public static var topViewMatrx3D:Matrix3D
		private static var _antiAlias:int = 0;//抗锯齿等级
		private static var _gameAngle:int = 0;//游戏角度
		private static var _effectsLev:int = 0;//游戏特效等级
		
		
		public static var cam3D:Camera3D=new Camera3D(new Object);
		public static var sun3D:Camera3D=new Camera3D(new Object);
		public static var light3D:Camera3D=new Camera3D(new Object);
		
		public static var focus3D:Focus3D=new Focus3D;
		public static var shake3D:Vector3D = new Vector3D;
		public static var focus2D:Vector3D = new Vector3D;
		public static var lightCathPos:Vector3D=new Vector3D;
		public static var mouseInfo:MouseVO=new MouseVO();
		public static var shaderDictionary:Array=new Array();
		
		public static var ready:Boolean=false;
		
		
		
		public static var radd:Number=0;
		public static var gadd:Number=0;
		public static var badd:Number=0;
		
		public static var buildChooseTexture:Texture;
		public static var sceneLightText:Texture;
		public static var groundLightText:Texture;
		public static var shenduText:Texture;
		public static var bowenText:Texture;
		public static var bowenNrmText:Texture;
		
		public static var totalNum:int=0;
		public static var canScanShader:int=30;
		public static var stageWidth:int=1024;
		public static var stageHeight:int=600;
		public static var groundHightBitMapData:BitmapData//用512*512;
		public static var frameTime:Number = 1000/60;
		
		
		public static var sw2D:Number=1
		public static var tx2D:Number=1
		public static var ty2D:Number=1
		public static var sinAngle2D:Number=1;
		public static const default_mainScale:Number = 2.55;//默认的角色和特效大小缩放比例
	
		
		
		public static function get fogAttenuation():Number
		{
			return _fogAttenuation;
		}

		public static function set fogAttenuation(value:Number):void
		{
			_fogAttenuation = value;
		}

		public static function get gameAngle():int
		{
			return _gameAngle;
		}

		public static function set gameAngle(value:int):void
		{
			_gameAngle = value;
		}

		public static function get effectsLev():int
		{
			return _effectsLev;
		}

		public static function set effectsLev(value:int):void
		{
			_effectsLev = value;
			
		}

		/**
		 * 粒子文件的根目录(这个在游戏启动时, 会由2D层传递过来) 
		 */
		public static function get particleRoot():String
		{
			return _particleRoot;
		}

		/**
		 * @private
		 */
		public static function set particleRoot(value:String):void
		{
			_particleRoot = value;
		}

		public static function get fogDistance():Number
		{
			return _fogDistance;
		}

		public static function set fogDistance(value:Number):void
		{
			_fogDistance = value;
		}

		public static function get antiAlias():int
		{
			return _antiAlias;
		}
		
		public static function set antiAlias(value:int):void
		{
			_antiAlias = value;
		}
		
		public static function get mainScale():Number{return default_mainScale*mainRelateScale}
		public static function set mainScale(value:Number):void{mainRelateScale = value/default_mainScale};
		public static var mainRelateScale:Number = 1;//全局缩放比例（坐标等）
		//		public static var mainStaffScale:Number = 2.55;
		//		public static var mainRelateScale:Number = 1;
		public static var sceneViewHW:uint=1000; //这个作为屏幕约束比例 。对于镜头存像，以及鼠拾取都有关联
		
		public static var isDevelop:Boolean = false;
		/**
		 * 粒子是否为二进制造模型
		 */	
		public static var sourceObj:Boolean = true;
		
		public static var uiCamAngle:int = 0;
		/**
		 * 缓存时间 
		 */		
		public static var cacheTime:int = 2000;
		
		public static var cacheSkillTime:int = 600;
		
		/**
		 * 是否使用二进制文件
		 */		
		public static var fileByteMode:Boolean = false;
		/**
		 * openGL显卡 
		 */		
		public static var isOpenGL:Boolean = false;
		/**
		 * 0表示默认渲染模式 1表示无阴影黑色背景 
		 */		
		public static var rendMode:int = 1;
		
		public static var shadowType:int = 2;
		/**
		 * 加载优先级的阈值 (当优先级大于该数值的时候，自动跳过排队)
		 */		
		public static var loadPriorityThreshold:int = int.MAX_VALUE;
		
		public static var is3D:Boolean;
		/**
		 * 引擎版本号 
		 */		
		public static var version:int = 33; 
		
		public static var allBuffNum:int;
		
		//public static var light:Vector3D = new Vector3D(1,1,1,0);
		
		public static var shockFun:Function;
		/**
		 * 精简buffer的模式 
		 */		
		public static var compressBuffer:Boolean = false;
		
		public static var lockFollow:Boolean = false;
		
		public static var light:LightVo;
		
		public static var skyCubeMap:TextureCubeMapVo;
		
		public static var prbLutTexture:TextureVo;
		
		public static var stage3DVO:Stage3DVO=new Stage3DVO()
		
		public static var selectVec:Vector3D;
		
		public static var fogColor:Vector3D = new Vector3D(72/255,171/255,190/255);
		private static var _fogDistance:Number = 20;
		private static var _fogAttenuation:Number = 0.2;
		public static var fogShowObj:Object;//是否显示雾效(有无)
		
		
		public static var showTexture:Boolean = true;
		public static var showLightmap:Boolean = true;
		public static var rayTraceVo:RayTraceVo = new RayTraceVo;
		
		
		public static function loadModeOk(str:String):void
		{
			totalNum++;
		}
		
		public static function get disposed():Boolean
		{
			return context3D.driverInfo == "Disposed" || context3D.driverInfo == "";
		}
	}
}
