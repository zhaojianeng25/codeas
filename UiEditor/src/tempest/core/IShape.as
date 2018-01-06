package tempest.core
{
	import flash.display.Graphics;

	public interface IShape
	{
		/**
		 * 指定属于该 Shape 对象的 Graphics 对象，可通过此对象执行矢量绘画命令。
		 * @return
		 */
		function get graphics():Graphics;
	}
}
