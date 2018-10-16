package modules.materials
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.graphics.codec.JPEGEncoder;
	
	import common.msg.event.scene.Mevent_ExpToH5_Event;
	import common.utils.frame.BasePanel;
	import common.utils.ui.btn.LButton;
	import common.utils.ui.cbox.ComLabelBox;
	import common.utils.ui.file.FileNode;
	
	import materials.MaterialTree;
	
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.h5.ExpResourcesModel;
	import modules.hierarchy.h5.RectanglePack;
	import modules.hierarchy.node.RectangleID;
	
	import pack.BuildMesh;
	
	import render.ground.TerrainEditorData;
	
	public class CombineLightPanel extends BasePanel
	{
		public function CombineLightPanel()
		{
			super();
			this.setStyle("backgroundColor",0x404040);
			this.setStyle("borderColor",0x000000);
			this.setStyle("borderStyle","solid");
			this.setStyle("borderVisible",true);
			this.horizontalScrollPolicy = "off";
			
			this.addBtn();
		}
		private var bitmapUI:UIComponent;
		private var infoTxt:Label;
		private var scaleTxt:Label;
		
		private function addBtn():void{
			this.bitmapUI = new UIComponent;
			this.addChild(bitmapUI);
			this.bitmapUI.y = 100;
			this.bitmapUI.scaleX = this.bitmapUI.scaleY = 0.5;
			
			var bgTop:Canvas = new Canvas();
			bgTop.setStyle("backgroundColor",0x303030);
			bgTop.setStyle("borderColor",0x000000);
			bgTop.setStyle("borderStyle","solid");
			bgTop.setStyle("borderVisible",true);
			bgTop.setStyle("left",0);
			bgTop.setStyle("right",0);
			bgTop.height = 40;
			this.addChild(bgTop);
			
			var typeMode:ComLabelBox = new ComLabelBox;
			typeMode.label = "合并模式";
			typeMode.height = 20;
			typeMode.y = 10;
			typeMode.changFun = typeChang;
			this.addChild(typeMode);
			
			var ary:Array = new Array;
			ary.push({type:0,name:"整图"});
			ary.push({type:1,name:"材质"});
			ary.push({type:2,name:"材质+纹理"});
			typeMode.data = ary;
			this.currentData = ary[0];
			
			var btn:LButton = new LButton;
			btn.label = "生成";
			btn.addEventListener(MouseEvent.CLICK,onCreatClick);
			btn.x = 80;
			btn.y = 10;
			this.addChild(btn);
			
			this.infoTxt = new Label();
			this.infoTxt.width = 200;
			this.infoTxt.height = 30;
			this.infoTxt.x = 230;
			this.infoTxt.y = 10;
			this.infoTxt.setStyle("color",0x9f9f9f);
			this.addChild(this.infoTxt);
			
			this.scaleTxt = new Label();
			this.scaleTxt.width = 200;
			this.scaleTxt.height = 30;
			this.scaleTxt.x = 430;
			this.scaleTxt.y = 10;
			this.scaleTxt.setStyle("color",0x9f9f9f);
			this.scaleTxt.addEventListener(MouseEvent.CLICK,onScaleClick);
			this.addChild(this.scaleTxt);
			this.showScale();
			
			var saveBtn:LButton = new LButton;
			saveBtn.label = "保存";
			saveBtn.addEventListener(MouseEvent.CLICK,onSaveClick);
			saveBtn.x = 500;
			saveBtn.y = 10;
			this.addChild(saveBtn);
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
			this.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,onMouseDown);
			
		}
		
		protected function onScaleClick(event:MouseEvent):void
		{
			this.bitmapUI.scaleX = this.bitmapUI.scaleY = 1.0;
			this.showScale();
		}
		
		protected function onSaveClick(event:MouseEvent):void
		{
			if(!this.packList){
				return;
			}
			var file:File = new File(TerrainEditorData.fileRoot+"mergelightuv");
			if(file.exists){
				file.deleteDirectory(true);
			}
			var list:Array = new Array;
			var fs:FileStream;
			for(var i:int=0;i<this.packList.length;i++){
				var rec:Vector.<RectangleID> = this.packList[i].rects;
				var imageid:int = this.packList[i].packId;
				var imagewidth:int = this.packList[i].bitmapdata.width;
				var imageheight:int = this.packList[i].bitmapdata.height;
				for(var j:int=0;j<rec.length;j++){
					var obj:Object = new Object;
					obj.id = rec[j].id;
					obj.x = rec[j].x;
					obj.y = rec[j].y;
					obj.width = rec[j].width;
					obj.height = rec[j].height;
					obj.imageid = imageid;
					obj.imagewidht = imagewidth;
					obj.imageheight = imageheight;
					list.push(obj);
				}
				
				var jpg:JPEGEncoder = new JPEGEncoder(100);
				var byte:ByteArray = jpg.encode(this.packList[i].bitmapdata);
				
				file = new File(TerrainEditorData.fileRoot+"mergelightuv/"+"build"+ imageid + ".jpg");
				fs = new FileStream();
				fs.open(file,FileMode.WRITE);
				fs.writeBytes(byte);
				fs.close();
				
			}
			var md5Str:String = MergeLightUV.getMd5();
			file = new File(TerrainEditorData.fileRoot+"mergelightuv/config.txt");
			fs = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeUTF(md5Str);
			fs.writeObject(list);
			fs.close();
		}
		
		
		protected function onMouseUp(event:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP,onMouseUp);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP,onMouseUp);
			this._lastX = this.stage.mouseX;
			this._lastY = this.stage.mouseY;
		}
		private var _lastX:int;
		private var _lastY:int;
		protected function onMouseMove(event:MouseEvent):void
		{
			var dx:int = this.stage.mouseX - this._lastX;
			var dy:int = this.stage.mouseY - this._lastY;
			this._lastX = this.stage.mouseX;
			this._lastY = this.stage.mouseY;
			
			this.bitmapUI.x += dx;
			this.bitmapUI.y += dy;
			
		}
		
		protected function onMouseWheel(event:MouseEvent):void
		{
			var sc:Number = this.bitmapUI.scaleX
			sc += event.delta * 0.01;
			this.bitmapUI.scaleX = this.bitmapUI.scaleY = sc;
			this.showScale();
		}
		
		private var currentType:int = 0;
		private var currentData:Object;
		protected function onCreatClick(event:MouseEvent):void
		{
			this.showInfo("开始按<" + this.currentData.name + ">导出");
			
			//FileNodeManage.getListAllFileNode(_hierarchyPanel.listBaseArr)
			var evt:Mevent_ExpToH5_Event = new Mevent_ExpToH5_Event(Mevent_ExpToH5_Event.EVENT_COMBINE_LIGHT_H5);
			evt.data = this;
			ModuleEventManager.dispatchEvent(evt);
		}
		
		public function setList($arr:Vector.<FileNode>):void{
			//trace(obj);
			this.combineLightMap($arr);
		}
		
		private function sortFileNodeGroupLightMap($arr:Vector.<FileNode>):Object
		{
			var backArr:Vector.<FileNode>=new Vector.<FileNode>;
			var data:Array=new Array();
			for(var i:uint=0;i<$arr.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=$arr[i] as HierarchyFileNode
				if($hierarchyFileNode.data as BuildMesh)	{
					var $BuildMesh:BuildMesh=$hierarchyFileNode.data as BuildMesh;
					if(!$BuildMesh.isGround && !MaterialTree($BuildMesh.prefabStaticMesh.material).noLight){
						var $picItem:Array=ExpResourcesModel.getInstance().changeUrlByMaterialInfoArr($BuildMesh.prefabStaticMesh.materialInfoArr)
						var $picKey:String="";
						while($picItem.length){
							var $obj:Object=$picItem.pop();
							if($obj.type==0){
								$picKey+=$obj.url
							}
						}
						var $kkkk:Object=new Object();
						$kkkk.node=$arr[i];
						$kkkk.hasAlpha=MaterialTree($BuildMesh.prefabStaticMesh.material).hasAlpha
						$kkkk.materialUrl=decodeURI($BuildMesh.prefabStaticMesh.materialUrl)
						$kkkk.picKey=$picKey;
						data.push($kkkk);
					}
				}
			}
			data.sortOn(["hasAlpha","materialUrl","picKey"]);
			
			var dataDic:Object = new Object;
			
			
			for(var j:uint=0;j<data.length;j++){
				//backArr.push(data[j].node)
				//trace(data[j].materialUrl)
				var key:String
				if(this.currentType == 0){
					key = "all";
				}else if(this.currentType == 1){
					key = data[j].materialUrl;
				}else if(this.currentType == 2){
					key = data[j].materialUrl + data[j].picKey;
				}
				
				if(!dataDic[key]){
					dataDic[key] = new Array;
				}
				dataDic[key].push(data[j].node);
			}
			
			return dataDic;
		}
		private var bitmapList:Array;
		private var txtList:Array;
		private var packList:Vector.<RectanglePack>;
		private function combineLightMap($arr:Vector.<FileNode>):void{
			this.clearBitmap();
			var dic:Object = this.sortFileNodeGroupLightMap($arr);
			var flag:int = 0;
			this.bitmapList = new Array;
			this.txtList = new Array;
			this.packList = new Vector.<RectanglePack>;
			for(var key:String in dic){
				var ary:Array = dic[key];
				var recAry:Vector.<RectangleID> = new Vector.<RectangleID>;
				for(var i:int = 0;i<ary.length;i++){
					var node:FileNode = ary[i];
					var size:int = BuildMesh(node.data).lightMapSize;
					var r:RectangleID = new RectangleID(0,0,size,size);
					r.id = node.id;
					recAry.push(r);
				}
				var rp:RectanglePack = new RectanglePack();
				rp.pack(recAry,flag,this.addBitMap);
				this.packList.push(rp);
				flag++;
			}
			
			this.showInfo("共生成" + flag + "张图");
			
			
		}
		
		public function clearBitmap():void{
			while(this.bitmapUI.numChildren){
				this.bitmapUI.removeChildAt(0);
			}
		}
		
		public function addBitMap(id:int,bitmapdata:BitmapData):void{
			
			
			var bitmap:Bitmap = new Bitmap(bitmapdata);
			this.bitmapUI.addChild(bitmap);
			this.bitmapList[id] = bitmap;
			
			var txt:TextField = new TextField();
			txt.width = 400;
			txt.height = 60;
			txt.y = -50;
			this.bitmapUI.addChild(txt);
			this.txtList[id] = txt;
			
			txt.htmlText = "<font color='#ff0000' size='40'><b>" + bitmapdata.width + " × " + bitmapdata.height + "</b></font>"
			
			this.resetBitmap();
		}
		
		public function resetBitmap():void{
			var xpos:int = 0;
			for(var i:int=0;i<bitmapList.length;i++){
				if(bitmapList[i]){
					bitmapList[i].x = xpos;
					txtList[i].x = xpos;
					xpos += bitmapList[i].width + 100;
					
				}
				
			}
		}
		
		public function showInfo(str:String):void{
			this.infoTxt.text = str;
			
		}
		
		public function showScale():void{
			var sc:Number = this.bitmapUI.scaleX;
			sc = int(sc * 100)/100
			this.scaleTxt.text = "缩放：" + sc;
		}
		
		public function typeChang(obj:Object):void{
			this.currentType = 	obj.type;
			this.currentData = obj;
		}
		
		
		
		
	}
}
