package modules.materials.view
{
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeOP;

	public class ResultNodeUI extends BaseMaterialNodeUI
	{

		private var diffuseItem:ItemMaterialUI;
		private var metallicItem:ItemMaterialUI;
		private var normalItem:ItemMaterialUI;
		private var specularItem:ItemMaterialUI;
		private var specularPowerItem:ItemMaterialUI;
		private var reflectItem:ItemMaterialUI;
		private var subsurfaceColorItem:ItemMaterialUI;
		private var alphaItem:ItemMaterialUI;
		private var killItem:ItemMaterialUI;
		private var emissiveItem:ItemMaterialUI;
		
		private var _blenderMode:int;
		private var _killNum:Number = 0;
		private var _backCull:Boolean = true;
		private var _writeZbuffer:Boolean = true;
		private var _useDynamicIBL:Boolean;
		private var _normalScale:Number;
		private var _lightProbe:Boolean;
		private var _directLight:Boolean; 
		private var _noLight:Boolean; 
		private var _fogMode:int;
		private var _scaleLightMap:Boolean;
		public function ResultNodeUI()
		{
			super();
			
			nodeTree = new NodeTreeOP;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.OP;
			
			initItem();
			
			titleBitmap = new phys_marterialCls1;
			addTitleImg();
			
			this.width = 162;
			this.height = 360;
			
		}
		
		
		private function initItem():void{
			diffuseItem = new ItemMaterialUI("漫反射(Diffuse)",MaterialItemType.VEC3);
			metallicItem = new ItemMaterialUI("金属(metallic)",MaterialItemType.FLOAT);
			specularItem = new ItemMaterialUI("高光(Specular)",MaterialItemType.FLOAT);
			specularPowerItem = new ItemMaterialUI("粗糙度(Roughness)",MaterialItemType.FLOAT);
			normalItem = new ItemMaterialUI("法线(Normal)",MaterialItemType.VEC3);
			reflectItem = new ItemMaterialUI("反射(Reflection)",MaterialItemType.VEC3);
			subsurfaceColorItem = new ItemMaterialUI("表面散射(subsurface)",MaterialItemType.VEC3);
			alphaItem = new ItemMaterialUI("透明度(alpha)",MaterialItemType.FLOAT);
			killItem = new ItemMaterialUI("不透明蒙版(alphaMask)",MaterialItemType.FLOAT);
			emissiveItem = new ItemMaterialUI("自发光(emissive)",MaterialItemType.VEC3);
			
			addItems(diffuseItem);
			addItems(metallicItem);
			addItems(specularItem);
			addItems(specularPowerItem);
			addItems(normalItem);
			addItems(reflectItem);
			addItems(subsurfaceColorItem);
			addItems(alphaItem);
			addItems(killItem);
			addItems(emissiveItem);
		}
		
		override public function getData():Object{
			var obj:Object = super.getData();
			obj.blenderMode = blenderMode;
			obj.killNum = _killNum;
			obj.backCull = _backCull;
			obj.useDynamicIBL = _useDynamicIBL;
			obj.normalScale = normalScale;
			obj.lightProbe = lightProbe;
			obj.directLight = directLight;
			obj.noLight = noLight;
			obj.fogMode = fogMode;
			obj.scaleLightMap = scaleLightMap;
			obj.writeZbuffer = writeZbuffer;
			return obj;
		}
		
		override public function setData(obj:Object):void{
			super.setData(obj);
			this.blenderMode = obj.blenderMode;
			this._killNum = obj.killNum;
			this._backCull = obj.backCull;
			this._useDynamicIBL = obj.useDynamicIBL;
			this._normalScale = obj.normalScale;
			this._lightProbe = obj.lightProbe;
			this._directLight = obj.directLight;
			this._noLight = obj.noLight;
			this._fogMode = obj.fogMode;
			this._scaleLightMap = obj.scaleLightMap;
			if(obj.hasOwnProperty("writeZbuffer")){
				this._writeZbuffer = obj.writeZbuffer;
			}
			if(isNaN(_killNum)){
				_killNum = 0;
			}
			if(isNaN(_normalScale)){
				_normalScale = 1;
			}
			NodeTreeOP(nodeTree).blendMode = this.blenderMode;
			NodeTreeOP(nodeTree).killNum = _killNum;
			NodeTreeOP(nodeTree).backCull = _backCull;
			NodeTreeOP(nodeTree).useDynamicIBL = _useDynamicIBL;
			NodeTreeOP(nodeTree).normalScale = _normalScale;
			NodeTreeOP(nodeTree).lightProbe = _lightProbe;
			NodeTreeOP(nodeTree).directLight = _directLight;
			NodeTreeOP(nodeTree).noLight = _noLight;
			NodeTreeOP(nodeTree).fogMode = _fogMode;
			NodeTreeOP(nodeTree).scaleLightMap = _scaleLightMap;
			NodeTreeOP(nodeTree).writeZbuffer = _writeZbuffer;
		}

		public function get blenderMode():int
		{
			return _blenderMode;
		}

		public function set blenderMode(value:int):void
		{
			_blenderMode = value;
			NodeTreeOP(nodeTree).blendMode = value;
		}

		public function get killNum():Number
		{
			return NodeTreeOP(nodeTree).killNum;
		}

		public function set killNum(value:Number):void
		{
			_killNum = value;
			NodeTreeOP(nodeTree).killNum = value;
		}
		
		public function get backCull():Boolean
		{
			return _backCull;
		}
		
		public function set backCull(value:Boolean):void
		{
			_backCull = value;
			NodeTreeOP(nodeTree).backCull = value;
		}
		
		public function get writeZbuffer():Boolean
		{
			return _writeZbuffer;
		}
		
		public function set writeZbuffer(value:Boolean):void
		{
			_writeZbuffer = value;
			NodeTreeOP(nodeTree).writeZbuffer = value;
		}
		
		public function get useDynamicIBL():Boolean
		{
			return _useDynamicIBL;
		}
		
		public function set useDynamicIBL(value:Boolean):void
		{
			_useDynamicIBL = value;
			NodeTreeOP(nodeTree).useDynamicIBL = value;
		}
		
		public function get normalScale():Number
		{
			return _normalScale;
		}
		
		public function set normalScale(value:Number):void
		{
			_normalScale = value;
			NodeTreeOP(nodeTree).normalScale = value;
		}
		
		public function get lightProbe():Boolean
		{
			return _lightProbe;
		}
		
		public function set lightProbe(value:Boolean):void
		{
			_lightProbe = value;
			NodeTreeOP(nodeTree).lightProbe = value;
		}
		
		public function get directLight():Boolean
		{
			return _directLight;
		}
		
		public function set directLight(value:Boolean):void
		{
			_directLight = value;
			NodeTreeOP(nodeTree).directLight = value;
		}
		
		public function get noLight():Boolean
		{
			return _noLight;
		}
		
		public function set noLight(value:Boolean):void
		{
			_noLight = value;
			NodeTreeOP(nodeTree).noLight = value;
		}
		
		public function get fogMode():int
		{
			return _fogMode;
		}
		
		public function set fogMode(value:int):void
		{
			_fogMode = value;
			NodeTreeOP(nodeTree).fogMode = value;
		}
		
		public function get scaleLightMap():Boolean
		{
			return _scaleLightMap;
		}
		
		public function set scaleLightMap(value:Boolean):void
		{
			_scaleLightMap = value;
			NodeTreeOP(nodeTree).scaleLightMap = value;
		}

		
		
	}
}