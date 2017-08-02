package _Pan3D.gemo
{
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.Display3DSprite;
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
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Display3DRectangle extends Display3DSprite
	{
		public var vcAry:Vector.<Number>;
		/**
		 * vc状态数组 
		 */		
		public var idStatus:Vector.<Boolean>;
		private var _idleNum:int;
		
//		private var _width:int;
//		private var _height:int;
		private var _bitmapdata:BitmapData;

		private var wNum:int;
		private var hNum:int;

		private var allNum:int;
		
		public var zbuff:Number;
		
		public function Display3DRectangle(context:Context3D)
		{
			super(context);
			_bitmapdata = new BitmapData(16,16,true,0);
//			_bitmapdata.setPixel32(1,0,0xff00ff00);
//			_bitmapdata.setPixel32(2,0,0x660000ff);
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
			if(hasNew){
				_objData.texture = TextureManager.getInstance().bitmapToTexture(_bitmapdata);
				hasNew = false;
			}
				
		}
		
		public function initData($depth:Number):void{
			allNum = 120;
			zbuff =$depth;
			
			idStatus = new Vector.<Boolean>;
			for(var j:int;j<allNum;j++){
				idStatus.push(true);
			}
			
			vcAry = new Vector.<Number>;
			for(j=0;j<allNum;j++){
				vcAry.push(1,1,1,-2000);//w h x y
			}
			
			_idleNum = allNum;
			
			_objData = new ObjData();
			
			var vertices:Vector.<Number> = new Vector.<Number>;
			var uvs:Vector.<Number> = new Vector.<Number>;
			var indexs:Vector.<uint> = new Vector.<uint>;
			
			for(var i:int;i<allNum;i++){
				vertices.push(
					0, 0, zbuff,
					0, -2, zbuff, 
					2, -2, zbuff, 
					2, 0, zbuff
				);
				
//				var a:Number = 0;
				var flag:int = i;
				
				var u:Number = 1/16;
				var v:Number = 1/16;
				var h:Number = (i%16)*u;
				var k:Number = int(i/16)*v;
				uvs.push(
					h,k,flag+8,
					h,k+v,flag+8,
					h+u,k+v,flag+8,
					h+u,k,flag+8
				);
				
				indexs.push(i*4,1+i*4,2+i*4,i*4,2+i*4,3+i*4);
			}
			
			_objData.vertices = vertices;
			_objData.uvs = uvs;
			_objData.indexs = indexs;
			
			_objData.texture = TextureManager.getInstance().bitmapToTexture(_bitmapdata);
			
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
		
		override protected function uplodToGpu():void{
			
			_objData.vertexBuffer = this._context.createVertexBuffer(_objData.vertices.length / 3, 3);
			_objData.vertexBuffer.uploadFromVector(Vector.<Number>(_objData.vertices), 0, _objData.vertices.length / 3);
			
			_objData.uvBuffer = this._context.createVertexBuffer(_objData.uvs.length / 3, 3);
			_objData.uvBuffer.uploadFromVector(Vector.<Number>(_objData.uvs), 0, _objData.uvs.length / 3);
			
			_objData.indexBuffer = this._context.createIndexBuffer(_objData.indexs.length);
			_objData.indexBuffer.uploadFromVector(Vector.<uint>(_objData.indexs), 0, _objData.indexs.length);
			
		}
		
		override protected function setVa():void{
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setTextureAt(0, _objData.texture);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(_objData.indexs.length/3);
		}
		
		private var _vcIndex:Vector.<Number> = Vector.<Number>([0,0,0,0]);
		override protected function setVc():void{
			var index:int;
			for(var i:int;i<vcAry.length;i+=4){
				index = 8 + int(i/4);
				
//				var sw:Number=vcAry[i]/Scene_data.stageWidth;
//				var sh:Number=vcAry[i+1]/Scene_data.stageHeight;
//				var tx:Number=-Scene_data.focus2D.x/Scene_data.stageWidth*2+vcAry[i+2]/Scene_data.stageWidth*2
//				var ty:Number=-Scene_data.focus2D.z/Scene_data.stageHeight*2-vcAry[i+3]/Scene_data.stageHeight*2
//				_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,index,Vector.<Number>( [sw,sh,tx,ty]));   //等用
				
				_vcIndex[0] = vcAry[i]/Scene_data.stageWidth;
				_vcIndex[1] = vcAry[i+1]/Scene_data.stageHeight;
				_vcIndex[2] = -Scene_data.focus2D.x/Scene_data.stageWidth*2+vcAry[i+2]/Scene_data.stageWidth*2
				_vcIndex[3] = -Scene_data.focus2D.z/Scene_data.stageHeight*2-vcAry[i+3]/Scene_data.stageHeight*2
				_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,index,_vcIndex);   //等用
				
			}
			
		}
		override protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			_context.setTextureAt(0,null);
		}
		
		public function set texture(value:Texture):void{
			_objData.texture = value;
		}
		
		
		public function requestRectangle(rec3D:Rectangle3D):Boolean{
			if(idleNum <= 0){
				return false;
			}
			
			for(var i:int;i<idStatus.length;i++){
				if(idStatus[i]){
					idStatus[i] = false;
					rec3D.vcId = i;
					idleNum--;
					reUploadTexture(i,rec3D.color32);
					rec3D.displayTaget = this;
					return true;
				}
			}
			
			return false;
		}
		
		private var hasNew:Boolean;
		public function reUploadTexture(num:int,color:uint):void{
			var xpos:int = num%16;
			var ypos:int = num/16;
			_bitmapdata.setPixel32(xpos,ypos,color);
			hasNew = true;
		}

		/**
		 * 空闲数据数量 
		 */
		public function get idleNum():int
		{
			return _idleNum;
		}

		/**
		 * @private
		 */
		public function set idleNum(value:int):void
		{
			//trace(value);
			_idleNum = value;
			if(_idleNum == allNum){
				if(this.parent){
					this.parent.removeChild(this);
				}
			}else{
				if(!this.parent){
					GemoManager.getInstance().addChild(this);
				}
			}
		}
		
		override public function reload():void{
			_context = Scene_data.context3D;
			_program = Program3DManager.getInstance().getProgram(Display3DRectangleShader.DISPLAY3DRECTANGLESHADER);
			uplodToGpu();
			_objData.texture = TextureManager.getInstance().bitmapToTexture(_bitmapdata);
		}
		
		
		
	}
}