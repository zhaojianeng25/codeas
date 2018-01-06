package tempest.utils
{
	import flash.display.Sprite;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;

	public class VersionUtil
	{
		/**
		 * 设置右键菜单
		 * @param versionXMLCls
		 * @param main
		 * @param strFormat
		 */
		public static function setRightMenu(versionXMLCls:Class, main:Sprite, strFormat:String = "MyApp Build@build R@release"):void
		{
			var versionXMLData:ByteArray = new versionXMLCls as ByteArray;
			var versionXML:XML = new XML(versionXMLData.readUTFBytes(versionXMLData.length));
			strFormat = strFormat.replace("@build", versionXML.build.@count);
			strFormat = strFormat.replace("@release", versionXML.release.@count);
			main.contextMenu = main.contextMenu || new ContextMenu();
			main.contextMenu.hideBuiltInItems();
			main.contextMenu.customItems.push(new ContextMenuItem(strFormat, false, false));
		}

		/**
		 * 获取版本
		 * @param versionXMLCls
		 * @param strFormat
		 * @return
		 */
		public static function getVersion(versionXMLCls:Class, strFormat:String = "MyApp Build@build R@release"):String
		{
			var versionXMLData:ByteArray = new versionXMLCls as ByteArray;
			var versionXML:XML = new XML(versionXMLData.readUTFBytes(versionXMLData.length));
			strFormat = strFormat.replace("@build", versionXML.build.@count);
			strFormat = strFormat.replace("@release", versionXML.release.@count);
			return strFormat;
		}
	}
}
