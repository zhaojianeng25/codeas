var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var UIImageShader = (function (_super) {
    __extends(UIImageShader, _super);
    function UIImageShader() {
        _super.call(this);
    }
    UIImageShader.prototype.binLocation = function ($context) {
        $context.bindAttribLocation(this.program, 0, "v3Pos");
        $context.bindAttribLocation(this.program, 1, "v2uv");
    };
    UIImageShader.prototype.getVertexShaderString = function () {
        var $str = "attribute vec3 v3Pos;" +
            "attribute vec2 v2uv;" +
            "uniform vec2 scale;" +
            "varying vec2 v_texCoord;" +
            "void main(void)" +
            "{" +
            "   v_texCoord = vec2(v2uv.x, v2uv.y);" +
            "   vec4 vt0= vec4(v3Pos.x*scale.x,v3Pos.y*scale.y,v3Pos.z,1.0);" +
            "   gl_Position = vt0;" +
            "}";
        return $str;
    };
    UIImageShader.prototype.getFragmentShaderString = function () {
        var $str = " precision mediump float;\n" +
            "uniform sampler2D s_texture;\n" +
            "varying vec2 v_texCoord;\n" +
            "void main(void)\n" +
            "{\n" +
            "vec4 infoUv = texture2D(s_texture, v_texCoord.xy);\n" +
            "infoUv.xyz *= infoUv.w;\n" +
            "gl_FragColor = infoUv;\n" +
            "}";
        return $str;
    };
    UIImageShader.UI_IMG_SHADER = "UI_img_Shader";
    return UIImageShader;
})(Shader3D);
//# sourceMappingURL=UIImageShager.js.map