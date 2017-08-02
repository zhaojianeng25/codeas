package modules.hierarchy
{
	import flash.events.Event;
	
	import mx.controls.Alert;
	
	import common.utils.ui.file.FileNode;
	
	import light.LightStaticMesh;
	
	import mode3d.Model3DStaticMesh;
	
	import pack.BuildMesh;
	import pack.PrefabStaticMesh;
	
	import particle.ParticleStaticMesh;
	
	import proxy.top.model.IModel;
	import proxy.top.render.Render;
	
	public class HierarchyFileNode extends FileNode
	{
		public var type:uint;      //0 文件夹, 1prefab,2light
		public var iModel:IModel
		public var treeSelect:Boolean
		public var lock:Boolean
		public var isHide:Boolean
		
//		public var lightMapSize:uint
//		public var isGroundHight:Boolean
//		public var lightBlur:uint
//		public var captureId:uint
//		public var isNotCook:Boolean
		
		
		public function HierarchyFileNode()
		{
			super();
		}
		public function  clone($newxtId:uint):HierarchyFileNode
		{
			var $temp:HierarchyFileNode=new HierarchyFileNode()
			$temp.id=$newxtId
			$temp.type=this.type;
			$temp.treeSelect=this.treeSelect;
			$temp.lock=this.lock;
			$temp.name=this.name;
			$temp.path=this.path;
			$temp.url=this.url;
			$temp.extension=this.extension;
			$temp.rename=this.rename;
			$temp.isHide=this.isHide;
		
			$temp.data=this.data;
			
			if(this.data is BuildMesh){
				$temp.data=BuildMesh(this.data).clone()
				$temp.iModel=Render.creatDisplay3DModel(BuildMesh($temp.data).prefabStaticMesh,$temp.id)
			}
			if(this.data is PrefabStaticMesh){
				$temp.iModel=Render.creatDisplay3DModel(PrefabStaticMesh($temp.data),$temp.id)
				Alert.show("不可能再到这里")	
			}
			if(this.data is Model3DStaticMesh){
				$temp.iModel=Render.creatDisplay3DModel3D(Model3DStaticMesh($temp.data))
			}
			if(this.data is LightStaticMesh){
				$temp.data=LightStaticMesh(this.data).clone()
				$temp.iModel=Render.creatLightModel(LightStaticMesh($temp.data))
			}
			if(this.data is ParticleStaticMesh){
				$temp.data=ParticleStaticMesh(this.data).clone()
				$temp.iModel=Render.creatParticle(ParticleStaticMesh($temp.data))
			}
			if($temp.iModel){
				$temp.iModel.x=this.iModel.x
				$temp.iModel.y=this.iModel.y
				$temp.iModel.z=this.iModel.z
				$temp.iModel.scaleX=this.iModel.scaleX
				$temp.iModel.scaleY=this.iModel.scaleY
				$temp.iModel.scaleZ=this.iModel.scaleZ
				$temp.iModel.rotationX=this.iModel.rotationX
				$temp.iModel.rotationY=this.iModel.rotationY
				$temp.iModel.rotationZ=this.iModel.rotationZ
			}

			return $temp
		}
		public function showOrHide():void
		{
			iModel.visible=!isHide
		}
		public function changeEvent():void
		{
			this.dispatchEvent(new Event(Event.CHANGE));
		}
	}
}