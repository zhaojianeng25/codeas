package modules.materials.view.mathNode
{
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeDiv;

	public class MathDivNodeUI extends MathDynamicNodeUI
	{
		public function MathDivNodeUI()
		{
			super();
			
			nodeTree = new NodeTreeDiv;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.DIV;
			
			_titleLabel.text = "除法(Div/)";
			initItem();
		}
	}
}