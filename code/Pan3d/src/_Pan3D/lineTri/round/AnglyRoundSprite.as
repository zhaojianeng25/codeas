package _Pan3D.lineTri.round
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.Display3DSprite;
	
	import _me.Scene_data;
	
	public class AnglyRoundSprite extends Display3DSprite
	{
		private var _colorVec:Vector3D=new Vector3D(1,1,1,1)
		public function AnglyRoundSprite(context:Context3D)
		{
			super(context);
			initData();
		}
		
		private function initData():void
		{
			_objData=new ObjData;
			_objData.vertices=new Vector.<Number>
			_objData.normals=new Vector.<Number>
			_objData.indexs=new Vector.<uint>
				
				
			addXround()
			addYround()
			addZround()
			
			
			for(var i:uint=0;i<_objData.vertices.length/3;i++){
				_objData.indexs.push(i)
			}
				
			uplodToGpu();
			
		}
		private function addZround():void
		{
			
			var $m:Matrix3D=new Matrix3D	
			var $p:Vector3D=new Vector3D(80,0,0)
			for(var j:uint=0;j<180;j++){
				$m.identity();
				$m.appendRotation(j*2,Vector3D.Z_AXIS);
				var a:Vector3D=$m.transformVector($p)
				$m.identity();
				$m.appendRotation(j*2+2,Vector3D.Z_AXIS);
				var b:Vector3D=$m.transformVector($p)
				pushVector(a,b)
			}
			function pushVector(a:Vector3D,b:Vector3D):void
			{
				var h:Number=2
				_objData.vertices.push(a.x,a.y,a.z-h)
				_objData.vertices.push(b.x,b.y,b.z+h)
				_objData.vertices.push(a.x,a.y,a.z+h)
					
				_objData.vertices.push(a.x,a.y,a.z-h)
				_objData.vertices.push(b.x,b.y,b.z-h)
				_objData.vertices.push(b.x,b.y,b.z+h)
					
					
				_objData.normals.push(0,0,1)
				_objData.normals.push(0,0,1)
				_objData.normals.push(0,0,1)
				_objData.normals.push(0,0,1)
				_objData.normals.push(0,0,1)
				_objData.normals.push(0,0,1)
		
		

		
			}
		}
		private function addXround():void
		{
			
			var $m:Matrix3D=new Matrix3D	
			var $p:Vector3D=new Vector3D(0,0,80)
			for(var j:uint=0;j<180;j++){
				$m.identity();
				$m.appendRotation(j*2,Vector3D.X_AXIS);
				var a:Vector3D=$m.transformVector($p)
				$m.identity();
				$m.appendRotation(j*2+2,Vector3D.X_AXIS);
				var b:Vector3D=$m.transformVector($p)
				pushVector(a,b)
			}
			function pushVector(a:Vector3D,b:Vector3D):void
			{
				var h:Number=2
				_objData.vertices.push(a.x-h,a.y,a.z)
				_objData.vertices.push(b.x+h,b.y,b.z)
				_objData.vertices.push(a.x+h,a.y,a.z)
				_objData.vertices.push(a.x-h,a.y,a.z)
				_objData.vertices.push(b.x-h,b.y,b.z)
				_objData.vertices.push(b.x+h,b.y,b.z)
					
				_objData.normals.push(1,0,0)
				_objData.normals.push(1,0,0)
				_objData.normals.push(1,0,0)
				_objData.normals.push(1,0,0)
				_objData.normals.push(1,0,0)
				_objData.normals.push(1,0,0)
					
			}
		}
		private function addYround():void
		{
			
			var $m:Matrix3D=new Matrix3D	
			var $p:Vector3D=new Vector3D(80,0,0)
			for(var j:uint=0;j<180;j++){
				$m.identity();
				$m.appendRotation(j*2,Vector3D.Y_AXIS);
				var a:Vector3D=$m.transformVector($p)
				$m.identity();
				$m.appendRotation(j*2+2,Vector3D.Y_AXIS);
				var b:Vector3D=$m.transformVector($p)
				pushVector(a,b)
			}
			function pushVector(a:Vector3D,b:Vector3D):void
			{
				var h:Number=2
				_objData.vertices.push(a.x,a.y+h,a.z)
				_objData.vertices.push(a.x,a.y-h,a.z)
				_objData.vertices.push(b.x,b.y-h,b.z)
				_objData.vertices.push(a.x,a.y+h,a.z)
				_objData.vertices.push(b.x,b.y-h,b.z)
				_objData.vertices.push(b.x,b.y+h,b.z)
					
				_objData.normals.push(0,1,0)
				_objData.normals.push(0,1,0)
				_objData.normals.push(0,1,0)
				_objData.normals.push(0,1,0)
				_objData.normals.push(0,1,0)
				_objData.normals.push(0,1,0)
					
				
			}
		}
		override protected function uplodToGpu() : void {
			_objData.vertexBuffer = this._context.createVertexBuffer(_objData.vertices.length / 3, 3);
			_objData.vertexBuffer.uploadFromVector(Vector.<Number>(_objData.vertices), 0, _objData.vertices.length / 3);
			_objData.normalsBuffer = this._context.createVertexBuffer(_objData.normals.length / 3, 3);
			_objData.normalsBuffer.uploadFromVector(Vector.<Number>(_objData.normals), 0, _objData.normals.length / 3);
			_objData.indexBuffer = this._context.createIndexBuffer(_objData.indexs.length);
			_objData.indexBuffer.uploadFromVector(Vector.<uint>(_objData.indexs), 0, _objData.indexs.length);
		}
		override protected function setVa() : void {
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
		}
		override protected function setVc() : void {
	        super.setVc()
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1,Vector.<Number>([_colorVec.x,_colorVec.y,_colorVec.z,_colorVec.w]));
		}
		override protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
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
		public function set colorVec(value:Vector3D):void
		{
			_colorVec = value;
		}

	}
}


