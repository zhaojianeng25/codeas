var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var Display3DFollowShader = (function (_super) {
    __extends(Display3DFollowShader, _super);
    function Display3DFollowShader() {
        _super.call(this);
    }
    Display3DFollowShader.prototype.binLocation = function ($context) {
        $context.bindAttribLocation(this.program, 0, "vPosition");
        $context.bindAttribLocation(this.program, 1, "texcoord");
        $context.bindAttribLocation(this.program, 2, "basePos");
        $context.bindAttribLocation(this.program, 3, "speed");
        var needRotation = this.paramAry[3];
        if (needRotation) {
            $context.bindAttribLocation(this.program, 4, "rotation");
        }
        var hasRandomClolr = this.paramAry[1];
        if (hasRandomClolr) {
            $context.bindAttribLocation(this.program, 5, "color");
        }
    };
    Display3DFollowShader.prototype.getVertexShaderString = function () {
        var baseStr;
        var scaleStr;
        var rotationStr;
        var posStr;
        var addSpeedStr;
        var mulStr;
        var resultPosStr;
        var uvStr;
        var particleColorStr;
        var randomColorStr;
        var uvDefaultStr;
        var uvAnimStr;
        var uvSpeedStr;
        var randomColorStr;
        var particleColorStr;
        var defineBaseStr;
        var defineScaleStr;
        var defineRotaionStr;
        var defineAddSpeedStr;
        var defineMulStr;
        var defineUvAnimStr;
        var defineUvSpeedStr;
        var defineRandomColor;
        var defineParticleColor;
        defineBaseStr =
            "attribute vec4 vPosition;\n" +
                "attribute vec3 texcoord;\n" +
                "attribute vec4 basePos;\n" +
                "attribute vec3 speed;\n" +
                "uniform mat4 watheye;\n" +
                "uniform mat4 viewMatrix;\n" +
                "uniform mat4 modelMatrix;\n" +
                "uniform mat4 cameraMatrix;\n" +
                "uniform vec4 time;\n" +
                "uniform vec3 bindpos[20];\n" +
                "varying vec2 v0;\n";
        defineRandomColor =
            "attribute vec4 color;\n" +
                "varying vec4 v2;\n"; //随机颜色
        defineScaleStr =
            "uniform vec4 scale;\n" +
                "uniform vec4 scaleCtrl;\n"; //宽度不变，高度不变，最大比例，最小比例
        defineRotaionStr =
            "attribute vec2 rotation;\n"; //基础旋转x ， 旋转速度y
        defineAddSpeedStr =
            "uniform vec3 force;\n"; //外力x，外力y，外力z
        defineMulStr =
            "uniform mat4 rotationMatrix;\n" +
                "uniform vec3 worldPos;\n" +
                "uniform vec3 camPos;\n"; //世界中的位置
        defineUvAnimStr =
            "uniform vec3 animCtrl;\n"; //动画行数x，动画列数，动画间隔
        defineUvSpeedStr =
            "uniform vec2 uvCtrl;\n"; //u滚动速度，v滚动速度
        defineParticleColor =
            "varying vec2 v1;\n"; //粒子颜色坐标
        baseStr =
            "float ctime = time.x - basePos.w;\n" +
                "if (time.w > 0.0 && ctime >= 0.0) {\n" +
                "    ctime = fract(ctime / time.z) * time.z;\n" +
                "}\n" +
                "vec4 pos = vPosition;\n"; //自身位置
        scaleStr =
            "float stime = ctime - scale.w;\n" +
                "stime = max(stime,0.0);\n" +
                "float sf = scale.x * stime;\n" +
                "if (scale.y != 0.0 && scale.z != 0.0) {\n" +
                "    sf += sin(scale.y * stime) * scale.z;\n" +
                "}\n" +
                "if (sf > scaleCtrl.z) {\n" +
                "    sf = scaleCtrl.z;\n" +
                "} else if (sf < scaleCtrl.w) {\n" +
                "    sf = scaleCtrl.w;\n" +
                "}\n" +
                "vec2 sv2 = vec2(scaleCtrl.x * sf, scaleCtrl.y * sf);\n" +
                "sv2 = sv2 + 1.0;\n" +
                "pos.x *= sv2.x;\n" +
                "pos.y *= sv2.y;\n";
        rotationStr =
            "float angle = rotation.x + rotation.y * ctime;\n" +
                "vec4 np = vec4(sin(angle), cos(angle), 0, 0);\n" +
                "np.z = np.x * pos.y + np.y * pos.x;\n" +
                "np.w = np.y * pos.y - np.x * pos.x;\n" +
                "pos.xy = np.zw;\n";
        posStr =
            "vec3 addPos = speed * ctime;\n" +
                "vec3 uspeed = vec3(0,0,0);\n" +
                "if (ctime < 0.0 || ctime >= time.z) {\n" +
                "    addPos.y = addPos.y + 100000.0;\n" +
                "}\n";
        addSpeedStr =
            "if(time.y != 0.0 && length(speed) != 0.0) {\n" +
                "    uspeed = vec3(speed.x, speed.y, speed.z);\n" +
                "    uspeed = normalize(uspeed);\n" +
                "    uspeed = uspeed * time.y;\n" +
                "    uspeed.xyz = uspeed.xyz + force.xyz;\n" +
                "} else {\n" +
                "    uspeed = vec3(force.x, force.y, force.z);\n" +
                "}\n" +
                "addPos.xyz = addPos.xyz + uspeed.xyz * ctime * ctime;\n";
        mulStr =
            "uspeed = speed + uspeed * ctime * 2.0;\n" +
                "uspeed = normalize(uspeed);\n" +
                "vec4 tempMul = rotationMatrix * vec4(uspeed,1.0);\n" +
                "uspeed.xyz = tempMul.xyz;\n" +
                "uspeed = normalize(uspeed);\n" +
                "vec3 cPos = addPos;\n" +
                "tempMul = rotationMatrix * vec4(cPos,1.0);\n" +
                "cPos.xyz = tempMul.xyz; \n" +
                "cPos.xyz = worldPos.xyz + cPos.xyz;\n" +
                "cPos.xyz = camPos.xyz - cPos.xyz;\n" +
                "cPos = normalize(cPos);\n" +
                "cPos = cross(uspeed, cPos);\n" +
                "cPos = normalize(cPos);\n" +
                "uspeed = uspeed * pos.x;\n" +
                "cPos = cPos * pos.y;\n" +
                "pos.xyz = uspeed.xyz + cPos.xyz;\n";
        resultPosStr =
            "pos = watheye * pos;\n" +
                "pos.xyz = pos.xyz + basePos.xyz + addPos.xyz;\n" +
                "pos = modelMatrix * pos;\n" +
                "pos.xyz = pos.xyz + bindpos[int(texcoord.z)].xyz;\n" +
                "gl_Position = viewMatrix * cameraMatrix * pos;\n";
        uvDefaultStr =
            "v0 = vec2(texcoord.x,texcoord.y);\n";
        uvAnimStr =
            "vec2 uv = vec2(texcoord.x,texcoord.y);\n" +
                "float animframe = floor(ctime / animCtrl.z);\n" +
                "animframe = animframe / animCtrl.x;\n" +
                "uv.x += animframe;\n" +
                "animframe = floor(animframe);\n" +
                "uv.y += animframe / animCtrl.y;\n" +
                "v0.xy = uv.xy;\n";
        uvSpeedStr =
            "vec2 uv = uvCtrl;\n" +
                "uv.xy = uv.xy * ctime + texcoord.xy;\n" +
                "v0.xy = uv.xy;\n";
        randomColorStr =
            "v2 = color;\n";
        particleColorStr =
            "v1 = vec2(ctime/time.z,1.0);\n";
        //this.paramAry
        var hasParticle = this.paramAry[0];
        var hasRandomClolr = this.paramAry[1];
        var isMul = this.paramAry[2];
        var needRotation = this.paramAry[3];
        var needScale = this.paramAry[4];
        var needAddSpeed = this.paramAry[5];
        var uvType = this.paramAry[6];
        var str = "";
        var defineStr = "";
        str += baseStr;
        defineStr += defineBaseStr;
        if (needScale) {
            str += scaleStr;
            defineStr += defineScaleStr;
        }
        if (needRotation) {
            str += rotationStr;
            defineStr += defineRotaionStr;
        }
        str += posStr;
        if (needAddSpeed) {
            str += addSpeedStr;
            defineStr += defineAddSpeedStr;
        }
        if (isMul) {
            str += mulStr;
            defineStr += defineMulStr;
        }
        str += resultPosStr;
        if (uvType == 1) {
            str += uvAnimStr;
            defineStr += defineUvAnimStr;
        }
        else if (uvType == 2) {
            str += uvSpeedStr;
            defineStr += defineUvSpeedStr;
        }
        else {
            str += uvDefaultStr;
        }
        if (hasRandomClolr) {
            str += randomColorStr;
            defineStr += defineRandomColor;
        }
        if (hasParticle) {
            str += particleColorStr;
            defineStr += defineParticleColor;
        }
        //str += uvStr
        //str += particleColorStr
        //str += randomColorStr
        var resultAllStr = defineStr + "void main(){\n" + str + "}";
        return resultAllStr;
    };
    Display3DFollowShader.prototype.getFragmentShaderString = function () {
        var $str = " precision mediump float;\n" +
            "uniform sampler2D tex;\n" +
            "varying vec2 v0;\n" +
            "void main(void)\n" +
            "{\n" +
            "vec4 infoUv = texture2D(tex, v0.xy);\n" +
            "gl_FragColor = infoUv;\n" +
            "}";
        return $str;
    };
    Display3DFollowShader.Display3D_Follow_Shader = "Display3DFollowShader";
    return Display3DFollowShader;
})(Shader3D);
//# sourceMappingURL=Display3DFollowShader.js.map