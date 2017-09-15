package modules.prefabs
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import common.AppData;
	
	import modules.materials.view.MaterialTreeManager;
	
	import pack.PrefabStaticMesh;
	

	public class PrefabManager
	{
		private static var instance:PrefabManager;
		public function PrefabManager()
		{
		}
		public static function getInstance():PrefabManager{
			if(!instance){
				instance = new PrefabManager();
			}
			return instance;
		}
		private var _keyObj:Object=new Object
		public function getPrefabByUrl($url:String):PrefabStaticMesh
		{
			if(!Boolean(new File($url).exists)){
				return null
			}
			
			if(_keyObj[$url]){
				return _keyObj[$url]
			}else{
				var $fs:FileStream = new FileStream;
				$fs.open(new File($url),FileMode.READ);
				var $obj:Object = $fs.readObject();
			
				if($obj.materialUrl){
					$obj.materialUrl=String($obj.materialUrl).replace("file:///E:/zzw/TE/","")
					$obj.materialUrl=String($obj.materialUrl).replace(AppData.workSpaceUrl,"")
				}
				$fs.close();
				var $editPreFab:PrefabStaticMesh = objToPreFab($obj)
				$editPreFab.addEventListener(Event.CHANGE,onPreFabChange)
				$editPreFab.name=new File($url).name
				$editPreFab.url=$url.replace(AppData.workSpaceUrl,"")
				_keyObj[$url]=$editPreFab
				return _keyObj[$url]
			}
		}
		
		protected function onPreFabChange(event:Event):void
		{
			var _editPreFab:PrefabStaticMesh=PrefabStaticMesh(event.target)
			var obj:Object = new Object;
			var fs:FileStream = new FileStream;
			fs.open(new File(AppData.workSpaceUrl+PrefabStaticMesh(event.target).url),FileMode.WRITE);
			fs.writeObject(_editPreFab.readObject());
			fs.close();

		}

		private function objToPreFab($obj:Object):PrefabStaticMesh
		{
			var prefab:PrefabStaticMesh = new PrefabStaticMesh();
			for(var i:String in $obj) {
				prefab[i]=$obj[i]
			}
		
			if(prefab.materialUrl&&AppData.workSpaceUrl){
				//prefab.materialUrl=encodeURI(prefab.materialUrl)
				prefab.material = MaterialTreeManager.getMaterial(AppData.workSpaceUrl+prefab.materialUrl);
			}
			
			return prefab
		}
	}
}