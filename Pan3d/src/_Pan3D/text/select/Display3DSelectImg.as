package _Pan3D.text.select
{
	import _Pan3D.base.MakeModelData;
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.program.shaders.StatShader;
	import _Pan3D.text.Text3Dynamic;
	import _Pan3D.texture.TextureManager;
	
	import _me.Scene_data;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	/**
	 * 场景区域图块 
	 * @author zcp
	 */	
	public class Display3DSelectImg extends Display3DSprite
	{
		/**位图数据源*/
		private var _bitmapData:BitmapData;
		
		//宽
		private var _width:Number=0;
		//高
		private var _height:Number=0;
		
		private var _souce:Text3Dynamic;
		
		public var zbuff:Number = 1;
		
		public function Display3DSelectImg($context:Context3D){
			super($context);
			_objData=MakeModelData.makeJuXinTampData(new Vector3D(0,0,0.999),new Vector3D(2,-2,0.999));
		}
		/**
		 * 设置数据源 
		 * @param $bd
		 * 
		 */		
		public function set bitmapData($bd:BitmapData):void
		{
			_bitmapData = $bd;
			
			if(_bitmapData!=null)
			{
				_objData.texture=TextureManager.getInstance().bitmapToTexture(_bitmapData);
				_width=_bitmapData.width;
				_height=_bitmapData.height;
			}
			else
			{
				_objData.texture=null;
				_width=0;
				_height=0;
			}
			try{
				uplodToGpu();
			} 
			catch(error:Error) {
				if(!Scene_data.disposed){
					throw error;
				}
			}
		}
		
		public function refresh(txt:Text3Dynamic):void{
			_souce = txt;
			var sourceBitmapdata:BitmapData = txt.bitmapdata;
			var newBitmapdata:BitmapData = new BitmapData(getMaxNum(sourceBitmapdata.width),getMaxNum(sourceBitmapdata.height),true,0);
			var filter:GlowFilter = new GlowFilter(0xFFFF00,1,7,7,4,1)
			newBitmapdata.applyFilter(txt.bitmapdata,new Rectangle(0,0,sourceBitmapdata.width,sourceBitmapdata.height),new Point(),filter);
			bitmapData = newBitmapdata;
			this.x = txt.x;
			this.y = txt.y;
		}
		
		private function getMaxNum(num:int):int{
			for(var i:int;i<10;i++){
				if(num < Math.pow(2,i)){
					return Math.pow(2,i);
				}
			}
			return 1024;
		}
		/**
		 * 获取数据源 
		 * @param $bd
		 * 
		 */		
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
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
			
			var sw:Number=_width/Scene_data.stageWidth;
			var sh:Number=_height/Scene_data.stageHeight;
			//var tx:Number=-1+(_absoluteX-Scene_data.focus2D.x+Scene_data.stageWidth/2)/Scene_data.stageWidth*2
			var tx:Number= -Scene_data.focus2D.x/Scene_data.stageWidth*2 + _absoluteX/Scene_data.stageWidth*2;
			//var ty:Number=1-(_absoluteY+Scene_data.focus2D.z+Scene_data.stageHeight/2)/Scene_data.stageHeight*2
			var ty:Number=-Scene_data.focus2D.z/Scene_data.stageHeight*2 -_absoluteY/Scene_data.stageHeight*2; 
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,Vector.<Number>( [sw,sh,tx,ty]));   //等用
		}
		
		
		
		override public function reload():void{
			_context = Scene_data.context3D;
			this.bitmapData = _bitmapData;
			this._program = Program3DManager.getInstance().getProgram(Display3DSelectImgShader.DISPLAY3DSELECTIMGSHADER);
		}
		
	}
}