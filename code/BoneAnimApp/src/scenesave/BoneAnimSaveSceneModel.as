package scenesave
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	
	import common.AppData;
	
	import materials.MaterialTree;
	
	import modules.materials.view.MaterialTreeManager;
	
	import view.action.ActionPanel;
	import view.controlCenter.ControlCenterPanle;
	import view.mesh.MeshPanel;

	public class BoneAnimSaveSceneModel
	{
		private static var instance:BoneAnimSaveSceneModel;
		public function BoneAnimSaveSceneModel()
		{
		}
		public static function getInstance():BoneAnimSaveSceneModel{
			if(!instance){
				instance = new BoneAnimSaveSceneModel();
			}
			return instance;
		}
		private var zzwUrl:String
		public function saveScene(url:String):void
		{
			this.zzwUrl=decodeURI(url).replace(AppData.workSpaceUrl,"")
			 
 
			var file:File = new File;
			file.addEventListener(Event.SELECT,onFileWorkChg);
			file.browseForDirectory("选择文件夹");
			
			
			
		}
		private var  _saveTourl:String;
		protected function onFileWorkChg(event:Event):void
		{
			var file:File = event.target as File;
			_saveTourl=file.url+"/"
			var mesh:ArrayCollection = MeshPanel.getInstance().getAllInfo() as ArrayCollection;
			var bone:Object = ActionPanel.getInstance().getAllInfo() 
			var timeline:Object = ControlCenterPanle.getInstance().getAllInfo();
			for(var i:Number=0;i<mesh.length;i++){
				this.copyMesh(mesh[i])
			}
			for(var j:Number=0;j<bone.length;j++){
				this.copyBone(bone[j])
			}
			for(var k:Number=0;k<timeline.length;k++){
				this.copyTimeLinePartic(timeline[k])
			}

			copyFile( this.zzwUrl)
			Alert.show(this.zzwUrl,"导出成功");
		}
		private function copyTimeLinePartic(value:Object):void
		{
			if(value.children){
				for(var i:Number=0;i<value.children.length;i++){
					this.copyTimeLinePartic(value.children[i])
				}
			}else{
				 for(var j:Number=0;j<value.timeline.infoAry.length;j++){
					 if(value.timeline.infoAry[j].data&&value.timeline.infoAry[j].data.particleInfo){
						 var $particleUrl:String= value.timeline.infoAry[j].data.particleInfo.particleUrl;
						 if($particleUrl){
							 moveTempParticle($particleUrl)
						 }
					 }
				
				 }
			}
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
				copyFile($url.replace(".material",".txt"));
				copyFile($url.replace(".material","_byte.txt"));
			}
			
		}
		private function copyBone(value:Object):void
		{
			
			if(value.children){
				for(var i:Number=0;i<value.children.length;i++){
					this.copyBone(value.children[i])
				}
			}else{
				copyFile( value.url)
			}
		}
		
		private function copyMesh(value:Object):void
		{
			  if(value.children){
				  for(var i:Number=0;i<value.children.length;i++){
					  this.copyMesh(value.children[i])
				  }
			  }else{
				  copyFile(value.url)
				  copyFile(value.textureUrl)
				  copyFile(value.textureUrl.replace(".material",".txt"));
				  copyFile(value.textureUrl.replace(".material","_byte.txt"));
				  
				  for(var j:Number=0;value.materialInfoArr&&j<value.materialInfoArr.length;j++){
					  var infoObj:Object=value.materialInfoArr[j];
					  if(infoObj&&infoObj.type==0&&infoObj.url){
						  copyFile(infoObj.url);
					  }
				  }
			  }
			  
			
			  
			  
		}
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