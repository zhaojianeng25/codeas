package view.menu
{
	public class MenuData
	{
		[Bindable]
		public static var myMenuData:XML = 
			<root> 
				<menuitem label="文件"> 
					<menuitem label="新建"/>
					<menuitem label="打开"/> 
					<menuitem label="保存"/> 
					<menuitem label="授权" action="3"/> 
				</menuitem> 
				<menuitem label="皮肤管理" data="mesh"/> 
				<menuitem label="骨骼管理" data="bone"/>
				<menuitem label="动作编辑" data="action"/>
			</root> 
		public function MenuData()
		{
			
		}
	}
}