package _Pan3D.display3D
{
	import _me.Scene_data;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	
	public class Display3DNormalSprite extends Display3DSprite
	{
		public function Display3DNormalSprite(context:Context3D)
		{
			super(context);
		}
		override protected function setVa():void{
			_context.setVertexBufferAt(0,_objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1,_objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context.setVertexBufferAt(2,_objData.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setTextureAt(1,_objData.texture);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(_objData.indexs.length/3);
		}
		override protected function resetVa():void{
			_context.setVertexBufferAt(0,null);
			_context.setVertexBufferAt(1,null);
			_context.setVertexBufferAt(2,null);
			_context.setTextureAt(1,null);
		}
		private var xx:Number = 0;
		override protected function setVc():void{
			this.updateMatrix();
			xx += 0.01;
			var angle:Vector3D = new Vector3D(0,1,-1.732,0);
			angle.normalize();
			
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelMatrix, true);
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>([angle.x,angle.y,angle.z,angle.w]));
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,1,Vector.<Number>( [Scene_data.radd,Scene_data.gadd,Scene_data.badd,0.5 ]));
		}
	}
}