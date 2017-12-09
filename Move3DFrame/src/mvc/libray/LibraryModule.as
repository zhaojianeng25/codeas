package mvc.libray
{
	import com.zcp.frame.Module;
	
	public class LibraryModule extends Module
	{
		public function LibraryModule()
		{
			super();
		}
		override protected function listProcessors():Array
		{
			return [
				new LibraryProcessor(this),
			]
		}
	}
}