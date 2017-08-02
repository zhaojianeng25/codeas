/***********************************************************************/
/*************** 本代码由协议工具自动生成，请勿手动修改 ****************/
/***********************************************************************/





class point
{				
	/**
	 * 坐标X
	 */
	public pos_x:number;	//float		
	/**
	 * 坐标Y
	 */
	public pos_y:number;	//float		
	/**
	 从输入二进制流中读取结构体
	 */
	public read(input:ByteArray):void
	{			
		var i:number;		
		this.pos_x = input. readFloat ();
		this.pos_y = input. readFloat ();
	}

	/**
	 * 将结构体写入到输出二进制流中
	 */
	public write(output:ByteArray):void
	{			
		var i:number;
		output.writeFloat (this.pos_x);	
		output.writeFloat (this.pos_y);	
	}
}




class taxi_menu_info
{				
	/**
	 * 
	 */
	public id:number;	//int32		
	/**
	 * 传送地点名称
	 */
	public taxi_text:string = "";	//String
	/**
	 * 地图ID
	 */
	public map_id:number;	//uint32		
	/**
	 * 坐标X
	 */
	public pos_x:number;	//uint16		
	/**
	 * 坐标Y
	 */
	public pos_y:number;	//uint16		
	/**
	 从输入二进制流中读取结构体
	 */
	public read(input:ByteArray):void
	{			
		var i:number;		
		this.id = input. readInt32 ();
		this.taxi_text = input.readStringByLen(50);		
		this.map_id = input. readUint32 ();
		this.pos_x = input. readUint16 ();
		this.pos_y = input. readUint16 ();
	}

	/**
	 * 将结构体写入到输出二进制流中
	 */
	public write(output:ByteArray):void
	{			
		var i:number;
		output.writeInt32 (this.id);	
		output.writeStringByLen(this.taxi_text, 50);
		output.writeUint32 (this.map_id);	
		output.writeUint16 (this.pos_x);	
		output.writeUint16 (this.pos_y);	
	}
}




class char_create_info
{				
	/**
	 * 名称
	 */
	public name:string = "";	//String
	/**
	 * 阵营
	 */
	public faction:number;	//uint8		
	/**
	 * 性别
	 */
	public gender:number;	//uint8		
	/**
	 * 等级
	 */
	public level:number;	//uint16		
	/**
	 * 
	 */
	public guid:string = "";	//String
	/**
	 * 头像
	 */
	public head_id:number;	//uint32		
	/**
	 * 发型ID
	 */
	public hair_id:number;	//uint32		
	/**
	 * 种族，猛男美女萝莉那些
	 */
	public race:number;	//uint8		
	/**
	 * 邀请的帮派id
	 */
	public inviteGuid:string = "";	//String
	/**
	 从输入二进制流中读取结构体
	 */
	public read(input:ByteArray):void
	{			
		var i:number;		
		this.name = input.readStringByLen(50);		
		this.faction = input. readUint8 ();
		this.gender = input. readUint8 ();
		this.level = input. readUint16 ();
		this.guid = input.readStringByLen(50);		
		this.head_id = input. readUint32 ();
		this.hair_id = input. readUint32 ();
		this.race = input. readUint8 ();
		this.inviteGuid = input.readStringByLen(50);		
	}

	/**
	 * 将结构体写入到输出二进制流中
	 */
	public write(output:ByteArray):void
	{			
		var i:number;
		output.writeStringByLen(this.name, 50);
		output.writeUint8 (this.faction);	
		output.writeUint8 (this.gender);	
		output.writeUint16 (this.level);	
		output.writeStringByLen(this.guid, 50);
		output.writeUint32 (this.head_id);	
		output.writeUint32 (this.hair_id);	
		output.writeUint8 (this.race);	
		output.writeStringByLen(this.inviteGuid, 50);
	}
}




class quest_option
{				
	/**
	 * 任务id
	 */
	public quest_id:number;	//uint32		
	/**
	 * 图标
	 */
	public quest_icon:number;	//uint32		
	/**
	 * 任务等级
	 */
	public quest_level:number;	//uint16		
	/**
	 * 任务标题
	 */
	public quest_title:string = "";	//String
	/**
	 * 标识
	 */
	public flags:number;	//uint32		
	/**
	 从输入二进制流中读取结构体
	 */
	public read(input:ByteArray):void
	{			
		var i:number;		
		this.quest_id = input. readUint32 ();
		this.quest_icon = input. readUint32 ();
		this.quest_level = input. readUint16 ();
		this.quest_title = input.readStringByLen(50);		
		this.flags = input. readUint32 ();
	}

	/**
	 * 将结构体写入到输出二进制流中
	 */
	public write(output:ByteArray):void
	{			
		var i:number;
		output.writeUint32 (this.quest_id);	
		output.writeUint32 (this.quest_icon);	
		output.writeUint16 (this.quest_level);	
		output.writeStringByLen(this.quest_title, 50);
		output.writeUint32 (this.flags);	
	}
}




