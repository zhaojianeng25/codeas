package modules.lightProbe
{
	import com.zcp.frame.Module;
	import com.zcp.frame.event.ModuleEvent;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.msg.event.collision.MEvent_Collision;
	import common.msg.event.prefabs.MEvent_Objs_Show;
	import common.msg.event.scene.MEvent_ADD_LightProbe;
	import common.utils.frame.BaseProcessor;
	import common.utils.frame.MetaDataView;
	import common.utils.ui.file.FileNodeManage;
	import common.vo.editmode.EditModeEnum;
	
	import light.LightProbeTempStaticMesh;
	import light.LightProbeViewMesh;
	
	import manager.LayerManager;
	
	import proxy.pan3d.light.ProxyPan3DTempLightProbe;
	import proxy.top.model.IModel;
	import proxy.top.model.ITempLightProbe;
	import proxy.top.render.Render;
	
	import xyz.draw.TooXyzMoveData;
	
	public class LightProbeProcessor extends BaseProcessor
	{
		public function LightProbeProcessor($module:Module)
		{
			super($module);
			addEvents();
		}
		override protected function listenModuleEvents():Array 
		{
			return [
				MEvent_ADD_LightProbe,
				MEvent_Objs_Show
			]
		}
		
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			
			switch($me.getClass()) {
				case MEvent_ADD_LightProbe:
					var $mEvent_ADD_LightProbe:MEvent_ADD_LightProbe=$me as MEvent_ADD_LightProbe;
					if($mEvent_ADD_LightProbe.action==MEvent_ADD_LightProbe.MEVENT_ADD_LIGHTPROBE)
					{
						var $lightProbeId:uint=FileNodeManage.getFileNodeNextId(LightProbeEditorManager.getInstance().listArr);
						LightProbeEditorManager.getInstance().addLightProbe($lightProbeId)
					}
					break;
			}
		}
		private function addEvents():void
		{
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
			
		}
		private function get mouseInStage3D():Boolean
		{
			var $rect:Rectangle=new Rectangle(0,0,Scene_data.stage3DVO.width,Scene_data.stage3DVO.height)
			return $rect.containsPoint(new Point(Scene_data.stage3DVO.mouseX,Scene_data.stage3DVO.mouseY));
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			if((event.ctrlKey||event.shiftKey) &&AppData.editMode==EditModeEnum.EDIT_LIGHTPROBE&&mouseInStage3D){
				var $lightProbeModel:IModel=Render.getMouseHitLightProbeModel(new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY))
				if($lightProbeModel){
					if(event.ctrlKey||!_lightPorbeItem){
						_lightPorbeItem=new Vector.<IModel>;
					}
				
					var $needAdd:Boolean=true
					for(var i:uint=0;i<_lightPorbeItem.length;i++)
					{
						if(_lightPorbeItem[i]==$lightProbeModel){
							$needAdd=false
						}
					}
					if($needAdd){
						_lightPorbeItem.push($lightProbeModel)
					}
					showTempLightProbe(_lightPorbeItem)
				}
				
			}
			
		}
		private var _lightPorbeItem:Vector.<IModel>=new Vector.<IModel>;
		private var _tempLightProbeDataView:MetaDataView;
		private function showTempLightProbe($iModelArr:Vector.<IModel>):void
		{
			var $lightProbeViewMesh:LightProbeViewMesh=new LightProbeViewMesh();

			//ProxyPan3DTempLightProbe;
			
	
			if(!_tempLightProbeDataView){
				_tempLightProbeDataView = new MetaDataView();
				_tempLightProbeDataView.init(this,"属性",2);
				_tempLightProbeDataView.creatByClass(LightProbeViewMesh);
			}
			LayerManager.getInstance().showPropPanle(_tempLightProbeDataView);
			_tempLightProbeDataView.setTarget($lightProbeViewMesh);
			

			var tooXyzMoveData:TooXyzMoveData=Render.xyzPosMoveItem($iModelArr);
			tooXyzMoveData.dataChangeFun=xyzMoveDataChange
			xyzMoveDataChange()
			function xyzMoveDataChange():void
			{
				$lightProbeViewMesh.isUse= ProxyPan3DTempLightProbe($iModelArr[0]).lightProbeTempStaticMesh.isUse
				$lightProbeViewMesh.postion=new Vector3D(tooXyzMoveData.x,tooXyzMoveData.y,tooXyzMoveData.z)
			}
			$lightProbeViewMesh.addEventListener(Event.CHANGE,onMeshChange)
			function onMeshChange(event:Event):void
			{
				tooXyzMoveData.x=$lightProbeViewMesh.postion.x
				tooXyzMoveData.y=$lightProbeViewMesh.postion.y
				tooXyzMoveData.z=$lightProbeViewMesh.postion.z
					
			   for(var i:uint=0;i<$iModelArr.length;i++){
				   ProxyPan3DTempLightProbe($iModelArr[i]).lightProbeTempStaticMesh.isUse=$lightProbeViewMesh.isUse;
			   }
				if(Boolean(tooXyzMoveData.dataUpDate)){
					tooXyzMoveData.dataUpDate()
					if(Boolean(tooXyzMoveData.fun)){
						tooXyzMoveData.fun(tooXyzMoveData);
					}
				}
			}
		}
	}
}