package light
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import interfaces.ITile;
	
	import materials.Material;
	import materials.MaterialTree;
	
	import pack.ModePropertyMesh;
	
	public class LightProbeStaticMesh extends ModePropertyMesh implements ITile
	{
		private var _modelUrl:String
		private var _material:Material;
		private var _materialUrl:String;
		private var _cubeSize:Vector3D;

	    private var _lightModelScal:Number
		private var _betweenNum:Number
		private var _lastBetweenNum:Number
		private var _posItem:Array
		private var _seeAll:Boolean
		private var _changeBut:int
		
		private var _needChangePosItem:Boolean=false
	
		public function LightProbeStaticMesh()
		{
			super();
		}



	

		public function get lastBetweenNum():Number
		{
			return _lastBetweenNum;
		}

		public function set lastBetweenNum(value:Number):void
		{
			_lastBetweenNum = value;
		}

		public function get needChangePosItem():Boolean
		{
			return _needChangePosItem;
		}

		public function set needChangePosItem(value:Boolean):void
		{
			_needChangePosItem = value;
		}

		public function get posItem():Array
		{
			return _posItem;
		}

		public function set posItem(value:Array):void
		{
			_posItem = value;
		}
		public function get cubeSize():Vector3D
		{
			return _cubeSize;
		}
		[Editor(type="Vec3",Label="密度:",Step="1",sort="10",Category="属性",Tip="x")]
		public function set cubeSize(value:Vector3D):void
		{
			_cubeSize = value;

		}
		
		public function get lightModelScal():Number
		{
			return _lightModelScal;
		}
		[Editor(type="Number",Label="模型比例",Step="0.01",sort="11",MinNum="0.01",MaxNum="100",Category="属性",Tip="范围")]
		public function set lightModelScal(value:Number):void
		{
			_lightModelScal = value;
			changeLightProbe()
	
		}
		
		public function get betweenNum():Number
		{
			return _betweenNum;
		}
		[Editor(type="Number",Label="Probe间隔",Step="1",sort="12",MinNum="1",MaxNum="200",Category="属性",Tip="范围")]
		public function set betweenNum(value:Number):void
		{
			_betweenNum = value;

	
		}

		public function get seeAll():Boolean
		{
			return _seeAll;
		}
		[Editor(type="ComboBox",Label="全部显示",sort="1.5",Category="属性",Data="{name:false,data:false}{name:true,data:true}",Tip="是否当地形用来扫描高度")]
		public function set seeAll(value:Boolean):void
		{
			_seeAll = value;
			
			changeLightProbe()
		}
		
		public function get changeBut():int
		{
			return _changeBut;
		}
		[Editor(type="Btn",Label="更新数据",sort="50",Category="属性",Tip="范围")]
		public function set changeBut(value:int):void
		{
			_changeBut = value;
			changeLightProbe()
		}
		private function changeLightProbe():void
		{
			_needChangePosItem=true
			change()
		}
		

		public function get modelUrl():String
		{
			return _modelUrl;
		}
		[Editor(type="PreFabImg",Label="模型地址",extensinonStr="objs",sort="15",changePath="0",Category="模型")]
		public function set modelUrl(value:String):void
		{
			_modelUrl = value;
	
	
		}

		public function get materialUrl():String
		{
			return _materialUrl;
		}

		public function set materialUrl(value:String):void
		{
			_materialUrl = value;
		
		}

		public function get material():Material
		{
			return _material;
		}
		[Editor(type="MaterialImg",Label="材质",donotDubleClik="1",extensinonStr="materials.Material",sort="16",changePath="0",Category="材质")]
		public function set material(value:Material):void
		{
			if(_material != value){
				if(_material){
					_material.removeEventListener(Event.CHANGE,onMaterialChange)
				}
				_material = value;
				_material.addEventListener(Event.CHANGE,onMaterialChange);
				if(_material is MaterialTree){
					_materialUrl = MaterialTree(_material).url;
				}
	
			}
		}

		
		protected function onMaterialChange(event:Event):void
		{
	
			
		}
	
		public function readObject():Object
		{
			var $obj:Object=new Object
			$obj.materialUrl=_materialUrl
			$obj.modelUrl=_modelUrl
			$obj.cubeSize=_cubeSize
			$obj.lightModelScal=_lightModelScal
			$obj.betweenNum=_betweenNum
		
			var arr:Array=new Array
			for(var i:uint=0;i<_posItem.length;i++){
				arr[i]=new Array
				for(var j:uint=0;j<_posItem[i].length;j++){
					arr[i][j]=new Array
					for(var k:uint=0;k<_posItem[i][j].length;k++){
		
		
						arr[i][j][k]=LightProbeTempStaticMesh(_posItem[i][j][k]).readObject()
						
					}
				}
			}
			$obj.posItem=arr
			$obj.seeAll=_seeAll
			return $obj
		}


		
	}
}