class quest_canaccept_info
{				
	/**
	 * 任务ID
	 */
	public quest_id:number;	//uint32		
	/**
	 * 任务类别
	 */
	public quest_type:number;	//uint8		
	/**
	 * 标题
	 */
	public title:string = "";	//String
	/**
	 * 接受任务NPC模板id
	 */
	public npc_id:number;	//uint32		
	/**
	 * 任务等级
	 */
	public quest_level:number;	//uint32		
	/**
	 从输入二进制流中读取结构体
	 */
	public read(input:ByteArray):void
	{			
		var i:number;		
		this.quest_id = input. readUint32 ();
		this.quest_type = input. readUint8 ();
		this.title = input.readStringByLen(50);		
		this.npc_id = input. readUint32 ();
		this.quest_level = input. readUint32 ();
	}

	/**
	 * 将结构体写入到输出二进制流中
	 */
	public write(output:ByteArray):void
	{			
		var i:number;
		output.writeUint32 (this.quest_id);	
		output.writeUint8 (this.quest_type);	
		output.writeStringByLen(this.title, 50);
		output.writeUint32 (this.npc_id);	
		output.writeUint32 (this.quest_level);	
	}
}




class gossip_menu_option_info
{				
	/**
	 * id
	 */
	public id:number;	//int32		
	/**
	 * 选项icon图标
	 */
	public option_icon:number;	//int32		
	/**
	 * 选项文本
	 */
	public option_title:string = "";	//String
	/**
	 从输入二进制流中读取结构体
	 */
	public read(input:ByteArray):void
	{			
		var i:number;		
		this.id = input. readInt32 ();
		this.option_icon = input. readInt32 ();
		this.option_title = input.readStringByLen(200);		
	}

	/**
	 * 将结构体写入到输出二进制流中
	 */
	public write(output:ByteArray):void
	{			
		var i:number;
		output.writeInt32 (this.id);	
		output.writeInt32 (this.option_icon);	
		output.writeStringByLen(this.option_title, 200);
	}
}




class item_cooldown_info
{				
	/**
	 * 物品摸版
	 */
	public item:number;	//uint32		
	/**
	 * 冷却时间
	 */
	public cooldown:number;	//uint32		
	/**
	 从输入二进制流中读取结构体
	 */
	public read(input:ByteArray):void
	{			
		var i:number;		
		this.item = input. readUint32 ();
		this.cooldown = input. readUint32 ();
	}

	/**
	 * 将结构体写入到输出二进制流中
	 */
	public write(output:ByteArray):void
	{			
		var i:number;
		output.writeUint32 (this.item);	
		output.writeUint32 (this.cooldown);	
	}
}




class quest_status
{				
	/**
	 * 任务ID
	 */
	public quest_id:number;	//uint16		
	/**
	 * 任务状态
	 */
	public status:number;	//uint8		
	/**
	 从输入二进制流中读取结构体
	 */
	public read(input:ByteArray):void
	{			
		var i:number;		
		this.quest_id = input. readUint16 ();
		this.status = input. readUint8 ();
	}

	/**
	 * 将结构体写入到输出二进制流中
	 */
	public write(output:ByteArray):void
	{			
		var i:number;
		output.writeUint16 (this.quest_id);	
		output.writeUint8 (this.status);	
	}
}




class item_reward_info
{				
	/**
	 * 道具id
	 */
	public item_id:number;	//uint16		
	/**
	 * 道具数量
	 */
	public num:number;	//uint32		
	/**
	 从输入二进制流中读取结构体
	 */
	public read(input:ByteArray):void
	{			
		var i:number;		
		this.item_id = input. readUint16 ();
		this.num = input. readUint32 ();
	}

	/**
	 * 将结构体写入到输出二进制流中
	 */
	public write(output:ByteArray):void
	{			
		var i:number;
		output.writeUint16 (this.item_id);	
		output.writeUint32 (this.num);	
	}
}




class social_friend_info
{				
	/**
	 * 好友guid
	 */
	public guid:string = "";	//String
	/**
	 * 名字
	 */
	public name:string = "";	//String
	/**
	 * 帮派
	 */
	public faction:string = "";	//String
	/**
	 * 等级
	 */
	public level:number;	//uint16		
	/**
	 * 头像
	 */
	public icon:number;	//uint16		
	/**
	 * 头像
	 */
	public vip:number;	//uint16		
	/**
	 从输入二进制流中读取结构体
	 */
	public read(input:ByteArray):void
	{			
		var i:number;		
		this.guid = input.readStringByLen(50);		
		this.name = input.readStringByLen(50);		
		this.faction = input.readStringByLen(50);		
		this.level = input. readUint16 ();
		this.icon = input. readUint16 ();
		this.vip = input. readUint16 ();
	}

	/**
	 * 将结构体写入到输出二进制流中
	 */
	public write(output:ByteArray):void
	{			
		var i:number;
		output.writeStringByLen(this.guid, 50);
		output.writeStringByLen(this.name, 50);
		output.writeStringByLen(this.faction, 50);
		output.writeUint16 (this.level);	
		output.writeUint16 (this.icon);	
		output.writeUint16 (this.vip);	
	}
}




