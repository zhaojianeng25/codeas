package exph5
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Vector3D;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import PanV2.loadV2.ObjsLoad;
	
	import _Pan3D.base.ObjData;
	
	import _me.Scene_data;
	
	import common.AppData;
	
	import modules.prefabs.PrefabManager;
	
	import mvc.frame.view.FrameFileNode;
	
	import pack.PrefabStaticMesh;

	public class ChangObjsNrmModel
	{
		private static var instance:ChangObjsNrmModel;
		public function ChangObjsNrmModel()
		{
		}
		public static function getInstance():ChangObjsNrmModel{
			if(!instance){
				instance = new ChangObjsNrmModel();
			}
			return instance;
		}
		public var selectNode:FrameFileNode;
		private var type:Number=1
		public function changeByUrl(value:Number=1):void
		{
			this.type=value
			if(this.selectNode){
				var $prefabMesh:PrefabStaticMesh=PrefabManager.getInstance().getPrefabByUrl(AppData.workSpaceUrl+this.selectNode.url);
				_editPreUrl=AppData.workSpaceUrl+	$prefabMesh.axoFileName
				Alert.show("转换先中对象法线"+this._editPreUrl,"提示",Alert.YES | Alert.NO,null,	function onClose(evt:CloseEvent):void
				{
					if(evt.detail == Alert.YES){
						ObjsLoad.getInstance().addSingleLoad(_editPreUrl,objsFun)
					}
				});
			}else{
				Alert.show("请先中转换对象")
			}
			



		}
		private var _editPreUrl:String
		protected function objsFun($objData:ObjData):void
		{
			var wirteObjData:Object=new Object
			wirteObjData.vertices=$objData.vertices;
			wirteObjData.uvs=$objData.uvs;
			wirteObjData.lightUvs=$objData.lightUvs
			wirteObjData.indexs=$objData.indexs
			wirteObjData.normals=new Vector.<Number>
			for(var i:Number=0;i<$objData.normals.length/3;i++){
				var p:Vector3D=new Vector3D($objData.normals[i*3+0],$objData.normals[i*3+1],$objData.normals[i*3+2]);
				if(type==1){
					wirteObjData.normals.push(p.x,p.z,p.y);
				}
				if(type==2){
					wirteObjData.normals.push(p.x,p.y*-1,p.z);
				}
				if(type==3){
					wirteObjData.normals.push(p.x,p.y,p.z*-1);
				}
			//	wirteObjData.normals.push(0,1,0);
			}	
			$objData.normals=wirteObjData.normals
			if($objData.normals){
				$objData.normalsBuffer = Scene_data.context3D.createVertexBuffer($objData.normals.length / 3, 3);
				$objData.normalsBuffer.uploadFromVector(Vector.<Number>($objData.normals), 0, $objData.normals.length / 3);
			}
			var fs:FileStream = new FileStream;
			fs.open(new File(_editPreUrl),FileMode.WRITE);
			fs.writeObject(wirteObjData);
			fs.close();
			trace("转换完成"+_editPreUrl)
		}
	}
}