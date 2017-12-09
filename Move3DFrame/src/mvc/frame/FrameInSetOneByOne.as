package mvc.frame
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.Object3D;
	import _Pan3D.core.Quaternion;
	
	import mvc.frame.line.FrameLinePointVo;
	import mvc.frame.view.FrameFileNode;
	
	import xyz.MoveScaleRotationLevel;
	import xyz.draw.TooXyzMoveData;

	public class FrameInSetOneByOne
	{
		private static var instance:FrameInSetOneByOne;
		public function FrameInSetOneByOne()
		{
		}

		public static function getInstance():FrameInSetOneByOne{
			if(!instance){
				instance = new FrameInSetOneByOne();
			}
			return instance;
		}
	
		public function insetFrameOneByOne($selectNode:FrameFileNode):void
		{
			var $xyzMoveData:TooXyzMoveData=MoveScaleRotationLevel.getInstance().xyzMoveData;
			if($xyzMoveData&&$xyzMoveData.modelItem.length>1){
				var $ide:uint=$xyzMoveData.modelItem.indexOf($selectNode.iModel);
				if($ide>0){
					var $centen:FrameFileNode=FrameModel.getInstance().findfileNodeFromListByImodel(FrameModel.getInstance().ary,$xyzMoveData.modelItem[0]);
					var $centenPrePointVo:FrameLinePointVo=$centen.getPreFrameLinePointVoByTime(AppDataFrame.frameNum);
					var $selectPrePointVo:FrameLinePointVo=$selectNode.getPreFrameLinePointVoByTime(AppDataFrame.frameNum);
					
					var $centenNextPointVo:FrameLinePointVo=$centen.getNextFrameLinePointVoByTime(AppDataFrame.frameNum);
					var $selectNextPointVo:FrameLinePointVo=$selectNode.getNextFrameLinePointVoByTime(AppDataFrame.frameNum);
					
					if($centenPrePointVo&&$selectPrePointVo&&$centenNextPointVo&&$selectNextPointVo){
						if($centenPrePointVo.time==$selectPrePointVo.time&&$centenNextPointVo.time==$selectNextPointVo.time){
							
							var $m0:Matrix3D=$centenPrePointVo.getMatrix3D();
							var $m1:Matrix3D=$selectPrePointVo.getMatrix3D();
							$m0.invert();
							$m0.prepend($m1);
	
							var $n0:Matrix3D=$centenNextPointVo.getMatrix3D();
							var $n1:Matrix3D=$selectNextPointVo.getMatrix3D();
							$n0.invert();
							$n0.prepend($n1)
								
							for(var i:Number=$centenPrePointVo.time+1;i<$centenNextPointVo.time;i++){
								var $centenPointVo:FrameLinePointVo=	$centen.playFrameVoByTime(i);
								var $insetFrameLinePointVo:FrameLinePointVo=$selectNode.insetKey(i)
								var $mm:Matrix3D=$centenPointVo.getMatrix3D();
								var $nn:Matrix3D=this.getInsetMatrix3DByTime($m0,$n0,(i-$centenPrePointVo.time)/($centenNextPointVo.time-$centenPrePointVo.time))
								$mm.prepend($nn)
								$insetFrameLinePointVo.setMatrix3D($mm);
							}

						}
						
					}
					
				
				}
			}
			
			FrameModel.getInstance().framePanel.refrishFrameList()
		}
		public function getInsetMatrix3DByTime($m:Matrix3D,$n:Matrix3D,$num:Number):Matrix3D
		{
			var $mmmv:Vector.<Vector3D>=($m.clone()).decompose();
			var $a:Object3D=new Object3D();
			$a.x=$mmmv[0].x
			$a.y=$mmmv[0].y
			$a.z=$mmmv[0].z
			$a.scale_x=$mmmv[2].x
			$a.scale_y=$mmmv[2].y
			$a.scale_z=$mmmv[2].z
				
				
			var $nnnv:Vector.<Vector3D>=($n.clone()).decompose();
			var $b:Object3D=new Object3D();
			$b.x=$nnnv[0].x
			$b.y=$nnnv[0].y
			$b.z=$nnnv[0].z
			$b.scale_x=$nnnv[2].x
			$b.scale_y=$nnnv[2].y
			$b.scale_z=$nnnv[2].z
			
			var $vo:FrameLinePointVo=new FrameLinePointVo
			$vo.x=	$a.x+($b.x-$a.x)*$num;
			$vo.y=	$a.y+($b.y-$a.y)*$num;
			$vo.z=	$a.z+($b.z-$a.z)*$num;
			
			$vo.scale_x=	$a.scale_x+($b.scale_x-$a.scale_x)*$num;
			$vo.scale_y=	$a.scale_y+($b.scale_y-$a.scale_y)*$num;
			$vo.scale_z=	$a.scale_z+($b.scale_z-$a.scale_z)*$num;
			
			

			var q0:Quaternion=new Quaternion()
			q0.fromMatrix($m)
			
		
			var q1:Quaternion=new Quaternion()
			q1.fromMatrix($n)
			
			var resultQ:Quaternion = new Quaternion;
			resultQ.slerp(q0,q1,$num);
			var $ve:Vector3D=resultQ.toEulerAngles();
			$ve.scaleBy(180/Math.PI)
			
			$vo.rotationX=$ve.x
			$vo.rotationY=$ve.y
			$vo.rotationZ=$ve.z
			return $vo.getMatrix3D()
		}
		
	}
}