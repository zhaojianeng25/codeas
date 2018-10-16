package modules.materials.view
{
	import flash.display.Bitmap;
	
	import spark.components.Label;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	
	import _me.Scene_data;
	
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeTex;

	public class TextureSampleNodeUI extends BaseMaterialNodeUI
	{
		private var uvItem:ItemMaterialUI;
		private var rgbItem:ItemMaterialUI;
		private var rItem:ItemMaterialUI;
		private var gItem:ItemMaterialUI;
		private var bItem:ItemMaterialUI;
		private var aItem:ItemMaterialUI;
		private var rgbaItem:ItemMaterialUI;
		
		private var _bmp:Bitmap;
		private var _url:String;
		
		private var _wrap:int//0 reapte,1 clamp
		private var _mipmap:int;// 0=disable、1=nearest、2=linear
		private var _filter:int;// 0=linear1=nearest、
		private var _permul:Boolean;
		
		private var _mainTxt:Label;
		public function TextureSampleNodeUI()
		{
			super();
			
			initMainLabel();
			
			nodeTree = new NodeTreeTex;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.TEX;
			
			this.gap = 20;
			initItem();
			
			_titleLabel.text = "纹理采样";
			
			_titleLabel.width = 160;
			
			titleBitmap = new phys_marterialCls2;
			addTitleImg();
			
			this.width = 162;
			this.height = 160;
			
			_bmp = new Bitmap;
			_bgContainer.addChild(_bmp);
			
			
		}
		
		

		

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
			addBitmpUrl(value);
		}

		private function initMainLabel():void{
			_mainTxt = new Label;
			_mainTxt.setStyle("color",0xff0000);
			_mainTxt.setStyle("fontSize",12);
			_mainTxt.setStyle("fontWeight","bold");
			_mainTxt.x = 145;
			_mainTxt.y = 8;
			_mainTxt.height = 30;
			_mainTxt.width = 20;
			//_mainTxt.text = "M"
			this.addChild(_mainTxt);
		}
		
		private function initItem():void{
			uvItem = new ItemMaterialUI("UV",MaterialItemType.VEC2);
			rgbItem = new ItemMaterialUI("rgb",MaterialItemType.VEC3,false);
			rItem = new ItemMaterialUI("r",MaterialItemType.FLOAT,false);
			gItem = new ItemMaterialUI("g",MaterialItemType.FLOAT,false);
			bItem = new ItemMaterialUI("b",MaterialItemType.FLOAT,false);
			aItem = new ItemMaterialUI("a",MaterialItemType.FLOAT,false);
			rgbaItem = new ItemMaterialUI("rgba",MaterialItemType.VEC4,false);
			
			addItems(uvItem);
			addItems(rgbItem);
			addItems(rItem);
			addItems(gItem);
			addItems(bItem);
			addItems(aItem);
			addItems(rgbaItem);
		}
		
		public function addBitmpUrl($url:String):void{
			_url = $url;
			NodeTreeTex(nodeTree).url = $url;
			LoadManager.getInstance().addSingleLoad(new LoadInfo(Scene_data.fileRoot + $url,LoadInfo.BITMAP,onLoadBmp,0,$url));
		}
		
		private function onLoadBmp($bmp:Bitmap,url:String):void{
			_bmp.bitmapData = $bmp.bitmapData;
			var wh:int = Math.max($bmp.bitmapData.width,$bmp.bitmapData.height);
			_bmp.scaleX = 80 / wh;
			_bmp.scaleY = 80 / wh;
			_bmp.x = 10;
			_bmp.y = 60;
		}
		
		override public function getData():Object{
			var obj:Object = super.getData();
			obj.url = _url;
			obj.isMain = NodeTreeTex(nodeTree).isMain;
			obj.wrap = NodeTreeTex(nodeTree).wrap;
			obj.mipmap= NodeTreeTex(nodeTree).mipmap;
			obj.filter= NodeTreeTex(nodeTree).filter;
			obj.permul= NodeTreeTex(nodeTree).permul;
			return obj;
		}
		
		override public function setData(obj:Object):void{
			super.setData(obj);
			obj.url = String(obj.url).replace(Scene_data.fileRoot,"");//兼容原来相对路径
			addBitmpUrl(obj.url);
			NodeTreeTex(nodeTree).url = obj.url;
			this.isMain = obj.isMain;
			this.wrap = obj.wrap;
			this.mipmap = obj.mipmap;
			this.filter = obj.filter;
			this.permul = obj.permul;
			showDynamic();
		}
		
		public function get wrap():int
		{
			return _wrap;
		}
		
		public function set wrap(value:int):void
		{
			_wrap = value;
			NodeTreeTex(nodeTree).wrap = value;
		}
		
		public function get filter():int
		{
			return _filter;
		}
		
		public function set filter(value:int):void
		{
			_filter = value;
			NodeTreeTex(nodeTree).filter = value;
		}
		
		public function get mipmap():int
		{
			return _mipmap;
		}
		
		public function set mipmap(value:int):void
		{
			_mipmap = value;
			NodeTreeTex(nodeTree).mipmap = value;
		}
		
		public function get permul():Boolean
		{
			return _permul;
		}
		
		public function set permul(value:Boolean):void
		{
			_permul = value;
			NodeTreeTex(nodeTree).permul = value;
		}
		
		override public function changeDynamic():void{
			super.changeDynamic();
			showDynamic();
		}
		
		public function set isMain(value:Boolean):void{
			NodeTreeTex(nodeTree).isMain = value;
			if(value){
				_mainTxt.text = "M";
			}else{
				_mainTxt.text = "";
			}
		}
		
		override public function showDynamic():void{
			if(nodeTree.isDynamic){
				_titleLabel.text = "纹理采样<" + nodeTree.paramName + ">";
			}else{
				_titleLabel.text = "纹理采样";
			}
		}
		
		
		
	}
}