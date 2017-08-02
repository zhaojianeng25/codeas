package _Pan3D.shadow.dynamicShadow
{
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	
	public class Display3DynamicShadow extends Display3DSprite
	{
		
		public static var npcShadowText:Texture
		public static var shadowCamMatrix:Matrix3D;
		public function Display3DynamicShadow(context:Context3D)
		{
			super(context);
		}
		override public function set url(value : String) : void {
			resetSize()
		}
		public function  resetSize():void
		{
			_objData=new ObjData;
			var $w:Number=Scene_data.stage.stageWidth;
			var $h:Number=Scene_data.stage.stageHeight;
			
			var a:Vector3D=new Vector3D(-($h),0, -($w/2));
			var b:Vector3D=new Vector3D(+($h),0, +($w/2));
			var P0:Vector3D=new Vector3D(a.x, a.y, a.z);
			var P1:Vector3D=new Vector3D(a.x, b.y, b.z);
			var P2:Vector3D=new Vector3D(b.x, b.y, b.z);
			var P3:Vector3D=new Vector3D(b.x, a.y, a.z);
			var m:Matrix3D=new Matrix3D;
			m.appendRotation(45,Vector3D.Y_AXIS)
			P0=m.transformVector(P0)
			P1=m.transformVector(P1)
			P2=m.transformVector(P2)
			P3=m.transformVector(P3)
			
			var v : Array=
				[P0.x,P0.y,P0.z,
					P1.x,P1.y,P1.z, 
					P2.x,P2.y,P2.z, 
					P3.x,P3.y,P3.z];
			
			var u : Array=
				[0, 0,
					0, 1,  
					1, 1,  
					1, 0];
			var k : Array = [0, 2, 3, 0, 1, 2];
			
			_objData.vertices=new Vector.<Number>;
			var id:uint=0;
			for(id=0;id<v.length;id++){
				_objData.vertices.push(v[id])
			}
			_objData.uvs=new Vector.<Number>;
			for(id=0;id<u.length;id++){
				_objData.uvs.push(u[id])
			}
			_objData.indexs=new Vector.<uint>;
			for(id=0;id<k.length;id++){
				_objData.indexs.push(k[id])
			}
			try{
				uplodToGpu();	
			} 
			catch(error:Error) {
				if(!Scene_data.disposed){
					//throw error;
				}
			}
		}

		
		override protected function setVc() : void {
			x=Scene_data.focus3D.x
			y=Scene_data.focus3D.y
			z=Scene_data.focus3D.z
			this.updateMatrix();
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelMatrix, true);
			var m:Matrix3D=new Matrix3D
			m.prepend(shadowCamMatrix);
			m.prepend(posMatrix)
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, m, true);
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 12, Vector.<Number>([1/DynamicShadowUtil.shadowDis, -1/DynamicShadowUtil.shadowDis, 0.5, 0.5]));
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([DynamicShadowUtil.shadowColor.x,DynamicShadowUtil.shadowColor.y,DynamicShadowUtil.shadowColor.z,DynamicShadowUtil.shadowColor.w]));
			
		}

		
	    override protected function setVa() : void {
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setTextureAt(1, npcShadowText);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
		}
		override protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			_context.setTextureAt(1,null);
		}
		override public function update() : void {
			if (!this._visible) {
				return;
			}
			if (_objData && npcShadowText) {
				_context.setProgram(this.program);
				setVc();
				setVa();
				resetVa();
				
			}
		}
		override public function reload():void{
			return;
			_context = Scene_data.context3D;
			npcShadowText=_context.createTexture(2048,2048, Context3DTextureFormat.BGRA,true);
			_program = Program3DManager.getInstance().getProgram(Display3DynamicShadowShader.DISPLAY3D_YNAMIC_SHADOW_SHADER);
			uplodToGpu();
			
		}
	}
}