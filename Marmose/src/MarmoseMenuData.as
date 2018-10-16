package  
	
{
	public class MarmoseMenuData
	{
		public function MarmoseMenuData()
		{
		}
		
		[Bindable]
		public static var menuXml:XML = 
			<root>
				<menuitem label="文件">
					<menuitem label="打开文件" id="0"/> 
				</menuitem> 

				<menuitem label="创建"> 
					<menuitem label="创建新单元" id="20"/> 
				</menuitem>
					<menuitem label="转换图片"> 
					<menuitem label="全图片转jpg" id="30"/> 
<menuitem label="单个转jpg" id="31"/> 
<menuitem label="转着色器" id="33"/> 
				</menuitem>

				<menuitem label="转换模型"> 
			    	<menuitem label="二进制转obj文件" id="40"/> 
				</menuitem>

				<menuitem label="窗口"> 
					<menuitem label="删除Glist文件" id="50"/> 
				</menuitem>


			</root> 

	}
}