package proxy.top
{
	import proxy.pan3d.model.ProxyPan3dModel;
	import proxy.pan3d.render.RenderPan3d;
	import proxy.top.model.IModel;
	import proxy.top.render.IRender;
	
	public class TopProxyManager
	{
		public static var type:Boolean = true;     //true a3d, false pan3d
		public function TopProxyManager()
		{
		}
		
		public static function getRenderContext():IRender{
			
				return new RenderPan3d; 
			
		}
		
		public static function getModelTarget($name:String):IModel{
		
				return new ProxyPan3dModel;
			
		}
	}
}