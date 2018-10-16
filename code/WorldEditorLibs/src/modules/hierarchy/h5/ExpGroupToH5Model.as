package modules.hierarchy.h5
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import _Pan3D.utils.Cn2en;
	
	import _me.Scene_data;
	
	import common.AppData;
	
	import materials.MaterialTree;
	
	import modules.expres.ExpResFunVo;
	import modules.expres.ExpResModel;
	import modules.expres.ExpResPanel;
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	import modules.lizhi.LizhiManager;
	
	import pack.BuildMesh;
	
	import particle.ParticleStaticMesh;
	
	import render.build.BuildManager;

	public class ExpGroupToH5Model
	{
		private static var instance:ExpGroupToH5Model;
		public function ExpGroupToH5Model()
		{
		}
		public static function getInstance():ExpGroupToH5Model{
			if(!instance){
				instance = new ExpGroupToH5Model();
			}
			return instance;
		}
		public function expToH5($file:File):void
		{
			var $tabelItemStr:Array=["tb_creature#avatar,name,id","tb_item#id,name,id"]
			var directory:File = File.applicationDirectory; 
			var $configFile:File=new File(directory.nativePath+"/config.txt");
			if($configFile.exists){
				var fs:FileStream = new FileStream;
				fs.open($configFile,FileMode.READ);
				var $str:String = fs.readUTFBytes(fs.bytesAvailable)
				fs.close();
				var $item:Object=JSON.parse($str);
				if($item.model&&$item.model){
					$tabelItemStr=$item.model
				}
			}
			
			_outFile=$file;
            if(ExpResModel.expArpg){
				ExpResPanel.initExpPanel(selectBackFun,$tabelItemStr);
			}else{
				var file:File = new File;
				file.addEventListener(Event.SELECT,selectFile);
				file.browseForDirectory("选择文件夹");
			}
		}
		private function selectFile(event:Event):void
		{
			_groupName=Cn2enFun(_outFile.name.replace("."+_outFile.extension,""))
			this.onFileWorkChg(event.target as File)
		}
		private var isUi:Boolean=false
		private function selectBackFun($obj:ExpResFunVo):void
		{
			isUi=$obj.isUi
			_groupName=String($obj.id)
			this.onFileWorkChg(new File(AppData.expSpaceUrl))
		}

		public function Cn2enFun($str:String):String
		{
			return Cn2en.toPinyin(decodeURI($str))
		}
		protected var _outFile:File
		
		protected function onFileWorkChg(file:File):void
		{
	
			_rootUrl=decodeURI(file.url+"/")
	
			_groupByte=new ByteArray;

			ExpH5ByteModel.getInstance().clear();
			ExpResourcesModel.getInstance().initData(_rootUrl,returnFun)
				
			switch(_outFile.extension)
			{
				case "group":
				{
					expToGroup(_outFile)
					break;
				}
				case "prefab":
				{
					expToPrefab(_outFile)
					break;
				}
				case "lyf":
				{
					expToParticle(_outFile)
					break;
				}
				default:
				{
					break;
				}
			}
			ExpResourcesModel.getInstance().run()
			
		}
		
		private function expToParticle($file:File):void
		{
			_groupByte.writeBoolean(false)
			if($file.exists){
				_groupByte.writeInt(HierarchyNodeType.Particle) //类型
				var $url:String=$file.url.replace(AppData.workSpaceUrl,"")
				var particleUrl:String=ExpResourcesModel.getInstance().expParticleByUrl($url,_rootUrl);
				_groupByte.writeUTF(particleUrl)

			}
			
		}
		
		private function expToPrefab($file:File):void
		{
			_groupByte.writeBoolean(false)
			if($file.exists){
				var $fs:FileStream = new FileStream;
				$fs.open($file,FileMode.READ);
				var $obj:Object = $fs.readObject();	
				var $buildMesh:BuildMesh=BuildManager.getInstance().objToBuildMesh($obj);
				ExpH5ByteModel.getInstance().saveMaterialTreeHasNrmOrPbnByUrl($buildMesh.prefabStaticMesh.materialUrl,$buildMesh.prefabStaticMesh.axoFileName);	
				
				
							

				
				var objsurl:String=ExpResourcesModel.getInstance().expObjsByUrl($buildMesh.prefabStaticMesh.axoFileName,_rootUrl)
				var materialurl:String=ExpResourcesModel.getInstance().expMaterialTreeToH5(MaterialTree($buildMesh.prefabStaticMesh.material),_rootUrl)
				_groupByte.writeInt(HierarchyNodeType.Prefab); //类型
				_groupByte.writeUTF(objsurl);
				_groupByte.writeUTF(materialurl);
	
				writeMaterialInfoArr($buildMesh.prefabStaticMesh.materialInfoArr)
	
				
				
			}

			
			
		}
		//写入材质阐述
		private function writeMaterialInfoArr(materialInfoArr:Array):void
		{
		
			ExpResourcesModel.getInstance().expMaterialInfoArr(materialInfoArr,_rootUrl);
			ExpResourcesModel.getInstance().wirtieMaterialInfoTobyte(materialInfoArr,_groupByte)
		}
		private var _rootUrl:String;
		private var _groupName:String;
		protected var _groupByte:ByteArray
		private function expToGroup($file:File):void
		{
			_groupByte.writeBoolean(true)
			if($file.exists){
				var $fs:FileStream = new FileStream;
				$fs.open($file,FileMode.READ);
				var $obj:Object = $fs.readObject();
				var $arr:Array=makeReadFileNode($obj.item);
			
				_groupByte.writeInt($arr.length);//数量
				for(var i:uint=0;i<$arr.length;i++){
					var $tempNode:HierarchyFileNode = new HierarchyFileNode;
					$tempNode.name=$arr[i].name;
					$tempNode.type=$arr[i].type;
					_groupByte.writeInt($tempNode.type) //类型
					_groupByte.writeFloat(Number($arr[i].x));
					_groupByte.writeFloat(Number($arr[i].y));
					_groupByte.writeFloat(Number($arr[i].z));
					_groupByte.writeFloat(Number($arr[i].scaleX));
					_groupByte.writeFloat(Number($arr[i].scaleY));
					_groupByte.writeFloat(Number($arr[i].scaleZ));
					_groupByte.writeFloat(Number($arr[i].rotationX));
					_groupByte.writeFloat(Number($arr[i].rotationY));
					_groupByte.writeFloat(Number($arr[i].rotationZ));
						
					if($tempNode.type==HierarchyNodeType.Prefab){
						var $buildMesh:BuildMesh=BuildManager.getInstance().objToBuildMesh($arr[i].data);
						ExpH5ByteModel.getInstance().saveMaterialTreeHasNrmOrPbnByUrl($buildMesh.prefabStaticMesh.materialUrl,$buildMesh.prefabStaticMesh.axoFileName);			
						var objsurl:String=ExpResourcesModel.getInstance().expObjsByUrl($buildMesh.prefabStaticMesh.axoFileName,_rootUrl)
						var materialurl:String=ExpResourcesModel.getInstance().expMaterialTreeToH5(MaterialTree($buildMesh.prefabStaticMesh.material),_rootUrl)
						_groupByte.writeUTF(objsurl);
						_groupByte.writeUTF(materialurl);
						writeMaterialInfoArr($buildMesh.prefabStaticMesh.materialInfoArr)
					}
					if($tempNode.type==HierarchyNodeType.Particle){
						var $ParticleStaticMesh:ParticleStaticMesh=LizhiManager.getInstance().objToMesh($arr[i].data)
						var particleUrl:String=ExpResourcesModel.getInstance().expParticleByUrl($ParticleStaticMesh.url,_rootUrl);
	
						_groupByte.writeUTF(particleUrl);
					}
				}
	

			}
		}
		protected function returnFun():void
		{
			
			
			
			var $fs:FileStream;
			var $byte:ByteArray;
			var $oneUrl:String = _rootUrl +"model/" + _groupName+".txt"
			if(this.isUi){
				$oneUrl = _rootUrl +"model/ui/" + _groupName+".txt"
			}
			
			if(this._outFile.extension=="lyf"){
				$oneUrl=$oneUrl.replace(".txt","_lyf.txt");
			}
			
			
			MakeResFileList.getInstance().pushUrl($oneUrl)
			$fs = new FileStream;
			$fs.open(new File($oneUrl),FileMode.WRITE);
			$byte=new ByteArray;
			
			
			ExpH5ByteModel.getInstance().WriteByte($byte,true,[1,2,3,4]);
			$fs.writeInt(Scene_data.version)//写入版本号
			$fs.writeBytes($byte,0,$byte.length);//写入资源
			$fs.writeBytes(_groupByte,0,_groupByte.length);//写入引用数据
			$fs.close()
		

			var $baseFileUrl:String=  _rootUrl +"model/" + _groupName+"_base.txt";
			MakeResFileList.getInstance().pushUrl($baseFileUrl)
			$fs.open(new File($baseFileUrl),FileMode.WRITE);
			
			$byte=new ByteArray;
			$fs.writeInt(Scene_data.version)
			ExpH5ByteModel.getInstance().WriteByte($byte,false,[1,2,3,4]);
			$fs.writeBytes($byte,0,$byte.length);		
			$fs.writeBytes(_groupByte,0,_groupByte.length);//写入引用数据
			$fs.close();
			
		}
		private function writeData(fs:FileStream,file:File):void
		{
			var $byte:ByteArray=new ByteArray;
			$byte.writeInt(Scene_data.version)
			ExpH5ByteModel.getInstance().WriteByte($byte,false,[1,2,3,4]);
			fs.writeBytes($byte,0,$byte.length);

		}
		

		private function makeReadFileNode($arr:Array):Array
		{
			var tempArr:Array=new Array
			for(var i:uint=0;i<$arr.length;i++){
				switch($arr[i].type)
				{
					case HierarchyNodeType.Prefab:
					{
						tempArr.push($arr[i])
						break;
					}
					case HierarchyNodeType.Particle:
					{
						tempArr.push($arr[i])
						break;
					}
					default:
					{
						break;
					}
				}
				if($arr[i].children){
					tempArr=tempArr.concat(makeReadFileNode($arr[i].children))
				}
			}
			return tempArr
		}
		
	}
}