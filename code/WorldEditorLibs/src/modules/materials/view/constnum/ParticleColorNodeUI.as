package modules.materials.view.constnum
{
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreePaticleColor;
	import modules.materials.treedata.nodetype.NodeTreeVec3;

	public class ParticleColorNodeUI extends ConstVec3NodeUI
	{
		public function ParticleColorNodeUI()
		{
			super();
			_titleLabel.text = _bastTitleStr = "ParticleColor";
			nodeTree.isDynamic = true;
			nodeTree.paramName = _bastTitleStr;
		}
		
		override public function initNodeTree():void{
			nodeTree = new NodeTreePaticleColor;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.PTCOLOR;
		}
		
		override public function changeDynamic():void{
			showDynamic();
		}
		
		override public function showDynamic():void{
			_titleLabel.text = _bastTitleStr + "(" + getNumStr(constValue.x) + "," + getNumStr(constValue.y) + "," + getNumStr(constValue.z) + "," + getNumStr(constValue.w) + ")"
		}
	}
}