package view.controlCenter
{
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.CheckBox;
	import mx.controls.Label;
	import mx.controls.RadioButton;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.controls.treeClasses.TreeListData;
	
	
	public class LTreeItemRenderer extends TreeItemRenderer
	{
		private var lab:CheckBox;
		private var labW:int = 100;
		private var labH:int = 20;
		
		public function LTreeItemRenderer()
		{
			super();
			BindingUtils.bindSetter(SetLab,this,"listData");
			//this.height = 5;
			mouseFocusEnabled = false;
		}
		override protected function createChildren():void{
			super.createChildren();
			if(!lab){
				lab=new CheckBox();
				addChild(lab);
				lab.width = labW;
				lab.height = labH;
				lab.x = 10;
				lab.y = -4;
			}
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			lab.x = 10;//unscaledWidth-lab.width + 50;
			lab.y = -4;
			this.measuredHeight = 20;
			label.textColor = 0x9C9C9C;
		} 
		override protected function measure():void{
			super.measure();
			measuredHeight = 15;
		}
		
		/**
		 *
		 * @param value TreeListData listData
		 * 它的数据结构中间的item的结构一个XML
		 *
		 */
		private function SetLab(value:TreeListData):void{
			if(!value||!lab)
				return;
			//var str:String = value.item.name;
			if(value.hasChildren){
				lab.visible = false;
			}else{
				lab.visible = true;
			}
			lab.selected =  value.item.check;
			draw(value.hasChildren);
		}
		private function draw(isChildren:Boolean):void{
			this.graphics.clear();
			if(!isChildren){
				this.graphics.lineStyle(1,0x999999,0.5);
				this.graphics.moveTo(10,17);
			}else{
				this.graphics.lineStyle(1,0x999999,1);
				this.graphics.moveTo(0,17);
			}
			
			this.graphics.lineTo(202,17);
		}
		
	}
}