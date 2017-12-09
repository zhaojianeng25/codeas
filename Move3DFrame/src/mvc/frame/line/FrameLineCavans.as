package mvc.frame.line
{
	import mx.collections.ArrayCollection;
	
	import common.utils.frame.BaseComponent;
	import common.utils.ui.file.FileNode;
	
	import mvc.frame.view.FrameFileNode;
	import mvc.frame.FrameModel;
	
	public class FrameLineCavans extends BaseComponent
	{
		
		
		public function FrameLineCavans()
		{
			super();
			
			this.setStyle("top",30);
			this.setStyle("left",0);
			//this.setStyle("right",20);
			this.setStyle("bottom",0);
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
			
			this.setStyle("contentBackgroundColor",0x505050);
			this.setStyle("color",0x9f9f9f);
			

			
			
			
		}
		

		private var thnum:Number=0
		public function resetView():void
		{
			
			var startId:Number=FrameModel.getInstance().tree.verticalScrollPosition;
			this.thnum=0
			this.showTemp(FrameModel.getInstance().ary)

		}
		private function showTemp($arr:ArrayCollection):void
		{
			var startId:Number=FrameModel.getInstance().tree.verticalScrollPosition;
			for(var i :Number=0;i<$arr.length;i++)
			{
				var $node:FrameFileNode=$arr[i] as FrameFileNode;
				if($node.type==FrameFileNode.Folder0){
					this.thnum++;
					if(this.isPerentOpen($node)){
						this.showTemp($node.children);
					}else{
						this.removeChildNodeMc($node.children)
					}
				}else{
					if(!$node.parentNode||this.isPerentOpen($node.parentNode as FrameFileNode)){
						this.thnum++
						if(!$node.frameLineMc.parent){
							this.addChild($node.frameLineMc);
						
						}
						$node.frameLineMc.refrish()
						$node.frameLineMc.y=(this.thnum-startId-1)*20;
					}else{
						if($node.frameLineMc.parent){
							this.removeChild($node.frameLineMc)
						}
					}
				}
					
			}
		
		}
		private function removeChildNodeMc($arr:ArrayCollection):void
		{
			for(var i :Number=0;i<$arr.length;i++)
			{
				var $node:FrameFileNode=$arr[i] as FrameFileNode;
				if($node.type==FrameFileNode.Folder0){
					this.removeChildNodeMc($node.children)
				}else{
					if($node.frameLineMc.parent){
						this.removeChild($node.frameLineMc)
					}
				}
			}
		}
		private function isPerentOpen($node:FrameFileNode):Boolean
		{
			var arr:Array = FrameModel.getInstance().tree.openItems as Array;
			var $open:Boolean=false
			for(var i:int;i<arr.length;i++){
				if(arr[i]==$node){
					if($node.parentNode){
						$open=this.isPerentOpen($node.parentNode as FrameFileNode);
					}else{
						$open=true;
					}
				}
			}
			return $open;
		}
		

	}
}