package common.utils.frame
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	
	import spark.components.Label;
	
	import common.utils.ui.prefab.PicBut;
	
	import modules.brower.fileWin.BrowerManage;
	
	public class AccordionCanvas extends Canvas
	{
		private var _btn:UIComponent;
		public var container:Canvas;
		private var flagNum:int = 0;
		private var _labelTxt:Label;
		private var _categoryBmp:PicBut
		private var _showBut:PicBut
		private var isOpen:Boolean;
		public function AccordionCanvas()
		{
			super();
			
			
			_btn = new UIComponent;
			this.setStyle("left",0);
			this.setStyle("right",0);
			this.addChild(_btn);
			_btn.addEventListener(MouseEvent.CLICK,onClick);
			_btn.buttonMode = true;
			
			_labelTxt = new Label;
			_labelTxt.setStyle("height",20);
			_labelTxt.setStyle("color",0x9f9f9f);
			_labelTxt.setStyle("paddingTop",4);
			_labelTxt.x = 40;
			_labelTxt.mouseChildren = false;
			_labelTxt.mouseEnabled = false;
			this.addChild(_labelTxt);
			//_labelTxt.text = "场景";
			
			_showBut=new PicBut
			_showBut.x=5
			_showBut.y=5
			_showBut.setBitmapdata( BrowerManage.getIcon("icon_PanUp"),10,10)
			this.addChild(_showBut)
			_categoryBmp=new PicBut
			_categoryBmp.x=20
			this.addChild(_categoryBmp)
			
			container = new Canvas;
			container.setStyle("left",10);
			container.setStyle("right",10);
			container.y = 25;
			this.addChild(container);
			
			isOpen = true;
			
			this.addEventListener(Event.ADDED_TO_STAGE,drawBg);
			this.addEventListener(ResizeEvent.RESIZE,drawBg);
			
			container.addEventListener(Event.ADDED_TO_STAGE,onSize);
			container.addEventListener(ResizeEvent.RESIZE,onSize);
		}
		
		protected function onSize(event:Event=null):void{
			for(var i:int;i<container.getChildren().length;i++){
				var ui:BaseComponent = container.getChildren()[i] as BaseComponent;
				if(ui){
					ui.width = container.width;
					if(ui.isDefault){
						ui.height = 20;
					}
				}
			}
		}
		
		
		
		public function set Lable(value:String):void{
			_labelTxt.text = value;
			
			switch(value)
			{
				case "位置":
				{
					_categoryBmp.setBitmapdata( BrowerManage.getIcon("icon_transform"),16,16)
					break;
				}
				case "材质":
				{
					_categoryBmp.setBitmapdata( BrowerManage.getIcon("icon_sphere_small"),16,16)
					break;
				}
				case "模型":
				{
					_categoryBmp.setBitmapdata( BrowerManage.getIcon("icon_box_small"),16,16)
					break;
				}
				case "属性":
				{
					_categoryBmp.setBitmapdata( BrowerManage.getIcon("icon_attribute"),16,16)
					break;
				}
					
				default:
				{
					_labelTxt.x=30
					break;
				}
			}
			
			
			
		}
		
		protected function onClick(event:MouseEvent):void
		{
			if(container.parent){
				this.removeChild(container);
				this.height = 25;
				isOpen = false;
				_showBut.setBitmapdata( BrowerManage.getIcon("icon_PanRight"),10,10)
			}else{
				this.addChild(container);
				this.height = container.height + 25;
				isOpen = true;
				_showBut.setBitmapdata( BrowerManage.getIcon("icon_PanUp"),10,10)
			}
			
		
			this.dispatchEvent(new Event("openchange"));
		}
		
		public function addComponent(ui:BaseComponent):void{
			container.addChild(ui);
			
//			ui.y = 25 * flagNum;
//			flagNum ++;
//			_container.height = flagNum * 25 + 10;
//			this.height = _container.height + 25;
			
			ui.y = flagNum;
			if(ui.isDefault){
				flagNum += 25;
			}else{
				flagNum += (ui.height + 5);
			}
			
			container.height = flagNum + 10;
			this.height = container.height + 25;
			
		}
		
		
		private function drawBg(event:Event = null):void{
			_btn.graphics.clear();
			_btn.graphics.beginFill(0x4f4f4f,1);
			_btn.graphics.drawRect(0,0,this.width,20);
			_btn.graphics.endFill();
		}

	}
}