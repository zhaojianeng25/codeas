package navMesh
{
	import flash.geom.Vector3D;
	
	import interfaces.ITile;
	
	import pack.ModePropertyMesh;

	public class NavMeshStaticMesh extends ModePropertyMesh implements ITile
	{
		
		private var  _listData:Array;

		private var _midu:Number

		public var vecTri:Vector.<Vector3D>;//生存可行走的三角形
		public var astarItem:Array;
		public var heightItem:Array;
		public var jumpItem:Array;
		public var aPos:Vector3D;
		
		
		
		
		
		public function NavMeshStaticMesh()
		{
			super();

		}




		public function get midu():Number
		{
			return _midu;
		}
		[Editor(type="Number",Label="A星密度",Step="1",sort="3.1",MinNum="1",MaxNum="128",Category="参数",Tip="范围")]
		public function set midu(value:Number):void
		{
			_midu = value;
		}

		public function get listData():Array
		{
			return _listData;
		}
		[Editor(type="NavMeshUi",Label="碰撞Obj ",sort="10",Category="列表")]

		public function set listData(value:Array):void
		{
			_listData = value;
		}

		
		

		
		override public function change():void{
		
			
		}
		public function readObject():Object
		{
			var $listData:Array=new Array

			for(var i:Number=0;i<_listData.length;i++)
			{
				var temparr:Array=new Array()
				for(var j:Number=0;j<_listData[i].data.length;j++){
					temparr.push(new Vector3D(_listData[i].data[j].x,_listData[i].data[j].y,_listData[i].data[j].z))
				}
				var temp:Object=new Object;
				temp.data=temparr
				temp.name=_listData[i].name
				temp.isJumpRect=_listData[i].isJumpRect
				$listData.push(temp)
			
			}
			var $obj:Object=new Object;
			$obj.listData=$listData
			$obj.vecTri=vecTri;
			$obj.midu=_midu;
			$obj.astarItem=astarItem;
			$obj.heightItem=heightItem;
			$obj.jumpItem=jumpItem;
			$obj.aPos=aPos;
			
			return $obj
		}
	
	}
}