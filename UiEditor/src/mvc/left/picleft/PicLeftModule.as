
package mvc.left.picleft
{
	import com.zcp.frame.Module;
	
	public class PicLeftModule extends Module
	{
		public function PicLeftModule()
		{
			super();
		}
		override protected function listProcessors():Array
		{
			return [
				new PicLeftProcessor(this),
			]
		}
	}
}


