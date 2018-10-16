package common.utils.ui.collision
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.CollisionVo;
	import _Pan3D.base.ObjData;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	
	import common.AppData;
	import common.msg.event.collision.MEvent_Collision;
	import common.utils.ui.prefab.PreFabModelPic;
	import common.utils.ui.txt.TextVec3Input;
	
	import modules.hierarchy.h5.HitObjAnaly;

	public class CollisionPolygonMesh extends CollisionBaseMesh
	{

		private var _hitObjlPic:PreFabModelPic;
		private var _scaleTxt:TextVec3Input;

		public function CollisionPolygonMesh()
		{
			super();

			
			_hitObjlPic=new PreFabModelPic();
			_hitObjlPic.titleLabel = "请选取obj";
			_hitObjlPic.extensinonStr= "obj"
				
			_hitObjlPic.FunKey = "polygonUrl"


				
				
			this.addChild(_hitObjlPic)
			_hitObjlPic.y=75
				

				
			_scaleTxt = new TextVec3Input;
			_scaleTxt.label="比例:"
			this.addElement(_scaleTxt)
			_scaleTxt.y=50
			_scaleTxt.x=-20
			
			addEvents();
			
		}
		
		public function get polygonUrl():String
		{
			return _collisionVo.polygonUrl;
		}

		public function set polygonUrl(value:String):void
		{

			_collisionVo.polygonUrl=value
			var loaderinfo : LoadInfo = new LoadInfo(AppData.workSpaceUrl+_collisionVo.polygonUrl, LoadInfo.XML, onObjLoad,0);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
			
		}
		protected function onObjLoad(str : String) : void {
			var a:HitObjAnaly=new HitObjAnaly();
			var $objData:ObjData=a.analysis(str);
			for(var i:uint=0;i<$objData.vertices.length/3;i++){
				$objData.vertices[i*3+2]=-$objData.vertices[i*3+2]
			}
			var obj:Object=new Object;
			obj.indexs=$objData.indexs
			obj.vertices=$objData.vertices
			_collisionVo.data=obj;
			dispatchEvent(new Event(Event.CHANGE));
			
			//ModuleEventManager.dispatchEvent(new MEvent_Collision(MEvent_Collision.CHANGE_COLLISION_PYOLYGONMODEL));
		}
	
		private function addEvents():void
		{
			
			_scaleTxt.addEventListener(Event.CHANGE,onScaleChange)

		}
		
		protected function onScaleChange(event:Event):void
		{
			_collisionVo.scale_x=_scaleTxt.ve3Data.x;
			_collisionVo.scale_y=_scaleTxt.ve3Data.y;
			_collisionVo.scale_z=_scaleTxt.ve3Data.z;
			ModuleEventManager.dispatchEvent(new MEvent_Collision(MEvent_Collision.CHANGE_COLLISION_POSTION));
			
		}
		
		override public function set collisionVo(value:CollisionVo):void
		{
			super.collisionVo=value;
			_scaleTxt.ve3Data=new Vector3D(_collisionVo.scale_x,_collisionVo.scale_y,_collisionVo.scale_z)
				
			_hitObjlPic.target=this;
			_hitObjlPic.refreshViewValue();
			

		}
		
		
	}
}