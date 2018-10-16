package  _Pan3D.particle.ball
{
	import _Pan3D.base.ObjData;
	import _Pan3D.particle.ParticleData;
	
	import flash.display.BitmapData;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class GpuTuoQiuData extends ParticleData
	{
		public var vcIndexs:Vector.<uint>;
		public var vcIndexBuffer:VertexBuffer3D;
		public var basePos:Vector.<Number>;
		public var basePosBuffer:VertexBuffer3D
		public var beMove:Vector.<Number>;
		public var beMoveBuffer:VertexBuffer3D
		public var baseRotation:Vector.<Number>;
		public var baseRotationBuffer:VertexBuffer3D;
		public var toPos:Vector.<Number>;
		public var toPosBuffer:VertexBuffer3D
		public var rootPos:Vector.<Number>;
		public var rootPosBuffer:VertexBuffer3D
//		public var randomColor:Vector.<Number>;
//		public var randomColorBuffer:VertexBuffer3D
		//public var colorTexture:Texture;
		//public var bmpRandomColor:BitmapData;
		//public var bmpJbColor:BitmapData;
		

		
		public function GpuTuoQiuData()
		{
			super();
		}
		override public function dispose():void{
			super.dispose();
			if(vcIndexBuffer)
				vcIndexBuffer.dispose();
			if(basePosBuffer)
				basePosBuffer.dispose();
			if(beMoveBuffer)
				beMoveBuffer.dispose();
			if(toPosBuffer)
				toPosBuffer.dispose();
			if(rootPosBuffer)
				rootPosBuffer.dispose();

			
			if(vcIndexs){
				vcIndexs.length = 0;
				vcIndexs = null;
			}
			if(basePos){
				basePos.length = 0;
				basePos = null;
			}
			if(beMove){
				beMove.length = 0;
				beMove = null;
			}
			
			if(toPos){
				toPos.length = 0;
				toPos = null;
			}
			
			if(rootPos){
				rootPos.length = 0;
				rootPos = null;
			}
	
			
		}
		
		override public function unload():void{
			super.unload();
			
			if(vcIndexBuffer)
				vcIndexBuffer.dispose();
			if(basePosBuffer)
				basePosBuffer.dispose();
			if(beMoveBuffer)
				beMoveBuffer.dispose();
			if(toPosBuffer)
				toPosBuffer.dispose();
			if(rootPosBuffer)
				rootPosBuffer.dispose();

		}
		
		
	}
}