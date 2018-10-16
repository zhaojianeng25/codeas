package mesh
{
	import common.utils.frame.BaseComponent;
	import common.utils.frame.MetaDataView;
	import common.utils.frame.ReflectionData;
	
	import interfaces.ITile;
	
	import mesh.ui.AlignRect;
	import mesh.ui.NodeIconLabel;
	import mesh.ui.PanelPictureUI;
	
	public class H5UIMetaDataView extends MetaDataView
	{
		protected var _meshNodeLabel:NodeIconLabel;
		public function H5UIMetaDataView()
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
		override public function creatComponteByMetadata(obj:Object):BaseComponent{
			var type:String = obj.type;
			var k:BaseComponent=super.creatComponteByMetadata(obj)
			if(type=="AlignRect"){
				k=getAlignRect(obj)
			}
			if(type=="PanelPictureUI"){
				k=getPanelPictureUI(obj)
			}
			return k;

		}
		private function getPanelPictureUI(obj:Object):PanelPictureUI
		{
			var $preFabModelPic:PanelPictureUI=new PanelPictureUI()
			$preFabModelPic.FunKey = obj.key;
			$preFabModelPic.titleLabel=obj[ReflectionData.Key_Label];
			$preFabModelPic.category = obj[ReflectionData.Key_Category];
			$preFabModelPic.donotDubleClik = obj[ReflectionData.donotDubleClik];
			return $preFabModelPic;
		}
		private function getAlignRect(obj:Object):BaseComponent
		{
			var $CollisionUi:AlignRect=new AlignRect()
			$CollisionUi.FunKey = obj.key;
			$CollisionUi.category = obj[ReflectionData.Key_Category];
			return $CollisionUi;
		}
	
	
	}
}