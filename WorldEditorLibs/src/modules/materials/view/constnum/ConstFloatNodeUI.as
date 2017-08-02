package modules.materials.view.constnum
{
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeFloat;
	import modules.materials.view.BaseMaterialNodeUI;
	import modules.materials.view.ItemMaterialUI;
	import modules.materials.view.MaterialItemType;
	
	public class ConstFloatNodeUI extends BaseMaterialNodeUI
	{
		private var outItem:ItemMaterialUI;
		
		private var _constValue:Number;
		
		public function ConstFloatNodeUI()
		{
			super();
			
			titleBitmap = new phys_marterialCls;
			addTitleImg();
			this.gap = 20;
			this.width = 162;
			this.height = 65;
			
			_constValue = 0;
			
			nodeTree = new NodeTreeFloat;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.FLOAT;
			
			outItem = new ItemMaterialUI("out",MaterialItemType.FLOAT,false);
			addItems(outItem);
			
			_titleLabel.text = "float";
			
			_titleLabel.width = 160;
		}

		public function get constValue():Number
		{
			return _constValue;
		}

		public function set constValue(value:Number):void
		{
			_constValue = value;
			NodeTreeFloat(nodeTree).constValue = value;
			//_titleLabel.text = "float(" + _constValue + ")"
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
			this.constValue = obj.constValue;
			NodeTreeFloat(nodeTree).constValue = constValue;
			showDynamic();
		}
		
		override public function changeDynamic():void{
			super.changeDynamic();
			showDynamic();
		}
		
		override public function showDynamic():void{
			if(nodeTree.isDynamic){
				_titleLabel.text = "float<" + nodeTree.paramName + ">(" + _constValue + ")"
			}else{
				_titleLabel.text = "float(" + _constValue + ")"
			}
		}

	}
}