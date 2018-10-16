package  mvc.top
{
	public class TopMenuData
	{
		public function TopMenuData()
		{
		}
		
		[Bindable]
		public static var menuXml:XML = 
			<root>
				<menuitem label="文件">
					<menuitem label="打开文件" id="0"/> 
					<menuitem label="新建立空项目" id="1"/> 
					<menuitem label="保存文件" id="2"/> 
					<menuitem label="文件另存为" id="3"/>

				</menuitem> 
				<menuitem label="创建"> 
					<menuitem label="创建新单元" id="20"/> 
					<menuitem label="创建9宫格" id="21"/> 

				</menuitem>
				<menuitem label="编辑"> 
					<menuitem label="复制" id="30"/> 
					<menuitem label="粘贴" id="31"/> 
					<menuitem label="删除" id="32"/> 
					<menuitem label="撤销一次" id="33"/> 
					<menuitem label="重作一次" id="34"/> 

				</menuitem>
				<menuitem label="导出"> 


				</menuitem>



				<menuitem label="窗口"> 


		
				</menuitem>


				

			</root> 

	}
}