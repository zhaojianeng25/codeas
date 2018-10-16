package _Pan3D.triPoint
{
	import _Pan3D.base.ObjData;
	import _Pan3D.base.Object3D;
	import _Pan3D.display3D.Display3DSprite;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	
	public class TriPoint3DSprite extends Display3DSprite
	{
		public var thickness:Number=1
		public var clorVector3d:Vector3D=new Vector3D(1,0,0,1)
		public function TriPoint3DSprite(context:Context3D)
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
				_context.setProgram(this.program);
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
			if(obj.PointArr){
				
				for(var i:int=0;i<obj.PointArr.length;i++)
				{
					var object3D:Object3D=obj.PointArr[i];
					makeLineMode(new Vector3D(object3D.x,object3D.y,object3D.z),2)
				}
			}
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
		public function makeLineMode(a:Vector3D,num:Number=0,color:Vector3D=null) : void {
			var w:Number=num;
			var h:Number=num*(1024/600);
			if(num){
				thickness=num
			}
			if(!color){
				color=clorVector3d;
			}
			var indexNum:uint=0;
			if(_objData.vertices){
				indexNum=_objData.indexs.length;
			}else{
				_objData.vertices=new Vector.<Number>
				_objData.uvs=new Vector.<Number>
				_objData.normals=new Vector.<Number>
				_objData.indexs=new Vector.<uint>
			}
			
			_objData.vertices.push(
				a.x, a.y, a.z,
				a.x, a.y, a.z,
				a.x, a.y, a.z,
				
				a.x, a.y, a.z,
				a.x, a.y, a.z,
				a.x, a.y, a.z

			);
			_objData.uvs.push(
				-w,h,0,  -w,-h,0, w,-h,0,
				-w,h,0,  w,-h,0, w,h,0
			);
			
			for(var i:uint=0;i<=5;i++)
			{
				_objData.indexs.push(indexNum+i)
				_objData.normals.push(color.x,color.y,color.z,color.w)  //存放颜色
			}
			
		}
		
		
	}
}