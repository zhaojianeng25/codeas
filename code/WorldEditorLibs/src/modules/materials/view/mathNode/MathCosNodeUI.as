package modules.materials.view.mathNode
{
	import modules.materials.treedata.NodeTree;

	public class MathCosNodeUI extends MathStaticNodeUI
	{
		public function MathCosNodeUI()
		{
			super();
			_titleLabel.text = "余弦(Cos)";
			initItem();
			nodeTree.type = NodeTree.COS;
		}
	}
}