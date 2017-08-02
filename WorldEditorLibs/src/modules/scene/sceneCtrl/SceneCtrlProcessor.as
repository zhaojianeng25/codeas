package modules.scene.sceneCtrl
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import mx.controls.Alert;
	
	import _Pan3D.display3D.ground.ModelHasDepthSprite;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.msg.event.MEvent_baseShowHidePanel;
	import common.msg.event.scene.MEvent_ShowSceneCtrl;
	import common.msg.event.scene.MEvent_ShowSceneProp;
	import common.msg.event.scene.MEvent_Show_Imodel;
	import common.msg.event.scene.Mevent_Reader_Scene;
	import common.vo.editmode.EditModeEnum;
	
	import manager.LayerManager;
	
	import modules.brower.fileTip.RayTraceImageWindow;
	
	import proxy.top.model.IModel;
	import proxy.top.render.Render;
	
	import render.NewKeyControl;
	
	import xyz.MoveScaleRotationLevel;
	
	public class SceneCtrlProcessor extends Processor
	{
		private var _sceneCtrlView:SceneCtrlView;

		
		
		public function SceneCtrlProcessor($module:Module)
		{
			super($module);
			
			Render.selectModelFun=selectModelFun
		}
		
		
		
		public function get sceneCtrlView():SceneCtrlView
		{
			if(!_sceneCtrlView){
				_sceneCtrlView = new SceneCtrlView;
				_sceneCtrlView.init(this,"场景",1);
				
				NewKeyControl.getInstance().init(_sceneCtrlView)
			}
			return _sceneCtrlView;
		}
		
		public function showHide($me:MEvent_baseShowHidePanel):void
		{
			if($me.action == MEvent_baseShowHidePanel.SHOW){
				LayerManager.getInstance().addPanel(sceneCtrlView);
			}
		}
		
		private function toReaderScene():void
		{
		
			
		}
		
		override protected function listenModuleEvents():Array 
		{
			return [
				Mevent_Reader_Scene,
				MEvent_ShowSceneCtrl
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case MEvent_ShowSceneCtrl:
					showHide($me as MEvent_ShowSceneCtrl);
					initData();
					break;
				case Mevent_Reader_Scene:
					toReaderScene()
					break;
			}
		}
		
		private function initData():void
		{
		
			addEvents();
			
		}
		
		private function addEvents():void
		{
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
		
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove)
				
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp)

		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			if(AppData.editMode==EditModeEnum.EDIT_WORLD){
				 if(this.lastMousePos){
					
					if(this.mouseLineSprite.parent){
						this.mouseLineSprite.graphics.clear()
					}
					var $rect:Rectangle=getMouseRect()
					
					if($rect.width<1||$rect.height<1){
						selectCtrlMouseDown(event)
					}else{
						
						$rect.x-=Scene_data.stage3DVO.x
						$rect.y-=Scene_data.stage3DVO.y
						var evt:MEvent_Show_Imodel=new MEvent_Show_Imodel(MEvent_Show_Imodel.MEVENT_SELECT_ITEM_IMODEL);
						evt.item=Render.getRectHitModel($rect);
						evt.shiftKey=event.shiftKey
						ModuleEventManager.dispatchEvent(evt);
					}
						
						
			
					
	
				}
			
			}
			
			this.lastMousePos=null;
			
		}
		
	
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.G)//enter
			{
				ModelHasDepthSprite.editSee=!ModelHasDepthSprite.editSee
				
			}
			
		}
		private var mouseLineSprite:Sprite=new Sprite
		protected function onMouseMove(event:MouseEvent):void
		{
		

			if(this.lastMousePos&&AppData.editMode==EditModeEnum.EDIT_WORLD){
				
				if(!this.mouseLineSprite.parent){
					Scene_data.stage.addChild(this.mouseLineSprite)
				}
				this.mouseLineSprite.graphics.clear()
				this.mouseLineSprite.graphics.lineStyle(1,0xFFFFFF,0.5)
				this.mouseLineSprite.graphics.beginFill(0xFFFFFF,0.2);
				
				var $rect:Rectangle=getMouseRect()
				this.mouseLineSprite.graphics.drawRect($rect.x,$rect.y,$rect.width,$rect.height);
				this.mouseLineSprite.graphics.endFill();
				
				
			}
		}		
		private function getMouseRect():Rectangle
		{
			var rect:Rectangle=new Rectangle;
			rect.x=Math.min(this.lastMousePos.x,Scene_data.stage.mouseX);
			rect.y=Math.min(this.lastMousePos.y,Scene_data.stage.mouseY);
			rect.width=Math.abs(this.lastMousePos.x-Scene_data.stage.mouseX);
			rect.height=Math.abs(this.lastMousePos.y-Scene_data.stage.mouseY);
			
			return rect
		}
	
		private function get mouseInStage3D():Boolean
		{
			var $rect:Rectangle=new Rectangle(0,0,Scene_data.stage3DVO.width,Scene_data.stage3DVO.height)
			return $rect.containsPoint(new Point(Scene_data.stage3DVO.mouseX,Scene_data.stage3DVO.mouseY));
		}
		private function selectModelFun($iModel:IModel):void
		{
			trace("selectModelFun",$iModel)
			
			Alert.show("selectModelFun")
			
			var evt:MEvent_Show_Imodel=new MEvent_Show_Imodel(MEvent_Show_Imodel.MEVENT_SHOW_IMODEL);
			evt.iModel=$iModel;
			evt.shiftKey=false
			ModuleEventManager.dispatchEvent(evt);
			
			
		}
		private var lastMousePos:Point;
		protected function onMouseDown(event:MouseEvent):void
		{

			if(mouseInStage3D&&AppData.editMode==EditModeEnum.EDIT_WORLD){

				_sceneCtrlView.setFocus()
			}
			if(!MoveScaleRotationLevel.getInstance().useIt &&AppData.editMode==EditModeEnum.EDIT_WORLD&&mouseInStage3D){
				this.lastMousePos=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY)
			}
	
			
		}
		private function selectCtrlMouseDown(event:MouseEvent):void
		{
		
			if((event.ctrlKey||event.shiftKey) &&AppData.editMode==EditModeEnum.EDIT_WORLD&&mouseInStage3D){
				var $iModel:IModel=Render.getMouseHitModel(new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY))
				if($iModel){
					var evt:MEvent_Show_Imodel=new MEvent_Show_Imodel(MEvent_Show_Imodel.MEVENT_SHOW_IMODEL);
					evt.iModel=$iModel;
					evt.shiftKey=event.shiftKey
					ModuleEventManager.dispatchEvent(evt);
					
					
				}else{
					
					ModuleEventManager.dispatchEvent( new MEvent_ShowSceneProp(MEvent_baseShowHidePanel.SHOW));
				}
			}
		}

		
	}
}