package _Pan3D.text
{
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Vector3D;

	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Display3DText extends Display3DSprite
	{
		public var vcAry:Vector.<Number>;
		/**
		 * vc状态数组 
		 */		
		public var idStatus:Vector.<Boolean>;
		private var _idleNum:int;
		public var allNum:int;
		public function Display3DText(context:Context3D)
		{
			super(context);
			allNum = 50;
			initData();
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
		
		private function initData():void{
			
			idStatus = new Vector.<Boolean>;
			for(var j:int;j<allNum;j++){
				idStatus.push(true);
			}
			
			vcAry = new Vector.<Number>;
			for(j=0;j<allNum;j++){
				vcAry.push(0,-10000,1,1);
				vcAry.push(0,0,1,1);
			}
			
			idleNum = allNum;
			
			_objData = new ObjData();
			
			var vertices:Vector.<Number> = new Vector.<Number>;
			var uvs:Vector.<Number> = new Vector.<Number>;
			var pos:Vector.<Number> = new Vector.<Number>;
			var indexs:Vector.<uint> = new Vector.<uint>;
			
			for(var i:int;i<allNum;i++){
				vertices.push(
					0, 0, 0.2,
					0, -2, 0.2,
					2, -2, 0.2,
					2, 0, 0.2
				);
				
				var a:Number = 0;
				var flag:int = i*2;
				uvs.push(
					0,0,flag+12,flag+12+1,
					0,1,flag+12,flag+12+1,
					1,1,flag+12,flag+12+1,
					1,0,flag+12,flag+12+1
				);
				indexs.push(i*4,1+i*4,2+i*4,i*4,2+i*4,3+i*4);
			}
			
			_objData.vertices = vertices;
			_objData.uvs = uvs;
			_objData.indexs = indexs;
			
			uplodToGpu();
			
		}
		
		override protected function uplodToGpu():void{
			
			_objData.vertexBuffer = this._context.createVertexBuffer(_objData.vertices.length / 3, 3);
			_objData.vertexBuffer.uploadFromVector(Vector.<Number>(_objData.vertices), 0, _objData.vertices.length / 3);
			
			_objData.uvBuffer = this._context.createVertexBuffer(_objData.uvs.length / 4, 4);
			_objData.uvBuffer.uploadFromVector(Vector.<Number>(_objData.uvs), 0, _objData.uvs.length / 4);
			
			_objData.indexBuffer = this._context.createIndexBuffer(_objData.indexs.length);
			_objData.indexBuffer.uploadFromVector(Vector.<uint>(_objData.indexs), 0, _objData.indexs.length);
			
		}
		
		override protected function setVa():void{
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
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
		private var _vc4:Vector.<Number> = Vector.<Number>( [0,0,200,200]);
		private var _vc5:Vector.<Number> = Vector.<Number>( [10000,10,10,0]);
		private var _vc6:Vector.<Number> = Vector.<Number>( [10000,10,10,0]);
		override protected function setVc():void{
			var sw:Number=1/Scene_data.stageWidth;
			var sh:Number=1/Scene_data.stageHeight;
			
			_vc4[0] = sw;
			_vc4[1] = sh;
			_vc4[2] = 512;
			_vc4[3] = 256;
			
			_vc6[0] = Scene_data.stageWidth/2;
			_vc6[1] = -Scene_data.stageHeight/2;
			_vc6[2] = -Scene_data.focus2D.x/Scene_data.stageWidth*2;
			_vc6[3] = -Scene_data.focus2D.z/Scene_data.stageHeight*2;
			
			
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,_vc4);   //等用
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5 ,_vc5);
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 6 ,_vc6);
			
			var index:int;
			for(var i:int;i<vcAry.length;i+=4){
				index = 12 + int(i/4);
				
				_vc6[0] = vcAry[i];
				_vc6[1] = vcAry[i+1];
				_vc6[2] = vcAry[i+2];
				_vc6[3] = vcAry[i+3];
				
				_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, index , _vc6);
			}
		}
		/**
		 * 请求vc数据 
		 * @param text3D   文本请求对象
		 * @param ary      文本ID数组
		 * @param $digits  文本字符数量
		 * @return 		      是否请求成功
		 * 
		 */		
		/**
		 * 
		 * @param text3D
		 * @return 
		 * 
		 */
		public function requestDisplay(text3D:Text3D):Boolean{
			if(idleNum <= 0){
				return false;
			}
			
			if(objData.texture){
				if(objData.texture != text3D.texture){
					return false;
				}
			}else{
				objData.texture = text3D.texture;
			}
			
			for(var i:int;i<idStatus.length;i++){
				if(idStatus[i]){
					idStatus[i] = false;
					idleNum--;
					text3D.vcId = i;
					text3D.displayTaget = this;
					return true;
				}
			}
			return false;
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
			trace("display3dTest",value);
			_idleNum = value;
			if(_idleNum == 50){
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
			_program = Program3DManager.getInstance().getProgram(Display3DTextShader.Display3DTextShader);
			
		}
		
		override public function dispose():void{
			_objData.dispose();
			_objData = null;
			vcAry.length = 0;
			vcAry = null;
			idStatus.length = 0;
			idStatus = null;
			_vc4 = null;
			_vc5 = null;
			_vc6 = null;
		}
		
		
		
		
		
	}
}