class faction_info
{				
	/**
	 * 帮派guid
	 */
	public faction_guid:string = "";	//String
	/**
	 * 名字
	 */
	public faction_name:string = "";	//String
	/**
	 * 帮主名字
	 */
	public faction_bz:string = "";	//String
	/**
	 * 公告
	 */
	public faction_gg:string = "";	//String
	/**
	 * 等级
	 */
	public level:number;	//uint16		
	/**
	 * 头像
	 */
	public icon:number;	//uint8		
	/**
	 * 帮派人数
	 */
	public player_count:number;	//uint16		
	/**
	 * 等级限制
	 */
	public minlev:number;	//uint16		
	/**
	 从输入二进制流中读取结构体
	 */
	public read(input:ByteArray):void
	{			
		var i:number;		
		this.faction_guid = input.readStringByLen(50);		
		this.faction_name = input.readStringByLen(50);		
		this.faction_bz = input.readStringByLen(50);		
		this.faction_gg = input.readStringByLen(108);		
		this.level = input. readUint16 ();
		this.icon = input. readUint8 ();
		this.player_count = input. readUint16 ();
		this.minlev = input. readUint16 ();
	}

	/**
	 * 将结构体写入到输出二进制流中
	 */
	public write(output:ByteArray):void
	{			
		var i:number;
		output.writeStringByLen(this.faction_guid, 50);
		output.writeStringByLen(this.faction_name, 50);
		output.writeStringByLen(this.faction_bz, 50);
		output.writeStringByLen(this.faction_gg, 108);
		output.writeUint16 (this.level);	
		output.writeUint8 (this.icon);	
		output.writeUint16 (this.player_count);	
		output.writeUint16 (this.minlev);	
	}
}




class rank_info
{				
	/**
	 * 名字
	 */
	public name:string = "";	//String
	/**
	 * 伤害百分比
	 */
	public value:number;	//float		
	/**
	 从输入二进制流中读取结构体
	 */
	public read(input:ByteArray):void
	{			
		var i:number;		
		this.name = input.readStringByLen(50);		
		this.value = input. readFloat ();
	}

	/**
	 * 将结构体写入到输出二进制流中
	 */
	public write(output:ByteArray):void
	{			
		var i:number;
		output.writeStringByLen(this.name, 50);
		output.writeFloat (this.value);	
	}
}




class line_info
{				
	/**
	 * 分线号
	 */
	public lineNo:number;	//uint16		
	/**
	 * 玩家比率
	 */
	public rate:number;	//uint8		
	/**
	 从输入二进制流中读取结构体
	 */
	public read(input:ByteArray):void
	{			
		var i:number;		
		this.lineNo = input. readUint16 ();
		this.rate = input. readUint8 ();
	}

	/**
	 * 将结构体写入到输出二进制流中
	 */
	public write(output:ByteArray):void
	{			
		var i:number;
		output.writeUint16 (this.lineNo);	
		output.writeUint8 (this.rate);	
	}
}




class wait_info
{				
	/**
	 * 名字
	 */
	public name:string = "";	//String
	/**
	 * 状态
	 */
	public state:number;	//int8		
	/**
	 从输入二进制流中读取结构体
	 */
	public read(input:ByteArray):void
	{			
		var i:number;		
		this.name = input.readStringByLen(50);		
		this.state = input. readInt8 ();
	}

	/**
	 * 将结构体写入到输出二进制流中
	 */
	public write(output:ByteArray):void
	{			
		var i:number;
		output.writeStringByLen(this.name, 50);
		output.writeInt8 (this.state);	
	}
}




class cultivation_rivals_info
{				
	/**
	 * 序号
	 */
	public index:number;	//uint32		
	/**
	 * 名字
	 */
	public name:string = "";	//String
	/**
	 * 等级
	 */
	public level:number;	//uint32		
	/**
	 * 武器
	 */
	public weapon:number;	//uint32		
	/**
	 * 外观
	 */
	public avatar:number;	//uint32		
	/**
	 * 神兵
	 */
	public divine:number;	//uint32		
	/**
	 * 战力
	 */
	public force:number;	//uint32		
	/**
	 * 宝箱
	 */
	public chest:number;	//uint32		
	/**
	 * 性别
	 */
	public gender:number;	//uint32		
	/**
	 从输入二进制流中读取结构体
	 */
	public read(input:ByteArray):void
	{			
		var i:number;		
		this.index = input. readUint32 ();
		this.name = input.readStringByLen(50);		
		this.level = input. readUint32 ();
		this.weapon = input. readUint32 ();
		this.avatar = input. readUint32 ();
		this.divine = input. readUint32 ();
		this.force = input. readUint32 ();
		this.chest = input. readUint32 ();
		this.gender = input. readUint32 ();
	}

	/**
	 * 将结构体写入到输出二进制流中
	 */
	public write(output:ByteArray):void
	{			
		var i:number;
		output.writeUint32 (this.index);	
		output.writeStringByLen(this.name, 50);
		output.writeUint32 (this.level);	
		output.writeUint32 (this.weapon);	
		output.writeUint32 (this.avatar);	
		output.writeUint32 (this.divine);	
		output.writeUint32 (this.force);	
		output.writeUint32 (this.chest);	
		output.writeUint32 (this.gender);	
	}
}

