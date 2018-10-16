package common.utils.ui.prefab
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.utils.getDefinitionByName;
	
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import PanV2.loadV2.BmpLoad;
	
	import common.AppData;
	import common.msg.event.brower.MEvent_BrowerShowFile;
	import common.msg.event.materials.MEvent_Material;
	import common.utils.frame.AccordionCanvas;
	import common.utils.frame.CombineReflectionView;
	import common.utils.frame.MetaDataView;
	import common.utils.ui.file.FileNode;
	
	import interfaces.ITile;
	
	import materials.MaterialCubeMap;
	import materials.MaterialTree;
	
	import modules.brower.fileWin.BrowerManage;
	import modules.materials.view.MaterialTreeManager;
	
	import pack.PrefabStaticMesh;

	public class MaterialModelPic extends PreFabModelPic
	{
		public function MaterialModelPic()
		{
			super();

		}
		override protected function list_dragDropHandler(event:DragEvent):void
		{
			var $fileNode:FileNode = event.dragSource.dataForFormat(FileNode.FILE_NODE) as FileNode;
			if(canInPutFileD($fileNode)){
				
				setData($fileNode.data)
				if(target&&FunKey){
					target[FunKey]=$fileNode.data
				}
			}
		}
		override  protected function list_dragEnterHandler(event:DragEvent):void
		{
			var $fileNode:FileNode = event.dragSource.dataForFormat(FileNode.FILE_NODE) as FileNode;
			if(canInPutFileD($fileNode) ){
				
				var ui:UIComponent = event.target as UIComponent;
				
				DragManager.acceptDragDrop(ui);
			}
		}
		override protected function _searchButClik(event:MouseEvent):void
		{
			if(target&&FunKey){

				var evt:MEvent_BrowerShowFile=new MEvent_BrowerShowFile(MEvent_BrowerShowFile.BROWER_SHOW_SAMPE_FILE)
				evt.data=target[FunKey]
				evt.listOnly=_listOnly;
				ModuleEventManager.dispatchEvent(evt);
				_listOnly=!_listOnly;
			}
		}
		override protected function onDubleClik(event:MouseEvent):void
		{
			
			if(_donotDubleClik==3){  //骨骼编辑器特殊
				super.onDubleClik(event)
				return 
			}
			if(target[FunKey] as MaterialTree){
				var $materialTree:MaterialTree=target[FunKey] as MaterialTree
			
				var materilaEvt:MEvent_Material = new MEvent_Material(MEvent_Material.MEVENT_MATERIAL_SHOW);
				materilaEvt.url =AppData.workSpaceUrl+	$materialTree.url
				ModuleEventManager.dispatchEvent(materilaEvt);
					
			}else{
				super.onDubleClik(event)
			}
			
				
			
		}
	

		
		private function canInPutFileD($fileNode:FileNode):Boolean
		{
			for(var i:uint=0;i<extensinonItem.length;i++)
			{
				var $str:String=extensinonItem[i]
				var $cla:Class = getDefinitionByName($str) as Class;
				if($fileNode.data is $cla ){
					return true
				}
			}

			return false;
		}
		private function setData($data:Object):void
		{
			if($data){
				//(@10eb7ba1)
	
				var $ITile:ITile=ITile($data);
				var $baseName:String=$ITile.getName()
				_labelTxt.text=decodeURI($baseName)
				trace(_labelTxt.text)
				if($ITile.getBitmapData()){
					_iconBmp.setBitmapdata($ITile.getBitmapData(),64,64)
				}else{
					_iconBmp.setBitmapdata(BrowerManage.getIconByClass($ITile["constructor"]),64,64)
				}
				_iconBmp.doubleClickEnabled=true
				var picUrl:String
				if($data as MaterialCubeMap){
					var $materialCubeMap:MaterialCubeMap=$data as MaterialCubeMap
					if($materialCubeMap.url){
						picUrl=$materialCubeMap.url.replace(".cube",".jpg");
						picUrl=File.desktopDirectory.url+"/world/"+picUrl;
						getFileBmpByUrl(picUrl)
					}
					
				}
				if($data as MaterialTree){
					var $materialTree:MaterialTree=$data as MaterialTree
					picUrl=$materialTree.url.replace(".material",".jpg");
					picUrl=File.desktopDirectory.url+"/world/"+picUrl;
					getFileBmpByUrl(decodeURI(picUrl))
				}
				
				
				
			}else{
				_iconBmp.setBitmapdata(BrowerManage.getIcon("meinv"),64,64)
				_labelTxt.text=" "
			}
			
	
			this.testCanShowBut()
	
			
		}
		//检测材质是否有动太参数
		private function testCanShowBut():void
		{
			var $isDynamic:Boolean=false
		
			var $materialTree:MaterialTree=target[FunKey] as MaterialTree
			if($materialTree){
				for(var i:uint=0;i<$materialTree.data.length;i++){
					if($materialTree.data[i].data.isDynamic){  //是动态
						$isDynamic=true
					}
				}
			}
			if($isDynamic=false){
				target.materialInfoArr=null
			}
			_openWith.visible=false
			this.showMaterialParamUi()
			
			
		}
			
		private var _materialTreeMc:MaterialParamUi
		override protected function _openWithClik(event:MouseEvent):void
		{
			

		}
		private function showMaterialParamUi():void
		{
			if(!_materialTreeMc){
				_materialTreeMc=new MaterialParamUi
				this.addChild(_materialTreeMc)
			}

			if(target[FunKey] as MaterialTree){
				_materialTreeMc.setData(target[FunKey] as MaterialTree,target )
				_materialTreeMc.y=100
				setListHeith(_materialTreeMc.height+_materialTreeMc.y)
			}
		}
			
		private function setListHeith($num:Number):void
		{
			this.height=$num
			Object(this.parent).height=this.height
			AccordionCanvas(this.parent.parent).height=25+this.height;
			var $dis:Object=this
			while($dis.parent){
				$dis=$dis.parent;
				if($dis as CombineReflectionView){
					CombineReflectionView($dis).relistPos();
				}
				if($dis as MetaDataView){
					MetaDataView($dis).relistPos();
				}
			}
	
		}
		
		private function getFileBmpByUrl($url:String):void
		{
			var $file:File=new File($url)
			if($file.exists){
				BmpLoad.getInstance().addSingleLoad($url,function ($bitmap:Bitmap,$obj:Object):void{
					_iconBmp.setBitmapdata($bitmap.bitmapData,64,64)
				},{})
			}
		}
		override public function refreshViewValue():void
		{
			if(target&&FunKey){
				var dde:Object=target[FunKey]
				setData(target[FunKey])
			}
			_listOnly=true
		}
	
	}
}