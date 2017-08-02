package view
{
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.events.FlexEvent;
	
	import _Pan3D.base.enum.EnumParticleType;
	import _Pan3D.particle.Display3DFacetPartilce;
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.particle.ball.Display3DBallPartilceNew;
	import _Pan3D.particle.bone.Display3DBoneParticleNew;
	import _Pan3D.particle.bone.Display3DBonePartilce;
	import _Pan3D.particle.crossFacet.Display3DCrossFacetPartilce;
	import _Pan3D.particle.cylinder.Display3DCylinderPartilce;
	import _Pan3D.particle.follow.Display3DFollowPartilce;
	import _Pan3D.particle.followLocus.Display3DFollowLocusPartilce;
	import _Pan3D.particle.followLocus.Display3DFollowMulLocusParticle;
	import _Pan3D.particle.hightLocus.Display3DHightLocusPartilce;
	import _Pan3D.particle.link.Display3DLinkPartilce;
	import _Pan3D.particle.locus.Display3DLocusPartilce;
	import _Pan3D.particle.locusball.Display3DLocusBallPartilce;
	import _Pan3D.particle.mask.Display3DMaskPartilce;
	import _Pan3D.particle.modelObj.Display3DModelParticleNew;
	import _Pan3D.particle.modelObj.Display3DModelPartilce;
	import _Pan3D.particle.specialLocus.Display3DSpecialLocusPartilce;
	
	import _me.Scene_data;
	
	import modules.brower.fileTip.InputWindow;
	
	import view.component.ParticleItemBtn;
	
	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 * 粒子条目类 
	 * 
	 * 负责联系 粒子，时间轴，和显示ui的总类
	 * 
	 */	
	public class ParticleItem extends Canvas
	{
		public var timeline:TimeLineSprite;//对应的时间轴对象
		public var display3D:Display3DParticle;//对应的粒子
		//private var cb:CheckBox;//是否显示控制
		private var btn:ParticleItemBtn;
		private var _selected:Boolean;//是否选中
		public var type:int;//对应的粒子类型
		public function ParticleItem(type:int)
		{
			super();
			this.type = type;
			this.width = 130;
			this.height = 20;
			
			btn = new ParticleItemBtn;
//			btn.width = 80;
//			btn.height = 20;
//			btn.x = 20;
			this.addChild(btn);
//			btn.toggle = true;
			
			//根据不同的类型生成不同类型的粒子对象
			switch(type)
			{
				case EnumParticleType.FACET:
				{
					this.display3D = new Display3DFacetPartilce(Scene_data.context3D);
					btn.label = "3D面片";
					break;
				}

				case EnumParticleType.LOCUS:
				{
					this.display3D = new Display3DLocusPartilce(Scene_data.context3D);
					btn.label = "轨迹";
					break;
				}	
				case EnumParticleType.CYLINDER:
				{
					this.display3D = new Display3DCylinderPartilce(Scene_data.context3D);
					btn.label = "圆环";
					break;
				}	

			
				case EnumParticleType.CROSSFACET:
				{
					this.display3D = new Display3DCrossFacetPartilce(Scene_data.context3D);
					btn.label = "十字面片";
					break;
				}
				case EnumParticleType.FOLLOW:
				{
					this.display3D = new Display3DFollowPartilce(Scene_data.context3D);
					btn.label = "跟随粒子";
					break;
				}
				case EnumParticleType.MODEL:
				{
					this.display3D = new Display3DModelPartilce(Scene_data.context3D);
					btn.label = "模型粒子";
					break;
				}
				case EnumParticleType.LINK:
				{
					this.display3D = new Display3DLinkPartilce(Scene_data.context3D);
					btn.label = "连接粒子";
					break;
				}
				case EnumParticleType.MASK:
				{
					this.display3D = new Display3DMaskPartilce(Scene_data.context3D);
					btn.label = "遮罩粒子";
					break;
				}
				case EnumParticleType.FOLLOW_LOCUS:
				{
					this.display3D = new Display3DFollowLocusPartilce(Scene_data.context3D);
					btn.label = "跟随轨迹"
					break;
				}
				case EnumParticleType.BONE:
				{
					this.display3D = new Display3DBonePartilce(Scene_data.context3D);
					btn.label = "骨骼粒子"
					break;
				} 
				case EnumParticleType.LOCUS_BALL:
					this.display3D = new Display3DLocusBallPartilce(Scene_data.context3D);
					btn.label = "曲线粒子";
					break;

				case EnumParticleType.HIGH_LOCUS:
					this.display3D = new Display3DHightLocusPartilce(Scene_data.context3D);
					btn.label = "高级轨迹";
					break;
				case EnumParticleType.SPECIAL_LOCUS:
					this.display3D = new Display3DSpecialLocusPartilce(Scene_data.context3D);
					btn.label = "特殊轨迹";
					break;
				case EnumParticleType.BALL_NEW:
					this.display3D = new Display3DBallPartilceNew(Scene_data.context3D);
					btn.label = "新椭球粒子";
					break;
	
				case EnumParticleType.BONE_NEW:
					this.display3D = new Display3DBoneParticleNew(Scene_data.context3D);
					btn.label = "新骨骼粒子";
					break;
				case EnumParticleType.MODEL_NEW:
					this.display3D = new Display3DModelParticleNew(Scene_data.context3D);
					btn.label = "遮罩模型";
					break;
				case EnumParticleType.FOLLOW_MUL_LOCUS:
					this.display3D = new Display3DFollowMulLocusParticle(Scene_data.context3D);
					btn.label = "跟随多轨迹";
					break;
			}
			
			display3D.visible = false;
			AppParticleData.particleLevel.addParticle(display3D);//将粒子添加到 粒子系统中显示
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCom);
			btn.type = type;
			btn.addEventListener(Event.CHANGE,onChg);
			//display3D.bindTarget = AppData.role;
//			cb = new CheckBox;
//			this.addChild(cb);
//			cb.selected = true;
//			cb.addEventListener(Event.CHANGE,onChg);
//			cb.visible = false;
		}
		
		public function showRename():void{
			//btn.showRename();
			InputWindow.getInstance().inputFilePanle("1",renameFun);
		}
		
		private function renameFun(str1:String,str2:String):void{
			display3D.name = btn.label = str1;
		}
		
		public function reFreshName():void
		{
			if(display3D.name){
				btn.label = display3D.name;
			}
		}
		private function onCom(event:Event):void{
			
		}
		
		/**
		 * 销毁条目
		 * 将对应的粒子从粒子系统中移除
		 * */
		public function destory():void{
			AppParticleData.particleLevel.removeParticle(display3D);
		}
		/**
		 * 刷入数据 
		 * @param value 数据对象
		 * 
		 */		
		public function setData(value:Object):void{
			display3D.setAllInfo(value);
			if(display3D.name){
				btn.label = display3D.name;
			}
		}

		public function get selected():Boolean
		{
			return btn.selected;
		}

		public function set selected(value:Boolean):void
		{
			btn.selected = value;
		}
		
				
		public function onChg(event:Event=null):void{
			_isShow = btn.isShow;
			applyShow();
		}
		
		private function applyShow():void{
	
			if(_isShow){
				timeline.showVisible = true;
			}else{
				timeline.showVisible = false;
			}
		}
		private var _isShow:Boolean = true;

		public function get isShow():Boolean
		{
			return _isShow;
		}

		public function set isShow(value:Boolean):void
		{
			_isShow = value;
			applyShow();
			btn.isShow = _isShow;
		}
		
		
		
		
		
	}
}