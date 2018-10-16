package mvc.centen.discenten
{
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	import vo.H5UIFileNode;
	import vo.InfoDataSprite;
	
	public class InfoLevel extends UIComponent
	{
		public function InfoLevel()
		{
			super();

		}
		public function setInfoItem(arr:ArrayCollection):void
		{
			trace("修改了所有")
			for(var i:uint=0;i<arr.length;i++){
				var $H5UIFileNode:H5UIFileNode=arr[i];
				if(!$H5UIFileNode.sprite){
					$H5UIFileNode.sprite=new InfoDataSprite
					$H5UIFileNode.sprite.h5UIFileNode=$H5UIFileNode;
				}
				if(!$H5UIFileNode.sprite.parent){
					this.addChild($H5UIFileNode.sprite)
				}
				$H5UIFileNode.sprite.updata()
			}
			
		}
		
		public function clearLevel():void
		{
			while(this.numChildren){
				this.removeChildAt(0)
			}
		}
		
	}
}