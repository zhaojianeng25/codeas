package tempest.utils
{
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.ui.ContextMenuItem;

	public class ContextMenuPlus
	{
		private var _contextMenu:ContextMenu;

		//########################################################################## 
		/**
		 * @param removeAll 是否禁用所有默认菜单
		 * @param listener 自定义菜单事件句柄
		 * @param ...customItems 自定义标签，可以是一个数组
		 */
		public function ContextMenuPlus(removeAll:Boolean=true, listener:Function=null, ... customItems)
		{
			_contextMenu=new ContextMenu();
			if (removeAll)
			{
				removeDefault();
			}
			if (customItems.length > 0)
			{
				addCustomItems(listener, customItems);
			}
		}

		//########################################################################## 
		//添加属性
		//########################################################################## 
		public function get contextMenu():ContextMenu
		{
			return _contextMenu;
		}

		public function get builtInItems():ContextMenuBuiltInItems
		{
			return _contextMenu.builtInItems;
		}

		//########################################################################## 
		// 
		// Methods 方法
		// 
		//########################################################################## 
		/**
		 * 禁用默认菜单
		 * @param ...leave 保留默认菜单(标签数组)
		 */
		public function removeDefault(... leave):void
		{
			_contextMenu.hideBuiltInItems();
			if (leave.length == 0)
			{
				return;
			}
			var defaultItems:ContextMenuBuiltInItems=_contextMenu.builtInItems;
			for each (var item:String in leave)
			{
				defaultItems[item]=true;
			}
		}

		/**
		 * 添加自定义菜单项
		 * @param caption 菜单项标题
		 * @param listener 事件句柄
		 * @param separatorBefore 是否在菜单上方添加分割线
		 * @param enabled 是否可用
		 * @param visible 是否可见
		 */
		public function addCustom(listener:Function, caption:String, separatorBefore:Boolean=false, enabled:Boolean=true, visible:Boolean=true):void
		{
			var item:ContextMenuItem=new ContextMenuItem(caption, separatorBefore, enabled, visible);
			_contextMenu.customItems.push(item);
			if (listener != null)
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, listener);
		}

		/**
		 * 添加自定义菜单组，所有菜单项共用同一个事件句柄
		 * 通过 event.currentTarget.caption 区分不同的菜单项
		 * private function onSelect(event:ContextMenuEvent):void{
		 * var item:ContextMenuItem = event.currentTarget;
		 * switch(item.caption)...}
		 * @param listener 事件句柄
		 * @param separatorBefore 是否在菜单组上方添加分隔线
		 * @param ...customItems 菜单项标题，可以是一个数组
		 */
		public function addGroup(listener:Function, separatorBefore:Boolean=false, ... customItems):void
		{
			addCustomItems(listener, customItems, separatorBefore);
		}

		//########################################################################## 
		//添加自定义菜单项
		//########################################################################## 
		private function addCustomItems(listener:Function, customItems:Array, separatorBefore:Boolean=false):void
		{
			var itemArr:Array=customItems.length == 1 && customItems[0] is Array ? customItems[0] : customItems;
			for each (var caption:String in itemArr)
			{
				addCustom(listener, caption, separatorBefore);
				if (separatorBefore)
				{
					separatorBefore=false;
				}
			}
		}
	}
}
