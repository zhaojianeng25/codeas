package proxy.top.model
{
	import light.LightProbeTempStaticMesh;
	
	import proxy.pan3d.light.ProxyPan3DLightProbe;

	public interface ITempLightProbe extends IModel
	{
		 function get perentModel():ProxyPan3DLightProbe
		 function get lightProbeTempStaticMesh():LightProbeTempStaticMesh
		 function set lightProbeTempStaticMesh(value:LightProbeTempStaticMesh):void
	}
}