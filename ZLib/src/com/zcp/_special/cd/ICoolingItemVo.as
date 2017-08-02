package com.zcp._special.cd
{
	/**
	 * 道具或技能VO类接口
	 * @author zcp
	 * 
	 */	
	public interface ICoolingItemVo
	{
		/**获取冷却ItemID*/
		function getCoolingID():*;
		/**获取冷却Item类型*/
		function getCoolingType():int;
		
		/**获取固有冷却时间（注意：技能的CD时间和公共冷却时间不同,道具的相同）*/
		function getCoolingTime():int;
		/**获取固有公共冷却时间*/
		function getPublicCoolingTime():int;
		
		/**固有固有公共冷却时间影响ItemID类别（注意：技能的此值为-1,道具的此值为其他值） */
		function getPublicCoolingTimeType():*;
	}
}