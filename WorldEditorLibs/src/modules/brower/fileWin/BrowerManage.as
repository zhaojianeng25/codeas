package modules.brower.fileWin
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	
	import common.AppData;
	import common.msg.event.hierarchy.MEvent_Hierarchy_ReFileName;
	
	import materials.Material;
	import materials.MaterialCubeMap;
	import materials.MaterialReflect;
	import materials.MaterialShadow;
	import materials.MaterialTree;
	import materials.Texture2DMesh;
	import materials.TextureParticleMesh;
	
	import modules.prefabs.PrefabManager;
	
	import pack.GroupMesh;
	import pack.Prefab;
	import pack.PrefabStaticMesh;

	public class BrowerManage
	{
		public function BrowerManage()
		{
		}
		/**
		 *新建立文件 
		 * @param $file
		 * @param $url
		 * 
		 */
		public static function creaFloder($file:File,$url:String="新建文件夹"):void
		{
			var newUrl:String;
			if($file.isDirectory){
				newUrl=$file.nativePath+"/"+$url
			}else{
				newUrl=$file.nativePath.substr(0,$file.nativePath.length-$file.name.length)+"/"+$url
			}
			var newFile:File = new File(newUrl);
			if(!newFile.exists){
				newFile.createDirectory();
			}
		}
		/**
		 *更改文件名 
		 * @param $file
		 * @param $str
		 * 
		 */
		public static function changeFileName($file:File,$str:String):Boolean
		{
			if($str.length==0){
				return false
			}
			var newUrl:String;
			if($file.isDirectory){
				newUrl=$file.nativePath.substr(0,$file.nativePath.length-$file.name.length)+$str;
			}else{
				newUrl=$file.nativePath.substr(0,$file.nativePath.length-$file.name.length)+$str+"."+$file.extension
			}
			if(newUrl==$file.nativePath){
				return false
			}
			var newFile:File = new File(newUrl);
			if(newFile.exists){
				
				Alert.show("文件夹下已存在同名文件，重命名失败！");
				return false
			}else{
				
				if($file.extension=="lmap"){
					changeMapFolder($file,newFile)
				}
			
				$file.moveTo(newFile,true);
				if($file.extension=="group"){
				
					var $evt:MEvent_Hierarchy_ReFileName=new MEvent_Hierarchy_ReFileName(MEvent_Hierarchy_ReFileName.MEVENT_HIERARCHY_REFILENAME)
					$evt.file=newFile
					ModuleEventManager.dispatchEvent($evt);
					
		
					
				}
				return true
			}
			function changeMapFolder(a:File,b:File):void
			{
				var aUrl:String=a.url.replace("."+a.extension,"_hide")
				var bUrl:String=b.url.replace("."+b.extension,"_hide")
				var af:File = new File(aUrl);
				var bf:File = new File(bUrl);
				if(af.exists&&!bf.exists){ //A有B没有
					af.moveTo(bf,true);
				}
			}
		
			
		}
	
		public static function creatMap($file:File,name:String):void
		{
			if($file.isDirectory){
				var obj:Object = new Object;
				var file:File = new File($file.url + "/" + name + ".lmap");
//				if(file.exists){
//					file = new File($file.url + "/newmap1.lmap"); 
//				}
				if(file.exists){
					Alert.show("创建失败！");
					return;
				}
				var fs:FileStream = new FileStream;
				fs.open(file,FileMode.WRITE);
				fs.writeObject(obj);
				fs.close();
			}
		
		}
		/**
		 *修显是否显示perfab里的内容 
		 * @param $file
		 * 
		 */
		private static var _perFabKey:Dictionary=new Dictionary;
		public static function changePerFabShow($file:File):void
		{
			if(_perFabKey[$file.url]){
				_perFabKey[$file.url]=!Boolean(_perFabKey[$file.url]);
			}else{
				_perFabKey[$file.url]=true;
			}
			var $prefabStaticMesh:PrefabStaticMesh=PrefabManager.getInstance().getPrefabByUrl($file.url);
			changeObjsShow(new File(AppData.workSpaceUrl+$prefabStaticMesh.axoFileName),_perFabKey[$file.url])
		}
		private static var _objsKey:Dictionary=new Dictionary;
		public static function changeObjsShow($file:File,value:Boolean):void
		{
			_objsKey[$file.url]=value;
			
		}
		public static function isObjsCanShow($file:File):Boolean
		{
			if(AppData.showObjs){
			    return AppData.showObjs;
			}
			return _objsKey[$file.url];
		}
		public static function isPerfabCanShow($file:File):Boolean
		{
			return _perFabKey[$file.url];
		}
		
		
		[Embed(source="assets/icon/folder.jpg")]
		private static const bmpFoldder:Class;
		[Embed(source="assets/Landscape.png")]
		private static const Landscape:Class;
		
		[Embed(source="assets/marterial.png")]
		private static const MaterialCls:Class;
		[Embed(source="assets/marterialins.png")]
		private static const MaterialinsCls:Class;
		
		[Embed(source="assets/marterial_01.png")]
		private static const MaterialReflectCls:Class;
		[Embed(source="assets/icon_Particle.png")]
		private static const TextureParticleCls:Class;
		[Embed(source="assets/icon_Texture2d.png")]
		private static const Texture2DCls:Class;
		
		[Embed(source="assets/marterial_02.png")]
		private static const MaterialCubeMapCls:Class;
		
		[Embed(source="assets/marterial_03.png")]
		private static const MaterialShadowCls:Class;
		[Embed(source="assets/icon_folder_small.png")]
		private static const icon_folder_small:Class;
		
		[Embed(source="assets/profeb.png")]
		private static const PrefabCls:Class;
		[Embed(source="assets/icon_cube01.png")]
		private static const icon_cube01:Class;
		[Embed(source="assets/search.png")]
		private static const Search:Class;
		[Embed(source="assets/meinv.png")]
		private static const Meinv:Class;
		
		[Embed(source="assets/Grid.png")]
		private static const Grid:Class;
		
		[Embed(source="assets/icon_PanRight.png")]
		private static const icon_PanRight:Class;
		[Embed(source="assets/icon_PanUp.png")]
		private static const icon_PanUp:Class;
		[Embed(source="assets/icon_transform.png")]
		private static const icon_transform:Class;
		
		[Embed(source="assets/icon_sphere_small.png")]
		private static const icon_sphere_small:Class;
		
		[Embed(source="assets/icon_box_small.png")]
		private static const icon_box_small:Class;
		[Embed(source="assets/icon_attribute.png")]
		private static const icon_attribute:Class;
		[Embed(source="assets/menu/icon_Folder_64x.png")]
		private static const icon_Folder_64x:Class;
		
		[Embed(source="assets/Emitter_particle_18p.png")]
		private static const Emitter_particle_18p:Class;
		
		
		[Embed(source="assets/coins_32.png")]
		private static const Database:Class;
		
		[Embed(source="assets/table_32.png")]
		private static const Page:Class;
		
		[Embed(source="assets/folder_32.png")]
		private static const Folder:Class;
		
		[Embed(source="assets/ATO.png")]
		private static const Ato:Class;
		
		[Embed(source="assets/AXO.png")]
		private static const Axo:Class;
		
		[Embed(source="assets/BAY.png")]
		private static const Bay:Class;
		
		[Embed(source="assets/MD.png")]
		private static const Md:Class;
		
		[Embed(source="assets/MAP.png")]
		private static const Map:Class;
		
		[Embed(source="assets/CSV.png")]
		private static const Csv:Class;
		
		[Embed(source="assets/BOQ.png")]
		private static const Boq:Class;
		
		[Embed(source="assets/ATM.png")]
		private static const Atm:Class;
		
		[Embed(source="assets/AXM.png")]
		private static const Axm:Class;
		
		[Embed(source="assets/ACT.png")]
		private static const Act:Class;
		
		[Embed(source="assets/BON.png")]
		private static const Bon:Class;
		
		[Embed(source="assets/SKL.png")]
		private static const Skl:Class;
		
		[Embed(source="assets/closeX.png")]
		private static const closeX:Class;
		
		[Embed(source="assets/CA_GroupBackground.png")]
		private static const icon_box_back:Class;
		[Embed(source="assets/icon_box_change.png")]
		private static const icon_box_change:Class;


		
		[Embed(source="assets/coins_16.png")]
		private static var coins_16:Class;
		[Embed(source="assets/icon_class_DirectionalLight18.png")]
		private static var icon_class_DirectionalLight18:Class;
		[Embed(source="assets/captureIcon16.png")]
		private static var captureIcon16:Class;
		[Embed(source="assets/lightProbeIco.png")]
		private static var lightprobeIco:Class;
		[Embed(source="assets/table_16.png")]
		private static var table_16:Class;
		[Embed(source="assets/grass_16.png")]
		private static var grass_16:Class;
		[Embed(source="assets/folder_16.png")]
		private static var folder_16:Class;
		[Embed(source="assets/profeb_16.png")]
		private static var profeb_16:Class;
		[Embed(source="assets/icon_point16.png")]
		private static var light_16:Class;
		[Embed(source="assets/jiantou32.png")]
		private static var jiantou32:Class;
		[Embed(source="assets/water_plane16.png")]
		private static var water_16:Class;
		[Embed(source="assets/hideIcon20.png")]
		private static var hideIcon20:Class;
		[Embed(source="assets/menu/icon_FolderOpen_bright.png")]
		private static var icon_FolderOpen_bright:Class;
		[Embed(source="assets/menu/icon_FolderOpen_dark.png")]
		private static var icon_FolderOpen_dark:Class;
		
		

		
		[Embed(source="assets/icon/Select.png")]
		private static var Select:Class;
		[Embed(source="assets/icon/Move.png")]
		private static var Move:Class;
		[Embed(source="assets/icon/Rotate.png")]
		private static var Rotate:Class;
		[Embed(source="assets/icon/Scale.png")]
		private static var Scale:Class;
		[Embed(source="assets/icon/Camera.png")]
		private static var Camera:Class;
		
		[Embed(source="assets/Materialcompiler.png")]
		private static var Materialcompiler:Class;
		[Embed(source="assets/Materialsave.png")]
		private static var Materialsave:Class;
		[Embed(source="assets/seePanelBut.png")]
		private static var seePanelBut:Class;
		[Embed(source="assets/Align_a.png")]
		private static var Align_a:Class;
		[Embed(source="assets/Align_b.png")]
		private static var Align_b:Class;
		[Embed(source="assets/Align_c.png")]
		private static var Align_c:Class;
		
		
		[Embed(source="assets/h5uia1.png")]
		private static var h5uia1:Class;
		[Embed(source="assets/h5uia2.png")]
		private static var h5uia2:Class;
		[Embed(source="assets/h5uia3.png")]
		private static var h5uia3:Class;
		[Embed(source="assets/h5uia4.png")]
		private static var h5uia4:Class;
		[Embed(source="assets/h5uia5.png")]
		private static var h5uia5:Class;
		[Embed(source="assets/h5uia6.png")]
		private static var h5uia6:Class;
		[Embed(source="assets/h5uia7.png")]
		private static var h5uia7:Class;
		[Embed(source="assets/h5uia8.png")]
		private static var h5uia8:Class;
		[Embed(source="assets/h5uia9.png")]
		private static var h5uia9:Class;
		[Embed(source="assets/h5uia10.png")]
		private static var h5uia10:Class;
		[Embed(source="assets/h5uia11.png")]
		private static var h5uia11:Class;



	
		
		
		
		
		[Embed(source="assets/icon/Box001.png")]
		private static var Box001:Class;
		[Embed(source="assets/icon/Cylinder001.png")]
		private static var Cylinder001:Class;
		[Embed(source="assets/icon/Plane001.png")]
		private static var Plane001:Class;
		[Embed(source="assets/icon/Sphere001.png")]
		private static var Sphere001:Class;
		[Embed(source="assets/icon/Teapot001.png")]
		private static var Teapot001:Class;
		
		
		[Embed(source="assets/LockButton_b.png")]
		private static var LockButton_b:Class;
		[Embed(source="assets/LockButton_a.png")]
		private static var LockButton_a:Class;
		[Embed(source="assets/renderLine.jpg")]
		private static var renderLine:Class;

		
		
		
		
		
		
		
		
		public static function getIcon($str:String):BitmapData
		{
	
			switch($str.toLocaleLowerCase())
			{
				case "h5uia1":
				{
					return Bitmap(new h5uia1).bitmapData
					break;
				}
				case "h5uia2":
				{
					return Bitmap(new h5uia2).bitmapData
					break;
				}
				case "h5uia3":
				{
					return Bitmap(new h5uia3).bitmapData
					break;
				}
				case "h5uia4":
				{
					return Bitmap(new h5uia4).bitmapData
					break;
				}
				case "h5uia5":
				{
					return Bitmap(new h5uia5).bitmapData
					break;
				}
				case "h5uia6":
				{
					return Bitmap(new h5uia6).bitmapData
					break;
				}
				case "h5uia7":
				{
					return Bitmap(new h5uia7).bitmapData
					break;
				}
				case "h5uia8":
				{
					return Bitmap(new h5uia8).bitmapData
					break;
				}
				case "h5uia9":
				{
					return Bitmap(new h5uia9).bitmapData
					break;
				}
				case "h5uia10":
				{
					return Bitmap(new h5uia10).bitmapData
					break;
				}
				case "h5uia11":
				{
					return Bitmap(new h5uia11).bitmapData
					break;
				}
		
					
				case "align_a":
				{
					return Bitmap(new Align_a).bitmapData
					break;
				}
				case "align_b":
				{
					return Bitmap(new Align_b).bitmapData
					break;
				}
				case "align_c":
				{
					return Bitmap(new Align_c).bitmapData
					break;
				}
				case "jiantou32":
				{
					return Bitmap(new jiantou32).bitmapData
					break;
				}
				case "seepanelbut":
				{
					return Bitmap(new seePanelBut).bitmapData
					break;
				}
				case "lmap":
				{
					return Bitmap(new Landscape).bitmapData
					break;
				}
				case "closex":
				{
					return Bitmap(new closeX).bitmapData
					break;
				}
				case "material":
				{
					return Bitmap(new MaterialCls).bitmapData
					break;
				}
				case "materialins":
				{
					return Bitmap(new MaterialinsCls).bitmapData
					break;
				}
				case "prefab":
				{
					return Bitmap(new PrefabCls).bitmapData
					break;
				}
				case "search":
				{
					return Bitmap(new Search).bitmapData
					break;
				}
				case "meinv":
				{
					return Bitmap(new Grid).bitmapData
					break;
				}
				case "database":
				{
					return Bitmap(new Database).bitmapData
					break;
				}
				case "page":
				{
					return Bitmap(new Page).bitmapData
					break;
				}
				case "folder":
				{
					return Bitmap(new Folder).bitmapData
					break;
				}
				case "ato":
				{
					return Bitmap(new Ato).bitmapData
					break;
				}
				case "axo":
				{
					return Bitmap(new Axo).bitmapData
					break;
				}
				case "bay":
				{
					return Bitmap(new Bay).bitmapData
					break;
				}
				case "md":
				{
					return Bitmap(new Md).bitmapData
					break;
				}
				case "map":
				{
					return Bitmap(new Map).bitmapData
					break;
				}
				case "csv":
				{
					return Bitmap(new Csv).bitmapData
					break;
				}
				case "boq":
				{
					return Bitmap(new Boq).bitmapData
					break;
				}
				case "axm":
				{
					return Bitmap(new Axm).bitmapData
					break;
				}
				case "bon":
				{
					return Bitmap(new Bon).bitmapData
					break;
				}
				case "atm":
				{
					return Bitmap(new Atm).bitmapData
					break;
				}
				case "act":
				{
					return Bitmap(new Act).bitmapData
					break;
				}
				case "skl":
				{
					return Bitmap(new Skl).bitmapData
					break;
				}
				case "select":
				{
					return Bitmap(new Select).bitmapData
					break;
				}
				case "move":
				{
					return Bitmap(new Move).bitmapData
					break;
				}
				case "rotate":
				{
					return Bitmap(new Rotate).bitmapData
					break;
				}
				case "scale":
				{
					return Bitmap(new Scale).bitmapData
					break;
				}
					
				case "camera":
				{
					return Bitmap(new Camera).bitmapData
					break;
				}
				case "materialcompiler":
				{
					return Bitmap(new Materialcompiler).bitmapData
					break;
				}
				case "materialsave":
				{
					return Bitmap(new Materialsave).bitmapData
					break;
				}
				case "cube":
				{
					return Bitmap(new MaterialCubeMapCls).bitmapData
					break;
				}
				case "box001":
				{
					return Bitmap(new Box001).bitmapData
					break;
				}
				case "cylinder001":
				{
					return Bitmap(new Cylinder001).bitmapData
					break;
				}
				case "plane001":
				{
					return Bitmap(new Plane001).bitmapData
					break;
				}
				case "sphere001":
				{
					return Bitmap(new Sphere001).bitmapData
					break;
				}
				case "teapot001":
				{
					return Bitmap(new Teapot001).bitmapData
					break;
				}
				case "lockbutton_a":
				{
					return Bitmap(new LockButton_a).bitmapData
					break;
				}
				case "lockbutton_b":
				{
					return Bitmap(new LockButton_b).bitmapData
					break;
				}
				case "renderline":
				{
					return Bitmap(new renderLine).bitmapData
					break;
				}
				case "icon_box_change":
				{
					return Bitmap(new icon_box_change).bitmapData
					break;
				}
				case "icon_box_back":
				{
					return Bitmap(new icon_box_back).bitmapData
					break;
				}
				case "light_16":
				{
					return Bitmap(new light_16).bitmapData
					break;
				}
				case "water_16":
				{
					return Bitmap(new water_16).bitmapData
					break;
				}
				case "icon_cube01":
				{
					return Bitmap(new icon_cube01).bitmapData
					break;
				}
				case "icon_panright":
				{
					return Bitmap(new icon_PanRight).bitmapData
					break;
				}
					
				case "icon_panup":
				{
					return Bitmap(new icon_PanUp).bitmapData
					break;
				}
				case "icon_transform":
				{
					return Bitmap(new icon_transform).bitmapData
					break;
				}
				case "icon_sphere_small":
				{
					return Bitmap(new icon_sphere_small).bitmapData
					break;
				}
				case "icon_box_small":
				{
					return Bitmap(new icon_box_small).bitmapData
					break;
				}
				case "icon_attribute":
				{
					return Bitmap(new icon_attribute).bitmapData
					break;
				}
				case "icon_folder_64x":
				{
					return Bitmap(new icon_Folder_64x).bitmapData
					break;
				}
					
				default:
				{
					break;
				}
			}	
			return null
		}
		



		public static function getIconClassByName($str:String):Class
		{
			switch($str)
			{
				case "hideIcon20":
				{
					return hideIcon20;
					
					break;
				}
				case "coins":
				{
					return coins_16;
					
					break;
				}
				case "icon_class_DirectionalLight18":
				{
					return icon_class_DirectionalLight18;
					
					break;
				}
				case "Emitter_particle_18p":
				{
					return Emitter_particle_18p;
					
					break;
				}
				case "captureIcon16":
				{
					return captureIcon16;
					
					break;
				}
				case "lightprobeIco":
				{
					return lightprobeIco;
					
					break;
				}
					
				case "table_16":
				{
					return table_16;
					
					break;
				}
				case "grass_16":
				{
					return grass_16;
					
					break;
				}
					
				case "folder":
				{
					return folder_16;
					
					break;
				}
				case "icon_folderopen_bright":
				{
					return icon_FolderOpen_bright;
					
					break;
				}
				case "icon_FolderOpen_dark":
				{
					return icon_FolderOpen_dark;
					
					break;
				}
				case "profeb_16":
				{
					return profeb_16;
					
					break;
				}
				case "light_16":
				{
					return light_16;
					
					break;
				}
				case "water_16":
				{
					return water_16;
					
					break;
				}
					
				default:
				{
					return folder_16;
					break;
				}
			}
				
		}
		public static function getIconByClass(cls:Class):BitmapData
		{
			
		
			switch(cls)
			{
				case Material:
				case MaterialTree:					
				{
					return Bitmap(new MaterialCls).bitmapData
					break;
				}
				case Prefab:
				case PrefabStaticMesh:
				{
					return Bitmap(new PrefabCls).bitmapData
					break;
				}
				case Texture2DMesh:
				{
					return Bitmap(new Texture2DCls).bitmapData
					break;
				}
				case TextureParticleMesh:
				{
					return Bitmap(new TextureParticleCls).bitmapData
					break;
				}
				case MaterialReflect:
				{
					return Bitmap(new MaterialReflectCls).bitmapData
					break;
				}
				case MaterialCubeMap:
				{
					return Bitmap(new MaterialCubeMapCls).bitmapData
					break;
				}
				case GroupMesh:
				{
					return Bitmap(new icon_folder_small).bitmapData
					break;
				}
				case MaterialShadow:
				{
					return Bitmap(new MaterialShadowCls).bitmapData
					break;
				}
				default:
				{
					return Bitmap(new MaterialShadowCls).bitmapData
					break;
				}
				
			}	
			
			
			return null
		}
		
		
	}
}