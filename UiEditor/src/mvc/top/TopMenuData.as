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
					<menuitem label="刷新图片" id="4"/>
				</menuitem> 
				<menuitem label="创建"> 
					<menuitem label="创建新单元" id="20"/> 
		<menuitem label="创建9宫格" id="21"/> 
		<menuitem label="创建共享图" id="22"/> 
				<menuitem label="隐藏线框" id="23"/> 
				</menuitem>
				<menuitem label="编辑"> 
					<menuitem label="复制" id="30"/> 
					<menuitem label="粘贴" id="31"/> 
					<menuitem label="删除" id="32"/> 
					<menuitem label="撤销一次" id="33"/> 
		<menuitem label="重作一次" id="34"/> 

		<menuitem label="排序列表" id="35"/> 
		<menuitem label="清理无引用" id="36"/> 
	

				</menuitem>
				<menuitem label="导出"> 

<menuitem label="导出h5uiXML" id="40"/> 
<menuitem label="lua转Csv" id="41"/> 	
				</menuitem>



				<menuitem label="窗口"> 

<menuitem label="删除Glist文件" id="50"/> 
<menuitem label="清理H5工作目录" id="52"/> 
	<menuitem label="合并系列动画" id="51"/> 
<menuitem label="打包项目" id="53"/> 
<menuitem label="zipFile" id="54"/> 

		
				</menuitem>


				

			</root> 

	}
}