package modules.materials.view
{
	import common.utils.frame.BaseReflectionView;
	import common.utils.frame.ReflectionData;
	
	import materials.DynamicConstItem;
	import materials.MaterialTreeParam;
	
	public class DynamicMaterialParamView extends BaseReflectionView
	{
		
		
		public function DynamicMaterialParamView()
		{
			super();
		}
		
		public function setMaterial($maParam:MaterialTreeParam):void{
			
			this.removeAllComponent();
			
			var dynamicConstList:Vector.<DynamicConstItem> = $maParam.dynamicConstList;
			var ary:Array = new Array;
			for(var i:int;i<dynamicConstList.length;i++){
				var obj:Object = new Object;
				obj.Type = ReflectionData.Curve;
				obj.Label = dynamicConstList[i].paramName;
				obj.GetFun = dynamicConstList[i].getCurve;
				obj.SetFun = dynamicConstList[i].setCurve;
				obj.Category = "数值";
				ary.push(obj);
			}
			
			this.creat(ary);
		}
		
		
		
	}
}