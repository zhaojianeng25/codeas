var GameInstance = (function () {
    function GameInstance() {
    }
    GameInstance.initData = function () {
        this.skillEffectItem = new Array;
        this.skillEffectItem.push({ effect_file: "jichu_nan", effect: "skill_01" }); //多一个
        this.skillEffectItem.push({ effect_file: "jichu_nan", effect: "skill_01" });
        this.skillEffectItem.push({ effect_file: "jichu_nan", effect: "skill_02" });
        this.skillEffectItem.push({ effect_file: "jichu_nan", effect: "skill_03" });
        this.skillEffectItem.push({ effect_file: "jichu_nan", effect: "m_skill_01" });
        this.skillEffectItem.push({ effect_file: "jichu_nan", effect: "m_skill_02" });
        this.skillEffectItem.push({ effect_file: "jichu_nan", effect: "s_skill_01" });
        this.skillEffectItem.push({ effect_file: "jichu_nan", effect: "s_skill_02" });
    };
    GameInstance.getSkillById = function ($id) {
        return this.skillEffectItem[$id];
    };
    return GameInstance;
})();
//# sourceMappingURL=GameInstance.js.map