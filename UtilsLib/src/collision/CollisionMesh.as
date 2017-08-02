package collision
{
	import flash.events.Event;
	
	import pack.Prefab;

	public class CollisionMesh extends Prefab
	{

		private var _url:String;
		private var _trinum:Number
		private var _friction:Number
		private var _restitution:Number
	
		private var _indexs:Vector.<uint>;
		private var _vertices:Vector.<Number>;
		private var _uvs:Vector.<Number>;
		private var _lightUvs:Vector.<Number>;
		private var _normals:Vector.<Number>;
		private var _isField:Boolean;
		
		

		private var _item:Array
		private var _showTriModel:Boolean;
		public function CollisionMesh()
		{
			super();
		}
		


		public function get restitution():Number
		{
			return _restitution;
		}
		[Editor(type="Number",Label="反弹系数",Step="0.01",sort="2",Category="显示",Tip="反弹系数")]
		public function set restitution(value:Number):void
		{
			_restitution = value;
		}

		public function get friction():Number
		{
			return _friction;
		}
		[Editor(type="Number",Label="摩擦系数",Step="0.01",sort="3",Category="显示",Tip="摩擦系数")]
		public function set friction(value:Number):void
		{
			_friction = value;
		}
		
		public function get isField():Boolean
		{
			return _isField;
		}
		[Editor(type="ComboBox",Label="是为地面",sort="4",Category="显示",Data="{name:false,data:false}{name:true,data:true}",Tip="")]
		public function set isField(value:Boolean):void
		{
			_isField = value;
		}
		
		public function get showTriModel():Boolean
		{
			return _showTriModel;
		}
		[Editor(type="ComboBox",Label="显示模型",sort="5",Category="显示",Data="{name:false,data:false}{name:true,data:true}",Tip="")]
		public function set showTriModel(value:Boolean):void
		{
			_showTriModel = value;
			change();
		}

		public function get item():Array
		{
			return _item;
		}
		[Editor(type="CollisionUi",Label="碰撞Obj ",sort="10",Category="列表")]
		public function set item(value:Array):void
		{
			_item = value;
			change();
		}

	
		public function get normals():Vector.<Number>
		{
			return _normals;
		}

		public function set normals(value:Vector.<Number>):void
		{
			_normals = value;
		}

		public function get lightUvs():Vector.<Number>
		{
			return _lightUvs;
		}

		public function set lightUvs(value:Vector.<Number>):void
		{
			_lightUvs = value;
		}

		public function get uvs():Vector.<Number>
		{
			return _uvs;
		}

		public function set uvs(value:Vector.<Number>):void
		{
			_uvs = value;
		}

		public function get vertices():Vector.<Number>
		{
			return _vertices;
		}

		public function set vertices(value:Vector.<Number>):void
		{
			_vertices = value;
		}

		public function get indexs():Vector.<uint>
		{
			return _indexs;
		}

		public function set indexs(value:Vector.<uint>):void
		{
			_indexs = value;
		}

		public function get trinum():Number
		{
			return _trinum;
		}
		[Editor(type="Number",Label="三角形数",Step="0",sort="1",Category="显示",Tip="三角形数量")]
		public function set trinum(value:Number):void
		{
			_trinum = value;
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}

		override public function getName():String
		{
			return name;
		}


		public function change():void{
			this.dispatchEvent(new Event(Event.CHANGE));
		}


	}
}