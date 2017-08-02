package com.zcp._special.cd
{
	import com.zcp.pool.Pool;
	import com.zcp.timer.TimerHelper;
	
	import flash.events.Event;

	/**
	 * CDFace管理器
	 * @author zcp
	 * 
	 */	
	public class CDFaceManager
	{
		/**
		 * @private
		 * 所有需要监测并展示CD效果的itemFace集合
		 */
		private static var itemFaces:Array = [];
		/**
		 * @private
		 * 所有最顶层控制CD进度的的CDFace的集合 
		 */
		private static var parentCDFaces:Array = [];
		/**
		 * @private
		 * CDFace池
		 */
		private static var cdFacePool:Pool = new Pool("CDFaceManager.cdFacePool",100);

		
		public function CDFaceManager()
		{
			throw new Event("静态类");
		}
		/**
		 * 注册一个ItemFace
		 * @param $itemFace
		 */
		public static function registerItemFace($itemFace:ICoolingItemFace):void
		{
			if(itemFaces.indexOf($itemFace)!=-1)return;
			//添加进管理器数组
			itemFaces.push($itemFace);
			//更新此ItemFace的冷却效果
			updateItemFaceCooling($itemFace);
		}
		/**
		 * 移除一个ItemFace的注册
		 * @param $itemFace
		 */
		public static function removeItemFace($itemFace:ICoolingItemFace):void
		{
			var index:int = itemFaces.indexOf($itemFace);
			if(index!=-1)
			{
				//从管理器数组中移除
				itemFaces.splice(index,1);
				//从CDFace树中移除
				var cdFace:CDFace = $itemFace.getCDFace(false);
				if(cdFace!=null)
				{
					var parentCDFace:CDFace = cdFace.parentCDFace;
					if(parentCDFace!=null)
					{
						parentCDFace.removeBindingChild(cdFace, false);
					}
				}
			}
		}
		/**
		 * 查看指定ID的CD是否处于冷却中
		 * @param $itemID 道具或技能ID 此函数没有判断公共冷却啊111111111111
		 **/	
		public static function isCooling($itemID:*):Boolean 
		{
			var parentCDFace:CDFace;
			for each(parentCDFace in parentCDFaces)
			{
				if(parentCDFace.isPublic==false && parentCDFace.coolingID==$itemID)
				{
					if(parentCDFace.getLosttime()>0)return true;
					else return false;
				}
			}
			return false;
		}
		
		/**
		 * 播放指定ID的CD效果
		 * 说明：当场景中某个itemID的道具或技能发生CD数据发生变化时需要调度此函数
		 * @param $itemID 冷却ID
		 * @param $CD CD时长（单位：毫秒）
		 * @param $nowCD CD当前播放到的位置（单位：毫秒）
		 * @param $plulicCD 公共CD时长（单位：毫秒）
		 * @param $plulicNowCD 公共CD当前播放到的位置（单位：毫秒）
		 * @param $publicIncidence 公共CD影响"类型"数组（[]、null不匹配任何）
		 **/	
		public static function cdPlay($itemID:*,$CD:Number, $nowCD:Number, 
									  $plulicCD:Number=0,$plulicNowCD:Number=0,$publicIncidence:Array=null):void {
			
			//毫秒 --> 秒
			$CD /= 1000;
			$nowCD /= 1000;
			$plulicCD /= 1000;
			$plulicNowCD /= 1000;
			
			//生成根CDFace
			//===========================================================
			var parent:CDFace;
			//私有CDFace
			if($itemID!=null && $CD>0)
			{
				//查找旧的
				parent = getParentCDFace(false,$itemID);
				if(parent==null)
				{
					parent = cdFacePool.createObj(CDFace,1,1,cdComplete) as CDFace;
					parent.isPublic = false;
					parent.coolingID = $itemID;
					
					//添加进数组
					parentCDFaces.push(parent);
				}
				//更新CD
				parent.play($CD, $nowCD);
			}
			//公有CDFace
			if($publicIncidence && $publicIncidence.length>0 && $plulicCD>0)
			{
				for each(var coolingID:* in $publicIncidence)
				{
					//查找旧的
					parent = getParentCDFace(true,coolingID);
					if(parent==null)
					{
						parent = cdFacePool.createObj(CDFace,1,1,cdComplete) as CDFace;
						parent.isPublic = true;
						parent.coolingID = coolingID;
						
						//添加进数组
						parentCDFaces.push(parent);
					}
					//更新CD
					if(parent.getLosttime()<$plulicCD-$plulicNowCD)//注意这个判断
					{
						parent.play($plulicCD, $plulicNowCD);
					}
				}
			}
			//===========================================================
			
			//更新每一个子CDFace
			//===========================================================
			for each(var itemFace:ICoolingItemFace in itemFaces)
			{
				updateItemFaceCooling(itemFace);
			}
			//===========================================================
		}
		/**
		 * 清除指定ID的CD效果（ 暂不支持清除公共冷却ID; 暂未对该冷却CD的CDFace还原）
		 * @param $itemID 冷却ID
		 **/	
		public static function cdClear($itemID:*):void {
			if($itemID==null)return;
			
			var len:int = parentCDFaces.length;
			while(len-->0)
			{
				var parentCDFace:CDFace = parentCDFaces[len];
				if(parentCDFace.isPublic==false && parentCDFace.coolingID==$itemID)
				{
					//回收移除
					cdComplete(parentCDFace);
					break;
				}
			}
		}
		/**
		 * 获取绑定根CDFace
		 * @param $isPublic 是否是公共冷却
		 * @param $coolingID 冷却ID
		 **/	
		private static function getParentCDFace($isPublic:Boolean, $coolingID:*):CDFace {
			
			var len:int = parentCDFaces.length;
			while(len-->0)
			{
				var parentCDFace:CDFace = parentCDFaces[len];
				if(parentCDFace.isPublic==$isPublic && parentCDFace.coolingID==$coolingID)
				{
					return parentCDFace;
				}
			}
			return null;
		}
		/**
		 * 更新单个ItemFace的冷却效果
		 **/	
		private static function updateItemFaceCooling($itemFace:ICoolingItemFace):void {
			
			//获取标识ID
			var itemCDFace:CDFace = $itemFace.getCDFace(true);
			var itemVo:ICoolingItemVo = $itemFace.getCoolingItemVo();
			var itemCoolingID:* = itemVo.getCoolingID();
			var itemPublicCoolingID:* = itemVo.getPublicCoolingTimeType();
			
			//更新绑定
			//查找此子ItemFace应该绑定到哪个根
			var tempParent:CDFace = itemCDFace.parentCDFace;
			for each(var parent:CDFace in parentCDFaces)
			{
				if(parent.isPublic)//公共
				{
					if(parent.coolingID == itemPublicCoolingID)//冷却ID相同
					{
						if(tempParent==null)
						{
							tempParent = parent;
						}
						else if(tempParent.getLosttime()<parent.getLosttime())//小于或小于等于，，在等于的情况下tempParent可能与parent为同一个对象 11111111111111
						{
							tempParent = parent;
						}
					}
				}
				else//私有
				{
					if(parent.coolingID == itemCoolingID)//冷却ID相同
					{
						if(tempParent==null)
						{
							tempParent = parent;
						}
						else if(tempParent.getLosttime()<parent.getLosttime())//小于或小于等于，，在等于的情况下tempParent可能与parent为同一个对象 11111111111111
						{
							tempParent = parent;
						}
					}
				}
			}
			//更新绑定
			if(tempParent!=null && tempParent!=itemCDFace.parentCDFace)
			{
				tempParent.addBindingChild(itemCDFace, false);
			}
				
		}
		/**
		 * @ private
		 * 一个CDFace播放完毕回调
		 */
		private static function cdComplete($baceCDFace:CDFace):void
		{
			var index:int = parentCDFaces.indexOf($baceCDFace);
			if(index!=-1)
			{
				parentCDFaces.splice(index,1);
			}
			cdFacePool.disposeObj($baceCDFace);
		}
	}
}