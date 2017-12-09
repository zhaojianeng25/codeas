package exph5.exprole
{
	import mx.collections.ArrayCollection;
	
	import _Pan3D.role.AnimDataManager;
	
	import _me.Scene_data;

	public class ExpActionModel
	{
		private static var instance:ExpActionModel;
		private var localAllNum:uint;
		private var _boneImportSort:BoneImportSort 
		public function ExpActionModel()
		{
			_boneImportSort=new BoneImportSort
		}
		public static function getInstance():ExpActionModel{
			if(!instance){
				instance = new ExpActionModel();
			}
			return instance;
		}
		public function setAllInfo(ary:Array):void
		{
			localAllNum = ary.length;
			dataAry=new ArrayCollection
			for(var i:int=0;i<ary.length;i++){
				addLocalAnim(ary[i]);
			}
			
		}
		public function addLocalAnim(obj:Object):void{
			AnimDataManager.getInstance().addAnim(Scene_data.md5Root + obj.url,onLocalAnimLoad,obj);
		}
		public var dataAry:ArrayCollection 
		private function onLocalAnimLoad(ary0:Array,obj:Object):void{
			
			var prePorcessInfo:Object = _boneImportSort.processBoneNew(obj.hierarchy,obj);
			var ary:Array = obj.data = prePorcessInfo.animAry;
			
			obj.source = prePorcessInfo.source;
			obj.strAry = prePorcessInfo.strAry;
			obj.hierarchy = prePorcessInfo.hierarchy;
			obj.str = prePorcessInfo.str;
			
			
			//			obj.data = ary;
			dataAry.addItem(obj);
			/*
			AppDataBone.role.addAnimLocal(obj.fileName,ary,obj.bounds,obj.pos);
			BonePanel.getInstance().setData(ary[0]);
			
			//			AppData.role.bindParticle = ParticleManager.getInstance().getParticle();
			//			ParticleManager.getInstance().getParticle().bindTarget = AppData.role;
			localFlag++;
			trace(localFlag,localAllNum)
			if(localFlag == localAllNum){
				HangPanel.getInstance().setAllInfo();
				MeshPanel.getInstance().addAllParticle();
				ControlCenterPanle.getInstance().buildByFile();
				AppDataBone.role.play(dataAry[0].fileName);
				
				var sort:Sort = new Sort();
				sort.fields = [new SortField("name", true)];
				dataAry.sort = sort;
				dataAry.refresh();
				
			}
			*/
		}

	}
}