class GameInstance {
    public static mainChar: SceneChar;
    public static attackChar: SceneChar;

    private static skillEffectItem: Array<any>;
    public static initData(): void
    {
        this.skillEffectItem = new Array;
        this.skillEffectItem.push({ effect_file: "jichu_nan", effect: "skill_01" }); //多一个
        this.skillEffectItem.push({ effect_file: "jichu_nan", effect: "skill_01" });
        this.skillEffectItem.push({ effect_file: "jichu_nan", effect: "skill_02" });
        this.skillEffectItem.push({ effect_file: "jichu_nan", effect: "skill_03" });
        this.skillEffectItem.push({ effect_file: "jichu_nan", effect: "m_skill_01" });
        this.skillEffectItem.push({ effect_file: "jichu_nan", effect: "m_skill_02" });
        this.skillEffectItem.push({ effect_file: "jichu_nan", effect: "s_skill_01" });
        this.skillEffectItem.push({ effect_file: "jichu_nan", effect: "s_skill_02" });
    }
    public static getSkillById($id: number): any
    {
        return this.skillEffectItem[$id]
    }

}