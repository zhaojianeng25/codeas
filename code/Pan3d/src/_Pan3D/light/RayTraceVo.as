package _Pan3D.light
{
	import flash.geom.Vector3D;

	public class RayTraceVo
	{
		public var envImg:String;
		public var useEnvColor:Boolean;
		public var envColor:Vector3D = new Vector3D;
		public var usePbr:Boolean;
		public var useIBL:Boolean;
		public var atlis:Boolean;
		public function RayTraceVo()
		{
		}
	}
}