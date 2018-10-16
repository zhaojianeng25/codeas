package view.topmenu
{
	public class TopMenulist
	{
		public function TopMenulist()
		{
		}
		/*
		<component:ImageButton source="style/btn/new.png" toolTip="新建" data="0" click="onMenuClick(event)"/>
			<component:ImageButton source="style/btn/open.png" toolTip="打开" x="30" data="1" click="onMenuClick(event)"/>
			<component:ImageButton source="style/btn/save.png" toolTip="保存" x="60" data="2" click="onMenuClick(event)"/>
			<component:ImageButton source="style/btn/mesh.png" toolTip="皮肤管理" x="90" data="3" click="onMenuClick(event)"/>
			<component:ImageButton source="style/btn/action.png" toolTip="动作管理" x="120" data="4" click="onMenuClick(event)"/>
			<component:ImageButton source="style/btn/edit.png" toolTip="编辑面板" x="150" data="5" click="onMenuClick(event)"/>
			<component:ImageButton source="style/btn/showbone.png" toolTip="显示骨架" x="180" data="6" click="onMenuClick(event)"/>
			<component:ImageButton source="style/btn/showMesh.png" toolTip="隐藏/显示mesh" x="210" data="7" click="onMenuClick(event)"/>
			<component:ImageButton source="style/btn/bone.png" toolTip="骨骼管理" x="240" data="8" click="onMenuClick(event)"/>
			<component:ImageButton source="style/btn/hang.png" toolTip="悬挂管理" x="270" data="9" click="onMenuClick(event)"/>
		
			<component:ImageButton source="style/btn/urlSet.png" toolTip="路径设定" x="300" data="10" click="onMenuClick(event)"/>
			<component:ImageButton source="style/btn/exp.png" toolTip="导出人物+动画" x="330" data="11" click="onMenuClick(event)"/>
			<component:ImageButton source="style/btn/ride.png" toolTip="坐骑" x="360" data="12" click="onMenuClick(event)"/>
			<component:ImageButton source="style/btn/setBg.png" toolTip="更换背景" x="390" data="13" click="onMenuClick(event)"/>
			<component:ImageButton source="style/btn/setting.png" toolTip="设置" x="420" data="14" click="onMenuClick(event)"/>
		
			<component:ImageButton source="style/btn/preset.png" toolTip="导出预处理" x="450" data="15" click="onMenuClick(event)"/>
			<component:ImageButton source="style/btn/byteFile.png" toolTip="文件压缩转换" x="480" data="17" click="onMenuClick(event)"/>
			<component:ImageButton source="style/btn/mesh2anim.png" toolTip="mesh和anim对应" x="510" data="18" click="onMenuClick(event)"/>
			<component:ImageButton source="style/btn/posChange.png" toolTip="位置剥离" x="540" data="18" click="showAnimPosChange()"/>
			<component:ImageButton source="style/btn/light.png" toolTip="流光" x="570" data="18" click="showLight()"/>
			<component:ImageButton source="style/btn/normal.png" toolTip="法线" x="600" data="18" click="showNormal()"/>
			<component:ImageButton source="style/btn/updateSortWare.png" toolTip="软件更新" right="30" data="16" click="onMenuClick(event)"/>
*/
		[Bindable]
		public static var menuXml:XML = 
			<root>
				<menuitem label="文件">
					<menuitem label="新建" id="0"/> 
					<menuitem label="打开" id="1"/> 
<menuitem label="保存" id="2"/>
<menuitem label="另存为" id="22"/>
		
				</menuitem> 
				<menuitem label="管理"> 
					<menuitem label="皮肤管理" id="3"/> 
<menuitem label="动作管理" id="4"/> 
<menuitem label="编辑面板" id="5"/> 
<menuitem label="显示骨架" id="6"/> 
<menuitem label="隐藏/显示mesh" id="7"/> 
<menuitem label="骨骼管理" id="8"/> 
<menuitem label="悬挂管理" id="9"/> 

				</menuitem>
				<menuitem label="设定"> 
					<menuitem label="路径设定" id="10"/> 
			
					<menuitem label="坐骑" id="45"/> 
					<menuitem label="更换背景" id="13"/> 
<menuitem label="设置" id="14"/> 


				</menuitem>
				<menuitem label="导出"> 
<menuitem label="导出预处理" id="15"/> 
<menuitem label="文件压缩转换" id="17"/> 


		<menuitem label="导出人物+动画" id="11"/> 
<menuitem label="导出技能" id="19"/> 

<menuitem label="设置数据库表" id="20"/> 
				</menuitem>



				<menuitem label="窗口"> 
		<menuitem label="编辑器属性" id="50"/> 
		<menuitem label="显示/隐藏网格" id="51"/> 
		
				</menuitem>


				

			</root> 

	}
}