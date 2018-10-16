package _me {
	import flash.display.Stage;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.Event;
	
	import _Pan3D.program.Program3DManager;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class Config {
		private static var config_end : Function;
		
		private static var reLoadConfig:Function;
		
		private static var softModeFunction:Function;
		
		private static var hasCofig:Boolean;

		/**
		 * 初始化3D引擎 
		 * @param _stage 舞台
		 * @param _config_end 引擎初始化完成回调
		 * @param reConfigFun 重新配置回调
		 * @param softModeFun 不能正确初始化回调 1表示未开启硬件加速 2驱动不支持 3表示其他错误
		 * 
		 */		
		public static function init(_stage : Stage, _config_end : Function,reConfigFun:Function = null,errorFun:Function=null) : void {
			
			config_end = _config_end;
			Scene_data.stage = _stage;
			Scene_data.stage3D = Scene_data.stage.stage3Ds[0];
			Scene_data.stage3D.addEventListener(Event.CONTEXT3D_CREATE, myContext3DHandler);
			Scene_data.stage3D.requestContext3D();
			reLoadConfig = reConfigFun;
			softModeFunction = errorFun;
		}
		private static function myContext3DHandler(evt : Event) : void {
			Scene_data.context3D = Scene_data.stage3D.context3D;
			
			if(Scene_data.context3D.driverInfo.indexOf("Software") != -1 && Boolean(softModeFunction)){
				if(Scene_data.context3D.driverInfo.indexOf("Direct blitting") != -1  || Scene_data.context3D.driverInfo.indexOf("userDisabled") != -1){
					softModeFunction(1);
				}else if(Scene_data.context3D.driverInfo.indexOf("oldDriver") != -1 || Scene_data.context3D.driverInfo.indexOf("unavailable") != -1){
					softModeFunction(2);
				}else{
					softModeFunction(3);
				}
			}
			
			if(Scene_data.context3D.driverInfo == "OpenGL"){
				Scene_data.isOpenGL = true;
			}
			
//			if(Capabilities.version.indexOf("MAC") != -1){
//				Scene_data.isOpenGL = true;
//			}
			
			restConfigContext3D();
			Scene_data.ready = true;
			Program3DManager.getInstance().initReg();
			if(hasCofig){
				reLoadConfig();
			}else{
				config_end();
			}
			hasCofig = true;
		}
		public static function restConfigContext3D():void
		{
			Scene_data.context3D.configureBackBuffer(1024, 600, Scene_data.antiAlias, true); 
			Scene_data.context3D.setCulling(Context3DTriangleFace.NONE);
			
		}
		/**
		 * 配置抗锯齿等级 
		 * @param antiAlias 抗锯齿等级 0,1,2,3四个等级
		 * 
		 */		
		public static function configAntiAlias(antiAlias:int):void{
			switch(antiAlias)
			{
				case 0:
					Scene_data.antiAlias = 0;
					break;
				case 1:
					Scene_data.antiAlias = 2;
					break;
				case 2:
					Scene_data.antiAlias = 4;
					break;
				case 3:
					Scene_data.antiAlias = 16;
					break;
				default:
					Scene_data.antiAlias = 0;
					break;
				
			}
			try{
				Scene_data.context3D.configureBackBuffer(Scene_data.stageWidth, Scene_data.stageHeight,Scene_data.antiAlias, true);
			}catch(e:Error){
				if(!Scene_data.disposed){
					throw e;
				}
			}
			
		}
		
		public static function dynamicConfig():void{
			
		}
		

	}
}
