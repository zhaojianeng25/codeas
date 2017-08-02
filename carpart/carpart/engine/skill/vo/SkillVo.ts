class SkillVo {
    public action: string;
    public skillname:string
    public keyAry: Array<SkillKeyVo>;
    public types: number;
    public bloodTime:number;
    public static defaultBloodTime:number = 250;

    public setData($info: any): void {
        this.keyAry = new Array;
        if (!$info) {
            console.log("技能有错")
        }
        this.action = $info.action;
        this.skillname = $info.skillname;
        this.bloodTime = $info.blood;

        this.types = $info.type;

        if (this.types == SkillType.FixEffect) {
            this.keyAry = this.getFixEffect($info.data);
        } else if (this.types == SkillType.TrajectoryDynamicTarget || this.types == SkillType.TrajectoryDynamicPoint){
            this.keyAry = this.getTrajectoryDynamicTarget($info.data);
        }

    }

    private getFixEffect($ary: Array<any>): Array<SkillKeyVo> {
        var keyAry: Array<SkillFixEffectKeyVo> = new Array;
        for (var i: number = 0; i < $ary.length; i++){
            var key: SkillFixEffectKeyVo = new SkillFixEffectKeyVo();
            key.setData($ary[i]);
            keyAry.push(key);
        }
        return keyAry
    }

    private getTrajectoryDynamicTarget($ary: Array<any>): Array<SkillKeyVo> {
        var keyAry: Array<SkillTrajectoryTargetKeyVo> = new Array;
        for (var i: number = 0; i < $ary.length; i++) {
            var key: SkillTrajectoryTargetKeyVo = new SkillTrajectoryTargetKeyVo();
            key.setData($ary[i]);
            keyAry.push(key);
        }
        return keyAry
    }



}

class SkillType {
    public static TrajectoryDynamicTarget: number = 1;
    public static FixEffect: number = 4;
    public static TrajectoryDynamicPoint: number = 3;
}