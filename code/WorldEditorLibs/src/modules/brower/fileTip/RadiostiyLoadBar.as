package modules.brower.fileTip
{
	import flash.display.Bitmap;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	import modules.brower.fileWin.BrowerManage;
	
	public class RadiostiyLoadBar extends UIComponent
	{
		private var _bg:UIComponent;
		private var _lineSp:UIComponent
		private var _lineBack:UIComponent

		private var _titleLabel:Label
		public function RadiostiyLoadBar($title:String)
		{
			super();
			addBack();
			addText($title);
			

		}
		


		private function addText($title:String):void
		{
	
				
			_titleLabel=new Label
			_titleLabel.x=5
			_titleLabel.y=8
			_titleLabel.text=$title
			_titleLabel.width=60
			_titleLabel.height=20
			_titleLabel.setStyle("color",0x9f9f9f);
			_titleLabel.setStyle("size",14);
			this.addChild(_titleLabel)
				
				
			_numLabel=new Label
			_numLabel.x=60
			_numLabel.y=8
			_numLabel.text="0%"
			_numLabel.width=60
			_numLabel.height=20
			_numLabel.setStyle("color",0x9f9f9f);
			_numLabel.setStyle("size",14);
			this.addChild(_numLabel)
				
			
		}
		private var _lineBmp:Bitmap
		private function addBack():void
		{
			_bg = new UIComponent;
			this.addChild(_bg);
			
			_lineBack=new UIComponent
			this.addChild(_lineBack)
			_lineBack.x=5
			_lineBack.y=35
		
			_lineSp=new UIComponent
			this.addChild(_lineSp)
			_lineSp.x=5
			_lineSp.y=35
				
			_lineBmp=new Bitmap
			_lineBmp.bitmapData=BrowerManage.getIcon("renderLine")
		
			_lineSp.addChild(_lineBmp)
			
		}
		private function drawback():void{

		
			_bg.graphics.clear();
			_bg.graphics.lineStyle(2,0x676767)
			_bg.graphics.beginFill(0xffffff,0);
			_bg.graphics.drawRect(0,0,this.width,50);
			_bg.graphics.endFill();
			
			_lineBack.graphics.clear()
			_lineBack.graphics.lineStyle(1,0x676767,0)
			_lineBack.graphics.beginFill(0xffffff,0.05);
			_lineBack.graphics.drawRect(0,0,this.width-10,10);
			_lineBack.graphics.endFill();
			
//			_lineSp.graphics.clear()
//			_lineSp.graphics.beginFill(0xffff00,1);
//			_lineSp.graphics.drawRect(0,0,(_skipNum/100)*(this.width-10),10);
//			_lineSp.graphics.endFill();
			
			_lineBmp.width=(_skipNum/100)*(this.width-10)
			
			
			_numLabel.text=int(_skipNum)+"%"


			
		}
		private var _skipNum:Number=0
		private var _numLabel:Label;
		public function setNum($num:Number):void
		{
			_skipNum=$num
			drawback()
			
		}
		override public function set width(value:Number):void{
			super.width = value;
			drawback();
		}

		public function changeSize():void{
			drawback();
			
		}
	}
}