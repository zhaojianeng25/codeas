package savescene
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	
	import common.AppData;
	
	import materials.MaterialTree;
	
	import modules.materials.view.MaterialTreeManager;

	public class SaveSceneParticleModel
	{
		public function SaveSceneParticleModel()
		{
		}
		public static function getInstance():SaveSceneParticleModel{
			if(!instance){
				instance = new SaveSceneParticleModel;
			}
			return instance;
		}
		public function saveScene(url:String):void
		{
		
 
			var file:File = new File;
			file.addEventListener(Event.SELECT,onFileWorkChg);
			file.browseForDirectory("选择文件夹");

		}
		private var  _saveTourl:String;
		protected function onFileWorkChg(event:Event):void
		{
			var file:File = event.target as File;
			_saveTourl=file.url+"/"
				
            var lyfFile:File=new File(AppParticleData.lyfUrl)
	

			this.moveTempParticle(lyfFile.url.replace(AppData.workSpaceUrl,""));
			
			Alert.show("工程另存为完成");
		}
		
		private function moveTempParticle($particleUrl:String):void
		{
			
			ParticleManager.getInstance().getParticle(AppData.workSpaceUrl+$particleUrl)
			var loaderinfo:LoadInfo = new LoadInfo(AppData.workSpaceUrl+$particleUrl,LoadInfo.BYTE,onbyteLoad,0);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
			function onbyteLoad(byte:ByteArray):void{
				setTimeout(	function ():void
				{
					copyFile( $particleUrl)
					copyFile($particleUrl.replace(".lyf","_byte.txt"));
					var particles:CombineParticle = ParticleManager.getInstance().dicPool[AppData.workSpaceUrl+$particleUrl]
					var a:Array=particles.getMaterialTexUrlAry()
					var b:Array=particles.getMaterialAry();
					for(var materialTreeId:uint=0;materialTreeId<b.length;materialTreeId++){
						var $MaterialTree:MaterialTree=MaterialTree(b[materialTreeId])
						var materialUrl:String=$MaterialTree.url.replace(AppData.workSpaceUrl,"")
						copyFile(materialUrl)
						moveMaterialTree(materialUrl)
					}
					for(var k:uint=0;k<a.length;k++){
						copyFile(a[k])
					}
					
				},100)
				
			}
			
			
			
			
		}
		
		private function moveMaterialTree($url:String):void
		{
			var $materialTree:MaterialTree=MaterialTreeManager.getMaterial(AppData.workSpaceUrl+$url)
			if($materialTree){
				var picArr:Array=$materialTree.getTxtList();
				for(var j:uint=0;j<picArr.length;j++)
				{
					copyFile(picArr[j]);
				}
				copyFile($url);
				var materiaTxt:String=$url.replace(".material",".txt")
				copyFile(materiaTxt);
			}
			
		}

 
		private static var instance:SaveSceneParticleModel;
		private function copyFile($url:String):void
		{
			var $file:File=new File(AppData.workSpaceUrl+$url)
			if($file.exists){
				var $tourl:String=_saveTourl+$url
				var destination:File = File.documentsDirectory;
				destination = destination.resolvePath($tourl);
				$file.copyTo(destination, true);
				trace($tourl)
			}else{
				
				if($url&&$url!="null"){
					Alert.show("文件不存在",$file.url)
				}
				
			}
			
		}
	}
}