class ShowDisModel {

    private static _instance: ShowDisModel;
    public static getInstance(): ShowDisModel {
        if (!this._instance) {
            this._instance = new ShowDisModel();
        }
        return this._instance;
    }


    constructor() {


    }
    public setPos(value: CANNON.Vec3): void
    {
        var ca: CANNON.Quaternion = new CANNON.Quaternion(Math.abs(value.x), Math.abs(value.y), Math.abs(value.z))

        console.log(ca)

        var cb: Vector3D = Physics.QuaternionC2Vec3dW(ca);

        var $q: Quaternion = new Quaternion(cb.x, cb.y, cb.z,1);
       $q.setMd5W();

      var $m:Matrix3D=  $q.toMatrix3D()

      $m.appendTranslation(0, 50, 0);
      $m.prependScale(0.1, 0.1, 0.1);


    }

    public addTempHit($pos:Vector3D): void
    {
        var $dis: ScenePerfab = new ScenePerfab()
        SceneManager.getInstance().addMovieDisplay($dis);
        $dis.setPerfabName("10001")

        $dis.scaleY = 5;
        $dis.scaleX = 0.1;
        $dis.scaleZ = 0.1;

        $dis.x = $pos.x
        $dis.y = $pos.y
        $dis.z = $pos.z
    }

}