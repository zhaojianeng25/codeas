package _Pan3D.text
{
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.text.select.Display3DSelectImg;
	import _Pan3D.text.select.Display3DSelectImgShader;
	import _Pan3D.texture.TextureCount;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.utils.TickTime;
	
	import _me.Scene_data;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.geom.Vector3D;

	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class TextFieldManager
	{
		private static var _instance:TextFieldManager;
//		private var _idleNum:int;
		/**
		 * vc对应ID的状态 是否处于使用中 
		 */		
//		public var idStatus:Vector.<Boolean>;
		/**
		 * 显示对象存储的数组 
		 */		
		private var display3dAry:Vector.<Display3DText>;
		/**
		 * 动态显示对象的存储的数组 
		 */		
		private var display3dynamicAry:Vector.<Display3DynamicText>;
		/**
		 * 显示对象的容器 
		 */		
		private var _contaniner:Display3DContainer;
		/**
		 * 静态图片的材质 
		 */		
		private var _texture:Texture;
		
		private var _currentText:Text3Dynamic;
		private var _selectDisplay:Display3DSelectImg;
		public function TextFieldManager()
		{
			initDisplay();
			initTexture();
			TickTime.addCallback(dispose);
		}
		public static function getInstance():TextFieldManager{
			if(!_instance){
				_instance = new TextFieldManager;
			}
			return _instance;
		}
		/**
		 * 初始化数组 
		 * 
		 */		
		private function initDisplay():void{
			display3dAry = new Vector.<Display3DText>;
			display3dynamicAry = new Vector.<Display3DynamicText>;
			_selectDisplay = new Display3DSelectImg(Scene_data.context3D);
			
			Program3DManager.getInstance().registe(Display3DTextShader.Display3DTextShader,Display3DTextShader);
			Program3DManager.getInstance().registe(Display3DynamicTextShader.DISPLAY3DYNAMICTEXTSHADER,Display3DynamicTextShader);
			Program3DManager.getInstance().registe(Display3DSelectImgShader.DISPLAY3DSELECTIMGSHADER,Display3DSelectImgShader);
			
			_selectDisplay.setProgram3D(Program3DManager.getInstance().getProgram(Display3DSelectImgShader.DISPLAY3DSELECTIMGSHADER));
		}
		/**
		 * 添加一个新的显示对象到显示列表中 
		 * @return 添加的显示对象
		 * 
		 */		
		private function addDisplay():Display3DText{
			var display3dText:Display3DText = new Display3DText(Scene_data.context3D);
			display3dAry.push(display3dText);
			display3dText.setProgram3D(Program3DManager.getInstance().getProgram(Display3DTextShader.Display3DTextShader));
			_contaniner.addChild(display3dText);
			return display3dText;
		}
		
		public function addDisplayDynamic():Display3DynamicText{
			var display3dText:Display3DynamicText = new Display3DynamicText(Scene_data.context3D);
			display3dynamicAry.push(display3dText);
			display3dText.setProgram3D(Program3DManager.getInstance().getProgram(Display3DynamicTextShader.DISPLAY3DYNAMICTEXTSHADER));
			_contaniner.addChild(display3dText);
			return display3dText; 
		}
		
		/**
		 * 文字系统初始化 
		 * @param container 显示系统的容器
		 * 
		 */		
		public function init(container:Display3DContainer):void{
			_contaniner = container;
		}
		
		/**
		 * 获取一个3d静态文本对象
		 * @return 静态文本
		 * 
		 */	
		public function getText3D($texture:Texture):Text3D{
			var text:Text3D = new Text3D(this,$texture);
			return text;
		}
		/**
		 * 获取一个图片文本 
		 * @param $width 宽
		 * @param $height 高
		 * @return 
		 * 
		 */		
		public function getText3Dynamic($width:int,$height:int,$zbuff:Number=0.2):Text3Dynamic{
			var text:Text3Dynamic = new Text3Dynamic(this,$width,$height,$zbuff);
			return text;
		}
		
		
		/**
		 * 初始化加载材质 
		 * 
		 */		
		private function initTexture():void{
			//TextureManager.getInstance().addTexture("assets/0_9.png",onTexture,null);
		}
		
		/**
		 * 设置材质 
		 * @param $texture
		 * @param info
		 * 
		 */	
		private function onTexture($texture:Texture,info:Object):void{
			_texture = $texture;
		}
		
		/**
		 * 从文字系统请求空闲的vc使用 
		 * @param text3d 发起请求的文本对象
		 * @param $digits 要请求字符的位数
		 * 
		 */		
		public function requestStaticDisplay(text3d:Text3D):void{
			//从当前列表中请求 如果请求不到则新建显示对象 并从新的显示对象中获取vc
			for(var i:int;i<display3dAry.length;i++){
				var tf:Boolean = display3dAry[i].requestDisplay(text3d);
				if(tf){
					return;
				}
			}
			var display3dText:Display3DText = addDisplay();
			display3dText.requestDisplay(text3d);
		}
		
		/**
		 * 从文字系统请求空闲的动态资源使用 
		 * @param txt 发起请求的动态文本对象
		 * 
		 */		
		public function requestDisplay(txt:Text3Dynamic):void{
			for(var i:int;i<display3dynamicAry.length;i++){
				var tf:Boolean = display3dynamicAry[i].requestDisplay(txt);
				if(tf){
					return;
				}
			}
			var display3dText:Display3DynamicText = addDisplayDynamic();
			display3dText.initData(txt.width,txt.height,txt.zbuff);
			display3dText.requestDisplay(txt);
			//sort();
		}
			
		public function addChild(display3dText:Display3DSprite):void{
			_contaniner.addChild(display3dText);
		}
		
		private function sort():void{
			_contaniner.sort("zbuff",true);
		}
		
		public function addSelect(txt:Text3Dynamic):void{
			_selectDisplay.refresh(txt);
			_currentText = txt;
			if(!_selectDisplay.parent)
				_contaniner.addChild(_selectDisplay);
			sort();
		}
		
		public function removeSelect(txt:Text3Dynamic):void{
			if(_currentText == txt){
				_contaniner.removeChild(_selectDisplay);
			}
		}
		
		public function reload():void{
			for(var i:int;i<_contaniner.childrenList.length;i++){
				if(_contaniner.childrenList[i] is Display3DynamicText){
					Display3DynamicText(_contaniner.childrenList[i]).reload();
				}
			}
			
			if(_selectDisplay){
				_selectDisplay.reload();
			}
			
		}
		
		public function dispose():void{
			//trace("文本类型的总数量" + display3dynamicAry.length)
			var l:int = display3dynamicAry.length - 1;
			for(var i:int = l;i>=0;i--){
				if(display3dynamicAry[i].idleNum == display3dynamicAry[i].allNum){
					display3dynamicAry[i].dispose();
					display3dynamicAry.splice(i,1);
				}
			}
			
			l = display3dAry.length - 1;
			for(i = l;i>=0;i--){
				if(display3dAry[i].idleNum == display3dAry[i].allNum){
					display3dAry[i].dispose();
					display3dAry.splice(i,1);
				}
			}
			
			TextureCount.getInstance().countTextFiled(display3dynamicAry.length);
			
		}
		
	}
}