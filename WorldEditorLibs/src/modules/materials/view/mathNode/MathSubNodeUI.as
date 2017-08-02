package modules.materials.view.mathNode
{
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeAdd;
	import modules.materials.treedata.nodetype.NodeTreeSub;

	public class MathSubNodeUI extends MathDynamicNodeUI
	{
		public function MathSubNodeUI()
		{
			super();
			
			nodeTree = new NodeTreeSub;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.SUB;
			
			_titleLabel.text = "减法(Sub-)";
			initItem();
		}
	}
}