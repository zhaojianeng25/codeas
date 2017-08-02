package modules.materials
{
	import com.zcp.frame.Module;
	import com.zcp.frame.event.ModuleEvent;
	
	import flash.display.BitmapData;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	import mx.events.AIREvent;
	
	import spark.components.Window;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.msg.event.MEvent_MainOperate;
	import common.msg.event.materials.MEvent_Material;
	import common.msg.event.materials.MEvent_Material_Connect;
	import common.utils.frame.BaseProcessor;
	import common.utils.frame.MetaDataView;
	import common.vo.editmode.EditModeEnum;
	
	import manager.LayerManager;
	
	import materials.Material;
	import materials.MaterialCubeMap;
	import materials.MaterialReflect;
	import materials.MaterialShadow;
	import materials.MaterialTree;
	import materials.MaterialTreeParam;
	import materials.Texture2DMesh;
	import materials.TextureParticleMesh;
	
	import modules.brower.fileTip.AmaniTexture2DPoint;
	import modules.brower.fileWin.BrowerManage;
	import modules.hierarchy.FileSaveModel;
	import modules.materials.view.BaseMaterialNodeUI;
	import modules.materials.view.DynamicMaterialParamView;
	import modules.materials.view.ItemMaterialUI;
	import modules.materials.view.MaterialNodeLineUI;
	import modules.materials.view.MaterialTreeManager;
	import modules.materials.view.prop.NodeTreePropManager;
	import modules.scene.SceneEditModeManager;
	import modules.sceneConfig.SceneConfigPanel;
	
	import proxy.top.render.Render;
	
	public class MaterialProcessor extends BaseProcessor
	{
		private var _materialView:MaterialPanel;
		private var _materialViewBase:MetaDataView;
		private var _materialReflectView:MetaDataView;
		private var _materialCubeMapView:MetaDataView;
		private var _materialShadowView:MetaDataView;
		private var _materialInstanceView:DynamicMaterialParamView;
		

		public function MaterialProcessor($module:Module)
		{
			super($module);
			
	
			
			NodeTreePropManager.getInstance().init(this)
		}
		
		override protected function listenModuleEvents():Array 
		{
			return [
				MEvent_Material,
				MEvent_Material_Connect
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
	
			switch($me.getClass()) {
				case MEvent_Material:
					if($me.action == MEvent_Material.MEVENT_MATERIAL_CREATNEW){
						creatMaterial(MEvent_Material($me).url,MEvent_Material($me).name);
					}
					else
					if($me.action == MEvent_Material.MEVENT_TEXTURECUBEMAP_CREATNEW){
						creatTextureCubeMap(MEvent_Material($me).url,MEvent_Material($me).name);
					}
					else
					if($me.action == MEvent_Material.MEVENT_MATERIAL_SHOW){
						showMaterial(MEvent_Material($me).url);
					}
					else 
					if($me.action == MEvent_Material.MEVENT_MATERIAL_SHOW_BASE){
						
						showMaterialBase(MEvent_Material($me).material);
					}
					else
					if($me.action == MEvent_Material.MEVENT_MATERIAL_REFLECT_SHOW){
						showMaterialReflect(MEvent_Material($me).materialReflect);
					}
					else
					if($me.action == MEvent_Material.MEVENT_MATERIAL_CUBEMAP_SHOW){
						showMaterialCube(MEvent_Material($me));
					}
					else
					if($me.action == MEvent_Material.MEVENT_TEXTURE2D_SHOW){
						showTexture2dMesh(MEvent_Material($me));
					}
					else
					if($me.action == MEvent_Material.MEVENT_TEXTUREPARTICLE_SHOW){
					     showTextureParticle(MEvent_Material($me))
					}
					else 
					if($me.action == MEvent_Material.MEVENT_MATERIAL_SHADOW_SHOW){
						showMaterialShadow(MEvent_Material($me).materialShadow);
					}else if($me.action == MEvent_Material.MEVENT_MATERIAL_SAVE){
						saveMaterial(MEvent_Material($me).material as MaterialTree,MEvent_Material($me).glslMaterial as MaterialTree);
					}
					else 
					if($me.action == MEvent_Material.MEVENT_MATERIAL_PROP){
						showProp(MEvent_Material($me).nodeTreeView);
					}
					else
					if($me.action == MEvent_Material.MEVENT_MATERIAL_CREAT_INSTANCE){
						creatMaterialInstance(MEvent_Material($me).url,MEvent_Material($me).name,MEvent_Material($me).material as MaterialTree);
					}else if($me.action == MEvent_Material.MEVENT_MATERIAL_SHOW_INSTANCE){
						showMaterialInstance(MEvent_Material($me).url);
					}else if($me.action == MEvent_Material.MEVENT_MATERIAL_JPNG_PANEL){
						showJpngPanel();
					}else if($me.action == MEvent_Material.MEVENT_MATERIAL_COMBINE_LIGHTMAP){
						showCombineLightMapPanel();
					}
					break;
				case MEvent_Material_Connect:
					if($me.action == MEvent_Material_Connect.MEVENT_MATERIAL_CONNECT_STARTDRAG){
						startDragLine(MEvent_Material_Connect($me).itemNode);
					}else if($me.action == MEvent_Material_Connect.MEVENT_MATERIAL_CONNECT_STOPDRAG){
						stopDragLine(MEvent_Material_Connect($me).itemNode);
					}else if($me.action == MEvent_Material_Connect.MEVENT_MATERIAL_CONNECT_REMOVELINE){
						removeLine(MEvent_Material_Connect($me).line);
					}else if($me.action == MEvent_Material_Connect.MEVENT_MATERIAL_CONNECT_DOUBLUELINE){
						setConnetLine(MEvent_Material_Connect($me).startNode,MEvent_Material_Connect($me).endNode);
					}
					break;
				
			
			}
			
		
		}

		private var _texturueParticleMeshView:MetaDataView;
		private function showTextureParticle($mEvent_Material:MEvent_Material):void
		{

			var $textureParticleMesh:TextureParticleMesh=$mEvent_Material.textureParticleMesh
			if(!_texturueParticleMeshView){
				_texturueParticleMeshView = new MetaDataView();
				_texturueParticleMeshView.init(this,"属性",2);
				_texturueParticleMeshView.creatByClass(TextureParticleMesh);
			}
			LayerManager.getInstance().showPropPanle(_texturueParticleMeshView);
			_texturueParticleMeshView.setTarget($textureParticleMesh);
			
			
			
			//特殊处理，没有加载完成的情况下
			setTimeout(function():void{
				$textureParticleMesh.dispatchEvent(new Event(Event.CHANGE))
			},50)
			setTimeout(function():void{
				$textureParticleMesh.dispatchEvent(new Event(Event.CHANGE))
			},500)
			$textureParticleMesh.chooseFolder=function chooseFolderFun():void
			{
				var file:File=new File;
				file.browseForDirectory("")
				file.addEventListener(Event.SELECT,onSelect);
				function onSelect(e:Event):void
				{
					if(File(e.target).isDirectory){
						
						$textureParticleMesh.textureName=$textureParticleMesh.filePath+File(e.target).name+".wdp"
						Render.chooseTexture2DFolderUrl($textureParticleMesh,File(e.target).getDirectoryListing())
						setTimeout(_texturueParticleMeshView.refreshView,100)// 特殊shua'xing
						setTimeout(_texturueParticleMeshView.refreshView,1000)//
						setTimeout(_texturueParticleMeshView.refreshView,2000)//
					}
				}
			}
			$textureParticleMesh.setXyPanelFun=function setXyPanelFun():void
			{
				if($textureParticleMesh.bmpSprite){
					AmaniTexture2DPoint.getInstance().inputFilePanle($textureParticleMesh.bmpSprite,function ($p:Point):void{
						$textureParticleMesh.centerPos.x=$p.x
						$textureParticleMesh.centerPos.y=$p.y
						_texturueParticleMeshView.refreshView()
						$textureParticleMesh.dispatchEvent(new Event(Event.CHANGE))
					})
				}
			}
		}
		
		private var _texturue2dMeshView:MetaDataView;
		private function showTexture2dMesh($mEvent_Material:MEvent_Material):void
		{

			var $texture2DMesh:Texture2DMesh=$mEvent_Material.texture2Dmesh
			if(!_texturue2dMeshView){
				_texturue2dMeshView = new MetaDataView();
				_texturue2dMeshView.init(this,"属性",2);
				_texturue2dMeshView.creatByClass(Texture2DMesh);
			}
	
			//Render.changeTexture2DData($texture2DMesh)
			
			
			
			
			LayerManager.getInstance().showPropPanle(_texturue2dMeshView);
			_texturue2dMeshView.setTarget($texture2DMesh);
			
			//特殊处理，没有加载完成的情况下
			setTimeout(function():void{
				$texture2DMesh.dispatchEvent(new Event(Event.CHANGE))
			},50)
			setTimeout(function():void{
				$texture2DMesh.dispatchEvent(new Event(Event.CHANGE))
			},500)

				
			$texture2DMesh.chooseFolder=function chooseFolderFun():void
			{
				var file:File=new File;
				file.browseForDirectory("")
				file.addEventListener(Event.SELECT,onSelect);
				function onSelect(e:Event):void
				{
					if(File(e.target).isDirectory){
		
						$texture2DMesh.textureName=$texture2DMesh.filePath+File(e.target).name+".wdp"
						Render.chooseTexture2DFolderUrl($texture2DMesh,File(e.target).getDirectoryListing())
						setTimeout(_texturue2dMeshView.refreshView,100)// 特殊shua'xing
						setTimeout(_texturue2dMeshView.refreshView,1000)//
						setTimeout(_texturue2dMeshView.refreshView,2000)//
					}
                    
				}
				
			}
			$texture2DMesh.setXyPanelFun=function setXyPanelFun():void
			{
				if($texture2DMesh.bmpSprite){
					AmaniTexture2DPoint.getInstance().inputFilePanle($texture2DMesh.bmpSprite,function ($p:Point):void{
					
						$texture2DMesh.centerPos.x=$p.x
						$texture2DMesh.centerPos.y=$p.y
						
				
						_texturue2dMeshView.refreshView()
						
						$texture2DMesh.dispatchEvent(new Event(Event.CHANGE))

						
					})
				}
			}
		}
		
	
		
		private function creatTextureCubeMap($url:String, name:String):void
		{
			if(AppData.type == 1){
				var rootFile:File = new File($url);
				var file:File = new File($url + "/"+ name +".cube");
				if(!file.exists){
					var obj:Object = new Object;
					var fs:FileStream = new FileStream;
					fs.open(file,FileMode.WRITE);
					fs.writeObject(obj);
					fs.close();
				}
			}
			
		}	
		
		public function creatMaterial($url:String,$name:String):void{
			
			if(AppData.type == 1){
				
				var rootFile:File = new File($url);
				var file:File = new File($url + "/"+ $name +".material");
				if(!file.exists){
					var obj:Object = new Object;
					var fs:FileStream = new FileStream;
					fs.open(file,FileMode.WRITE);
					fs.writeObject(obj);
					fs.close();
				}
				
			}else{
				
	
	
				Render.creatAmaniFile($name,"Texture3D")
				//ModuleEventManager.dispatchEvent(new MEvent_Brower_Refresh(MEvent_Brower_Refresh.MEVENT_BROWER_REFRESH));
				
			}
			
		}

		
		public function creatMaterialInstance($url:String,name:String,$material:MaterialTree):void{
			if(!$material.hasDynamic()){
				Alert.show("该材质不存在动态参数");
				return;
			}
			var materiaInstance:MaterialTreeParam = new MaterialTreeParam;
			materiaInstance.setMaterial($material);
			
			var rootFile:File = new File($url);
			var file:File = new File($url + "/"+ name +".materialins");
			if(!file.exists){
				var obj:Object = materiaInstance.getData();
				var fs:FileStream = new FileStream;
				fs.open(file,FileMode.WRITE);
				fs.writeObject(obj);
				fs.close();
			}
		}
		
		
		public function showMaterial(url:String):void{
			if(!_materialView){
				_materialView = new MaterialPanel;
				_materialView.init(this,"材质",1);
			}
			LayerManager.getInstance().addPanel(_materialView);
			
			var materailTree:MaterialTree = MaterialTreeManager.getMaterial(url);//new MaterialTree;

			_materialView.showMaterial(materailTree);
			
			SceneEditModeManager.changeMode(EditModeEnum.EDIT_MATERIAL)
				
				
		}

		
		public function showMaterialInstance(url:String):void{
			if(!_materialInstanceView){
				_materialInstanceView = new DynamicMaterialParamView;
				_materialInstanceView.init(this,"参数",2);
			}
			LayerManager.getInstance().addPanel(_materialInstanceView);
			
			var materialTreeInstance:MaterialTreeParam = MaterialTreeManager.getMaterialInstance(url);
			
			_materialInstanceView.setMaterial(materialTreeInstance);
		}
		
		public function showProp($ui:BaseMaterialNodeUI):void{
			NodeTreePropManager.getInstance().showNode($ui);
		}
		
		public function saveMaterial($materialTree:MaterialTree,$glslMaterialTree:MaterialTree):void{
			$materialTree.url=$materialTree.url.replace(AppData.workSpaceUrl,"")
			var file:File = new File(AppData.workSpaceUrl+$materialTree.url);
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.WRITE);
			fs.writeObject($materialTree.getData());
			fs.close();
			
			var tempUrl:String = file.parent.url;
			var filename:String = file.name.split(".")[0];
			
			var glslUrl:String = tempUrl + "/" + filename + ".txt";//file.url.replace("material","txt");
			//var glslUrl:String = "file:///C:/workts/WebGLEngine/WebGLEngine/assets/material.txt"
			file = new File(glslUrl);
			var str:String = JSON.stringify($glslMaterialTree.compileData);
			fs = new FileStream;
			fs.open(file,FileMode.WRITE);
			fs.writeUTFBytes(str);
			fs.close();
			
			//MaterialSaveModel.getInstance().buildMaterialByUrl($materialTree.url)
			
			MaterialSaveModel.getInstance().saveByteMaterial($glslMaterialTree.compileData,glslUrl)
			
			var $bmp:BitmapData=_materialView.materialPreView.materialRenderView.renderBimp.bitmapData
			if($bmp){
				var $bmp128:BitmapData=new BitmapData(128,128);
				var $m:Matrix=new Matrix()
				$m.scale($bmp128.width/$bmp.width,$bmp128.height/$bmp.height)
				$bmp128.draw($bmp,$m)
				var $bmpFileName:String=$materialTree.url.replace(".material","material.jpg")
				var $url:String=File.desktopDirectory.url+"/world/"+$bmpFileName;
				
				
				var $iconBmp:BitmapData=BrowerManage.getIcon("material")
				var $mIcon:Matrix=new Matrix
				if($iconBmp){
					$mIcon.scale(20/$iconBmp.width,20/$iconBmp.height);
					$mIcon.tx=105
					$mIcon.ty=5
					$bmp128.draw($iconBmp,$mIcon)
				}
				FileSaveModel.getInstance().saveBitmapdataToJpg($bmp128,$url)
			}
			
		}
		
		
		public function showMaterialBase($material:Material):void{
			if(!_materialViewBase){
				_materialViewBase = new MetaDataView();
				_materialViewBase.init(this,"属性",2);
				_materialViewBase.creatByClass(Material);
			}
			
			LayerManager.getInstance().showPropPanle(_materialViewBase);
			_materialViewBase.setTarget($material);
		}
		
		public function showMaterialReflect($material:MaterialReflect):void{
			if(!_materialReflectView){
				_materialReflectView = new MetaDataView();
				_materialReflectView.init(this,"属性",2);
				_materialReflectView.creatByClass(MaterialReflect);
			}
			
			LayerManager.getInstance().showPropPanle(_materialReflectView);
			_materialReflectView.setTarget($material);
		}
		
		public function showMaterialShadow($material:MaterialShadow):void{
			if(!_materialShadowView){
				_materialShadowView = new MetaDataView();
				_materialShadowView.init(this,"属性",2);
				_materialShadowView.creatByClass(MaterialShadow);
			}
			
			LayerManager.getInstance().showPropPanle(_materialShadowView);
			_materialShadowView.setTarget($material);
		}
		public function showMaterialCube($mEvent_Material:MEvent_Material):void{
			var $editCubeMap:MaterialCubeMap=$mEvent_Material.materialCubemap

			if(!_materialCubeMapView){
				_materialCubeMapView = new MetaDataView();
				_materialCubeMapView.init(this,"属性",2);
				_materialCubeMapView.creatByClass(MaterialCubeMap);
			}
			
			LayerManager.getInstance().showPropPanle(_materialCubeMapView);
			
			//_editCubeMap.addEventListener(Event.CHANGE,onCubeMapChange)
			_materialCubeMapView.setTarget($editCubeMap);
		}
	
		
		public function startDragLine($node:ItemMaterialUI):void{
			_materialView.lineContainer.startLine($node);
		}
		
		public function stopDragLine($node:ItemMaterialUI):void{
			_materialView.lineContainer.stopLine($node);
		}
		
		public function setConnetLine($startItem:ItemMaterialUI,$endItem:ItemMaterialUI):void{
			if(_materialView){
				_materialView.lineContainer.addConnentLine($startItem,$endItem);	
			}
	
		}
		
		public function removeLine($line:MaterialNodeLineUI):void{
			_materialView.lineContainer.removeLine($line);
		}
		
		private var _jpngPanel:JpngPanel;
		private var _win:Window
		public function showJpngPanel():void{

			if(_win&&!_win.closed){
				_win.close()
			}
			_jpngPanel=new JpngPanel();
			var $win:Window = new Window;
			$win.transparent=false;
			$win.type=NativeWindowType.NORMAL;
			$win.systemChrome=NativeWindowSystemChrome.STANDARD;
			$win.width= 400;
			$win.height= 400;
			$win.alwaysInFront=false
			$win.resizable=true
			$win.showStatusBar = false;
			$win.title = "生成jpng"
			
			
			_jpngPanel.setStyle("left",0);
			_jpngPanel.setStyle("right",0);
			_jpngPanel.setStyle("top",0);
			_jpngPanel.setStyle("bottom",0);
			
			$win.addElement(_jpngPanel);
			$win.addEventListener(AIREvent.WINDOW_COMPLETE,windowComplete)
			$win.addEventListener(AIREvent.APPLICATION_ACTIVATE,windowActivate)
			
			
			$win.open(true);
			_win=$win
			_win.visible=false

		}
		
		private var _combineLightmapPanel:CombineLightPanel;
		public function showCombineLightMapPanel():void{
			if(_win&&!_win.closed){
				_win.close()
			}
			_combineLightmapPanel=new CombineLightPanel();
			var $win:Window = new Window;
			$win.transparent=false;
			$win.type=NativeWindowType.NORMAL;
			$win.systemChrome=NativeWindowSystemChrome.STANDARD;
			$win.width= 1200;
			$win.height= 800;
			$win.alwaysInFront=false
			$win.resizable=true
			$win.showStatusBar = false;
			$win.title = "合并Lightmap"
			
			
			_combineLightmapPanel.setStyle("left",0);
			_combineLightmapPanel.setStyle("right",0);
			_combineLightmapPanel.setStyle("top",0);
			_combineLightmapPanel.setStyle("bottom",0);
			
			$win.addElement(_combineLightmapPanel);
			$win.addEventListener(AIREvent.WINDOW_COMPLETE,windowComplete)
			$win.addEventListener(AIREvent.APPLICATION_ACTIVATE,windowActivate)
			
			
			$win.open(true);
			_win=$win
			_win.visible=false
		}
		
		protected function windowActivate(event:AIREvent):void
		{
			//trace(event.target)
			
		}
		protected function windowComplete(event:AIREvent):void
		{
			Window(event.target).nativeWindow.x=Scene_data.stage.nativeWindow.x+Scene_data.stage.stageWidth/2-Window(event.target).nativeWindow.width/2;
			Window(event.target).nativeWindow.y=Scene_data.stage.nativeWindow.y+Scene_data.stage.stageHeight/2-Window(event.target).nativeWindow.height/2;
			_win.visible=true
			
		}
		
		
		
	}
}