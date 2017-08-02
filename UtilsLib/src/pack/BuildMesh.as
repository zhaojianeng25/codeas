package pack
{
	import interfaces.ITile;

	public class BuildMesh extends ModePropertyMesh implements ITile
	{

		private var _fileNode:Object;
		private var _url:String
		private var _prefabStaticMesh:PrefabStaticMesh
		
		
		private var _captureId:uint;
		//private var _isGroundHight:Boolean;
		private var  _isPerspective:Boolean
		
		private var _lightMapSize:int;
		private var _groupMaterialId:int;
		private var _lightBlur:uint;
		private var _isNotCook:Boolean;
		private var _lightProbe:Boolean;
		private var _isGround:Boolean;
		

		




		public function get groupMaterialId():int
		{
			return _groupMaterialId;
		}
	//	[Editor(type="Number",Label="材质Group",Step="1",sort="4",MinNum="-1",MaxNum="999",Category="属性",Tip="范围")]
		public function set groupMaterialId(value:int):void
		{
			_groupMaterialId = value;
			
			change();
		}

		public function readObject():Object
		{
			var $obj:Object=new Object
			$obj.url=_url
			$obj.captureId=_captureId

			$obj.lightMapSize=_lightMapSize
			$obj.lightBlur=_lightBlur
			$obj.isNotCook=_isNotCook
			$obj.isGround=_isGround
			$obj.groupMaterialId=_groupMaterialId
			$obj.isPerspective=_isPerspective
			$obj.lightProbe=_lightProbe
			return $obj
		}
		public function clone():BuildMesh
		{
			var $buildMesh:BuildMesh=new BuildMesh
			$buildMesh.url=_url
			$buildMesh.captureId=_captureId

			$buildMesh.lightMapSize=_lightMapSize
			$buildMesh.lightBlur=_lightBlur;
			$buildMesh.isNotCook=_isNotCook;
			$buildMesh.isGround=_isGround;
			$buildMesh.groupMaterialId=_groupMaterialId;
			$buildMesh.isPerspective=_isPerspective
			$buildMesh.lightProbe=_lightProbe
			$buildMesh.prefabStaticMesh=_prefabStaticMesh
			return $buildMesh
		}
		
		
		
		public function BuildMesh()
		{
			super();
		}

		public function get prefabStaticMesh():PrefabStaticMesh
		{
			return _prefabStaticMesh;
		}

		public function set prefabStaticMesh(value:PrefabStaticMesh):void
		{
			_prefabStaticMesh = value;
		}

		public function get captureId():uint
		{
			return _captureId;
		}
	//	[Editor(type="CaptureIdUi",Label="captureId",extensinonStr="capture.CaptureStaticMesh",Step="1",sort="5",Category="属性",Tip="范围")]
		public function set captureId(value:uint):void
		{
			_captureId = value;
			
			change();
		}
		public function get isGround():Boolean
		{
			return _isGround;
		}
	//	[Editor(type="ComboBox",Label="设为地面",sort="1",Category="属性",Data="{name:false,data:false}{name:true,data:true}",Tip="是否当地形用来扫描高度")]
		public function set isGround(value:Boolean):void
		{
			_isGround = value;
			change();
		}

		public function get isNotCook():Boolean
		{
			return _isNotCook;
		}
	//	[Editor(type="ComboBox",Label="参与烘培",sort="1",Category="属性",Data="{name:false,data:false}{name:true,data:true}",Tip="是否当地形用来扫描高度")]
		public function set isNotCook(value:Boolean):void
		{
			_isNotCook = value;
			change();
		}
		
		public function get isPerspective():Boolean
		{
			return _isPerspective;
		}
		[Editor(type="ComboBox",Label="穿透对象",sort="4",Category="属性",Data="{name:false,data:false}{name:true,data:true}",Tip="是否当地形用来扫描高度")]
		public function set isPerspective(value:Boolean):void
		{
			_isPerspective = value;
			change();
		}
		
		public function get lightProbe():Boolean
		{
			return _lightProbe;
		}
		[Editor(type="ComboBox",Label="lightProbe",sort="3",Category="属性",Data="{name:false,data:false}{name:true,data:true}",Tip="是否当地形用来扫描高度")]
		public function set lightProbe(value:Boolean):void
		{
			_lightProbe = value;
			change();
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}


		public function get lightMapSize():int
		{
			return _lightMapSize;
		}
		[Editor(type="ComboBox",Label="贴图尺寸",sort="2",Category="属性",Data="{name:32,data:32}{name:64,data:64}{name:128,data:128}{name:256,data:256}{name:512,data:512}{name:1024,data:1024}",Tip="2的幂")]
		public function set lightMapSize(value:int):void
		{
			_lightMapSize = value;
			change();
		}

		
		public function get lightBlur():uint
		{
			return _lightBlur;
		}
		[Editor(type="Number",Label="灯光模糊",Step="1",sort="4",MinNum="0",MaxNum="20",Category="属性",Tip="范围")]
		public function set lightBlur(value:uint):void
		{

			_lightBlur = value;
			change();
		}

		
	}
}