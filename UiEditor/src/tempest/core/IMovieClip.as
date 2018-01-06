package tempest.core
{
	import flash.display.Scene;

	/**
	 *
	 * @author wushangkun
	 */
	public interface IMovieClip
	{
		/**
		 * 指定播放头在 MovieClip 实例的时间轴中所处的帧的编号。
		 * @return
		 */
		function get currentFrame():int;
		/**
		 * 在 MovieClip 实例的时间轴中播放头所在的当前标签。
		 * @return
		 */
		function get currentLabel():String;
		/**
		 * 返回由当前场景的 FrameLabel 对象组成的数组。
		 * @return
		 */
		function get currentLabels():Array;
		/**
		 * 在 MovieClip 实例的时间轴中播放头所在的当前场景。
		 * @return
		 */
		function get currentScene():Scene;
		/**
		 * 一个布尔值，指示影片剪辑是否处于活动状态。
		 * @return
		 */
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
		/**
		 * 从流式 SWF 文件加载的帧数。
		 * @return
		 */
		function get framesLoaded():int;
		/**
		 * 一个由 Scene 对象组成的数组，每个对象都列出了 MovieClip 实例中场景的名称、帧数和帧标签。
		 * @return
		 */
		function get scenes():Array;
		/**
		 * MovieClip 实例中帧的总数。
		 * @return
		 */
		function get totalFrames():int;
		/**
		 * 指示属于 SimpleButton 或 MovieClip 对象的其它显示对象是否可以接收鼠标释放事件。
		 * @return
		 */
		function get trackAsMenu():Boolean;
		/**
		 * 从指定帧开始播放 SWF 文件。
		 * @param frame
		 * @param scene
		 */
		function gotoAndPlay(frame:Object, scene:String = null):void;
		/**
		 * 将播放头移到影片剪辑的指定帧并停在那里。
		 * @param frame
		 * @param scene
		 */
		function gotoAndStop(frame:Object, scene:String = null):void
		/**
		 * 将播放头转到下一帧并停止。
		 */
		function nextFrame():void;
		/**
		 * 将播放头移动到 MovieClip 实例的下一场景。
		 */
		function nextScene():void;
		/**
		 * 在影片剪辑的时间轴中移动播放头。
		 */
		function play():void;
		/**
		 * 将播放头转到前一帧并停止。
		 */
		function prevFrame():void;
		/**
		 * 将播放头移动到 MovieClip 实例的前一场景。
		 */
		function prevScene():void;
		/**
		 * 停止影片剪辑中的播放头。
		 */
		function stop():void;
		/**
		 * 添加帧回调
		 * @param args
		 */
		function addFrameScript(... args):void;
	}
}
