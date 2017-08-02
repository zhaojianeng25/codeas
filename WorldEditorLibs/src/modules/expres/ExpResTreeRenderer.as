package modules.expres
{
	import mx.controls.Label;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import common.utils.ui.prefab.PicBut;
	
	import modules.brower.fileWin.BrowerManage;
	
	public class ExpResTreeRenderer   extends TreeItemRenderer
	{
		private var _lockBut:PicBut;
		private var _nameLabel:Label;
		private var _infoTxt:Label;
		public function ExpResTreeRenderer()
		{
			super();
			addnames();
			addLabels();
			addButs();
			this.addEventListener(FlexEvent.DATA_CHANGE,dataChange)
		}
		
		private function addnames():void
		{
			_nameLabel=new Label
			_nameLabel.x=120
			_nameLabel.y=5
			_nameLabel.text="c"
			_nameLabel.width=200
			_nameLabel.height=20
			_nameLabel.setStyle("color",0x9f9f9f);
			_nameLabel.setStyle("size",14);
			this.addChild(_nameLabel)
			
		}
		private function addLabels():void
		{
			_infoTxt=new Label
			_infoTxt.x=200
			_infoTxt.y=5
			_infoTxt.text="c"
			_infoTxt.width=200
			_infoTxt.height=20
			_infoTxt.setStyle("color",0x9f9f9f);
			_infoTxt.setStyle("size",14);
			this.addChild(_infoTxt)
		

		}
		protected function dataChange(event:FlexEvent):void
		{
			if(this.data){
				_nameLabel.text=this.data.name;
				_infoTxt.text=this.data.info;
			}
		}
		protected function onResize(event:ResizeEvent):void
		{
		
		}
		
		private function addButs():void
		{
			_lockBut=new PicBut
			_lockBut.setBitmapdata(BrowerManage.getIcon("lockbutton_b"),15,15)
			_lockBut.y=4
			_lockBut.x=150
			_lockBut.buttonMode=true
			//this.addChild(_lockBut)
			
		}
		
	
	}
}