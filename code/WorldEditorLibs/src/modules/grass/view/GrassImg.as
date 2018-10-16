package modules.grass.view
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.listClasses.ListBase;
	import mx.events.FlexEvent;
	
	import common.msg.event.grass.MEvent_deleGrass;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.img.FileImage;
	
	public class GrassImg extends ListBase
	{

		private var _fileImage:FileImage;
		public function GrassImg()
		{
			super();

			_fileImage=	new FileImage()
			this.addChild(_fileImage)
			this.width=60
			this.height=60
				
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE,list_dragEnterHandler)
			this.addEventListener(MouseEvent.RIGHT_CLICK,onRightClik)
		}
		
		protected function onRightClik(event:MouseEvent):void
		{
			_menuFile.display(this.stage,stage.mouseX,stage.mouseY);
			
		}
		private var _menuFile:NativeMenu = new NativeMenu;
		protected function list_dragEnterHandler(event:FlexEvent):void
		{
			var item:NativeMenuItem = new NativeMenuItem("删除");
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,onSel);
			
		}
		
		protected function onSel(event:Event):void
		{

			var $grassEvent:MEvent_deleGrass=new MEvent_deleGrass(MEvent_deleGrass.DELE_GRASS)
			$grassEvent.fileNode=FileNode(this.data)
			ModuleEventManager.dispatchEvent($grassEvent);

		}
		override public function set data(value:Object):void
		{
			super.data = value;
			_fileImage.x=3
			_fileImage.y=2
			_fileImage.width=this.width-6
			_fileImage.height=this.height-6
			_fileImage.fileUrl=String(value.url)

		}
	}
}