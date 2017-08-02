package modules.materials.view.mathNode
{
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeAdd;

	public class MathAddNodeUI extends MathDynamicNodeUI
	{
		public function MathAddNodeUI()
		{
			super();
			
			nodeTree = new NodeTreeAdd;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.ADD;
			
			_titleLabel.text = "加法(Add+)";
			initItem();
			
		}
	}
}