using Fusion;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterControlManager : NetworkBehaviour
{
    #region Monobehaviour callbakcs
    void Start()
    {
        
    }
    #endregion

    #region Public virtual methods
    public virtual void Move(InputStorage inputStorageOut)
    {

    }

    public virtual void Jump(InputStorage inputStorageOut)
    {

    }
    public virtual void Fire(InputStorage inputStorageOut)
    {

    }
    #endregion


}
