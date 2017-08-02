package _Pan3D.batch
{
	import _Pan3D.particle.ParticleData;
	
	import flash.geom.Matrix3D;

	public interface IBatch
	{
		function getResultMatrix():Matrix3D;
		function getResultUV():Vector.<Number>
		function getColor():Vector.<Number>;
		function get particleData():ParticleData;
	}
}