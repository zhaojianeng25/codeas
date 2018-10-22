package guiji
{
	import _Pan3D.base.Object3D;
	import _Pan3D.core.MathClass;
	import _Pan3D.lineTri.LineTri3DSprite;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	
	import _Pan3D.particle.locus.Display3DLocusPartilce;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class Line3DArrSprite extends LineTri3DSprite
	{
		protected var beginVector3D:Vector3D=new Vector3D(0,0,-70)
		protected var endVector3D:Vector3D=new Vector3D(0,0,+70)
		public function Line3DArrSprite(context:Context3D)
		{
			super(context);
		}
		override public function setLineData(obj:Object=null):void
		{
			clear();
			var pointeArr:Array=new Array;
			if(obj.guijiLizhiVO){
				beginVector3D=Display3DLocusPartilce(obj.guijiLizhiVO).beginVector3D
				endVector3D=Display3DLocusPartilce(obj.guijiLizhiVO).endVector3D
			}
		
			if(obj.PointArr){
				for(var i:int=0;i<obj.PointArr.length;i++)
				{
					var object3D:Object3D=obj.PointArr[i];
					pointeArr.push(new Vector3D(object3D.x,object3D.y,object3D.z))
				}
				drawLinkLine(obj.PointArr);
				uplodToGpu();
			}
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
		protected function drawLinkLine(arr:Array):void
		{

			for(var i:int=0;i<arr.length;i++)
			{
				
				var c:Object3D=Object3D(arr[i]);
				var backA:Vector3D=MathClass.math_change_point(beginVector3D,c.angle_x,c.angle_y,c.angle_z);
				var backB:Vector3D=MathClass.math_change_point(endVector3D,c.angle_x,c.angle_y,c.angle_z);
				var s:Vector3D=new Vector3D(backA.x+c.x,backA.y+c.y,backA.z+c.z)
				var e:Vector3D=new Vector3D(backB.x+c.x,backB.y+c.y,backB.z+c.z)
		

				makeLineMode(new Vector3D(c.x,c.y,c.z),s,1,new Vector3D(0,0.8,0.2,1))
				makeLineMode(new Vector3D(c.x,c.y,c.z),e,1,new Vector3D(0,0.8,0.2,1))
			}
		}
	}
}