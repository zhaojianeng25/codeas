package _Pan3D.skill.vo.effect
{
	import flash.geom.Vector3D;
	
	import _Pan3D.skill.vo.SkillKeyVo;
	
	import _me.Scene_data;

	/**
	 * 效果的数据模型类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class EffectSkillVo extends SkillKeyVo
	{
		/**
		 * 粒子路径 
		 */		
		public var particleUrl:String;
		/**
		 * 终点类型 
		 * @see _Pan3D.skill.vo.effect.EnumEffectType
		 */		
		public var effectType:int;
		/**
		 *  指定的定点（静态点）
		 */		
		public var fiexPoint:Vector3D;
		
		public var rotationInfo:Vector3D;
		/**
		 * 距离地面高度（动态点） 
		 */		
		public var height:int;
		/**
		 * 绑定类型 
		 */		
		public var bindtype:int;
		
		public var bindIndex:int;
		
		public var bindSocket:Boolean;
		public var socket:String;
		
		public function EffectSkillVo()
		{
			
		}
		
		public function setInfo(obj:Object):void{
			effectType = obj.type;
			
			//particleUrl = Scene_data.particleRoot + "lid" + obj.particleInfo.particleID + ".lyf";
			if(obj.particleInfo){
				particleUrl = Scene_data.fileRoot + obj.particleInfo.particleUrl;
			}
			
			
			if(effectType == EnumEffectType.FIXED_POINT){
				var pos:Object = obj.typeInfo.pos;
				if(pos){
					fiexPoint = new Vector3D(pos.x,pos.y,pos.z);
					fiexPoint.scaleBy(Scene_data.mainRelateScale)
					
					var rotaion:Object = obj.typeInfo.rotation;
					if(rotaion){
						rotationInfo = new Vector3D(rotaion.x,rotaion.y,rotaion.z);
					}else{
						rotationInfo = null;
					}
					bindSocket = false;
				}else{
					bindSocket = true;
					socket = obj.typeInfo.socket;
				}
				
				
			}else if(effectType == EnumEffectType.DYNAMIC_POINT){
				//height = obj.typeInfo.height * Scene_data.mainRelateScale;
			}
			
			//bindtype = obj.bindtype;
			
		}
		
		override public function dispose():void{
			particleUrl = null;
			fiexPoint = null;
			rotationInfo = null;
		}
		
	}
}