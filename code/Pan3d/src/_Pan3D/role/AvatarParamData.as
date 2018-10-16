package _Pan3D.role
{
	/**
	 * 某个换装部件 的 基本参数数据
	 * @author zcp
	 */
	public class AvatarParamData
	{
		//基本参数***********************************************
		/**
		 * ID 某角色换装的唯一标识,注意该ID必须唯一
		 */
		public var id:String;
		/**部件类型*/
		public var type:String;
		/**
		 * 换装资源绝对地址
		 */
		public var source:String;

		
//		/**
//		 *是否清空同种类型的换装 	//屏蔽此属性,  现在的规则是 只要部位相同, 必然顶掉
//		 **/
//		public var clearSameType:Boolean = false;

		
		/**类型（是装备0 还是特效1）*/
		public var showType:int;
		/**
		 * 循环类型（针对粒子）1表示播放完成后移除
		 */		
		public var repeatType:int;
		/**
		 *  （针对粒子）播放完成后的回调函数
		 */		
		public var playCompleteFun:Function;
		/**
		 * 对应的换装资源是否加载完成 
		 */		
		public var complete:Boolean;
		/**
		 * 装备等级 控制绑定的粒子效果 
		 */		
		public var level:int;
		/**
		 * 控制二级粒子的绑定效果 
		 */		
		public var secondLevel:int;
		
		/**
		 * @parm $id 换装ID
		 * @parm $type 换装类型
		 * @parm $source 换装资源绝对地址
		 * */
		public function AvatarParamData($id:String=null, $type:String=null, $source:String=null, $clearSameType:Boolean=false)
		{
			id = $id;
			type = $type;
			source = $source;
//			clearSameType = $clearSameType;
		}
		
		
		/**
		 * 创建一个副本
		 * 注意：ID也将被复制
		 */
		public function clone():AvatarParamData
		{
			var apd:AvatarParamData = new AvatarParamData(id,type,source);
//			apd.clearSameType = clearSameType;
			apd.showType = showType;
			apd.level = level;
			return apd;
		}
		
		/**
		 * 检测是否相等
		 */
		public function equals($toCompare:AvatarParamData):Boolean
		{
			return id == $toCompare.id
				&&type == $toCompare.type
				&&source==$toCompare.source
//				&&clearSameType == $toCompare.clearSameType
				&&showType==$toCompare.showType
		}
	}
}