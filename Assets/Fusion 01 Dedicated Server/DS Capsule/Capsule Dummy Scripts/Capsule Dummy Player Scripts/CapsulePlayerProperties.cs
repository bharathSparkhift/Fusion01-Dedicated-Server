using Fusion;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CapsulePlayerProperties : NetworkBehaviour
{
    #region
    [SerializeField] CapsulePlayerController capsulePlayerController;
    #endregion

    #region Network callbacks
    public override void Render()
    {
        // Runner.GetPlayerRtt(playerRef: Object.HasInputAuthority);
    }
    #endregion
}
