package _Pan3D.lineTri
{
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.Display3DSprite;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class LineTri3DSprite extends Display3DSprite
	{
        public var thickness:Number=1
        public var colorVector3d:Vector3D=new Vector3D(1,0,0,1)
		public function LineTri3DSprite(context:Context3D)
		{
			super(context);
		}
		override protected function setVc() : void {
			this.updateMatrix();
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelMatrix, true);
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,10,Vector.<Number>( [100,0,1024,0]));   //等用
			}
		override protected function setVa() : void {
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(2, _objData.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(_objData.indexs.length/3);
		}
		override public function updataPos():void{
			if(this._parent){
				this._absoluteX = this._x + this._parent.absoluteX;
				this._absoluteY = this._y + this._parent.absoluteY;
				this._absoluteZ = this._z + this._parent.absoluteZ;
			}else{
				this._absoluteX = this._x
				this._absoluteY = this._y
				this._absoluteZ = this._z
			}
			updatePosMatrix();
		}
		override protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			_context.setVertexBufferAt(2, null);
		}

		override public function update() : void {
			if (!this._visible) {
				return;
			}
			if (_objData && _objData.indexBuffer) {
				
				_context.setProgram(this._program);
				setVc();
				setVa();
				resetVa();
			}
		}
		override public function set url(value : String) : void {
		}
		public function setLineData(obj:Object=null):void
		{
			clear();
			var a:Vector3D=new Vector3D(0,0,0);
			var b:Vector3D=new Vector3D(100,0,0);
			var c:Vector3D=new Vector3D(100,100,100);
			makeLineMode(a,b,1)
			makeLineMode(b,c,1)
			uplodToGpu();
		}
		public function clear():void
		{
			if(_objData){
				_objData.vertexBuffer=null;
				_objData.uvBuffer=null;
				_objData.indexBuffer=null;
			}
			_objData=new ObjData;
		}
		public function refreshGpu():void
		{
			uplodToGpu()
		}
		override public function resetStage():void
		{
			_context=Scene_data.context3D
			if(_objData&&_objData.vertices){
				uplodToGpu()
			}
		}
		override protected function uplodToGpu() : void {
			
			_objData.vertexBuffer = this._context.createVertexBuffer(_objData.vertices.length / 3, 3);
			_objData.vertexBuffer.uploadFromVector(Vector.<Number>(_objData.vertices), 0, _objData.vertices.length / 3);
			
			_objData.uvBuffer = this._context.createVertexBuffer(_objData.uvs.length / 3, 3);
			_objData.uvBuffer.uploadFromVector(Vector.<Number>(_objData.uvs), 0, _objData.uvs.length / 3);
			
			_objData.normalsBuffer = this._context.createVertexBuffer(_objData.normals.length / 4, 4);
			_objData.normalsBuffer.uploadFromVector(Vector.<Number>(_objData.normals), 0, _objData.normals.length /4);
			
			_objData.indexBuffer = this._context.createIndexBuffer(_objData.indexs.length);
			_objData.indexBuffer.uploadFromVector(Vector.<uint>(_objData.indexs), 0, _objData.indexs.length);
		}
		public static var thickNessScale:Number=0.5
	    public function makeLineMode(a:Vector3D,b:Vector3D,num:Number=0,color:Vector3D=null,fuck:Boolean=true) : void {
			if(num){
				thickness=num
			}
			if(!color){
				color=colorVector3d;
			}
		    var indexNum:uint=0;
			var i:uint;
			if(_objData.vertices){
				indexNum=_objData.indexs.length;
			}else{
				_objData.vertices=new Vector.<Number>
				_objData.uvs=new Vector.<Number>
				_objData.normals=new Vector.<Number>
				_objData.indexs=new Vector.<uint>
			}
			if(fuck){
				//高质量的线
				_objData.vertices.push(
					a.x, a.y, a.z,
					a.x, a.y, a.z,
					b.x, b.y, b.z,
					
					a.x, a.y, a.z,
					b.x, b.y, b.z,
					b.x, b.y, b.z,
					
					a.x, a.y, a.z,
					a.x, a.y, a.z,
					b.x, b.y, b.z,
					
					a.x, a.y, a.z,
					b.x, b.y, b.z,
					b.x, b.y, b.z,
					
					a.x, a.y, a.z,
					a.x, a.y, a.z,
					b.x, b.y, b.z,
					
					a.x, a.y, a.z,
					b.x, b.y, b.z,
					b.x, b.y, b.z
				);
				_objData.uvs.push(
					
					thickness*thickNessScale,0,0,  -thickness*thickNessScale,0,0,  -thickness*thickNessScale,0,0, 
					thickness*thickNessScale,0,0,  -thickness*thickNessScale,0,0,   thickness*thickNessScale,0,0,
					
					0,thickness*thickNessScale,0,  0,-thickness*thickNessScale,0,  0,-thickness*thickNessScale,0, 
					0,thickness*thickNessScale,0,  0,-thickness*thickNessScale,0,   0,thickness*thickNessScale,0,
					
					0,0,thickness*thickNessScale,  0,0,-thickness*thickNessScale,  0,0,-thickness*thickNessScale, 
					0,0,thickness*thickNessScale,  0,0,-thickness*thickNessScale,   0,0,thickness*thickNessScale
				);
			
				for( i=0;i<=17;i++)
				{
					_objData.indexs.push(indexNum+i)
					_objData.normals.push(color.x,color.y,color.z,color.w)  //存放颜色
				}
			}else{
				_objData.vertices.push(
					a.x, a.y, a.z,
					a.x, a.y, a.z,
					b.x, b.y, b.z
				);
				_objData.uvs.push(
					thickness,0,0,  -thickness,0,0,  -thickness,0,0
				);
				for( i=0;i<3;i++)
				{
					_objData.indexs.push(indexNum+i)
					_objData.normals.push(color.x,color.y,color.z,color.w)  //存放颜色
				}
			}

		}


	}
}