

package common.utils.frame
{
	import flash.events.Event;
	
	import common.utils.ui.img.IconNameLabel;
	
	import interfaces.ITile;
	
	import modules.brower.fileWin.BrowerManage;
	
	import mvc.frame.view.FrameFileNode;

	
	public class CombineReflectionView extends BaseReflectionView
	{
		private var _iconLable:IconNameLabel;
		public function CombineReflectionView()
		{
			
			super();
			_iconLable = new IconNameLabel;
			this.addChild(_iconLable);
			
		}
		public function setTarget($target:FrameFileNode):void
		{
			//			_iconLable.icon = BrowerManage.getIcon("folder")
			//			_iconLable.label ="组合"
			
			_iconLable.icon = BrowerManage.getIconByClass($target.data["constructor"] as Class);
			_iconLable.label = ITile($target.data).getName();
			_iconLable.target=$target
		}
		
		public function addView($view:BaseReflectionView):void{
			var vlist:Vector.<AccordionCanvas> = $view.accordList;
			for(var i:int;i<vlist.length;i++){
				var cav:AccordionCanvas = vlist[i];
				if(cav.parent){
					cav.parent.removeChild(cav);
				}
				this.addChild(cav);
				this._accordList.push(cav);
				cav.removeEventListener("openchange",$view.relistPos);
				cav.addEventListener("openchange",relistPos);
			}
			relistPos();
		}
		override public function relistPos(event:Event = null):void{
			var ypos:int =43;
			for(var i:int;i<_accordList.length;i++){
				_accordList[i].y = ypos;
				ypos += _accordList[i].height + 1;
			}
		}
		
	}
}


