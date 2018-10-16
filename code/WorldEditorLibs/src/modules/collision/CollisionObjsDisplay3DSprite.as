package modules.collision
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	
	import _Pan3D.display3D.model.Display3DModelSprite;
	import _Pan3D.program.Program3DManager;
	
	public class CollisionObjsDisplay3DSprite extends Display3DModelSprite
	{

		public function CollisionObjsDisplay3DSprite(context:Context3D)
		{
			super(context);
			
			Program3DManager.getInstance().registe(CollisionObjsDisplay3DShader.COLLISIONOBJSDISPLAY3DSHADER,CollisionObjsDisplay3DShader)
			program=Program3DManager.getInstance().getProgram(CollisionObjsDisplay3DShader.COLLISIONOBJSDISPLAY3DSHADER)
	
		}
		
		
		override protected function setVa() : void {
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
			
		}
		
		override  protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			
		}
		
		override  protected function setVc() : void {
			this.updateMatrix();
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, posMatrix, true);
			var nrm:Vector3D=new Vector3D(1,1,1);
			nrm.normalize();
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([nrm.x,nrm.y,nrm.z,1])); //专门用来存树的通道的
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([2,4,0,0])); //专门用来存树的通道的
		}
	}
}


