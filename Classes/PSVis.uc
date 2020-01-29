class PSVis extends Mutator;

#exec TEXTURE IMPORT NAME=greyskin FILE="Textures\greyskin.bmp" MIPS=OFF

var Actor DummyList[64];

event PostBeginPlay() {
    local PlayerStart PS;
    local Actor D;
    local int i;

    super.PostBeginPlay();

    i = 0;
    foreach AllActors(class'PlayerStart', PS) {
        D = Spawn(class'Actor', none, '', PS.Location, PS.Rotation);
        D.SetCollision(false, false, false);
        D.SetCollisionSize(0,0);
        D.DrawType = DT_Mesh;
        D.Mesh = LodMesh'Botpack.Commando';
        D.Skin = texture'PSVis.greyskin';
        D.LoopAnim('Breath1');

        DummyList[i] = D;
        i++;
        if (i >= 64) break;
    }

    SetTimer(1.0, true);
}

event Timer() {
    local int i;
    local PlayerPawn P;
    local bool bAllReady;

    bAllReady = true;
    foreach AllActors(class'PlayerPawn', P) {
        if (P.bReadyToPlay == false) {
            bAllReady = false;
            break;
        }
    }

    if (bAllReady) {
        for (i = 0; i < 64; i++) {
            if (DummyList[i] == none)
                break;

            DummyList[i].Destroy();
            DummyList[i] = none;
        }

        SetTimer(0.0, false);
    }
}
