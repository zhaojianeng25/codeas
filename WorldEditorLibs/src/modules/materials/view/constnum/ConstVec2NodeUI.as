package modules.materials.view.constnum
{
	import flash.geom.Point;
	
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeVec2;
	import modules.materials.view.BaseMaterialNodeUI;
	import modules.materials.view.ItemMaterialUI;
	import modules.materials.view.MaterialItemType;
	
	public class ConstVec2NodeUI extends BaseMaterialNodeUI
	{
		private var outItem:ItemMaterialUI;
		
		private var _constValue:Point;
		public function ConstVec2NodeUI()
		{
			super();
			titleBitmap = new phys_marterialCls;
			addTitleImg();
			this.gap = 20;
			this.width = 162;
			this.height = 65;
			
			_constValue = new Point;
			
			nodeTree = new NodeTreeVec2;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.VEC2;
			
			outItem = new ItemMaterialUI("out",MaterialItemType.VEC2,false);
			addItems(outItem);
			
			_titleLabel.text = "vec2";
			
			_titleLabel.width = 160;
		}

		public function get constValue():Point
		{
			return _constValue;
		}

		public function set constValue(value:Point):void
		{
			_constValue = value;
			NodeTreeVec2(nodeTree).constValue = value;
			//_titleLabel.text = "vec2(" + getNumStr(value.x) + "," + getNumStr(value.y) + ")"
			showDynamic();
		}
		
		private function getNumStr(num:Number):String{
			var n:Number = int(num * 100)/100;
			return n.toString();
		}
		
		override public function getData():Object{
			var obj:Object = super.getData();
			obj.constValue = _constValue;
			return obj;
		}
		
		override public function setData(obj:Object):void{
			super.setData(obj);
			this.constValue = new Point(obj.constValue.x,obj.constValue.y);
			NodeTreeVec2(nodeTree).constValue = constValue;
			showDynamic();
		}
		
		override public function changeDynamic():void{
			super.changeDynamic();
			showDynamic();
		}
		
		override public function showDynamic():void{
			if(nodeTree.isDynamic){
				_titleLabel.text = "vec2<" + nodeTree.paramName + ">(" + getNumStr(_constValue.x) + "," + getNumStr(_constValue.y) + ")"
			}else{
				_titleLabel.text = "vec2(" + getNumStr(_constValue.x) + "," + getNumStr(_constValue.y) + ")"
			}
		}

	}
}