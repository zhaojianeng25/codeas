var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var TextureRes = (function (_super) {
    __extends(TextureRes, _super);
    function TextureRes() {
        _super.apply(this, arguments);
    }
    TextureRes.prototype.destory = function () {
        Scene_data.context3D.deleteTexture(this.texture);
    };
    return TextureRes;
})(ResCount);
//# sourceMappingURL=TextureRes.js.map