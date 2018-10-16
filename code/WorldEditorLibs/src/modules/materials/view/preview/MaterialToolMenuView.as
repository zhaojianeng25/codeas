package modules.materials.view.preview
{
	import mx.core.UIComponent;
	
	import common.utils.ui.prefab.PicBut;
	
	import modules.brower.fileWin.BrowerManage;
	
	public class MaterialToolMenuView extends UIComponent
	{
		
		private var backUI:UIComponent;
		private var _comiplerBut:PicBut;
		private var _saveBut:PicBut;


		public function MaterialToolMenuView()
		{
			super();
			backUI=new UIComponent
			this.addChild(backUI)
			drawBg(100,100)
			addButs();
		}
		
		public function get saveBut():PicBut
		{
			return _saveBut;
		}

		public function set saveBut(value:PicBut):void
		{
			_saveBut = value;
		}

		public function get comiplerBut():PicBut
		{
			return _comiplerBut;
		}

		public function resetSize($w:Number,$h:Number):void
		{
			drawBg($w,$h)
			
			_saveBut.x=$w-100
			_comiplerBut.x=$w-60
		}
		private function addButs():void
		{
			
			
			_saveBut=new PicBut
			_saveBut.setBitmapdata(BrowerManage.getIcon("materialsave"))
			this.addChild(_saveBut)
				
				
			_comiplerBut=new PicBut
			_comiplerBut.setBitmapdata(BrowerManage.getIcon("materialcompiler"))
			this.addChild(_comiplerBut)
			
			_comiplerBut.x=50
			_comiplerBut.y=5
			_saveBut.x=80
			_saveBut.y=5

				
	
			



		}
		private function drawBg($w:Number,$h:Number):void{
			backUI.graphics.clear();
			backUI.graphics.lineStyle(1,0x505050);
			backUI.graphics.beginFill(0x404040,1);//59
			backUI.graphics.drawRect(-1,0,$w+2,30);
			backUI.graphics.endFill();

		}
	}
}