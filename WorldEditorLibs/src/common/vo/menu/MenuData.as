package common.vo.menu
{
	public class MenuData
	{
		public function MenuData()
		{
		}
		
		[Bindable]
		public static var myMenuData:XML = 
			<root>
				<menuitem label="文件">
					<menuitem label="保存场景" id="0"/> 
					<menuitem label="场景另存为" id="15"/> 
					<menuitem label="修改编辑器配置" id="1"/>
				</menuitem> 
				<menuitem label="地形"> 
					<menuitem label="导出Obj" id="2"/> 
					<menuitem label="导出数据" id="3"/>
					<menuitem label="导出A3D" id="4"/>
					<menuitem label="显示网格" id="7"/>
		
				</menuitem>
				<menuitem label="灯光"> 
					<menuitem label="添加点灯" id="5"/> 
	
					<menuitem label="c++渲染" id="14"/> 
					<menuitem label="扫描ObjsIcon" id="12"/> 
					<menuitem label="连接c++渲染器" id="16"/> 
					<menuitem label="debug渲染" id="161"/> 
					<menuitem label="光线追踪镜头" id="20"/> 
				</menuitem>
				<menuitem label="显示"> 
					<menuitem label="地面网格" id="7"/> 
					<menuitem label="模型网格" id="20"/> 
					<menuitem label="默认布局" id="8"/> 
					<menuitem label="显示Collision" id="13"/> 
					<menuitem label="显示C++烘培参数" id="17"/> 

					<menuitem label="返回环境" id="9"/> 
				</menuitem>

				<menuitem label="导出"> 
					<menuitem label="导出小地图数据" id="11"/> 
					<menuitem label="导出唯一场景文件" id="18"/> 
			<menuitem label="合并lightmap" id="22"/> 

				</menuitem>

				<menuitem label="材质" data="action" id="88888">
						<menuitem label="生成jpng" id="21"/> 	
				</menuitem>
			</root> 

	}
}