﻿class Display3DFollowShader extends Shader3D {
    static Display3D_Follow_Shader: string = "Display3DFollowShader";
    constructor() {
        super();
    }
    binLocation($context: WebGLRenderingContext): void {
        $context.bindAttribLocation(this.program, 0, "vPosition");
        $context.bindAttribLocation(this.program, 1, "texcoord");
        $context.bindAttribLocation(this.program, 2, "basePos");
        $context.bindAttribLocation(this.program, 3, "speed");

        var needRotation: number = this.paramAry[3];
        if (needRotation){
            $context.bindAttribLocation(this.program, 4, "rotation");
        }

        var hasRandomClolr: number = this.paramAry[1];
        if (hasRandomClolr) {
            $context.bindAttribLocation(this.program, 5, "color");
        }

    } 
    getVertexShaderString(): string {
        var baseStr: string;
        var scaleStr: string;
        var rotationStr: string;
        var posStr: string;
        var addSpeedStr: string;
        var mulStr: string;
        var resultPosStr: string;
        var uvStr: string;
        var particleColorStr: string;
        var randomColorStr: string;
        var uvDefaultStr: string;
        var uvAnimStr: string;
        var uvSpeedStr: string;
        var randomColorStr: string;
        var particleColorStr: string;

        var defineBaseStr: string;
        var defineScaleStr: string;
        var defineRotaionStr: string;
        var defineAddSpeedStr: string;
        var defineMulStr: string;
        var defineUvAnimStr: string;
        var defineUvSpeedStr: string;
        var defineRandomColor: string;
        var defineParticleColor: string;

        defineBaseStr =
        "attribute vec4 vPosition;\n" +
        "attribute vec3 texcoord;\n" +//uv坐标xy
        "attribute vec4 basePos;\n" +//基础位置xyz，发射起始时间w
        "attribute vec3 speed;\n" +//速度xyz
        "uniform mat4 watheye;\n" +//面向视点矩阵
        "uniform mat4 viewMatrix;\n" +//模型矩阵
        "uniform mat4 modelMatrix;\n" +//模型矩阵
        "uniform mat4 cameraMatrix;\n" +//摄像机矩阵
        "uniform vec4 time;\n" +//当前时间x,自身加速度y,粒子生命z,是否循环w
        "uniform vec3 bindpos[20];\n" +
        "varying vec2 v0;\n";

        defineRandomColor = 
        "attribute vec4 color;\n" +//随机颜色
        "varying vec4 v2;\n";//随机颜色

        defineScaleStr = 
        "uniform vec4 scale;\n" +//缩放x，抖动周期y，抖动振幅z
        "uniform vec4 scaleCtrl;\n"//宽度不变，高度不变，最大比例，最小比例
        defineRotaionStr =
        "attribute vec2 rotation;\n";//基础旋转x ， 旋转速度y
        defineAddSpeedStr = 
        "uniform vec3 force;\n";//外力x，外力y，外力z
        defineMulStr = 
        "uniform mat4 rotationMatrix;\n" +//旋转矩阵
        "uniform vec3 worldPos;\n" +//世界中的位置
        "uniform vec3 camPos;\n"//世界中的位置
        defineUvAnimStr = 
        "uniform vec3 animCtrl;\n"//动画行数x，动画列数，动画间隔
        defineUvSpeedStr = 
        "uniform vec2 uvCtrl;\n"//u滚动速度，v滚动速度
        defineParticleColor = 
        "varying vec2 v1;\n";//粒子颜色坐标

        baseStr =
        "float ctime = time.x - basePos.w;\n" + //计算当前时间
        "if (time.w > 0.0 && ctime >= 0.0) {\n" +
        "    ctime = fract(ctime / time.z) * time.z;\n" +
        "}\n" +
        "vec4 pos = vPosition;\n"//自身位置

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
        "pos.y *= sv2.y;\n"
        
        rotationStr = 
        "float angle = rotation.x + rotation.y * ctime;\n" +
        "vec4 np = vec4(sin(angle), cos(angle), 0, 0);\n" +
        "np.z = np.x * pos.y + np.y * pos.x;\n" +//b.x = sin_z * a.y + cos_z * a.x;
        "np.w = np.y * pos.y - np.x * pos.x;\n" +//b.y = cos_z * a.y - sin_z * a.x;
        "pos.xy = np.zw;\n"

        posStr =
        "vec3 addPos = speed * ctime;\n" +//运动部分
        "vec3 uspeed = vec3(0,0,0);\n" +
        "if (ctime < 0.0 || ctime >= time.z) {\n" +//根据时间控制粒子是否显示
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
        "uspeed = speed + uspeed * ctime * 2.0;\n" +//当前速度方向
        "uspeed = normalize(uspeed);\n" +
        "vec4 tempMul = rotationMatrix * vec4(uspeed,1.0);\n" +
        "uspeed.xyz = tempMul.xyz;\n" +
        "uspeed = normalize(uspeed);\n" +
        "vec3 cPos = addPos;\n" + //v(视点-位置)
        "tempMul = rotationMatrix * vec4(cPos,1.0);\n" +
        "cPos.xyz = tempMul.xyz; \n" +
        "cPos.xyz = worldPos.xyz + cPos.xyz;\n" +
        "cPos.xyz = camPos.xyz - cPos.xyz;\n" +
        "cPos = normalize(cPos);\n" +
        "cPos = cross(uspeed, cPos);\n" +//法线
        "cPos = normalize(cPos);\n" +
        "uspeed = uspeed * pos.x;\n" +
        "cPos = cPos * pos.y;\n" +
        "pos.xyz = uspeed.xyz + cPos.xyz;\n";

        resultPosStr =
        "pos = watheye * pos;\n" + //控制是否面向视点
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
        "v0.xy = uv.xy;\n"
        randomColorStr = 
        "v2 = color;\n"
        particleColorStr = 
        "v1 = vec2(ctime/time.z,1.0);\n"
        //this.paramAry

        var hasParticle: number = this.paramAry[0];
        var hasRandomClolr: number = this.paramAry[1];
        var isMul: number = this.paramAry[2];
        var needRotation: number = this.paramAry[3];
        var needScale: number = this.paramAry[4];
        var needAddSpeed: number = this.paramAry[5];
        var uvType: number = this.paramAry[6];

        var str: string = "";
        var defineStr: string = "";
        str += baseStr;
        defineStr += defineBaseStr;

        if (needScale){
            str += scaleStr;
            defineStr += defineScaleStr;

        }
        if (needRotation) {
            str += rotationStr;
            defineStr += defineRotaionStr;
        }
        str += posStr;
        if (needAddSpeed){
            str += addSpeedStr;
            defineStr += defineAddSpeedStr;
        }
        if (isMul){
            str += mulStr;
            defineStr += defineMulStr;
        }
        str += resultPosStr;

        if (uvType == 1) {
            str += uvAnimStr;
            defineStr += defineUvAnimStr;
        } else if (uvType == 2) {
            str += uvSpeedStr;
            defineStr += defineUvSpeedStr;
        } else {
            str += uvDefaultStr;
        }

        if (hasRandomClolr){
            str += randomColorStr;
            defineStr += defineRandomColor;
        }

        if (hasParticle){
            str += particleColorStr;
            defineStr += defineParticleColor;
        }



        //str += uvStr
        //str += particleColorStr
        //str += randomColorStr



        var resultAllStr: string = defineStr + "void main(){\n" + str + "}";
        
        return resultAllStr;
    }
    getFragmentShaderString(): string {
        var $str: string =
            " precision mediump float;\n" +
            "uniform sampler2D tex;\n" +
            "varying vec2 v0;\n" +

            "void main(void)\n" +
            "{\n" +
            "vec4 infoUv = texture2D(tex, v0.xy);\n" +
            "gl_FragColor = infoUv;\n" +
            "}"
        return $str;

    }

} 