package modules.hierarchy
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import PanV2.xyzmove.MathUint;
	
	import common.utils.ui.file.FileNode;
	
	import proxy.top.model.ILight;

	public class RenderMathPointLigth
	{
		private static var instance:RenderMathPointLigth;
		public function RenderMathPointLigth()
		{
		}
		public static function getInstance():RenderMathPointLigth{
			if(!instance){
				instance = new RenderMathPointLigth();
			}
			return instance;
		}
		private var _lightItem:Vector.<HierarchyFileNode>
		public function mathLihtItem($arr:Vector.<FileNode>):void
		{
			_lightItem=new Vector.<HierarchyFileNode>
			for(var i:uint=0;i<$arr.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=$arr[i] as HierarchyFileNode ;
				if($hierarchyFileNode.type==HierarchyNodeType.Light){
					_lightItem.push($hierarchyFileNode)
				}
			}
			
		}
		public function getModelHaseLightArr($obj:Object,$posMatrix:Matrix3D):Array
		{
	
			var $hasArr:Array=new Array
			var $vertices:Vector.<Number>=$obj.vertices
			var $indexs:Vector.<uint>=$obj.indexs

			for(var j:uint=0;j<_lightItem.length;j++){
				var $iLight:ILight=_lightItem[j].iModel as ILight
				var lightPos:Vector3D=new Vector3D($iLight.x,$iLight.y,$iLight.z)
				for(var i:uint=0;i<$indexs.length/3;i++)
				{
					var a:Vector3D=new Vector3D($vertices[$indexs[i*3+0]*3+0],$vertices[$indexs[i*3+0]*3+1],$vertices[$indexs[i*3+0]*3+2])
					var b:Vector3D=new Vector3D($vertices[$indexs[i*3+1]*3+0],$vertices[$indexs[i*3+1]*3+1],$vertices[$indexs[i*3+1]*3+2])
					var c:Vector3D=new Vector3D($vertices[$indexs[i*3+2]*3+0],$vertices[$indexs[i*3+2]*3+1],$vertices[$indexs[i*3+2]*3+2])
						
					a=$posMatrix.transformVector(a)
					b=$posMatrix.transformVector(b)
					c=$posMatrix.transformVector(c)
						
					var dis:Number=MathUint.vector3DToRectangleDis(a,b,c,lightPos);
                   	if(dis<($iLight.distance*2)){
						
		
						
					   var obj:Object=$iLight.readObject
					   obj.x=  $iLight.x
					   obj.y=  $iLight.y
					   obj.z=  $iLight.z
					   $hasArr.push(obj);
					   i=$indexs.length
				    }
				}
			}
			return $hasArr
		}
		
	}
}