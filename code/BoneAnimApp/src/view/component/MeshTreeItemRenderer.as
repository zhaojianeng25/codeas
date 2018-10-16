package view.component
{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.Label;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.controls.treeClasses.TreeListData;
	
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.program.shaders.Md5MatrialShader;
	import _Pan3D.utils.MaterialManager;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	import manager.LayerManager;
	
	import materials.MaterialTree;
	
	import utils.FileConfigUtils;
	import utils.FilterStringUtils;
	
	import view.mesh.MeshBindListPanle;
	import view.mesh.MeshBindListPanle2;
	import view.mesh.MeshBindPanle;
	import view.mesh.MeshBoneMaterialMeshPanel;
	import view.mesh.MeshPanel;
	
	
	public class MeshTreeItemRenderer extends TreeItemRenderer
	{
		private var checkBox:CheckBox;
		private var labW:int = 100;
		private var labH:int = 20;
		
		private var imgLable:Label;
		private var particleLabel:Label;
		
		//private var lightMapLable:Label;
		
		public function MeshTreeItemRenderer()
		{
			super();
			BindingUtils.bindSetter(SetLab,this,"listData");
		}
		override protected function createChildren():void{
			super.createChildren();
			if(!checkBox){
				checkBox=new CheckBox();
				addChild(checkBox);
				checkBox.width = labW;
				checkBox.height = labH;
				checkBox.x = 10;
				checkBox.y = -4;
				checkBox.addEventListener(MouseEvent.CLICK,onCb);
			}
			if(!imgLable){
				imgLable = new Label;
				addChild(imgLable);
				imgLable.width = 70;
				imgLable.height = 20;
				imgLable.text = "材质";
				imgLable.x = 140;
				imgLable.y = -2;
				imgLable.addEventListener(MouseEvent.CLICK,onImg);
				
				imgLable.setStyle("color","#9C9C9C");
			}
			if(!particleLabel){
				particleLabel = new Label;
				addChild(particleLabel);
				particleLabel.width = 70;
				particleLabel.height = 20;
				particleLabel.text = "特效";
				particleLabel.x = 210;
				particleLabel.y = -2;
				particleLabel.addEventListener(MouseEvent.CLICK,onParticle);
			}
			
//			if(!lightMapLable){
//				lightMapLable = new Label;
//				addChild(lightMapLable);
//				lightMapLable.width = 70;
//				lightMapLable.height = 20;
//				lightMapLable.text = "高光贴图";
//				lightMapLable.x = 280;
//				lightMapLable.y = -2;
//				lightMapLable.addEventListener(MouseEvent.CLICK,onLightImg);
//			}
			
			if(label){
				label.x = 30;
				label.y = -2;
				label.width = 100;
				//label.setStyle("color","#9C9C9C");
				label.textColor = 0x9C9C9C;
			}
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			checkBox.x = 10;//unscaledWidth-lab.width + 50;
			checkBox.y = -4;
			
			label.x = 30;
			label.y = -2;
			label.width = 100;
			
			label.textColor = 0x9C9C9C;
			
			imgLable.x = 140;
			
			this.measuredHeight = 20;
		}
		
		override protected function measure():void{
			super.measure();
			measuredHeight = 15;
		}
		
		/**
		 *
		 * @param value TreeListData listData
		 * 它的数据结构中间的item的结构一个XML
		 *
		 */
		private function SetLab(value:TreeListData):void{
			if(!value||!checkBox)
				return;
			//var str:String = value.item.name;
			if(value.hasChildren){
				particleLabel.visible = imgLable.visible = checkBox.visible = false;
			}else{
				particleLabel.visible = imgLable.visible = checkBox.visible = true;
			}
			checkBox.selected =  value.item.check;
			if(value.item.textureName){
				//imgLable.text = value.item.textureName;
			}
			if(value.item.particleName)
				particleLabel.text = value.item.particleName;
			
			draw(value.hasChildren);
			
			label.toolTip = value.item.fileName;
			
			if(value.item.particleList && value.item.particleList.length){
				particleLabel.setStyle("color","#ff0000");
			}else{
				particleLabel.setStyle("color","#9C9C9C");
			}
			
		}
		private function draw(isChildren:Boolean):void{
			this.graphics.clear();
			if(!isChildren){
				this.graphics.lineStyle(1,0x999999,0.2);
				this.graphics.moveTo(10,17);
			}else{
				this.graphics.lineStyle(1,0x999999,0.5);
				this.graphics.moveTo(0,17);
			}
			
			this.graphics.lineTo(336,17);
		}
		
		private function onCb(event:Event):void{
			TreeListData(listData).item.check = checkBox.selected;
			TreeListData(listData).item.data.visible = checkBox.selected;
			var ary:Array = TreeListData(listData).item.particleList;
			if(ary){
				for(var i:int;i<ary.length;i++){
					ary[i].visible = checkBox.selected;
				}
			}
			
			if(ary){
				AppDataBone.role.removeAllMeshParticle(TreeListData(listData).item.fileName);
				AppDataBone.role.addMeshParticle(TreeListData(listData).item.fileName,ary);
			}
			
			
		}
		
		private function onImg(event:MouseEvent):void{
			
		
			if(!_meshBoneMaterialMeshPanel){
				_meshBoneMaterialMeshPanel = new MeshBoneMaterialMeshPanel;
				
			}
			_meshBoneMaterialMeshPanel.init(null,"属性",2);
			_meshBoneMaterialMeshPanel.setData(TreeListData(listData),changeMaterialInfoArr)
			LayerManager.getInstance().addPanel(_meshBoneMaterialMeshPanel);

			return 
		
			var fileurl:String = MeshPanel.getInstance().lastFileImgUrl;
			if(!fileurl){
				fileurl= FileConfigUtils.readConfig().meshImgUrl;
			}
			var file:File = new File(fileurl);
			file.browseForOpen("打开材质文件",[new FileFilter("material","*.material;*.material")]);
			file.addEventListener(Event.SELECT,onSel)
		}
		private function changeMaterialInfoArr():void
		{
			
			trace("修改完成")
		
		}
		private var _meshBoneMaterialMeshPanel:MeshBoneMaterialMeshPanel


		
		private function onSel(event:Event):void{
			
			if(FilterStringUtils.getErrorName(event.target.name)){
				Alert.show("该文件的文件名存在 大写字母/空格/中文或者其他特殊字符");
				return;
			}
			
			var url:String = event.target.url;
			
			if(url.indexOf(Scene_data.md5Root) == -1){
				Alert.show("非工作空间");
				return;
			}
			
			MeshPanel.getInstance().lastFileImgUrl = url;
			FileConfigUtils.writeConfig("meshImgUrl",File(event.target).parent.url);
			
			url = url.substring(Scene_data.md5Root.length);
			
			TreeListData(listData).item.textureUrl = url;
			TreeListData(listData).item.texturePath = File(event.target).nativePath;
			TreeListData(listData).item.textureName = File(event.target).name;
			imgLable.text = TreeListData(listData).item.textureName;
			//TextureManager.getInstance().addTexture(Scene_data.md5Root + url,addTexture,TreeListData(listData).item);
			MaterialManager.getInstance().getMaterial(Scene_data.fileRoot + url,addMaterial,TreeListData(listData).item,true,Md5MatrialShader.MD5_MATRIAL_SHADER,Md5MatrialShader);
		}
		
		private function addMaterial($mt:MaterialTree,info:Object):void{
			//trace($mt);
			//Program3DManager.getInstance()
			data.data.material = $mt;
			AppDataBone.role.addMeshData(TreeListData(listData).item.fileName,data.data);
		}
		
		private function addTexture(textureVo:TextureVo,info:Object):void{
			TreeListData(listData).item.texture = textureVo.texture;
			AppDataBone.role.addTextureLocal(TreeListData(listData).item.fileName,textureVo.texture);
			AppDataBone.role.addMeshLocal(TreeListData(listData).item.fileName,data.data);
		}
		
		/*************************/
		
//		private function onLightImg(event:MouseEvent):void{
//			var fileurl:String = MeshPanel.getInstance().lastFileImgUrl;
//			if(!fileurl){
//				fileurl= FileConfigUtils.readConfig().meshImgUrl;
//			}
//			var file:File = new File(fileurl);
//			file.browseForOpen("打开贴图文件",[new FileFilter("img","*.jpg;*png")]);
//			file.addEventListener(Event.SELECT,onLightSel)
//		}
//		private function onLightSel(event:Event):void{
//			
//			if(FilterStringUtils.getErrorName(event.target.name)){
//				Alert.show("该文件的文件名存在 大写字母/空格/中文或者其他特殊字符");
//				return;
//			}
//			
//			var url:String = event.target.url;
//			
//			if(url.indexOf(Scene_data.md5Root) == -1){
//				Alert.show("非工作空间");
//				return;
//			}
//			
//			MeshPanel.getInstance().lastFileImgUrl = url;
//			FileConfigUtils.writeConfig("meshImgUrl",File(event.target).parent.url);
//			
//			url = url.substring(Scene_data.md5Root.length);
//			
//			TreeListData(listData).item.textureLightUrl = url;
//			TreeListData(listData).item.textureLightPath = File(event.target).nativePath;
//			TreeListData(listData).item.textureLightName = File(event.target).name;
//			lightMapLable.text = TreeListData(listData).item.textureLightName;
//			TextureManager.getInstance().addTexture(Scene_data.md5Root + url,addLightTexture,TreeListData(listData).item);
//		}
//		private function addLightTexture(textureVo:TextureVo,info:Object):void{
//			TreeListData(listData).item.lightTexture = textureVo.texture;
//			AppDataBone.role.addTextureLightLocal(TreeListData(listData).item.textureLightName,textureVo.texture);
//			AppDataBone.role.addMeshLightLocal(TreeListData(listData).item.textureLightName,data.data);
//		}
		
		
		/*************************/
		private function onParticle(event:MouseEvent):void{
			
			//var hangPanel:HangPanel = HangPanel.getInstance();
			var meshBindPanle:MeshBindListPanle = MeshBindListPanle.getInstance();
			meshBindPanle.init(null,"粒子",2);
			LayerManager.getInstance().addPanel(meshBindPanle,true);
			meshBindPanle.showData(TreeListData(listData).item);
			return;
			MeshBindListPanle.getInstance().show(this.parentDocument.parent,TreeListData(listData).item);
			MeshBindListPanle2.getInstance().show(this.parentDocument.parent,TreeListData(listData).item);
			return;
			MeshBindPanle.getInstance().show(this.parentDocument.parent,TreeListData(listData).item);
			return;
			var fileurl:String = MeshPanel.getInstance().lastParticleUrl;
			if(!fileurl){
				fileurl= FileConfigUtils.readConfig().meshParticleUrl;
			}
			var file:File = new File(fileurl);
			file.browseForOpen("打开粒子文件",[new FileFilter("lyf","*.lyf")]);
			file.addEventListener(Event.SELECT,onParticleSel)
		}
		
		private function onParticleSel(event:Event):void{
			var file:File = event.target as File;
			TreeListData(listData).item.particleNativePath = file.nativePath;
			TreeListData(listData).item.particleUrl = file.url;
			TreeListData(listData).item.particleName = file.name;
			TreeListData(listData).item.bindIndex = 19;
			ParticleManager.getInstance().addParticleByUrl(file.url,TreeListData(listData).item);
			
			MeshPanel.getInstance().lastParticleUrl = file.parent.url;
			FileConfigUtils.writeConfig("lyfUrl",MeshPanel.getInstance().lastParticleUrl);
			particleLabel.text = file.name;
		}
		
		public function particleResult():void{
			
		}
		
		
		
	}
}