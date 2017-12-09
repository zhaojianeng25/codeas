
package  mvc.mesh
{
	import common.utils.frame.MetaDataView;
	
	import interfaces.ITile;
	
	public class FrameNodeMetaDataView extends MetaDataView
	{


	
		protected var _meshNodeLabel:NodeIconLabel;
		public function FrameNodeMetaDataView()
		{
			super();
			this.iconLable.visible=false;
			
			_meshNodeLabel = new NodeIconLabel;
			this.addChild(_meshNodeLabel);
		}
		override public function setTarget(target:Object):void{
			_meshNodeLabel.target=target
			_meshNodeLabel.label = ITile(target).getName();
			super.setTarget(target)
		}

		
		
	}
}