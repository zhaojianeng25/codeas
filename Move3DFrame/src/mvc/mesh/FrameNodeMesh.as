
package  mvc.mesh
{
	import flash.geom.Vector3D;
	
	import common.AppData;
	
	import modules.prefabs.PrefabManager;
	
	import mvc.frame.view.FrameFileNode;
	
	import pack.ModePropertyMesh;
	import pack.PrefabStaticMesh;
	
	public class FrameNodeMesh extends ModePropertyMesh
	{


		private var _frameFileNode:FrameFileNode;

	
		public function FrameNodeMesh()
		{
			super();
		}

		public function get frameFileNode():FrameFileNode
		{
			return _frameFileNode;
		}

		public function set frameFileNode(value1:FrameFileNode):void
		{
			_frameFileNode = value1;
			
			this.postion=new Vector3D(_frameFileNode.iModel.x,_frameFileNode.iModel.y,_frameFileNode.iModel.z);
			this.scaleVec=new Vector3D(_frameFileNode.iModel.scaleX,_frameFileNode.iModel.scaleY,_frameFileNode.iModel.scaleZ);
			this.rotationVec=new Vector3D(_frameFileNode.iModel.rotationX,_frameFileNode.iModel.rotationY,_frameFileNode.iModel.rotationZ);
		}

		public function get modeUrl():String
		{
			return _frameFileNode.url;
		}
		[Editor(type="PreFabImg",Label="模型地址",extensinonStr="prefab",sort="9",changePath="0",Category="模型")]
		public function set modeUrl(value:String):void
		{
			_frameFileNode.url = value;
			
			var $url:String=AppData.workSpaceUrl+	_frameFileNode.url
			var _prefab:PrefabStaticMesh=PrefabManager.getInstance().getPrefabByUrl($url);
			
			if(_prefab){
				trace("换模型")
				_frameFileNode.name=_prefab.name.replace(".prefab","");
				_frameFileNode.iModel.prefab=_prefab
			
			}

			change();
		}
		
		public function get receiveShadow():Boolean
		{
			return _frameFileNode.receiveShadow;
		}
		[Editor(type="ComboBox",Label="接受阴影",sort="11",Category="属性",Data="{name:false,data:false}{name:true,data:true}",Tip="")]
		public function set receiveShadow(value:Boolean):void
		{
			_frameFileNode.receiveShadow = value;
			change();
		}
		
		public function get textureSize():int
		{
			return _frameFileNode.lightuvSize;
		}
		[Editor(type="ComboBox",Label="贴图尺寸",sort="3",Category="属性",Data="{name:32,data:32}{name:64,data:64}{name:128,data:128}{name:256,data:256}{name:512,data:512}{name:1024,data:1024}",Tip="2的幂")]
		public function set textureSize(value:int):void
		{
			_frameFileNode.lightuvSize = value;
			change();
		}
		public function refishPostion():void
		{
			this.postion.x=_frameFileNode.iModel.x

		
		}

		override public function getName():String
		{
			// TODO Auto Generated method stub
			return _frameFileNode.name;
		}
	
		
		
	}
}