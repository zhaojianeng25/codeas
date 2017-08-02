package modules.collision
{
	import com.zcp.frame.Module;
	import com.zcp.frame.event.ModuleEvent;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.controls.Alert;
	
	import PanV2.loadV2.ObjsLoad;
	
	import _Pan3D.display3D.model.Display3DModelSprite;
	import _Pan3D.scene.SceneContext;
	
	import collision.CollisionMesh;
	
	import common.msg.event.collision.MEvent_Collision;
	import common.msg.event.prefabs.MEvent_Objs_Show;
	import common.utils.frame.BaseProcessor;
	import common.utils.frame.MetaDataView;
	import common.utils.ui.collision.CollisionNode;
	import common.vo.editmode.EditModeEnum;
	
	import manager.LayerManager;
	
	import modules.scene.SceneEditModeManager;
	
	import render.NewKeyControl;
	
	public class CollisionProcessor extends BaseProcessor
	{
		public function CollisionProcessor($module:Module)
		{
			super($module);
		}
		override protected function listenModuleEvents():Array 
		{
			return [
				MEvent_Collision,
				MEvent_Objs_Show
			]
		}
		
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				
				case MEvent_Objs_Show:
					var $mMEvent_Objs_Show:MEvent_Objs_Show= $me as MEvent_Objs_Show
					if($mMEvent_Objs_Show.action==MEvent_Objs_Show.MEVENT_OBJS_SHOW){
						showObjsMesh($mMEvent_Objs_Show)
					}
					break;
				case MEvent_Collision:
					var $eMEvent_Collision:MEvent_Collision= $me as MEvent_Collision
					if($eMEvent_Collision.action==MEvent_Collision.SELECET_COLLISION_VO){
					   selectMoveCollision($eMEvent_Collision.collisionNode)
					}
					if($eMEvent_Collision.action==MEvent_Collision.CHANGE_COLLISION_POSTION){
						CollisionLevel.getInstance().changeCollisionPostion()
					}
					if($eMEvent_Collision.action==MEvent_Collision.CHANGE_COLLISION_PYOLYGONMODEL){
						CollisionLevel.getInstance().resetData();
					}
					if($eMEvent_Collision.action==MEvent_Collision.SAVE_COLLISION_TO_OBJS){
						saveCollistionToObjs()
					}
					if($eMEvent_Collision.action==MEvent_Collision.SHOW_SCENE_COLLISTION){
						showSceneCollision()
					}
					if($eMEvent_Collision.action==MEvent_Collision.HIDE_SCENE_COLLISTION){
						hideSceneCollision()
					}
					break;
			}
		}
		private function hideSceneCollision():void
		{
			Display3DModelSprite.collistionState=false;
			
			for(var i:uint=0;i<SceneContext.sceneRender.modelLevel.modelItem.length;i++)
			{
				var d:Display3DModelSprite=SceneContext.sceneRender.modelLevel.modelItem[i];
				d.showCollision()
			}
		}
		private function showSceneCollision():void
		{
			Display3DModelSprite.collistionState=!Display3DModelSprite.collistionState
	
			for(var i:uint=0;i<SceneContext.sceneRender.modelLevel.modelItem.length;i++)
			{
				var d:Display3DModelSprite=SceneContext.sceneRender.modelLevel.modelItem[i];
		        d.showCollision()
			}
			
		}
		
		private function saveCollistionToObjs():void
		{

			
			if(_collisionMesh){

				var $file:File=new File(_collisionMesh.url)//objs文件地址
				var $fs:FileStream = new FileStream;
				$fs.open($file,FileMode.WRITE);
				
				
				var a:Object=new Object;
				a.indexs=_collisionMesh.indexs;
				a.vertices=_collisionMesh.vertices
				a.uvs=_collisionMesh.uvs;
				a.lightUvs=_collisionMesh.lightUvs;
				a.normals=_collisionMesh.normals;
				a.item=_collisionMesh.item;
				a.friction=_collisionMesh.friction;
				a.restitution=_collisionMesh.restitution;
				a.isField=_collisionMesh.isField;
				a.url=$file.url;
				
				
				$fs.writeObject(a);
				$fs.close();
				
		
				Alert.show("保存objs.Collision完毕");
				
			}
			
		}

		private function selectMoveCollision($CollisionNode:CollisionNode):void
		{

			if(_collisionMesh){
				CollisionDisplay3DSprite.showTriModel=_collisionMesh.showTriModel
			}
			
			CollisionLevel.getInstance().selectCollisionNode=$CollisionNode
				

			
		}
		public function showCollision($collisionMesh:CollisionMesh):void{
			if(!_collisionPanel){
				_collisionPanel = new CollisionPanel;
				_collisionPanel.init(this,"碰状",1);
				
				NewKeyControl.getInstance().init(_collisionPanel)
			}
			LayerManager.getInstance().addPanel(_collisionPanel);

			SceneEditModeManager.changeMode(EditModeEnum.EDIT_COLLISION)

			CollisionLevel.getInstance().collisionMesh=$collisionMesh
			
		}
		private var _objsMeshView:MetaDataView;
		private var _collisionPanel:CollisionPanel;
		private var _collisionMesh:CollisionMesh;
		private function showObjsMesh($mMEvent_Objs_Show:MEvent_Objs_Show):void
		{

			var $url:String=$mMEvent_Objs_Show.url
			
			if($url){
				
				if(!_objsMeshView){
					_objsMeshView = new MetaDataView();
					_objsMeshView.init(this,"属性",2);
					_objsMeshView.creatByClass(CollisionMesh);
				}
				var $file:File=new File($url)
				 _collisionMesh=new CollisionMesh
				_collisionMesh.name=$file.name
				
				if($file.exists){
					var $fs:FileStream = new FileStream;
					$fs.open($file,FileMode.READ);
					var obj:Object=$fs.readObject();
					_collisionMesh.indexs=obj.indexs;
					_collisionMesh.vertices=obj.vertices
					_collisionMesh.uvs=obj.uvs;
					_collisionMesh.lightUvs=obj.lightUvs;
					_collisionMesh.normals=obj.normals;
					_collisionMesh.trinum=_collisionMesh.indexs.length/3;
					_collisionMesh.friction=Number(obj.friction?obj.friction:0.1)
					_collisionMesh.restitution=Number(obj.restitution?obj.restitution:0.1)
					_collisionMesh.isField=Boolean(obj.isField);
					_collisionMesh.url=$file.url;
					
					_collisionMesh.showTriModel=CollisionDisplay3DSprite.showTriModel
					_collisionMesh.item=ObjsLoad.getCollisionItem(obj.item);

					showCollision(_collisionMesh);
					
				}
				

		
				LayerManager.getInstance().showPropPanle(_objsMeshView);
				_objsMeshView.setTarget(_collisionMesh);
			}
			
		}
		
	
		
		
	}
}