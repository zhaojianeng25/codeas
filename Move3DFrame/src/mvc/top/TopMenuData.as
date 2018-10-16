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
					<menuitem label="打开文件" id="10"/> 
					<menuitem label="保存文件" id="11"/> 
		<menuitem label="项目另存为" id="12"/> 

					<menuitem label="设置工作空间" id="14"/> 
				</menuitem> 

				<menuitem label="创建"> 

			<menuitem label="导出视屏" id="21"/> 

		<menuitem label="连接c++渲染" id="22"/> 
		<menuitem label="只渲染当前帧" id="23"/> 
				</menuitem>

				<menuitem label="编辑"> 
					<menuitem label="转换模型贴图" id="30"/> 
					<menuitem label="转换法线YZ互换" id="31"/> 
					<menuitem label="转换法线-Y" id="32"/> 
					<menuitem label="转换法线-Z" id="33"/> 
				</menuitem>

		<menuitem label="导出"> 
				<menuitem label="导出Fram3dH5" id="40"/> 
				<menuitem label="导入场景编辑器地图" id="41"/> 
<menuitem label="导入场景环境信息" id="42"/> 


				</menuitem>


				<menuitem label="窗口"> 
					<menuitem label="返回场景参数" id="50"/> 
				</menuitem>


			</root> 

	}
}