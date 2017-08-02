package modules.enginConfig
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import PanV2.loadV2.BmpLoad;
	import PanV2.xyzmove.lineTriV2.LineTri3DSprite;
	
	import _Pan3D.display3D.reflection.Display3DReflectionSprite;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.msg.event.engineConfig.MEventStageResize;
	import common.msg.event.engineConfig.MEvent_Config;
	import common.msg.event.projectSave.MEvent_ProjectData;
	import common.msg.event.terrain.MEvent_init_Terrain;
	import common.vo.editmode.EditModeEnum;
	
	import modules.scene.SceneEditModeManager;
	
	import proxy.top.render.Render;
	
	import render.grass.GrassManager;
	import render.ground.GroundManager;
	
	import terrain.GroundData;
	
	public class EngineConfigProcessor extends Processor
	{
	

		public function EngineConfigProcessor($module:Module)
		{
			super($module);
		}
		
		override protected function listenModuleEvents():Array 
		{
			return [
				MEvent_Config,
				MEventStageResize
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
				switch($me.getClass()) {
					case MEvent_Config:
						init();

						break;
					case MEventStageResize:
						resize($me as MEventStageResize)

						break;
				}
		}
		private function resize(evt:MEventStageResize):void
		{
			if(Scene_data.context3D){

				Render.changeStage3DView(evt.xpos,evt.ypos,evt.width,evt.height)
					
		
				
					
			}
		}

		private function init():void
		{
			
			
			Scene_data.cam3D.distance = 250;
			Scene_data.focus3D.angle_x = -45;
			Scene_data.focus3D.angle_y = -45;
			Scene_data.focus3D.x = -100;
			Scene_data.focus3D.y = 200;
			Scene_data.focus3D.z = -100;
			
			
			Scene_data.cam3D.x=0
			Scene_data.cam3D.y=300
			Scene_data.cam3D.z=-300
			Scene_data.cam3D.rotationX=-45	
			Scene_data.cam3D.rotationY=0	
				
				
//			Scene_data.cam3D.x=0
//			Scene_data.cam3D.y=300
//			Scene_data.cam3D.z=-300
//			Scene_data.cam3D.rotationX=-45	
//			Scene_data.cam3D.rotationY=0
//				
//				
//			Scene_data.cam3D.x=300
//			Scene_data.cam3D.y=300
//			Scene_data.cam3D.z=-300
//			Scene_data.cam3D.rotationX=-45	
//			Scene_data.cam3D.rotationY=0

			var $stage:Stage=Scene_data.stage

			$stage.addChild(ShowMc.getInstance())

			LineTri3DSprite.thickNessScale=3
			
	
				
			ModuleEventManager.dispatchEvent( new MEvent_init_Terrain(MEvent_init_Terrain.MEVENT_INIT_TERRAIN));
			ModuleEventManager.dispatchEvent( new MEvent_ProjectData(MEvent_ProjectData.PROJECT_INIT));
			
			SceneEditModeManager.changeMode(EditModeEnum.EDIT_WORLD)
			
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			Scene_data.stage.addEventListener(Event.ENTER_FRAME,onEnterFrame)
				
		
				
			//TooSelectRotationModel.showMc=ShowMc.getInstance()
			Display3DReflectionSprite.ShowMc=ShowMc.getInstance()

		    var dis:Sprite=new Sprite
			Scene_data.stage.addChild(dis)
			//Render.setAlertMainWin(dis)
					
		}
		
		protected function onEnterFrame(event:Event):void
		{
		
			return ;
			GroundManager.getInstance().upData()			
			GrassManager.getInstance().upData()
			
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			if(!Scene_data.viewMatrx3D){
				return 
			}
			var hitPos:Vector3D=GroundManager.getInstance().getMouseHitGroundPostion();
			if(hitPos){
				var Area_Size:uint=GroundData.cellScale*GroundData.terrainMidu*4;
				var cellNumX:uint=GroundData.cellNumX;
				var cellNumZ:uint=GroundData.cellNumZ;
				var $pos:Vector3D=hitPos.subtract(new Vector3D((Area_Size*cellNumX)/2,0,(Area_Size*cellNumZ)/2))
				GroundData.groundHitPos=$pos
			}
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode==Keyboard.T){
		
				
				
				
			}
		}
		
	}
}