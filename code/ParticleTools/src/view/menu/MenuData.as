package view.menu
{
	public class MenuData
	{
		[Bindable]
		public static var myMenuData:XML=
			<root>
				<menuitem label="文件"> 
					<menuitem label="新建" action="1"/>
					<menuitem label="打开" action="2"/>
					<menuitem label="保存" action="3"/>
			<menuitem label="另存为" action="4"/>
			<menuitem label="工程另存为" action="12"/>
					<menuitem label="导出" action="5"/>
				</menuitem> 
				<menuitem label="配置">
					<menuitem label="路径设置" action="6"/>
					<menuitem label="序列图设置" action="7"/>
					<menuitem label="项目配置" action="9"/>
					<menuitem label="授权" action="10"/>
				</menuitem>
				<menuitem label="添加">
				 <menuitem label="角色" action="8"/>
				 <menuitem label="模型" action="11"/>
				</menuitem>
			</root>
		public function MenuData()
		{
		}
		
	}
}