package mode3d
{
	import flash.events.Event;
	
	import materials.Material;
	
	import pack.Prefab;

	public class Model3DStaticMesh extends Prefab
	{

		private var _modelName:String
		private var _modelXFileCsvID:int
		private var _textureID:int	
		private var _material:Material;
		private var _xFileModel3D:XFileMode3DStaticMesh
		
		public function Model3DStaticMesh()
		{
		}

		public function readObject():Object
		{
			var $obj:Object=new Object
			$obj.csvID=csvID
			$obj.modelName=_modelName
			$obj.modelXFileCsvID=_modelXFileCsvID
			$obj.textureID=_textureID
			return $obj
		}


		public function get textureID():int
		{
			return _textureID;
		}
		public function set textureID(value:int):void
		{
			_textureID = value;
		}
		public function get modelName():String
		{
			return _modelName;
		}
		public function set modelName(value:String):void
		{
			_modelName = value;
		}
		public function get xFileModel3D():XFileMode3DStaticMesh
		{
			return _xFileModel3D;
		}
		[Editor(type="MaterialImg",Label="动作xFile",donotDubleClik="1",extensinonStr="mode3d.XFileMode3DStaticMesh",sort="1",changePath="0",Category="模型")]
		public function set xFileModel3D(value:XFileMode3DStaticMesh):void
		{
			
			
			if(_xFileModel3D != value){
				if(_xFileModel3D){
					_xFileModel3D.removeEventListener(Event.CHANGE,onMaterialChange)
				}
				_xFileModel3D = value;
				_xFileModel3D.addEventListener(Event.CHANGE,onXfileChange);
				
				change();
				
			}
		}
		protected function onXfileChange(event:Event):void
		{
			change();
		}
		
		public function get material():Material
		{
			return _material;
		}
		[Editor(type="MaterialImg",Label="材质",donotDubleClik="1",extensinonStr="materials.Material",sort="5",changePath="0",Category="材质")]
		public function set material(value:Material):void
		{
			if(_material != value){
				if(_material){
					_material.removeEventListener(Event.CHANGE,onMaterialChange)
				}
				_material = value;
				_material.addEventListener(Event.CHANGE,onMaterialChange);
			
				change();
				
			}
		}
		protected function onMaterialChange(event:Event):void
		{
			
			change();
			
	
			
			
		}

		override public function getName():String
		{
			return _modelName
			return "Model3D_"+csvID;;
		}


		public function get modelXFileCsvID():int
		{
			return _modelXFileCsvID;
		}
		
		public function set modelXFileCsvID(value:int):void
		{
			_modelXFileCsvID = value;
		}
		public function change():void{
		
			this.dispatchEvent(new Event(Event.CHANGE));
		}


	



	}
}