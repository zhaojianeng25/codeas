package _Pan3D.skill.custom
{
	/**
	 * 自定义粒子飞行路径 配置类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class PathManager
	{
		private static var dicKey:Array = new Array;
		public function PathManager()
		{
			
		}
		
		public static function reg():void{
//			dicKey[4] = CustomShuangXuanPath//丐帮怒气技能，持续时间1600毫秒
//			dicKey[5] = CustomSanlianPath;// 逍遥怒气技能
//			dicKey[6] = CustomDanmuPath;//弹幕技能，桃花怒气技能，持续时间1100毫秒
//			dicKey[7] = CustomXuanPath;//降龙十八掌
//			dicKey[9] = CustomXuanQiuPath;//北冥神功
		}
		
		public static function dynamicReg($id:uint,$cls:Class):void{
			if(dicKey[$id]){
				throw new Error("存在已经注册的ID");
			}else{
				dicKey[$id] = $cls;
			}
		}
		
		public static function getPath($id:int):Class{
			return dicKey[$id];
		}
		
		
	}
}