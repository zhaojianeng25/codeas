package modules.materials.view.constnum
{
	import flash.geom.Point;
	
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeHeightInfo;
	import modules.materials.treedata.nodetype.NodeTreePanner;
	import modules.materials.treedata.nodetype.NodeTreeVec2;
	import modules.materials.view.BaseMaterialNodeUI;
	import modules.materials.view.ItemMaterialUI;
	import modules.materials.view.MaterialItemType;
	
	public class PannerNodeUI extends BaseMaterialNodeUI
	{
		private var inItem:ItemMaterialUI;
		private var inSpeedItem:ItemMaterialUI;
		
		private var outItem:ItemMaterialUI;
		
		private var _coordinate:Point;
		private var _speed:Point
		public function PannerNodeUI()
		{
			super();
			titleBitmap = new phys_marterialCls;
			addTitleImg();
			this.gap = 20;
			this.width = 162;
			this.height = 85;
			
			
			_coordinate = new Point;
			_speed = new Point;
			
			nodeTree = new NodeTreePanner;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.PANNER;
			
			outItem = new ItemMaterialUI("out",MaterialItemType.VEC2,false);
			addItems(outItem);
			
			inItem = new ItemMaterialUI("coordinate",MaterialItemType.VEC2,true);
			addItems(inItem);
			
			inSpeedItem = new ItemMaterialUI("speed",MaterialItemType.VEC2,true);
			addItems(inSpeedItem);
			
			_titleLabel.text = "UV";
			
		}
		
		public function get speed():Point
		{
			return _speed;
		}

		public function set speed(value:Point):void
		{
			_speed = value;
			NodeTreePanner(nodeTree).speedValue = value;
		}

		public function get coordinate():Point
		{
			return _coordinate;
		}

		public function set coordinate(value:Point):void
		{
			_coordinate = value;
			NodeTreePanner(nodeTree).coordinateValue = value;
		}

		override public function getData():Object{
			var obj:Object = super.getData();
			obj.coordinate = coordinate;
			obj.speed = speed;
			return obj;
		}
		
		override public function setData(obj:Object):void{
			super.setData(obj);
			this.coordinate = new Point(obj.coordinate.x,obj.coordinate.y);
			this.speed = new Point(obj.speed.x,obj.speed.y);
		}

	}
}