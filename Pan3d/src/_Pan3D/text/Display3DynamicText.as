package _Pan3D.text
{
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.load.LoadManager;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.utils.TickTime;
	
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
	 * 2d图片文字显示类
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Display3DynamicText extends Display3DSprite
	{
		public var vcAry:Vector.<Number>;
		/**
		 * vc状态数组 
		 */		
		public var idStatus:Vector.<Boolean>;
		private var _idleNum:int;
		
		private var _width:int;
		private var _height:int;
		private var _zbuff:Number;
		private var _bitmapdata:BitmapData;

		private var wNum:int;

		private var hNum:int;

		public var allNum:int;
		
		public function Display3DynamicText(context:Context3D)
		{
			super(context);
			//initData();
			_bitmapdata = new BitmapData(512,512,true,0);
			//initData(100,12);
			TickTime.addCallback(uploadBitmap);
		}
		
		public function uploadBitmap():void{
			if(hasNew){
				hasNew = false;
				try
				{
					if(_objData.texture)
						_objData.texture.uploadFromBitmapData(_bitmapdata);// = TextureManager.getInstance().bitmapToTexture(_bitmapdata);
				} 
				catch(error:Error) 
				{
					if(!Scene_data.disposed){
						throw error;
					}
				}
			}	
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
			//uploadBitmap();
//			if(hasNew){
//				hasNew = false;
//				try
//				{
//					if(_objData.texture)
//						_objData.texture.uploadFromBitmapData(_bitmapdata);// = TextureManager.getInstance().bitmapToTexture(_bitmapdata);
//				} 
//				catch(error:Error) 
//				{
//					
//				}
//			}
				
		}
		
		public function initData($width:int,$height:int,$zbuff:Number):void{
			_width = $width;
			_height = $height;
			_zbuff = $zbuff;
			
			
			wNum = 512/_width;
			hNum = 512/_height;
			allNum = wNum*hNum;
			
			if(allNum > 200){
				allNum = 200;
			}
			
			idStatus = new Vector.<Boolean>;
			for(var j:int;j<allNum;j++){
				idStatus.push(true);
			}
			
			vcAry = new Vector.<Number>;
			for(j=0;j<allNum;j++){
				vcAry.push(0,-2000);
			}
			
			if(allNum%2){
				vcAry.push(0,-200);
			}
			
			_idleNum = allNum;
			
			_objData = new ObjData();
			
			var vertices:Vector.<Number> = new Vector.<Number>;
			var uvs:Vector.<Number> = new Vector.<Number>;
			var pos:Vector.<Number> = new Vector.<Number>;
			var indexs:Vector.<uint> = new Vector.<uint>;
			
			for(var i:int;i<allNum;i++){
				vertices.push(
					0, 0, $zbuff,
					0, -2, $zbuff, 
					2, -2, $zbuff, 
					2, 0, $zbuff
				);
				
				var a:Number = 0;
				var flag:int = i/2;
				
				var u:Number = _width/512;
				var v:Number = _height/512;
				var h:Number = (i%wNum)*u;
				var k:Number = int(i/wNum)*v;
				uvs.push(
					h,k,flag+12,
					h,k+v,flag+12,
					h+u,k+v,flag+12,
					h+u,k,flag+12
				);
				flag = i%2;
				if(flag == 0){
					pos.push(
						1,1,0,0,
						1,1,0,0,
						1,1,0,0,
						1,1,0,0
					);
				}if(flag == 1){
					pos.push(
						0,0,1,1,
						0,0,1,1,
						0,0,1,1,
						0,0,1,1
					);
				}
				
				indexs.push(i*4,1+i*4,2+i*4,i*4,2+i*4,3+i*4);
			}
			
			_objData.vertices = vertices;
			_objData.uvs = uvs;
			_objData.normals = pos;
			_objData.indexs = indexs;
			
			_objData.texture = TextureManager.getInstance().bitmapToTexture(_bitmapdata);
			
			try{
				uplodToGpu();
			} 
			catch(error:Error) {
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
			
			_objData.normalsBuffer = this._context.createVertexBuffer(_objData.normals.length / 4, 4);
			_objData.normalsBuffer.uploadFromVector(Vector.<Number>(_objData.normals), 0, _objData.normals.length / 4);
			
			_objData.indexBuffer = this._context.createIndexBuffer(_objData.indexs.length);
			_objData.indexBuffer.uploadFromVector(Vector.<uint>(_objData.indexs), 0, _objData.indexs.length);
			
		}
		
		override protected function setVa():void{
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(2, _objData.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context.setTextureAt(0, _objData.texture);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(_objData.indexs.length/3);
		}
		private var _vc4:Vector.<Number> = Vector.<Number>( [0,0,200,200]);
		private var _vc5:Vector.<Number> = Vector.<Number>( [10000,10,10,0]);
		private var _vc6:Vector.<Number> = Vector.<Number>( [10000,10,10,0]);
		override protected function setVc():void{
			var sw:Number=_width/Scene_data.stageWidth;
			var sh:Number=_height/Scene_data.stageHeight;
			//var tx:Number=-1+200/Scene_data.stageWidth*2;
			//var ty:Number=1-200/Scene_data.stageHeight*2;
			
			_vc4[0] = sw;
			_vc4[1] = sh;
			
			_vc6[0] = Scene_data.stageWidth/2;
			_vc6[1] = -Scene_data.stageHeight/2;
			_vc6[2] = -Scene_data.focus2D.x/Scene_data.stageWidth*2;
			_vc6[3] = -Scene_data.focus2D.z/Scene_data.stageHeight*2;
			
			
			
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,_vc4);   //等用
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5 ,_vc5);
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 6 ,_vc6);
			
//			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,Vector.<Number>( [sw,sh,200,200]));   //等用
//			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5 , Vector.<Number>([10000,10,10,0]));
//			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 6 , Vector.<Number>([Scene_data.stageWidth/2,-Scene_data.stageHeight/2,
//																									-Scene_data.focus2D.x/Scene_data.stageWidth*2,
//																									-Scene_data.focus2D.z/Scene_data.stageHeight*2]));
			
			
			var index:int;
			for(var i:int;i<vcAry.length;i+=4){
				index = 12 + int(i/4);
				
				_vc6[0] = vcAry[i];
				_vc6[1] = vcAry[i+1];
				_vc6[2] = vcAry[i+2];
				_vc6[3] = vcAry[i+3];
				
//				_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, index , Vector.<Number>([vcAry[i],vcAry[i+1],vcAry[i+2],vcAry[i+3]]));
				_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, index , _vc6);
			}
			
		}
		
		
		
		override protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			_context.setVertexBufferAt(2, null);
			_context.setTextureAt(0,null);
		}
		
		public function set texture(value:Texture):void{
			_objData.texture = value;
		}
		
		
		public function requestDisplay(txt3D:Text3Dynamic):Boolean{
			if(idleNum <= 0){
				return false;
			}else if(txt3D.width != _width || txt3D.height != _height){
				return false;
			}else if(txt3D.zbuff != _zbuff){
				return false;
			}
			
			for(var i:int;i<idStatus.length;i++){
				if(idStatus[i]){
					idStatus[i] = false;
					txt3D.vcId = i;
					idleNum--;
					//reUploadTexture(txt3D.bitmapdata,i);
					txt3D.displayTaget = this;
					return true;
				}
			}
			
			return false;
		}
		private var hasNew:Boolean;
		public function reUploadTexture($source:BitmapData,num:int):void{
			var xpos:int = num%wNum;
			var ypos:int = num/wNum;
			_bitmapdata.copyPixels($source,new Rectangle(0,0,$source.width,$source.height),new Point(xpos*_width,ypos*_height));
			//_objData.texture = TextureManager.getInstance().bitmapToTexture(_bitmapdata);
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
					TextFieldManager.getInstance().addChild(this);
				}
			}
		}
		
		override public function reload():void{
			_context = Scene_data.context3D;
			_program = Program3DManager.getInstance().getProgram(Display3DynamicTextShader.DISPLAY3DYNAMICTEXTSHADER);
			
			uplodToGpu();
			_objData.texture = TextureManager.getInstance().bitmapToTexture(_bitmapdata);
		}
		/**
		 * 深度 
		 * @return 
		 * 
		 */		
		public function get zbuff():Number
		{
			return _zbuff;
		}
		
		override public function dispose():void{
			if(_objData.texture)
				_objData.texture.dispose();
			_objData.dispose();
			_bitmapdata.dispose();
			_objData = null;
			_bitmapdata = null;
			TickTime.removeCallback(uploadBitmap);
		}
		
		
	}
}