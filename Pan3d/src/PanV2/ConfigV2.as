package  PanV2
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import _me.Scene_data;

	public class ConfigV2
	{
		private static var instance:ConfigV2;
		private var config_end:Function;
		public static function getInstance():ConfigV2
		{
			return instance?instance:new ConfigV2();
		}
		public function init(_stage : Stage, _config_end : Function,reConfigFun:Function = null,errorFun:Function=null) : void {
			config_end = _config_end;
			Scene_data.stage=_stage;
			stageAlign();
			
			Scene_data.stage3D = Scene_data.stage.stage3Ds[0];
			Scene_data.stage3D.addEventListener(Event.CONTEXT3D_CREATE, myContext3DHandler);
			Scene_data.stage3D.requestContext3D(Context3DRenderMode.AUTO,Context3DProfile.STANDARD);
			Scene_data.ready = true;
	
		}
		private  function myContext3DHandler(evt : Event) : void {
			Scene_data.context3D = Scene_data.stage3D.context3D;
			configAntiAlias(2)
			config_end();
		}

		/**
		 * 
		 * @param antiAlias  抗锯齿组别
		 * @param w 宽度
		 * @param h 高度
		 * 
		 */
		public  function configAntiAlias($antiAlias:uint,w:uint=600,h:uint=600):void{
			
			Scene_data.antiAlias=$antiAlias
			var $num:uint=0
			switch($antiAlias)
			{
				case 0:
					$num= 0;
					break;
				case 1:
					$num = 2;
					break;
				case 2:
					$num = 4;
					break;
				case 3:
					$num = 16;
					break;
				default:
					$num = 0;
					break;
			}
			if(w<100||h<100||w>3000||h>3000)
			{
				return;
			}
			
			try{

				Scene_data.context3D.configureBackBuffer(w,h,$num, true);

			}catch(e:Error){
				throw e;
			}
		}
		/**
		 *设计窗口为左上对齐，不缩放 
		 */
		private function stageAlign():void
		{
			Scene_data.stage.align=StageAlign.TOP_LEFT
			Scene_data.stage.scaleMode=StageScaleMode.NO_SCALE
	
		}
		
		
		
	}
}