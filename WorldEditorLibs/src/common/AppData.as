package common
{
	import flash.display.Scene;
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	
	import _Pan3D.core.MathCore;
	
	import _me.Scene_data;
	
	
	public class AppData
	{
		[Bindable]
		public static var appTitle:String = "";
		
		public static var light:Object;
		public static var environment:Object;
		public static var terrain:Object;
		public static var hierarchyList:Object;
		public static var fog:Object;
		public static var rayTraceVo:Object

		
		private static var _workSpaceUrl:String;
		private static var _expSpaceUrl:String;
		public static var mapUrl:String;
		public static var type:int;  //0a3d,1pan3d
		public static var editMode:String;
		public static var fileSort:Boolean=false;
		public static var showObjs:Boolean=false

		//public static var defaultMaterialUrl:String="CSV/texture/Texture3D/default.material"
		public static var defaultMaterialUrl:String="assets/white.material"
		//public static var mapName:String;
		public static var RenderSocketUrl:String="127.0.0.1"
	
		public static  var Ambient_light_intensity:Number=-1;
		public static  var Ambient_light_Size:Number=1;
		public static  var Shadow_precision:Number=1
		public static  var patch_precision:Number=0.25
		public static  var patch_num:Number=1
		public static  var openAo:Boolean=false;
		public static  var Ao_Range:Number=0.1
		public static  var Ao_strength:Number=0.25;
		
		public static var mainWindow:Sprite;
			

		
		
//		环境光亮度 0.25
//		阴影精度 1.0 
//		patch精度0.25 
//		光线传递次数 1 
//		开启AO false
//		AO范围 0.1
//		AO强度 0.1
			
		public static function get expSpaceUrl():String
		{
			return _expSpaceUrl;
		}

		public static function set expSpaceUrl(value:String):void
		{
			_expSpaceUrl = value;
		}

		public static function get workSpaceUrl():String
		{
			return _workSpaceUrl;
		}

		public static function set workSpaceUrl(value:String):void
		{
			_workSpaceUrl = value;
		}

		public static function readObject():Object{
			
		
			var obj:Object = new Object;
			obj.light = light;
			obj.terrain = terrain;
			obj.hierarchyList = hierarchyList;
			obj.environment = environment;
			obj.fog=fog;
			obj.rayTraceVo=rayTraceVo;
			
			
			obj.Ambient_light_intensity=Ambient_light_intensity
			obj.Ambient_light_Size=Ambient_light_Size
			obj.Shadow_precision=Shadow_precision
			obj.patch_precision=patch_precision
			obj.patch_num=patch_num
			obj.openAo=openAo
			obj.Ao_Range=Ao_Range
			obj.Ao_strength=Ao_strength
			
			

			return obj;
		}
		public static function writeObject(obj:Object):void{
			light = obj.light;
			terrain = obj.terrain;
			hierarchyList = obj.hierarchyList;
			environment = obj.environment;
			fog = obj.fog;
			readFog(fog)
		
			rayTraceVo = obj.rayTraceVo;
			readRayTraceVo(rayTraceVo)
	

			if(obj.hasOwnProperty("Ambient_light_intensity")){
				Ambient_light_intensity=obj.Ambient_light_intensity
				Ambient_light_Size=obj.Ambient_light_Size
				Shadow_precision=obj.Shadow_precision
				patch_precision=obj.patch_precision
				patch_num=obj.patch_num
				openAo=obj.openAo
				Ao_Range=obj.Ao_Range
				Ao_strength=obj.Ao_strength
			}else{
				AppData.Ambient_light_intensity=MathCore.argbToHex(255,255*0.1,255*0.1,255*0.1);
			}
			
				
	
		}
		private static function readRayTraceVo($obj:Object):void
		{
			
			if($obj){
				Scene_data.rayTraceVo.envImg=$obj.envImg
				Scene_data.rayTraceVo.useEnvColor=$obj.useEnvColor
				Scene_data.rayTraceVo.envColor.x=$obj.envColor.x
				Scene_data.rayTraceVo.envColor.y=$obj.envColor.y
				Scene_data.rayTraceVo.envColor.z=$obj.envColor.z
				Scene_data.rayTraceVo.envColor.w=$obj.envColor.w
				Scene_data.rayTraceVo.usePbr=$obj.usePbr
				Scene_data.rayTraceVo.useIBL=$obj.useIBL
				Scene_data.rayTraceVo.atlis=$obj.atlis
			}
		}
		public static function writeRayTraceVo():void
		{
			rayTraceVo=new Object;
			rayTraceVo.envImg=Scene_data.rayTraceVo.envImg
			rayTraceVo.useEnvColor=Scene_data.rayTraceVo.useEnvColor
			rayTraceVo.envColor=Scene_data.rayTraceVo.envColor
			rayTraceVo.usePbr=Scene_data.rayTraceVo.usePbr
			rayTraceVo.useIBL=Scene_data.rayTraceVo.useIBL
			rayTraceVo.atlis=Scene_data.rayTraceVo.atlis
			

			
		}
		private static function readFog($obj:Object):void
		{
			if($obj){
				Scene_data.fogDistance=fog.fogDistance 
				Scene_data.fogAttenuation=fog.fogAttenuation
				
				Scene_data.fogColor.x=$obj.fogColor.x
				Scene_data.fogColor.y=$obj.fogColor.y
				Scene_data.fogColor.z=$obj.fogColor.z
					
					
				Scene_data.gameAngle=$obj.gameAngle  //游戏角度也写在雾效里
			}
	
			Scene_data.fogShowObj=new Object
			Scene_data.fogShowObj.tempfogDistance=Scene_data.fogDistance
			Scene_data.fogShowObj.tempfogAttenuation=Scene_data.fogAttenuation
			Scene_data.fogDistance=40000;
			Scene_data.fogAttenuation=0;
		}
		
		public static function writeFog():void
		{
			fog=new Object;
			if(Scene_data.fogShowObj){
				Scene_data.fogDistance=Scene_data.fogShowObj.tempfogDistance
				Scene_data.fogAttenuation=Scene_data.fogShowObj.tempfogAttenuation
			}
			fog.fogColor = Scene_data.fogColor
			fog.fogDistance = Scene_data.fogDistance;
			fog.fogAttenuation =Scene_data.fogAttenuation
				
			fog.gameAngle =Scene_data.gameAngle
		
		
		}

	}
}