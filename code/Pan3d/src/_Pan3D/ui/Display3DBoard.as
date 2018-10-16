package _Pan3D.ui
{
	import _Pan3D.base.MakeModelData;
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.texture.TextureManager;
	
	import _me.Scene_data;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	public class Display3DBoard extends Display3DSprite
	{
		protected var _width:Number;
		protected var _height:Number;

		private var basebitmapdata:BitmapData;
		private var _alpha:Number = 1;
		public function Display3DBoard(context:Context3D)
		{
			super(context);
			var zNum:Number = 0.3;
			_objData=MakeModelData.makeJuXinTampData(new Vector3D(0,0,zNum),new Vector3D(2,-2,zNum));
			try
			{
				uplodToGpu();
			} 
			catch(error:Error) 
			{
				if(!Scene_data.disposed){
					throw error;
				}
			}
			
		}
		/**
		 * 设置背景图片 
		 * @param bitmapdata
		 * 
		 */		
		public function setBitmapdata(bitmapdata:BitmapData):void{
			basebitmapdata = new BitmapData(getMaxWH(bitmapdata.width),getMaxWH(bitmapdata.height),true,0x00ffffff);
			//var ma:Matrix = new Matrix;
			//ma.tx = (512-bitmapdata.width)/2;
			//ma.ty = (512-bitmapdata.height)/2;
			//basebitmapdata.draw(bitmapdata);
			basebitmapdata.copyPixels(bitmapdata,new Rectangle(0,0,bitmapdata.width,bitmapdata.height),new Point);
			
			_objData.texture=TextureManager.getInstance().bitmapToTexture(basebitmapdata);
			_width=basebitmapdata.width;
			_height=basebitmapdata.height;
			
		}
		
		public function setTexture(texture:Texture,w:int,h:int):void{
			_objData.texture = texture;
			_width = w;
			_height = h;
		}
		
		/**
		 * 获取最小的所需长度（不超过512）
		 * @param num
		 * @return 
		 * 
		 */		
		private function getMaxWH(num:int):int{
			var flag:int = 2;
			while(num > flag){
				flag = flag*2;
				if(flag == 1024){
					break;
				}
			}
			
			return flag;
		}
		
		
		
		override public function update() : void {
			if (!this._visible) {
				return;
			}
			if (_objData && _objData.texture) {
				_context.setProgram(this.program);
				setVc();
				setVa();
				resetVa();
			}
		}
		override protected function setVa() : void {
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context.setTextureAt(0, _objData.texture);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(_objData.indexs.length/3);
		}
		override protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			_context.setTextureAt(0,null);
		}
		override protected function setVc() : void {
			var sw:Number;
			var sh:Number;
			if(this.parent){
				sw=_width/Scene_data.stageWidth * this.parent.scale;
				sh=_height/Scene_data.stageHeight * this.parent.scale;
			}else{
				sw=_width/Scene_data.stageWidth;
				sh=_height/Scene_data.stageHeight;
			}
			
			var tx:Number=-1+_absoluteX/Scene_data.stageWidth*2
			var ty:Number=1-_absoluteY/Scene_data.stageHeight*2

			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,Vector.<Number>( [sw,sh,tx,ty]));   //等用
			
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([1, 1, 1, _alpha]));
		}
		
		override public function updataPos():void{
			if(this._parent){
				this._absoluteX = this._x + this._parent.absoluteX/Scene_data.mainRelateScale;
				this._absoluteY = this._y + this._parent.absoluteY/Scene_data.mainRelateScale;
				this._absoluteZ = this._z + this._parent.absoluteZ/Scene_data.mainRelateScale;
			}else{
				this._absoluteX = this._x;
				this._absoluteY = this._y;
				this._absoluteZ = this._z;
			}
			updatePosMatrix();
		}
		
		public function set alpha(value:Number):void{
			_alpha = value;
		}
		
		public function set texture(value:Texture):void{
			_objData.texture = value;
		}
		
		override public function reload():void{
			_context = Scene_data.context3D;
			_program = Program3DManager.getInstance().getProgram(Display3DBoardShader.DISPLAY3DBOARDSHADER);
			_objData.texture=TextureManager.getInstance().bitmapToTexture(basebitmapdata);
			try
			{
				uplodToGpu();
			} 
			catch(error:Error) 
			{
				if(!Scene_data.disposed){
					throw error;
				}
			}
		}
		
		override public function dispose():void{
			_objData.dispose();
		}

		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			_width = value;
		}

		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			_height = value;
		}


	}
}