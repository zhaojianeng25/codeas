package modules.brower.fileWin.see
{
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	import common.AppData;
	import common.utils.ui.check.CheckLabelBox;
	import common.utils.ui.prefab.PicBut;
	import common.utils.ui.txt.TextCtrlInput;
	
	import modules.brower.fileWin.BrowerManage;
	import modules.brower.fileWin.FileWindows;
	import modules.brower.fileWin.InFolderModelSprite;
	
	public class SeePanel extends UIComponent
	{
		private var _showBut:PicBut;
		private var _ui:UIComponent;
		private var _inFolderModelSprite:InFolderModelSprite;
		private var _picSizeBurTxt:TextCtrlInput;
		public function SeePanel()
		{
			super();
			addButs();
			addPanel();
			addPicSizeBar();
			addSort();
			addShowObjs()
			addEvent();
		}
		
		private function addSort():void
		{
			var cb:CheckLabelBox = new CheckLabelBox;
			cb.label = "名称排序: "
			cb.width = this.width;
			cb.height = 18;
			cb.target=this
			cb.changFun = Key_SetFun;
			cb.getFun =Key_GetFun;
			_ui.addChild(cb)
			cb.width=100
			cb.height=20
			cb.y=35

		}
		private function Key_SetFun(value:Boolean):void
		{
			AppData.fileSort = value;
			FileWindows(this.parent).refresh()
		}
		public function Key_GetFun():Boolean
		{
			return  AppData.fileSort;
		}
		private function addShowObjs():void
		{
			var cb:CheckLabelBox = new CheckLabelBox;
			cb.label = "显示所有文件: "
			cb.width = this.width;
			cb.height = 18;
			cb.target=this
			cb.changFun =objs_SetFun;
			cb.getFun =objs_GetFun;
			_ui.addChild(cb)
			cb.width=100
			cb.height=20
			cb.y=35+25
			
		}
		private function objs_SetFun(value:Boolean):void
		{
			AppData.showObjs = value;
			FileWindows(this.parent).refresh()
		}
		public function objs_GetFun():Boolean
		{
			return  AppData.showObjs;
		}
		


		public function set inFolderModelSprite(value:InFolderModelSprite):void
		{
			_inFolderModelSprite = value;
		}

		private function addPicSizeBar():void
		{
			_picSizeBurTxt = new TextCtrlInput;
			_picSizeBurTxt.height = 18;
			_picSizeBurTxt.width=100
			_picSizeBurTxt.center = true;
			_picSizeBurTxt.label = "图片尺寸:"
			_picSizeBurTxt.tip = "。。。"
			_picSizeBurTxt.maxNum=120;
			_picSizeBurTxt.minNum=60;
			_picSizeBurTxt.step =1
			_picSizeBurTxt.x=0
			_picSizeBurTxt.getFun =function ():Number{
				return 80
			}
			_picSizeBurTxt.changFun =function (value:Number):void
			{
				_inFolderModelSprite.picSize=value
				_inFolderModelSprite.changeSize()
			}
			_picSizeBurTxt.y=10
			_picSizeBurTxt.refreshViewValue()
			_ui.addChild(_picSizeBurTxt)

		}
		
		private function addEvent():void
		{
			_showBut.addEventListener(MouseEvent.MOUSE_DOWN,onShowButMouseOver)
		//	_ui.addEventListener(MouseEvent.MOUSE_OUT,onUiMouseOut)
			
		}
		
		protected function onUiMouseOut(event:MouseEvent):void
		{
			_ui.visible=false
			
		}
		
		protected function onShowButMouseOver(event:MouseEvent):void
		{
			_ui.visible=!_ui.visible
				
				

		}
		
		private function addPanel():void
		{
			_ui=new UIComponent
			_ui.graphics.clear()
			_ui.graphics.beginFill(0x6c6c6c,1)
			_ui.graphics.drawRect(0,0,135,85)
			_ui.graphics.endFill()
			this.addChild(_ui)
			_ui.y=22
			_ui.x=3
			_ui.visible=false

		}
		private function addButs():void
		{
			_showBut=new PicBut
			_showBut.setBitmapdata( BrowerManage.getIcon("seePanelBut"),99,23)
			this.addChild(_showBut)
		}
	}
}