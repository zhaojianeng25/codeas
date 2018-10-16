package modules.materials.view.constnum
{
	import flash.geom.Vector3D;
	
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeTex;
	import modules.materials.treedata.nodetype.NodeTreeVec3;
	import modules.materials.view.BaseMaterialNodeUI;
	import modules.materials.view.ItemMaterialUI;
	import modules.materials.view.MaterialItemType;
	
	public class ConstVec3NodeUI extends BaseMaterialNodeUI
	{
		private var outItem:ItemMaterialUI;
		
		private var outAItem:ItemMaterialUI;
		
		private var outRGBAItem:ItemMaterialUI;
		
		private var _constValue:Vector3D;
		
		protected var _bastTitleStr:String = "vec3"
		public function ConstVec3NodeUI()
		{
			super();
			titleBitmap = new phys_marterialCls;
			addTitleImg();
			this.gap = 20;
			this.width = 162;
			this.height = 95;
			
			_constValue = new Vector3D;
			
			initNodeTree();
			
			outItem = new ItemMaterialUI("out",MaterialItemType.VEC3,false);
			addItems(outItem);
			
			outAItem = new ItemMaterialUI("alpha",MaterialItemType.FLOAT,false);
			addItems(outAItem);
			
			outRGBAItem = new ItemMaterialUI("rgba",MaterialItemType.VEC4,false);
			addItems(outRGBAItem);
			
			_titleLabel.text = _bastTitleStr;
			
			_titleLabel.width = 160;
		}
		
		public function initNodeTree():void{
			nodeTree = new NodeTreeVec3;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.VEC3;
		}
		
		public function get constValue():Vector3D
		{
			return _constValue;
		}

		public function set constValue(value:Vector3D):void
		{
			_constValue = value;
			NodeTreeVec3(nodeTree).constVec3 = value;
			//_titleLabel.text = _bastTitleStr + "(" + getNumStr(value.x) + "," + getNumStr(value.y) + "," + getNumStr(value.z) + "," + getNumStr(value.w) + ")"
			showDynamic();
		}
		
		public function getNumStr(num:Number):String{
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
			this.constValue = new Vector3D(obj.constValue.x,obj.constValue.y,obj.constValue.z,obj.constValue.w);
			NodeTreeVec3(nodeTree).constVec3 = constValue;
			showDynamic();
		}
		
		override public function changeDynamic():void{
			super.changeDynamic();
			showDynamic();
		}
		
		override  public function showDynamic():void{
			if(nodeTree.isDynamic){
				_titleLabel.text = _bastTitleStr + "<" + nodeTree.paramName + ">(" + getNumStr(constValue.x) + "," + getNumStr(constValue.y) + "," + getNumStr(constValue.z) + "," + getNumStr(constValue.w) + ")"
			}else{
				_titleLabel.text = _bastTitleStr + "(" + getNumStr(constValue.x) + "," + getNumStr(constValue.y) + "," + getNumStr(constValue.z) + "," + getNumStr(constValue.w) + ")"
			}
		}
		
		

		
	}
}