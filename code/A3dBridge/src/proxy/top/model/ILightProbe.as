package proxy.top.model
{
	import light.LightProbeStaticMesh;
	
	import proxy.pan3d.light.ProxyPan3DTempLightProbe;

	public interface ILightProbe extends IModel
	{
		 function set lightProbeMesh(value:LightProbeStaticMesh):void
		 function get lightProbeTempItem():Vector.<ProxyPan3DTempLightProbe>
	
	}
}