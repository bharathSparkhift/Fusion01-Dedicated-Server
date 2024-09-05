using Fusion;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public struct Server_Input_Struct : INetworkInput
{
    public Vector3  direction;
    public float    rotation;
}
