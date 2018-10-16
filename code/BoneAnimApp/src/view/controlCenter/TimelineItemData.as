package view.controlCenter
{
	[Bindable]
	public class TimelineItemData
	{
		public var name:String;
		public var check:int;
		public var timeline:SkillTimeLineSprite;
		public function TimelineItemData()
		{
		}
		
		public function getAllInfo():Object{
			var obj:Object = new Object;
			obj.name = name;
			obj.check = check;
			obj.timeline = timeline.getAllInfo();
			return obj;
		}
		public function setAllInfo(obj:Object):void{
			this.name = obj.name;
			this.check = obj.check;
			this.timeline = new SkillTimeLineSprite;
			timeline.setAllInfo(obj.timeline);
		}
	}
}