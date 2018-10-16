package _Pan3D.lineTri.box
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.ObjData;
	import _Pan3D.base.ObjectHitBox;
	import _Pan3D.display3D.Display3DSprite;
	
	import _me.Scene_data;
	
	public class BoxSprite extends Display3DSprite
	{
		private var _colorVec:Vector3D=new Vector3D(1,1,1,1)
		public function BoxSprite(context:Context3D)
		{
			super(context);
			refreshGpu()
		}

		public function get colorVec():Vector3D
		{
			return _colorVec;
		}

		public function set colorVec(value:Vector3D):void
		{
			_colorVec = value;
		}

		public function get boxSize():Number
		{
			return _boxSize;
		}

		public function set boxSize(value:Number):void
		{
			_boxSize = value;
			refreshGpu()
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
		override public function updatePosMatrix():void{
			posMatrix.identity();
			posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
			posMatrix.prependScale(this._scale_x,this._scale_y,this._scale_z);
			posMatrix.prependRotation(_rotationX , Vector3D.X_AXIS);
			posMatrix.prependRotation(_rotationY , Vector3D.Y_AXIS);
			posMatrix.prependRotation(_rotationZ , Vector3D.Z_AXIS);
		}
		public function refreshGpu():void
		{
			if(!_objData){
				_objData=new ObjData
			}
			_objData.vertices=new Vector.<Number>;
			_objData.normals=new Vector.<Number>;
			_objData.indexs=new Vector.<uint>
			var _objectHitBox:ObjectHitBox=new ObjectHitBox
			_objectHitBox.beginx=-_boxSize
			_objectHitBox.beginy=-_boxSize
			_objectHitBox.beginz=-_boxSize
			_objectHitBox.endx=_boxSize
			_objectHitBox.endy=_boxSize
			_objectHitBox.endz=_boxSize
			
			makeBoxObj(_objectHitBox);
			for(var i:uint=0;i<_objData.normals.length/3;i++){
				_objData.indexs.push(i)
			}
			uplodToGpu()
		}
		private var _boxSize:Number=3
		private function makeBoxObj(tempHitBox:ObjectHitBox):void
		{
			var allPointItem:Vector.<Vector3D>=new Vector.<Vector3D>
			allPointItem.push(new Vector3D(tempHitBox.beginx,tempHitBox.endy,tempHitBox.beginz));
			allPointItem.push(new Vector3D(tempHitBox.endx,tempHitBox.endy,tempHitBox.beginz));
			allPointItem.push(new Vector3D(tempHitBox.endx,tempHitBox.beginy,tempHitBox.beginz));
			allPointItem.push(new Vector3D(tempHitBox.beginx,tempHitBox.beginy,tempHitBox.beginz));
			
			allPointItem.push(new Vector3D(tempHitBox.beginx,tempHitBox.endy,tempHitBox.endz));
			allPointItem.push(new Vector3D(tempHitBox.endx,tempHitBox.endy,tempHitBox.endz));
			allPointItem.push(new Vector3D(tempHitBox.endx,tempHitBox.beginy,tempHitBox.endz));
			allPointItem.push(new Vector3D(tempHitBox.beginx,tempHitBox.beginy,tempHitBox.endz));
			var triIndex:Array=new Array
			triIndex.push(0,1,3)
			triIndex.push(1,2,3)
			triIndex.push(4,7,5)
			triIndex.push(5,7,6)
			triIndex.push(1,5,2)
			triIndex.push(5,6,2)
			triIndex.push(4,0,7)
			triIndex.push(0,3,7)
			triIndex.push(0,4,1)
			triIndex.push(4,5,1)
			triIndex.push(3,2,7)
			triIndex.push(2,6,7)
		
			_objData.vertices=new Vector.<Number>;
			_objData.normals=new Vector.<Number>;
			_objData.indexs=new Vector.<uint>
			
			for(var i:uint=0;i<triIndex.length/3;i++){
				var a:uint=triIndex[i*3+0]
				var b:uint=triIndex[i*3+1]
				var c:uint=triIndex[i*3+2]

				_objData.vertices.push(allPointItem[a].x,allPointItem[a].y,allPointItem[a].z)
				_objData.vertices.push(allPointItem[b].x,allPointItem[b].y,allPointItem[b].z)
				_objData.vertices.push(allPointItem[c].x,allPointItem[c].y,allPointItem[c].z)
				
				_objData.normals.push(1,1,1)
				_objData.normals.push(1,1,1)
				_objData.normals.push(1,1,1)
				
			}

				
		}
		override protected function setVc() : void {
			this.updateMatrix();
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelMatrix, true);
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,8,Vector.<Number>( [0,0,0,1]));   //等用
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,10,Vector.<Number>( [100,0,1024,0]));   //等用
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0,Vector.<Number>([1,0,0,1]));
			
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1,Vector.<Number>([_colorVec.x,_colorVec.y,_colorVec.z,_colorVec.w]));
			
			
		}
		override  protected function setVa() : void {
			
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(_objData.indexs.length/3);
		}

		override protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
		}
		
		override  protected function uplodToGpu() : void {
			_objData.vertexBuffer = this._context.createVertexBuffer(_objData.vertices.length / 3, 3);
			_objData.vertexBuffer.uploadFromVector(Vector.<Number>(_objData.vertices), 0, _objData.vertices.length / 3);

			_objData.normalsBuffer = this._context.createVertexBuffer(_objData.normals.length / 3, 3);
			_objData.normalsBuffer.uploadFromVector(Vector.<Number>(_objData.normals), 0, _objData.normals.length / 3);
			
			
			_objData.indexBuffer = this._context.createIndexBuffer(_objData.indexs.length);
			_objData.indexBuffer.uploadFromVector(Vector.<uint>(_objData.indexs), 0, _objData.indexs.length);
		}

	}
}