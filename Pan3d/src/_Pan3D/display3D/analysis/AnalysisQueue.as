package _Pan3D.display3D.analysis
{
	import _Pan3D.role.MeshDataManager;
	import _Pan3D.utils.TickTime;
	import _Pan3D.vo.analysis.AnalysisQueueVo;
	
	import _me.Scene_data;

	/**
	 * 队列解析 
	 * @author liuyanfei QQ:421537900
	 * 
	 */
	public class AnalysisQueue
	{
		/**
		 * 队列存储 
		 */		
		private static var queue:Vector.<AnalysisQueueVo> = new Vector.<AnalysisQueueVo>;
		public function AnalysisQueue()
		{
		}
		/**
		 * 添加到队列 
		 * @param queueVo
		 * 
		 */		
		public static function addQueue(queueVo:AnalysisQueueVo):void{
			if(queueVo.priority >= Scene_data.loadPriorityThreshold){
				queueVo.fun(queueVo.data,queueVo.url);
				return;
			}
			
			if(queue.length == 0){
				TickTime.addCallback(analysisIng);
			}
			queue.push(queueVo);
		}
		/**
		 * 队列解析中...
		 * 
		 */		
		private static function analysisIng():void{
			var queueVo:AnalysisQueueVo = queue.shift();
			queueVo.fun(queueVo.data,queueVo.url);
			if(queue.length == 0){
				TickTime.removeCallback(analysisIng);
				AnalysisServer.getInstance().dispose();
			}
		}
	}
}