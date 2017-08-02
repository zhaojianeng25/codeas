package _Pan3D.particle.locus
{
	import flash.display3D.VertexBuffer3D;
	
	import _Pan3D.particle.ParticleData;
	
	public class GpuLocusData extends ParticleData
	{
		public var locusVa0:Vector.<Number>;
		public var locusVa0Buffer:VertexBuffer3D;

		public function GpuLocusData()
		{
			super();
		}
		override public function dispose():void{
			super.dispose();
			if(locusVa0Buffer){
				locusVa0Buffer.dispose();
			}
			if(locusVa0){
				locusVa0.length = 0;
				locusVa0 = null;
			}
		}
		
		override public function unload():void{
			super.unload();
			if(locusVa0Buffer){
				locusVa0Buffer.dispose();
			}
		}
	}
}